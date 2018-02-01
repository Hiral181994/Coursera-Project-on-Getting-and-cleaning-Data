Code Book
This document describes the code inside run_analysis.R.


Downloading and loading data
Downloads the UCI HAR zip file if it doesn't exist
Reads the activity labels to activityLabels
Reads the test data.frame 
Reads the training data.frame 
Manipulating data
Merges test data and training data to FinalMergedData

#From the data set in step an independent tidy data set with the average of each variable for each activity and each subject usimg aggregate function
tidyData <- cbind(subjectData, YData, filtered_activities)
library(dplyr)
NewData<-aggregate(. ~Volunteers + Activity, tidyData, mean)
Writing final data to text File
