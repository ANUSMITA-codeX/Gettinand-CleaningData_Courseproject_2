# run_analysis.R
# Course Project for Getting and Cleaning Data

library(dplyr)

# Step 1: Merge training and test sets
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("id", "feature"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Read training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Read test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

# Merge datasets
merged_data <- rbind(
  cbind(subject_train, y_train, x_train),
  cbind(subject_test, y_test, x_test)
)

# Step 2: Extract mean and standard deviation measurements
tidy_data <- merged_data %>% 
  select(subject, code, contains("mean"), contains("std"))

# Step 3: Use descriptive activity names
tidy_data$code <- activity_labels[tidy_data$code, 2]

# Step 4: Label with descriptive variable names
names(tidy_data)[2] <- "activity"
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("\\.", "", names(tidy_data))  # Remove dots

# Step 5: Create independent tidy dataset with averages
final_tidy_data <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean))

# Save the final dataset
write.table(final_tidy_data, "tidy_data_averages.txt", row.names = FALSE)

# Verification
cat("Script completed successfully.\n")
cat("Dimensions of final dataset:", dim(final_tidy_data), "\n")
cat("File saved as 'tidy_data_averages.txt'\n")