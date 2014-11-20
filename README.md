How run_analysis.R works
===================

The code assumes the user is in the same directory as the data.

Input:  Data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Output:  "project-tidy-data-wide.txt" text file.

Read the output:  Read the text file back using the following code:  
data <- read.table("project-tidy-data-wide.txt", header = TRUE)   
View(data)

### First, read the data.

Read in the following:
* train/X_train.txt train data
* train/y_train.txt train data's activity labels
* train/subject_train.txt train data's subject labels
* test/X_test.txt test data
* test/y_test.txt test data's activity labels
* test/subject_test.txt test data's subject labels
* features.txt column headings for train and test datasets
* activity_labels.txt labels for activity codes

### Next, combine all the data sources.

Re-label train data's activity labels and test data's activity labels to be descriptive words instead of numbers 1-6 using the lookup function.
Combine the test subjects, test labels, and test data into one data frame with subject numbers in the first column, test labels (walking, laying, etc) in the second column, and all data in subsequent columns.  
Do the same thing for train data. 
Then combine both test data and train data together into one large table.
Rename the headings of the table to be "subject", "activity", and column names from the features file.

### Extract mean and std columns into another table.

Create a new data table with only the columns for subject, activity, and any columns with mean() or std() titles.  
Then, replace the shorthand in the variable names with descriptive names.

### Create independent tidy data set.

Melt all the data into a long format with 4 columns: a column for subject, a column for activity, a column with every variable name and another column with the variable value. 
Then, cast the long table into a wide table while simultaneously obtaining the average of each variable.  

This results in a more concise table that displays the average of each variable measure in one column, and each different observation of that variable (with a different subject and different activity) in a different row.

Finally, write the wide tidy data table out to a text file.