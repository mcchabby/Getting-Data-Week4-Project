# Getting and Cleaning Data - Final Project
## How *run_analysis.R* works

1. Download UCI HAR Dataset if it doesn't exist in the project's directory.
2. Load Activity and Feature information into variables.
3. Loads Training set, Training Activity, and Training Subject; store them in a single data frame.
4. Loads Test set, Test Activity, and Test Subject; store them in a single data frame.
5. Merge Training and Test data into single data frame.
6. Select only Mean and Standard Deviation measurements for each feature.
7. Change labels to be more descriptive.
8. Create tidy dataset with average of each variable for each activity and each subject.
9. Write file tidy_data.txt