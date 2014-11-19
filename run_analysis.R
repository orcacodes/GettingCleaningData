########### Getting and Cleaning Data Course Project ########### 

#### Read in all necessary data sources from within the UCI HAR Dataset folder #### 

library(data.table)
train <- read.table("train/X_train.txt")
trainactivity <- read.table("train/y_train.txt")
trainsubject <- read.table("train/subject_train.txt")
test <- read.table("test/X_test.txt")
testactivity <- read.table("test/y_test.txt")
testsubject <- read.table("test/subject_test.txt")
features <- read.table("features.txt", stringsAsFactors=F)
activity <- read.table("activity_labels.txt")

#### Combine all data sources #### 

# convert activity labels to lower case words to be used as descriptive activity names
activity[,2] <- tolower(activity[,2])
## qdap package needed for the lookup function
# install.packages("qdap")
library(qdap)
# change testactivity values from numbers to activity names using a lookup function
testlabels <- apply(testactivity, 2, lookup, activity)
# bind subject and activity name to first two columns of test data
testdata <- cbind(testsubject, testlabels, test)
# change trainactivity values from numbers to activity names using a lookup function
trainlabels <- apply(trainactivity, 2, lookup, activity)
# bind subject and activity name to first two columns of train data
traindata <- cbind(trainsubject, trainlabels, train)
# bind both train and test datasets together into one large data set
alldata <- rbind(traindata, testdata)
# label the column names of alldata with subject, activity, and the names from the second column of the features data
# this results in a table of all the data
names(alldata) <- c("subject", "activity", features[,2])

#### Subset just mean and std columns, and give descriptive variable names #### 

# extract only the colums with names of subject, activity, mean(), and std() and put into alldata2
alldata2 <- alldata[ , grepl("subject|activity|mean\\(\\)|std\\(\\)", names(alldata))]
# do lots of replacement to give descriptive variable column names
names(alldata2) <- gsub("tBody", "Time of Body ", names(alldata2))
names(alldata2) <- gsub("tGravity", "Time of Gravity ", names(alldata2))
names(alldata2) <- gsub("fBody", "Frequency of Body ", names(alldata2))
names(alldata2) <- gsub("Acc", "Acceleration ", names(alldata2))
names(alldata2) <- gsub("Gyro", "Rotation ", names(alldata2))
names(alldata2) <- gsub("Mag", "Magnitude ", names(alldata2))
names(alldata2) <- gsub("Jerk", "Jerk ", names(alldata2))
names(alldata2) <- gsub("-mean\\(\\)-X", "in X axis - mean", names(alldata2))
names(alldata2) <- gsub("-mean\\(\\)-Y", "in Y axis - mean", names(alldata2))
names(alldata2) <- gsub("-mean\\(\\)-Z", "in Z axis - mean", names(alldata2))
names(alldata2) <- gsub("-std\\(\\)-X", "in X axis - std", names(alldata2))
names(alldata2) <- gsub("-std\\(\\)-Y", "in Y axis - std", names(alldata2))
names(alldata2) <- gsub("-std\\(\\)-Z", "in Z axis - std", names(alldata2))
names(alldata2) <- gsub("-mean\\(\\)", "- mean", names(alldata2))
names(alldata2) <- gsub("-std\\(\\)", "- std", names(alldata2))

#### Create the second, independent tidy data set #### 

# This section has code for both wide form and long form.  I decided to show the wide form.
# reshape2 package needed to melt and cast data frames
library(reshape2)
# melt data frame into a long format, keeping "subject" and "activity" as IDs 
# and all other columns with numbers will be melted into "variable" and "value"
datamelt <- melt(alldata2, id=c("subject", "activity"))
# put the data back together in a wide table keeping "subject" and "activity",
# then display the mean of the variables for that "subject" and "activity"
datacast <- dcast(datamelt, subject + activity ~ variable, mean)
# the next line can be used to make this wide table into a long format table
# alldata3 <- melt(datacast, id=c("subject", "activity"))
# write the result into a .txt file
write.table(datacast, "project-tidy-data-wide.txt", row.name=F)