library(dplyr)
#caching the data so I dont have to load it every time. Its much easier to check.
# also thought about using the DataCache library, but this works. 


#in read.csv I needed to put header =FALSE. in ?read.csv it shows it as defaulted to no header
#if you have any idea, let me know in the comments .
if (!(exists("activitylabelsRaw"))){
    activitylabelsRaw=read.csv("./UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
}
if (!(exists("featuresRaw"))){
    featuresRaw=read.csv("./UCI HAR Dataset/features.txt", sep="", header=FALSE)
}
if (!(exists("xtestRaw"))){
    xtestRaw=read.csv("./UCI HAR Dataset/test/X_test.txt",sep="", header=FALSE)
}
if (!(exists("ytestRaw"))){
    ytestRaw=read.csv("./UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
}
if (!(exists("subjecttestRaw"))){
    subjecttestRaw=read.csv("./UCI HAR Dataset/test/subject_test.txt",sep="", header=FALSE)
}

if (!(exists("xtrainRaw"))){
    xtrainRaw=read.csv("./UCI HAR Dataset/train/X_train.txt",sep="", header=FALSE)
}
if (!(exists("ytrainRaw"))){
    ytrainRaw=read.csv("./UCI HAR Dataset/train/y_train.txt",sep="", header=FALSE)
}
if (!(exists("subjecttrainRaw"))){
    subjecttrainRaw=read.csv("./UCI HAR Dataset/train/subject_train.txt",sep="",header=FALSE)
}

#used ytrain2 as a way of matching labels and activity numbers. 
#There is a MUCH more elegant way of doing it, I'm sure, but I was unable to find out. 
ytest2<- merge (ytestRaw, activitylabelsRaw, by = "V1") 
test<-data.frame(subjecttestRaw,ytest2,xtestRaw)

ytrain2<- merge(ytrainRaw, activitylabelsRaw, by = "V1") 

train<-data.frame(subjecttrainRaw,ytrain2,xtrainRaw)

accelData<-rbind(train,test)

featuresVector<-as.vector(featuresRaw[,2])

#what data do we want?
colnames(accelData) <- c("subjectNumber", "activity number", "activityName", featuresVector)

#selecting only the ones we want
accelData <- select(accelData, subjectNumber, activityName,
                   contains("mean"), contains("std"), -contains("freq"),
                   -contains("angle"))
#cleaning up column names

colnames(accelData) <- gsub("BodyBody","Body",colnames(accelData))
colnames(accelData) <- gsub("Acc","Accel",colnames(accelData))
colnames(accelData) <- gsub("^f","Frequency",colnames(accelData))
colnames(accelData) <- gsub("^t","Time",colnames(accelData))
colnames(accelData) <- gsub("-mean\\(\\)", "Mean", colnames(accelData))
colnames(accelData) <- gsub("-std\\(\\)", "Std", colnames(accelData))
colnames(accelData) <- gsub("-", "", colnames(accelData))


#creating tidy Data
tidyData <- aggregate(accelData[-c(1,2)], by=list(activity = accelData$activityName, subject=accelData$subjectNumber), mean)


write.table(tidyData, file = "tidyData.txt", row.names = FALSE, sep = "\t")







