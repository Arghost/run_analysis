Getting and Cleaning Data Course Project

Repository by R. Torres. Contains data and steps to collect, work with, and clean a data set.

Files in this repository:

1. CodeBook.md: Describes the variables, the data, and any transformations or work performed to clean up the data

2. run_analysis.R: Coding executing the following steps:
  a. Load all data into tables
  b. Merges the training and the test sets to create one data set.
  c. Extracts only the measurements on the mean and standard deviation for each measurement.
  d. Uses descriptive activity names to name the activities in the data set
  e. Appropriately labels the data set with descriptive variable names. 
  f. Create an independent tidy data set with the average of each variable for each activity and each subject.
  g. Exports the data to a csv file for easy reading and following.

3. TidyDataOutput.txt: CSV file that contains the mean of each variable for each individual (30 total) used for the test.
   File is composed of the dataset generated un the run_analysis code