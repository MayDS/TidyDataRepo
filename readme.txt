ReadMe for Getting and Cleaning Data course project

The function run_analysis() performs the following:
(1) downloads the zip file for the UCI HAR Dataset to a temporary location
(2) imports and combines the data sets, activity label IDs, and subject IDs for training and test
(3) imports the activity and features labels
(4) filters the data sets and feature labels for mean* and standard deviation measurements.
		* Note that the weighted freqency mean calculated measurements are not included
		to reduce complexity of the final data set.
(5) cleans up the naming of the features and labels the data set with these
(6) matches the activity IDs to activity names
(7) adds the activity name and subject ID columns to the dataset
(8) creates a second, independent, tidy data set with the average of each variable for each 
    activity and each subject
(9) writes the final data set from step 8 out as a csv file (either tidydata.csv or the filename 
	specified by the argument in the function call) in the user's current working directory
	
Note that this function was written and tested on a Windows operating system.

Variable names are defined in the associated codebook for this project.
