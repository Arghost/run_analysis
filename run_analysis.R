library(dplyr)


# Function to load all data into tables
load_TrainAndTest_data <- function(){
  
  #Read all the function names
  features <- as_tibble(read.table("UCI HAR Dataset/features.txt", col.names = c("n","feature")))
  
  #Read training data assignment column names
  train_x <- as_tibble(read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feature))
  
  #Training labels, related to the activities defined in activity_lables
  train_y <- as_tibble(read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code"))
  
  #Read test data assignment column names
  test_x <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
  
  #Test labels, related to the activities defined in activity_lables
  test_y <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
  
  #Read who performed the training activity (subject 1 to 30)
  train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
  
  #Read who performed the test activity (subject 1 to 30)
  test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
  
  #Read the possible activity labels executed
  act_lbls <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
  
  #Merge all datasets
  merged_data <- merge_data_sets(test_x, test_y, train_y, train_x, train_subject, test_subject)
  
  #Function to process the data and show results
  process_data(merged_data, act_lbls)
}
 
#Merges the training and the test sets to create one data set.
merge_data_sets <- function(test_x, test_y, train_y, train_x, train_subj, test_subj){
  
  #Data frame to use as merged
  merged <- tibble()
  #join test and train data for x and y
  x_data <- rbind(train_x, test_x)
  y_data <- rbind(train_y, test_y)
  
  sbj <- rbind(train_subj, test_subj)
  
  #Merge all info together
  merged <- cbind(sbj, x_data, y_data)
  
  return(merged)
}

# Process data as defined in the assignment
process_data <- function(merged_data, act_lbls){

  #Extracts only the measurements on the mean and standard deviation for each measurement.
  TidyData <- merged_data %>% 
            select(subject, code, contains("mean"), contains("std"))%>%
            rename(activity = code)
  
  #Uses descriptive activity names to name the activities in the data set
  TidyData$activity <- act_lbls[TidyData$activity, 2]
  
  #Appropriately labels the data set with descriptive variable names. 
  names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
  names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
  names(TidyData)<-gsub("angle", "Angle", names(TidyData))
  names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
  names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
  names(TidyData)<-gsub("mean", "Mean", names(TidyData))
  names(TidyData)<-gsub("std", "STD", names(TidyData))
  names(TidyData)<-gsub("^t", "Time", names(TidyData))
  names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
  names(TidyData)<-gsub("-mean()", "Mean", names(TidyData))
  names(TidyData)<-gsub("-std()", "STD", names(TidyData))
  
  #Create a second, independent tidy data set with the average of each variable for each activity and each subject.
  OutPut <- TidyData %>%
    group_by(subject, activity) %>%
    summarise_all(list(mean = mean))
  
  #Export data
  write.csv(OutPut, "TidyDataOutput.txt", row.names=FALSE)

  #Final print with results
  print(head(OutPut, 100))
}