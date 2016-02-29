## Code for Course Project in Getting and Cleaning Data course

## The output summary data file name for the run_analysis function can be entered
## as an argument.

run_analysis <- function(outputfile = "tidydata.csv"){
     
     library(plyr, quietly = TRUE)
     library(dplyr)
     library(reshape2)

     ## Download file
     temp <- tempfile()
     url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     download.file(url, destfile = temp, method = "libcurl")
     
     ## Import and combine X data
     con1 <- unz(temp, "UCI HAR Dataset/train/X_train.txt")
     con2 <- unz(temp, "UCI HAR Dataset/test/X_test.txt")
     Xtrain <- read.table(con1)
     Xtest <- read.table(con2)
     Xdata <- rbind(Xtrain, Xtest)
     
     ## Import and combine Y data
     con1 <- unz(temp, "UCI HAR Dataset/train/y_train.txt")
     con2 <- unz(temp, "UCI HAR Dataset/test/y_test.txt")
     Ytrain <- read.table(con1)
     Ytest <- read.table(con2)
     Ydata <- rbind(Ytrain, Ytest)
     
     ## Import and combine subject data
     con1 <- unz(temp, "UCI HAR Dataset/train/subject_train.txt")
     con2 <- unz(temp, "UCI HAR Dataset/test/subject_test.txt")
     Strain <- read.table(con1)
     Stest <- read.table(con2)
     subjects <- rbind(Strain, Stest)
     
     ## Import labels
     con1 <- unz(temp, "UCI HAR Dataset/activity_labels.txt")
     con2 <- unz(temp, "UCI HAR Dataset/features.txt")
     activities <- read.table(con1)
     features <- read.table(con2)
     unlink(temp)

     ## Find features for mean and std measurements
     validCols <- sort(c(grep("mean\\(\\)", features$V2), grep("std\\(\\)", features$V2)))
     
     ## Remove unneeded columns from Xdata and unneeded labels
     Xdata <- Xdata[, validCols]
     features <- features[validCols,]
     
     ## Clean up labels and add to Xdata
     features$V2 <- tolower(features$V2)
     features$V2 <- sub("\\(\\)","", features$V2)
     features$V2 <- gsub("\\-","",features$V2)
     features$V2 <- sub("acc","acceleration",features$V2)
     colnames(Xdata) <- features[,2]
     
     ## Convert Ydata to activity names
     Ydata <- join(Ydata, activities, match = "all")
     Ydata <- select(Ydata, activity = V2)
     Ydata$activity <- tolower(Ydata$activity)

     ## rename subject column
     subjects <- select(subjects, subjectid = V1)
     
     ## combine X, Y, and subject columns
     data <- cbind(subjects, Ydata, Xdata)
     
     ## create data set with means for each variable for each subject/activity pair
     datamelt <- melt(data,id=c("subjectid","activity"))
     output <- dcast(datamelt, subjectid + activity ~ variable, mean)
     
     ## write output file
     write.csv(output, file = outputfile)
}