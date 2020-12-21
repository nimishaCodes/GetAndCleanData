#Load packages
library(data.table)
library(magrittr) 
library(dplyr)  

#Start extracting data
filename <- "Coursera_GCData.zip"

# Checking if the file with "Coursera_GCData.zip" name exists already. If not, download into a file with that name.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder "UCI HAR Dataset" exists already. If not, unzip into that folder
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename)     
}

#Read metadata into variables
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

#Read Test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

#Read Training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


# 1. Merge the training and the test sets to create one data set.

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
# The one data set 'Merged_Data'
Merged_Data <- cbind(Subject, Y, X)


# 2. Extract only the measurements on the mean and standard deviation for each measurement.

Tidy_Data <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

#3. Use descriptive activity names to name the activities in the data set.

Tidy_Data$code <- activities[Tidy_Data$code, 2]

#4. Appropriately label the data set with descriptive variable names.

names(Tidy_Data)[2] = "activity"
names(Tidy_Data)<-gsub("Acc", "Accelerometer", names(Tidy_Data))
names(Tidy_Data)<-gsub("Gyro", "Gyroscope", names(Tidy_Data))
names(Tidy_Data)<-gsub("BodyBody", "Body", names(Tidy_Data))
names(Tidy_Data)<-gsub("Mag", "Magnitude", names(Tidy_Data))
names(Tidy_Data)<-gsub("^t", "Time", names(Tidy_Data))
names(Tidy_Data)<-gsub("^f", "Frequency", names(Tidy_Data))
names(Tidy_Data)<-gsub("tBody", "TimeBody", names(Tidy_Data))
names(Tidy_Data)<-gsub("-mean()", "Mean", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-std()", "STD", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-freq()", "Frequency", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("angle", "Angle", names(Tidy_Data))
names(Tidy_Data)<-gsub("gravity", "Gravity", names(Tidy_Data))

#To check names
names(Tidy_Data)

#5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

#From Tidy_Data, create another tidy data set Final_Data

Final_Data <- Tidy_Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

#Data set 'Final_Data' as a txt file 'Final_Data.txt'
write.table(Final_Data, "Final_Data.txt", row.name=FALSE)
