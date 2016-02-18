
Load  data and packagegs
---------------------------------------------------------
```{r}
library(data.table)
library(dplyr)
```
  Reading supporting data
---------------------------------------------------------
```{r}
featureNames <- read.table("./UCI HAR Dataset/features.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

```
 Reading train data
---------------------------------------------------------
```{r}
train_Data <- read.table("./UCI HAR Dataset/train/X_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

activityTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
```
 Reading test data
---------------------------------------------------------
```{r}
test_Data <- read.table("./UCI HAR Dataset/test/X_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
activityTest <- read.table("./UCI HAR Dataset//test/Y_test.txt")
```
Part 1 - Merge the training and the test sets to create one data set
---------------------------------------------------------
```{r}
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
Data_only <- rbind(train_Data,test_Data)
```
Naming the columns of total data is named from featuresNames by taking transpose

```{r}
colnames(Data_only) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
```
The data in features,activity and subject are merged and the complete data is now stored in completeData

```{r}
TotalData <- cbind(Data_only,activity,subject)
dim(TotalData)
```
Part 2 : Extracts only the measurements on the mean and standard deviation for each measurement
---------------------------------------------------------
```{r}

columnsWithMeanSTD <- grep("Mean|Std", names(TotalData), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
requiredData <- TotalData[,requiredColumns]
dim(requiredData) 
```
Part 3 : descriptive activity names are used to name the activities in the data set
---------------------------------------------------------
```{r}
requiredData$Activity <- as.character(requiredData$Activity)
for (i in 1:6){
    requiredData$Activity[requiredData$Activity == i] <- as.character(activityLabels[i,2])
}

requiredData$Activity <- as.factor(requiredData$Activity)
```
Part 4 :Appropriately labels the data set with descriptive variable names
---------------------------------------------------------
```{r}
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
```
Part 5 :Creating Tidy data and output  text file
---------------------------------------------------------
```{r}
requiredData$Subject <- as.factor(requiredData$Subject)
requiredData <- data.table(requiredData)
```



```{r}
tidy_Data <- aggregate(. ~Subject + Activity, requiredData, mean)
tidy_Data <- tidy_Data[order(tidy_Data$Subject,tidy_Data$Activity),]
write.table(tidy_Data, file = "Tidy_data.txt", row.names = FALSE)
```

