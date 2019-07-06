#####################################################
# Obtain name of the file (.zip archive with dataset)
#####################################################

urlLinkToDataSet <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

fileName <- URLdecode(urlLinkToDataSet) %>% 
              basename()





###################
# Download the file
###################

if (!file.exists(fileName)) {
  download.file(urlLinkToDataSet, fileName, method="curl")
} else {
  cat("The file [", fileName, "] already exists!")
}


print ("File was downloaded successfully")



# Unzip the file

library(tools)
dirName <- file_path_sans_ext(fileName)

if (!file.exists(dirName)) { 
  unzip(fileName)
}


print ("File was unzipped successfully")


#############################
# Read files into data frames
#############################

activityLabels <- read.table(paste(dirName, "activity_labels.txt", sep = "/"), col.names = c("activity_id", "activity_name"))
features <- read.table(paste(dirName, "features.txt", sep = "/"), col.names = c("feature_id", "feature_name"))

  # Read train data

subjectTrain <- read.table(paste(dirName, "train/subject_train.txt", sep = "/"), col.names = c("subject_id"))
xTrain <- read.table(paste(dirName, "train/X_train.txt", sep = "/"), col.names = features$feature_name)
yTrain <- read.table(paste(dirName, "train/Y_train.txt", sep = "/"), col.names = "activity_id")

  # Read test data

subjectTest <- read.table(paste(dirName, "test/subject_test.txt", sep = "/"), col.names = ("subject_id"))
xTest <- read.table(paste(dirName, "test/X_test.txt", sep = "/"), col.names = features$feature_name)
yTest <- read.table(paste(dirName, "test/Y_test.txt", sep = "/"), col.names = "activity_id")


print ("Files were uploaded to data frames successfully")


##################################################################
# 1. Merges the training and the test sets to create one data set.
##################################################################

  # Merge train and test datasets
xMerged <- rbind(xTrain, xTest)
yMerged <- rbind(yTrain, yTest)

  # Merge subjects datasets
subjectMerged <- rbind(subjectTrain, subjectTest)

  # Merge all datasets
mainMerge <- cbind(xMerged, yMerged, subjectMerged)


print ("Data frames wre merged successfully")


############################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
############################################################################################

extraction <- select(mainMerge, subject_id, activity_id, contains("mean"), contains("std"))


print ("Extraction of mean() and std() measurements was performed successfully")


###########################################################################
# 3. Uses descriptive activity names to name the activities in the data set
###########################################################################

activity_name <- activityLabels$activity_name[match(extraction$activity_id, activityLabels$activity_id)]

library(tibble)

extraction <- add_column(extraction, activity_name, .after = 2)


print ("Column with descriptive activity name was addeed successfully")


#####################################################################
# 4. Appropriately labels the data set with descriptive variable names
#####################################################################

# Now, in 'extraction' data frame we have column titles which have abbreviated view,
# such as 'tBodyAcc-mean()-X', 'tGravityAccMag-mean()' or 'fBodyBodyAccJerkMag-meanFreq()'.
# We can notice a specific pattern in these names, where 't' or 'f' at start of names - stand for Time/Frequency appropriately
# 'Acc' / 'Mag' - stand for Accelerometer / Magnitude

## !!!This block of code is optional. Just to print out all existing abbreviations in the header

# Run over column names, split them and store the chunks into the vector
#listOfAbbreviations <- c()

#for(n in names(extraction)) {
#  split <- unlist(gsub("([A-Z])", " \\1", gsub("\\.", " \\1", n)) %>% strsplit(" "))
#  print (split)
#  listOfAbbreviations <- append(listOfAbbreviations, split, after = length(listOfAbbreviations))
#}


## Throw away duplicates from the vector
#listOfAbbreviations <- unique(listOfAbbreviations, incomparables = FALSE)
  

## Now the unduplicated list of abbreviations ('listOfAbbreviations') can be easely examined
## and appropriate full names can be found

names(extraction)<-gsub("subject_id", "subjectId", names(extraction))
names(extraction)<-gsub("activity_id", "activityId", names(extraction))
names(extraction)<-gsub("activity_name", "activityName", names(extraction))
names(extraction)<-gsub("angle\\.", "angle-", names(extraction))

names(extraction)<-gsub("^t", "time-", names(extraction))
names(extraction)<-gsub("-t", "-time-", names(extraction))
names(extraction)<-gsub("^f", "frequency-", names(extraction))
names(extraction)<-gsub("-X\\.", "-X-", names(extraction))
names(extraction)<-gsub("-Y\\.", "-Y-", names(extraction))
names(extraction)<-gsub("-Z\\.", "-Z-", names(extraction))

names(extraction)<-gsub("BodyBody", "Body", names(extraction))

names(extraction)<-gsub("Acc", "Accelerometer", names(extraction))
names(extraction)<-gsub("Gyro", "Gyroscope", names(extraction))
names(extraction)<-gsub("Mag", "Magnitude", names(extraction))

names(extraction)<-gsub("\\.mean\\.\\.\\.", "\\.Mean()-", names(extraction), ignore.case = TRUE)
names(extraction)<-gsub("\\.mean\\.\\.", "\\.Mean()", names(extraction), ignore.case = TRUE)
names(extraction)<-gsub("\\.meanFreq\\.\\.\\.", "\\.Mean()-Frequency()-", names(extraction), ignore.case = TRUE)
names(extraction)<-gsub("\\.meanFreq\\.\\.", "Mean()-Frequency()", names(extraction), ignore.case = TRUE)
names(extraction)<-gsub("gravityMean\\.", "Gravity\\.Mean()", names(extraction))

names(extraction)<-gsub("\\.std...", "-STD()-", names(extraction), ignore.case = TRUE)
names(extraction)<-gsub("\\.std\\.\\.", "-STD()", names(extraction), ignore.case = TRUE)


print ("Full names were placed successfully")


#############################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject
#############################################################################

groupedData <-  group_by(extraction, subjectId, activityName)
summarisedData <- summarise_all(groupedData, funs(mean))


print ("Data was grouped and averaged successfully")

# Write tidy dataset to a .csv file

write.table(summarisedData, "tidy_dataset_human_activities.txt", row.name=FALSE)


print ("tidy_dataset_human_activities.txt file was written successfully")


