# Description of dataset used in this project and details of manipulation on it
---
### Source of data:
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (**WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING**) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. **The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.**

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

**For each record it is provided:**
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.
---
## Files used by the 'run_analysis.R' script:

> **According to the task only 8 files from the archive 'UCI HAR Dataset.zip' was used for analysis**.
**Information about the rest of the files can be obtained from the file 'README.txt' in the same [archive](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)**


|    №   | TITLE  | DESCRIPTION |
| ------ | ------ | ------- |
| 1 | activity_labels.txt | IDs and Names for each of the 6 activities|
| 2 | features.txt | List of all 561 features |
| 3 | train/subject_train.txt | List of ID of 70% of volunteers (21 persons). Each of 7352 lines corresponds to each line of the file 'X_train.txt', 7352 lines|
| 4 | train/X_train.txt | Table of 7352 observations over 561 features|
| 5 | train/Y_train.txt | List of ID of each of 6 activities. This list corresponds to the file 'X_train.txt'. 7352 lines |
| 6 | test/subject_test.txt | List of ID of 30% of volunteers (9 persons). Each of 2947 lines corresponds to each line of the file 'X_test.txt', 2947 lines |
| 7 | test/X_test.txt | Table of 2947 observations over 561 features |
| 8 | test/Y_test.txt | List of ID of each of 6 activities. This list corresponds to the file ‘X_test.txt’. 2947 lines |
---
&nbsp;
## Steps of the analysis:
0. Files listed above was automatically read into appropriate dataframes
1. Training and test data were merged with rbind() and cbind() functions to form united dataframe
2. With help of select() function 'mean' and 'std' measurements were extracted
3. IDs of 6 types of activities were superseded with descriptive names according to file 'activity_labels.txt'
4. Abbreviated names of measurements in header were superseded with descriptive names according to file **'features_info.txt' - this files is not mentioned in the table above**
5. Measurements of tidy data frame generated through the previous steps was grouped by subjectId and activityName in order to get mean() of each volunteer and each of his activity. Since each person performed 6 activities, this final file contains 30*6 = 180 rows 
6. In accordance to the task the final data frame was written to .txt file and uploaded to the GitHub
