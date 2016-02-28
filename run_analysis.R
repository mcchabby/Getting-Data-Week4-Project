# run_analysis.R
setwd ('~/code/Coursera-Getting-Data/week4-project/')
library(data.table)

# Download data
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

# Chech if file exists, if it doesn't create it and unzip.
if (!file.exists('./UCI_HAR_Dataset.zip')) {
	download.file(fileURL, 'UCI_HAR_Dataset.zip', mode = 'curl')
	if (!file.exists('./UCI HAR Dataset/')) {
		unzip('UCI_HAR_Dataset.zip', exdir = './')
	}
}

print('Initializing script...')
# 1. Merges training and the test sets to create one data set.
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = " ")
features <- as.character(features[,2])

training.activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
training.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
training.X <- read.table('./UCI HAR Dataset/train/X_train.txt')
training.data <-  data.frame(training.subject, training.activity, training.X)

test.activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')
test.X <- read.table('./UCI HAR Dataset/test/X_test.txt')
test.data <-  data.frame(test.subject, test.activity, test.X)

names(training.data) <- c(c('subject', 'activity'), features)
names(test.data) <- c(c('subject', 'activity'), features)

merged_data <- rbind(training.data, test.data)

# 2. Extracts only the measurements on the mean and standard
# 	 deviation for each measurement.
which_columns <- grep('mean|std', features)
mean_standard_dev_subset <- merged_data[,c(1, 2, which_columns + 2)]

# 3. Uses descriptive activity names to name the activities in the data set.
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity_labels <- as.character(activity_labels[,2])
mean_standard_dev_subset$activity <- activity_labels[mean_standard_dev_subset$activity]

# 4. Appropriately labels the data set with descriptive variable names
var_names <- names(mean_standard_dev_subset)
# Remove ( and )
var_names <- gsub("[(][)]", "", var_names)
# Change start of label from t to Time_
var_names <- gsub("^t", "Time_", var_names)
# Change start of lable from f to Frequency_
var_names <- gsub("^f", "Frequency_", var_names)
# Change feature to be more descriptive
var_names <- gsub("Acc", "_Accelerometer", var_names)
var_names <- gsub("Gyro", "_Gyroscope", var_names)
var_names <- gsub("Mag", "_Magnitude", var_names)
# Same as above for Mean and Standard Deviation
var_names <- gsub("-mean-", "_Mean_", var_names)
var_names <- gsub("-std-", "_StandardDeviation_", var_names)
# Change all - to _
var_names <- gsub("-", "_", var_names)
names(mean_standard_dev_subset) <- var_names

# 5. Creates a second, independent tidy data set with the average of
# 	 each variable for each activity and each subject.
tidy <- aggregate(
			mean_standard_dev_subset[,3:81],
			by = list(
						activity = mean_standard_dev_subset$activity,
						subject = mean_standard_dev_subset$subject
					),
			FUN = mean
		)
write.table(x = tidy, file = 'tidy_data.txt', row.names = FALSE)
print('Script execution concluded')

