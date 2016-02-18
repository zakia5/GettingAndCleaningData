# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
#     
#     http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 

library(data.table)
library(dplyr)

## read supporting data
# The supporting metadata in this data are the name of the features
# and the name of the activities. They are loaded into variables featureNames and activityLabels.
rm(list=ls())
featureNames <- read.table("./UCI HAR Dataset/features.txt",header=FALSE, stringsAsFactors=FALSE)
head(featureNames)
dim(featureNames)#[1] 561   2
# read activity levels
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
# Format training and test data sets
# Both training and test data sets are split up into subject, activity and features. They are present in three different files.

# Reading train data
train_Data <- read.table("./UCI HAR Dataset/train/X_train.txt")
summary(train_Data)
str(train_Data)
names(train_Data)
dim(train_Data) #[1] 7352  561
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
head(subjectTrain)
dim(subjectTrain) #[1] 7352    1
#Training labels: activity levels

activityTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
head(activityTrain)
dim(activityTrain) #[1] 7352    1

# Reading test data
test_Data <- read.table("./UCI HAR Dataset/test/X_test.txt")
summary(test_Data)
str(test_Data)
names(test_Data)
dim(test_Data) #[1] 2947  561
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

activityTest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
head(activityTest)
dim(activityTest) #[1] 2947    1
## Creating new data set
# Part 1 - Merge the training and the test sets to create one data set
subject <- rbind(subjectTrain, subjectTest)
head(subject)
dim(subject)#[1] 10299     1

activity <- rbind(activityTrain, activityTest)
head(activity)
dim(activity)#[1] 10299     1

Data_only <- rbind(train_Data,test_Data)
head(Data_only)
dim(Data_only)#[1] 10299 561  
#Naming the columns of total data  from featuresNames by taking transpose

colnames(Data_only) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
#The data in features,activity and subject are merged into TotalData.
TotalData <- cbind(Data_only,activity,subject)
head(TotalData)
dim(TotalData) #[1] 10299   563
names(TotalData)
### Part 2
# Extracts only the measurements on the mean and standard deviation for each measurement

columnsWithMeanSTD <- grep("Mean|Std", names(TotalData), ignore.case=TRUE)
#columnsWithMeanSTD 
#length(columnsWithMeanSTD)
#Add activity and subject columns to the list 
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
requiredData <- TotalData[,requiredColumns]
dim(requiredData) #[1] 10299    88
#Part 3 
#descriptive activity names are used to name the activities in the data set
requiredData$Activity <- as.character(requiredData$Activity)
for (i in 1:6){
    requiredData$Activity[requiredDataData$Activity == i] <- as.character(activityLabels[i,2])
}

requiredData$Activity <- as.factor(requiredData$Activity)
#head(requiredData)
#summary(requiredData)
##Part 4
#Appropriately labels the data set with descriptive variable names
#names(requiredData)

names(requiredData)<-gsub("Acc", "Accelerometer", names(requiredData))
names(requiredData)<-gsub("Gyro", "Gyroscope", names(requiredData))
names(requiredData)<-gsub("BodyBody", "Body", names(requiredData))
names(requiredData)<-gsub("Mag", "Magnitude", names(requiredData))
names(requiredData)<-gsub("^t", "Time", names(requiredData))
names(requiredData)<-gsub("^f", "Frequency", names(requiredData))
names(requiredData)<-gsub("tBody", "TimeBody", names(requiredData))
names(requiredData)<-gsub("-mean()", "Mean", names(requiredData), ignore.case = TRUE)
names(requiredData)<-gsub("-std()", "STD", names(requiredData), ignore.case = TRUE)
names(requiredData)<-gsub("-freq()", "Frequency", names(requiredData), ignore.case = TRUE)
names(requiredData)

### Part 5 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

requiredData$Subject <- as.factor(requiredData$Subject)
requiredData <- data.table(requiredData)
#head(requiredData)
# tidy_Data is created as a data set with average for each activity and subject. 

tidy_Data <- aggregate(. ~Subject + Activity, requiredData, mean)
tidy_Data <- tidy_Data[order(tidy_Data$Subject,tidy_Data$Activity),]
write.table(tidy_Data, file = "Tidy_data.txt", row.names = FALSE)
#head(tidy_Data)
str(tidy_Data)
dim(tidy_Data)#[1] 180  88
