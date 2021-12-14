
library(plyr)


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
subDir <- "data"
destfile="./data/dataset.zip"  


download.file(url ,destfile) 
unzip(zipfile = destfile, exdir = subDir)
files_path <- "./data/UCI Dataset"


train_data <- read.table(file.path(files_path, "train/X_train.txt"),header = FALSE)
Y_train <- read.table(file.path(files_path, "train/Y_train.txt"),header = FALSE)
subject_train <- read.table(file.path(files_path, "train/subject_train.txt"),header = FALSE)
train_data <- cbind(train_data,Y_train,subject_train)


test_data  <- read.table(file.path(files_path, "test/X_test.txt"),header = FALSE)
Y_test  <- read.table(file.path(files_path, "test/Y_test.txt" ),header = FALSE)
subject_test  <- read.table(file.path(files_path, "test/subject_test.txt"),header = FALSE)
test_data <- cbind(test_data,Y_test,subject_test)



data <- rbind(train_data,test_data)

features <- as.character(read.table(file.path(files_path, "features.txt"),header = FALSE)[,2])
features <- gsub("^t", "time", features)
features <- gsub("^f", "frequency", features)
features <- gsub("Acc", "Accelerometer", features)
features <- gsub("Gyro", "Gyroscope", features)


colnames(data) <- c(features, "activity", "subject")

data<-subset(data,select=grep("(-(mean|std)\\(\\))|activity|subject",colnames(data),value = TRUE))


levels(data$activity) <- as.character(read.table(file.path(files_path, "activity_labels.txt"),header = FALSE)[,2])


tidy <- aggregate(. ~subject + activity, data, mean)