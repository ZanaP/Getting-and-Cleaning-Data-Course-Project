### Initialize target values:
targetFolder <- 'UCI HAR Dataset'
filename <- 'getdata_dataset.zip'
### Get data from the internet:
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',filename)
### Unzip it:
unzip(filename)
### Read and merge data into the test and training sets:
test.data <- read.table(file.path(targetFolder, 'test', 'X_test.txt'))
test.activities <- read.table(file.path(targetFolder, 'test', 'y_test.txt'))
test.subjects <- read.table(file.path(targetFolder, 'test', 'subject_test.txt'))
train.data <- read.table(file.path(targetFolder, 'train', 'X_train.txt'))
train.activities <- read.table(file.path(targetFolder, 'train', 'y_train.txt'))
train.subjects <- read.table(file.path(targetFolder, 'train', 'subject_train.txt'))
### Now, combine the rows and columns of each of the data sets together in one table: 
data.data <- rbind(train.data, test.data)
data.activities <- rbind(train.activities, test.activities)
data.subjects <- rbind(train.subjects, test.subjects)
full_data <- cbind(data.subjects, data.activities, data.data)
### Define the complete list of features:
features <- read.table(file.path(targetFolder, 'features.txt'))
### Define & filter the features we need (created new object "NeededFeatures")
NeededFeatures <- features[grep('-(mean|std)\\(\\)', features[, 2 ]), 2]
full_data <- full_data[, c(1, 2, NeededFeatures)]
### Define the activities labels and names:
activities <- read.table(file.path(targetFolder, 'activity_labels.txt'))
full_data[, 2] <- activities[full_data[,2], 2]
### Define and label the new pooled data set with descriptive variable names in a string:
colnames(full_data) <- c(
+     'subject',
+     'activity',
+     gsub('\\-|\\(|\\)', '', as.character(NeededFeatures))
+ )
full_data[, 2] <- as.character(full_data[, 2])
### From pooled "full_data" dataset create new tidy data set with the average of each variable for each activity and each subject. 
### NOTE: Now is the time to install needed package "reshape" if not done earlier (do not forget to load it).
install.packages("reshape")
library (reshape)
final.melted <- melt(full_data, id = c('subject', 'activity'))
### Since we want out output to be dataframe, we will be using the dcast function in the package "reshape2" written by Hadley Wickham 
### that makes it easy to transform data between wide and long formats.
install.packages("reshape2")
library(reshape2)
final.mean <- dcast(final.melted, subject + activity ~ variable, mean)
### Finally, the output is written to a .txt file names "Tidy":
write.table(final.mean, file=file.path("tidy.txt"), row.names = FALSE, quote = FALSE)
