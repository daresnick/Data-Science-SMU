

## Answer to question 1:
length(intersect(gdpa$CountryCode,feda$CountryCode))

## Just a way of seeing the number that did not intersect
length(mergedfile$CountryCode) - length(intersect(gdpa$CountryCode,feda$CountryCode))

## The intersect function finds the elements that are the same in the two columns.   
  
#### Make blank values NAs and make sure the GDP and Rank columns are numeric to answer question 2.
##### I also want to keep track of the NAs before and after.

count(is.na(mergedfile$GDP))
mergedfile$GDP <- as.numeric(gsub("[^[:digit:]]","", mergedfile$GDP))
count(is.na(mergedfile$GDP))
str(mergedfile$GDP)

count(is.na(mergedfile$Rank))
mergedfile$Rank <- as.numeric(gsub("[^[:digit:]]","", mergedfile$Rank))
count(is.na(mergedfile$Rank))
str(mergedfile$Rank)
