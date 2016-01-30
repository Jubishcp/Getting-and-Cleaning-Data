#loading up required library
# Assuming the working directory has required data in the directory structure as extracted data


library(reshape2)

# reading the data
subjecttestdata<-read.table("subject_test.txt")
subjecttraindata<-read.table("subject_train.txt")
Xtestdata<-read.table("X_test.txt")
Xtraindata<-read.table("X_train.txt")
Ytestdata<-read.table("Y_test.txt")
Ytraindata<-read.table("Y_train.txt")
featureNames <- read.table("features.txt")
activitylabels<-read.table("activity_labels.txt")



# making column names understandable based on column meta data available
names(subjecttraindata) <- "subjectid"
names(Xtraindata) <- featureNames$V2
names(Ytraindata) <- "activity"

names(subjecttestdata) <- "subjectid"
names(Xtestdata) <- featureNames$V2
names(Ytestdata) <- "activity"

# puting all data together

alltrain <- cbind(subjecttraindata, Ytraindata, Xtraindata)
alltest <- cbind(subjecttestdata,Ytestdata, Xtestdata)
alldata <- rbind(alltrain, alltest)

#Extracting only the measurements on the mean and standard


extractingcolums <- grepl("mean\\(\\)", names(alldata),ignore.case = TRUE) |
  grepl("std\\(\\)", names(alldata),ignore.case = TRUE)|
  grepl("subjectid", names(alldata),ignore.case = TRUE)|
  grepl("activity", names(alldata),ignore.case = TRUE)
  
msdata <- alldata[, extractingcolums]


# making the activity descriptive from id

for (i in 1:6) {
  msdata$activity[msdata$activity == i] <- as.character(activitylabels$V2[i])
}



# creating tidy data
melteddata <- melt(msdata, id=c("subjectid","activity"))
tidydata <- dcast(melteddata, subjectid+activity ~ variable, mean)


#writing to file
write.csv(tidydata, "tidy.csv", row.names=FALSE)
