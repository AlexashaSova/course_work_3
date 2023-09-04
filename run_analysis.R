library(dplyr)


## STEP 1 - Downloading zip file, saving data to created folder


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


