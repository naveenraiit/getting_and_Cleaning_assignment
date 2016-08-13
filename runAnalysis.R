# Load libraries
library(plyr)

# Data download
if (!file.exists("data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/dataset.zip")
# Unzip the files
unzip("./data/dataset.zip")

#Read files from the test and directory
setwd("UCI HAR Dataset")
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjtrain <- read.table("train/subject_train.txt")

xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjtest <- read.table("test/subject_test.txt")

# Bind data from test and train in the single data frame
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subjdata <- rbind(subjtrain, subjtest)

# Extract mean and standard deviation for each measurement 
features <- read.table("features.txt")
meanandstdfeatures <- grep("-(mean|std)\\(\\)", features[, 2])
xdata <- xdata[ ,meanandstdfeatures]
names(xdata) <- features[meanandstdfeatures, 2]

# Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
ydata[, 1] <- activities[ydata[, 1], 2]
names(ydata) <- "activity"


# correct column name
names(subjdata) <- "subject"

# bind all the data in a single data set
alldata <- cbind(xdata, ydata, subjdata)

# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
averagesdata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averagesdata, "FINAL_data.txt", row.name=FALSE)
