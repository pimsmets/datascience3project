library(data.table)

# 1. Read test and training data

# read training data
data <- read.table("./UCI HAR Dataset/train/X_train.txt")
subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
activities <- read.table("./UCI HAR Dataset/train/Y_train.txt")

# add test data
data <- rbind(data, read.table("./UCI HAR Dataset/test/X_test.txt"))
subjects <- rbind(subjects, read.table("./UCI HAR Dataset/test/subject_test.txt"))
activities <- rbind(activities, read.table("./UCI HAR Dataset/test/Y_test.txt"))

# read activitylabels
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
activityLabels <- activityLabels[,2]

# read feature labels
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
features <- features[,2]

# 2. Label the data, and keep only "mean()" and "std()" features
featuresToKeep <- grepl("mean\\(\\)", features) | grepl("std\\(\\)", features)
data <- data[,featuresToKeep]
features <- features[featuresToKeep]

# 3. Clean up the feature names and set the column names
features <- lapply(features, function(x) { x <- gsub("-", "_", x); x <- gsub("\\(\\)", "", x); paste("avg", x, sep="_")})
names(data) <- features

# 4. Set the activity labels
activities <- lapply(activities, function(x) activityLabels[x])

# 5. Add subjects and activities to the data
#    and label the 2 new columns
data <- cbind(subjects, activities, data)
names(data)[1:2] = c("subject", "activity")

# 6. Average per subject&activity
data <- data.table(data)
setkey(data, subject, activity)
tidy <- data[, lapply(.SD, mean), by=list(data$subject, data$activity)]
setnames(tidy, c(1,2), c("subject", "activity"))

# 7. Write to file
write.table(tidy, file="result.txt", row.name=FALSE)
