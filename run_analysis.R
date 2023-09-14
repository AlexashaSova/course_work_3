library(dplyr)


## STEP 1 - Downloading zip file, saving data to created folder. 
## Reading train and test data, features and labels 


zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_archive_name <- "UCI HAR Dataset.zip"
#path to downloaded zip archive
path_to_zip <- paste0("./data/", zip_archive_name)

# creating directory if not exists to store input data
if(!file.exists("data")){
        dir.create("data")
}

# creating directory for an output data (tidy dataset) if not exists
if(!file.exists("out")){
        dir.create("out")
}

# check if this file was not previously downloaded to the data folder
if(!file.exists(path_to_zip)){
        download.file(zip_url, 
                      destfile = path_to_zip)
        # check if we downloaded
        # list.files("./data/")
}

# unzip archive
unzip(path_to_zip,
      exdir = "./data/")


# reading data
# make a variable for the path
path_to_data <- "./data/UCI HAR Dataset/"
# for faster operations make it a data.table 
# test data
test_subj <- read.table(file.path(paste0(path_to_data, "test/subject_test.txt")))
test_values <- read.table(file.path(paste0(path_to_data, "test/X_test.txt")))
test_row_names <- read.table(file.path(paste0(path_to_data, "test/y_test.txt")))

#train data
train_subj <- read.table(file.path(paste0(path_to_data, "train/subject_train.txt")))
train_values <- read.table(file.path(paste0(path_to_data, "train/X_train.txt")))
train_row_names <- read.table(file.path(paste0(path_to_data, "train/y_train.txt")))

# features
features <- read.table(file.path(paste0(path_to_data, "features.txt")))

# labels
labels <- read.table(file.path(paste0(path_to_data, "activity_labels.txt")))

# set column names to the activity labels
colnames(labels) <- c("activityID",
                      "label")


## STEP-2 - Merging train and test data into one data table

person_activity <- rbind(
        cbind(train_subj, train_values, train_row_names),
        cbind(test_subj, test_values, test_row_names)
)
rm(train_subj, train_values, train_row_names, test_subj, test_values, test_row_names)
# setting column names
colnames(person_activity) <- c("subject", 
                               features[, 2], 
                               "activity")


## STEP-3 Extracting only the measurements on the mean and std. dev. for each measurement

# choosing columns we need
needed_cols <- grepl("subject|activity|mean|st_dev", 
                     colnames(person_activity))
person_activity <- person_activity[, needed_cols]


## STEP-4 Using descriptive activity names to name the activities in the data set

# replace activity values with named factor levels
person_activity$activity <- factor(person_activity$activity, 
                                   levels = labels[, 1], 
                                   labels = labels[, 2])


## STEP-5 

# getting and cleaning column names from special symbols, 
person_activity_colnames <- colnames(person_activity)
person_activity_colnames <- gsub("[\\(\\)-]", 
                                 "", 
                                 person_activity_colnames)
person_activity_colnames <- gsub("^f", "frequencyDomain", 
                                 person_activity_colnames)
person_activity_colnames <- gsub("^t", "timeDomain", 
                                 person_activity_colnames)
person_activity_colnames <- gsub("Acc", "Accelerometer", 
                                 person_activity_colnames)
person_activity_colnames <- gsub("Gyro", "Gyroscope", 
                                 person_activity_colnames)
person_activity_colnames <- gsub("Mag", "Magnitude", 
                                 person_activity_colnames)
person_activity_colnames <- gsub("Freq", "Frequency", 
                                 person_activity_colnames)
person_activity_colnames <- gsub("mean", "Mean", 
                                 person_activity_colnames)
person_activity_colnames <- gsub("std", "StandardDeviation", 
                                 person_activity_colnames)
person_activity_colnames <- gsub("BodyBody", "Body", 
                                 person_activity_colnames)
# set cleaned labels as a column names
colnames(person_activity) <- person_activity_colnames


## STEP-6 creating second, independent dataset, that is tidy and has an average 
# of each variable for each activity and each subject


person_activity_means <- person_activity %>% group_by(subject, activity) %>% summarise_each(funs(mean))
# write tidy dataset
write.table(person_activity_means, 
            "./out/tidy_dataset.txt", 
            row.names = FALSE, 
            quote = FALSE)

