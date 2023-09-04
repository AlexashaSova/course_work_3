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


