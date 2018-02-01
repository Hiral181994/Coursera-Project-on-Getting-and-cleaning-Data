setwd("E:\\ML_Project")
getwd()
if(!file.exists("./projects")){dir.create("./projects")}
##Get the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./projects/Dataset.zip")
##Unzip the file
unzip(zipfile="./projects/Dataset.zip",exdir="./projects")
#path to the folder UCI HAR Dataset
path_toFiles <- file.path("./projects" , "UCI HAR Dataset")
files<-list.files(path_toFiles, recursive=TRUE)
files
#Value of Variables comes from X_train and X_test
trainData <- read.table("./projects/UCI Har Dataset/train/X_train.txt")
testData <- read.table("./projects/UCI Har Dataset/test/X_test.txt")
xData <- rbind(trainData,testData)
str(xData)
#Value of subjects comes from X_train and X_test

trainSubjectData <- read.table("./projects/UCI Har Dataset/train/subject_train.txt")
testSubjectData <- read.table("./projects/UCI Har Dataset/test/subject_test.txt")
subjectData <- rbind(trainSubjectData,testSubjectData)
#Value of activity comes from X_train and X_test

trainYData <- read.table("./projects/UCI Har Dataset/train/y_train.txt")
testYData <- read.table("./projects/UCI Har Dataset/test/y_test.txt")
YData <- rbind(trainYData,testYData)
#Activity Label file
ActivityLabelData <- read.table("./projects/UCI Har Dataset/activity_labels.txt")
#Feature Names
FeaturesData <- read.table("./projects/UCI Har Dataset/features.txt")
#Merging files to treat them as one
mergeData <- merge(subjectData, YData)
FinalMergedData <- merge(xData, mergeData)
str(FinalMergedData)
#Extracts only the measurements on the mean and standard deviation for each measurement.
FilteredData<-FeaturesData$V2[grep("mean\\()|std\\()", FeaturesData$V2)]
filtered_activities <- xData[,FilteredData]
#Descriptive activity names to name the activities in the data set
names(filtered_activities)<-gsub("^t", "time", names(filtered_activities))
names(filtered_activities)<-gsub("^f", "frequency", names(filtered_activities))
names(filtered_activities)<-gsub("Acc", "Accelerometer", names(filtered_activities))
names(filtered_activities)<-gsub("Gyro", "Gyroscope", names(filtered_activities))
names(filtered_activities)<-gsub("Mag", "Magnitude", names(filtered_activities))
names(filtered_activities)<-gsub("BodyBody", "Body", names(filtered_activities))
names(filtered_activities)

#Appropriately labels the data set with descriptive variable names.
YData[,1] <- ActivityLabelData[YData[,1],2]
names(YData) <- "Activity"
names(subjectData) <- "Volunteers"
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidyData <- cbind(subjectData, YData, filtered_activities)
library(dplyr)
NewData<-aggregate(. ~Volunteers + Activity, tidyData, mean)
# writes data to tidyData text file
write.table(NewData, file = "tidyData.txt",row.name=FALSE)
