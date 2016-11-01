###  Answer to Question 2:
#### Sort the data frame in ascending order by GDP (so United States is last). What is the 13th country in the resulting data frame? 
#### Making a merged file that is sorted by Rank in ascending order and putting any NAs last.
## Use this just to check
mergedsort <- sort(mergedfile$GDP, decreasing = FALSE ,na.last = TRUE)

## Answer to question 2: sorting the merged file by GDP in ascending order
mergedsort2 <- mergedfile[order(mergedfile$GDP, decreasing = FALSE ,na.last = TRUE),]
mergedsort2[c(12,13,14),c(2,3,4)]
mergedsort2[c(13),c(2,3,4)]
```
#### As you can see there are 2 12th to last GDPs so there is no 13!  But alphabetically St. Kitts and Nevis is 13th.  

#### Remove all rows but the ones with Ranks, and keep only the first 6 columns.
#### Also make two objects that represent only the "High income: OECD" and "High income: nonOECD"
mergedsort3 <- mergedsort2[1:190, c(1:6)]
highincomeOECD <- mergedsort3[mergedsort3$IncomeGroup == "High income: OECD",]
highincomenonOECD <- mergedsort3[mergedsort3$IncomeGroup == "High income: nonOECD",]

## Gets rid of NA rows
highincomeOECD <- highincomeOECD[complete.cases(highincomeOECD$GDP),]
highincomenonOECD <- highincomenonOECD[complete.cases(highincomenonOECD$GDP),]
