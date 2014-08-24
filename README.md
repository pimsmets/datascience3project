Read me
=======

##Goal of the script
To clean up a dataset containing data from a test with smartphone accelerometers.

##Prerequisites
The script uses the data.table package.

##Workings of the script

###Step 1 - Read the data into R

First the training data is read into 3 variables:
* data : a data frame containing all observations
* subjects : a list of the subjects (one per row in the data)
* activities : a list of the activities (one per row in the data)

Second, the test data is appended to these 3 variables

Finally, the activity and feature names are read into the variables activityLabels and features.

###Step 2 - Label and filter the data

We apply the feature names to the columns in the data.

Then we filter the features containing "mean()" or "std()" in their names, and eliminate all the other columns from the data.

###Step 3 - Clean up the feature names
We replace dashes '-' by underscores '_', and remove parentheses from the features names, to better fit the R rules.
We also prepend 'avg_' to the names, to indicate that the variables represent the average of a set of measurements.

###Step 4 - Activity labels
In the activities list, we replace every element with the corresponding label from the activityLabels list.

###Step 5 - Complete the data frame
We prepend the columns "subject" and "activity" to the data frame. All necessary data is now in this data frame.

###Step 6 - Get averages of all observation data per subject/activity
To easily summarize the data, we convert the data.frame to a data.table.
We set the keys of the datatable to the subject and activity columns, and then group by these columns, appying the mean function to all other columns.

###Step 7 - Write the resulting data set to a file
