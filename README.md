
This is an assignment on Getting and Cleaning Data, offered by Coursera, to demonstrate ability to collect, work with, and clean a data set. 

This assignment uses RStudio with R version 4.0.2. The github repo contains an **R script** that produces two independent tidy 
datasets, a **codebook** describing code details and a **Readme** file.


### Here is What code in 'run_analysis.R' does:

- Load data.table, dplyr and magrittr packages

- Download UCI HAR Dataset,  store file in project home directory and unzip  it

- Read metadata (features and activity_labels) into variables

- Read training and test data

-  Merge the training and the test sets to create one data set.

- Extract only the measurements on the mean and standard deviation for each measurement.

- Use descriptive activity names to name the activities in the data set.

- Appropriately label the data set with descriptive variable names.

- From the data set obtained so far, create a second, independent tidy data set with the average of each variable for each activity and each subject.
