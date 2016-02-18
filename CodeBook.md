   **CodeBook**
---------------------------------------------------------
This is a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data.

Dataset Used
---------------------------------------------------------
This data is obtained from "Human Activity Recognition Using Smartphones Data Set". The data linked are collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

The data set used can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

Discription of given Input Data Set
---------------------------------------------------------
The input data containts the following data files:

-   X_train.txt contains variable features for training.

-   y_train.txt contains the activities.

-   subject_train.txt and subject_test.txt contain information on the volunteer used.

-   X_test.txt contains variable features for testing.

-   y_test.txt contains the activities..

-   activity_labels.txt contains metadata on the different types of activities.

-   features.txt contains the name of the features in the data sets.


Transformations
---------------------------------------------------------

run_analysis.R files follows the goals step by step.

*   Step 1:

Read all the test and training files: y_test.txt, subject_test.txt and X_test.txt.
Combine the files to a data frame in the form of subjects, labels, the rest of the data.


*   Step 2:

Read the features from features.txt and filter it to only leave features that are either means ("mean()") or standard deviations ("std()"). 
A new data frame is then created that includes subjects, labels and the described features.


*   Step 3:

Read the activity labels from activity_labels.txt and replace the numbers with the text.


*   Step 4:

Make a column list (includig "subjects" and "label" at the start)
Appropriately labels the data set with descriptive variable names

*   Step 5:

Create a new data frame by finding the mean for each combination of subject and label. It's done by aggregate() function

*   Final step:

     Write the new tidy set into a text file called tidy_data.txt, formatted similarly to the original files.
     
Output Data Set
---------------------------------------------------------
The output data Tidy_data.txt is a a space-delimited value file. The header line contains the names of the variables. 

