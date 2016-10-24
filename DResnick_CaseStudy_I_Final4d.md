# Case Study I
Damon Resnick  
October 21, 2016  

### Introduction
Gross Domestic product and Education data was downloaded from the World Bank website. The data was cleaned, tidied, and merged together to form a dataset that could be analyzed to answer these five questions:  

1)  Merge the data based on the country shortcode. How many of the IDs match?     
2)  Sort the data frame in ascending order by GDP (so United States is last). What is the 13th country in the resulting data frame?  
3)  What are the average GDP rankings for the "High income: OECD" and "High income:nonOECD" groups?  
4)  Plot the GDP for all of the countries. Use ggplot2 to color your plot by Income Group.  
5)  Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income Group. How many countries are Lower middle income but among the 38 nations with highest GDP?   



The answers are presented within the file below as it becomes convenient to answer them, and they are also presented and discussed in more detail at the end of this file in the summary and conclusion.  


### The code below should be able to be run as R Markdown and present the results in a useful way.
##### This code was designed for use in RStudio on a Windows 10 machine. It should work on other platforms with no changes, however this may not be the case.  


```r
library(knitr)
library(formatR)
opts_chunk$set(tidy.opts=list(width.cutoff=80),tidy=TRUE)
opts_chunk$set(out.width='1000px', dpi=300)
```
  


#### Load packages I may need. Set working directory.

```r
library(stats)
library(plyr)
library(ggplot2)
library(repmis)

# setwd('C:/Users/hp/Desktop/SMU/Doing Data Science/Homework/Case Studies')

setwd(".")
```
<br><br>

#### Upload the data from the web and load data into two raw data sets in R.
##### This method is quick, but the data is only saved in active memory not on the hard drive.
##### This also makes the columns numeric and character by default.

```r
gdpraw <- source_data("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", 
    skip = 5, header = FALSE)
```

```
## Downloading data from: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
```

```
## SHA-1 hash of the downloaded data file is:
## 18dd2f9ca509a8ace7d8de3831a8f842124c533d
```

```r
fedraw <- source_data("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", 
    header = TRUE)
```

```
## Downloading data from: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
```

```
## SHA-1 hash of the downloaded data file is:
## 20be6ae8245b5a565a815c18a615a83c34745e5e
```


#### Another way to load the data.  Saves files to the hard drive and then loads into R.
#### This loads the data with slightly different variable names so if you use this make sure to rename them correctly.
#### This has been commented out below.

```r
# GDPFileUrl<-'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
# FEDFileUrl<-'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'

# download.file(GDPFileUrl,destfile='Data/FGDP_Rank_raw.csv')
# download.file(FEDFileUrl,destfile='Data/FEDSTATS_Country_raw.csv')

# gdpraw <- read.csv('./Data/FGDP_Rank_raw.csv',skip=5,header=FALSE) fedraw <-
# read.csv('./Data/FEDSTATS_Country_raw.csv',header=TRUE)
```


#### Looking at the data (Commented out for Markdown)

```r
# head(gdpraw) head(fedraw) str(gdpraw) str(fedraw)
```


#### Making data file objects so I won't have to load the data later if I need to go back and look at the raw data.

```r
gdpa <- gdpraw
feda <- fedraw
```


#### Remove columns I don't need, rename header, and Remove rows without country codes

```r
## get rid of all the other columns
gdpa <- gdpa[, c(1, 2, 4, 5)]
head(gdpa)
```

```
##    V1 V2             V4           V5
## 1 USA  1  United States  16,244,600 
## 2 CHN  2          China   8,227,103 
## 3 JPN  3          Japan   5,959,718 
## 4 DEU  4        Germany   3,428,131 
## 5 FRA  5         France   2,612,878 
## 6 GBR  6 United Kingdom   2,471,784
```

```r
## rename header
names.feda <- names(feda)
# names.feda
names(gdpa) <- c("CountryCode", "Rank", "Long Name", "GDP")
names(gdpa)
```

```
## [1] "CountryCode" "Rank"        "Long Name"   "GDP"
```

```r
## get rid of rows without country codes, only the first 215 have country codes
gdpa <- gdpa[1:215, ]
```


#### Merge files gdpa and feda using the CountryCode as a common column then count the NAs in each column.

```r
mergedfile <- merge(gdpa, feda, by = "CountryCode", all = TRUE)

## Count the number of NAs in each column
mergefile.na <- colSums(is.na(mergedfile))
## mergefile.na
```


### Answer to Question 1.

```r
## Answer to question 1:
length(intersect(gdpa$CountryCode, feda$CountryCode))
```

```
## [1] 210
```

```r
## Just a way of seeing the number that did not intersect
length(mergedfile$CountryCode) - length(intersect(gdpa$CountryCode, feda$CountryCode))
```

```
## [1] 29
```
The intersect function finds the elements that are the same in the two columns.   


#### Make blank values NAs and make sure the GDP and Rank columns are numeric so that we can answer question 2.
#### I also want to keep track of the NAs before and after.

```r
count(is.na(mergedfile$GDP))
```

```
##       x freq
## 1 FALSE  215
## 2  TRUE   24
```

```r
mergedfile$GDP <- as.numeric(gsub("[^[:digit:]]", "", mergedfile$GDP))
count(is.na(mergedfile$GDP))
```

```
##       x freq
## 1 FALSE  190
## 2  TRUE   49
```

```r
str(mergedfile$GDP)
```

```
##  num [1:239] NA 2584 NA 20497 114147 ...
```

```r
count(is.na(mergedfile$Rank))
```

```
##       x freq
## 1 FALSE  215
## 2  TRUE   24
```

```r
mergedfile$Rank <- as.numeric(gsub("[^[:digit:]]", "", mergedfile$Rank))
count(is.na(mergedfile$Rank))
```

```
##       x freq
## 1 FALSE  190
## 2  TRUE   49
```

```r
str(mergedfile$Rank)
```

```
##  num [1:239] NA 161 NA 105 60 125 32 26 133 NA ...
```


###  Answer to Question 2:
#### Sort the data frame in ascending order by GDP (so United States is last). What is the 13th country in the resulting data frame? 
#### Making a merged file that is sorted by Rank in ascending order and putting any NAs last.

```r
## Use this just to check
mergedsort <- sort(mergedfile$GDP, decreasing = FALSE, na.last = TRUE)

## Answer to question 2: sorting the merged file by GDP in ascending order
mergedsort2 <- mergedfile[order(mergedfile$GDP, decreasing = FALSE, na.last = TRUE), 
    ]
mergedsort2[c(12, 13, 14), c(2, 3, 4)]
```

```
##     Rank         Long Name.x GDP
## 82   178             Grenada 767
## 111  178 St. Kitts and Nevis 767
## 231  177             Vanuatu 787
```

```r
mergedsort2[c(13), c(2, 3, 4)]
```

```
##     Rank         Long Name.x GDP
## 111  178 St. Kitts and Nevis 767
```
#### As you can see there are 2 12th to last GDPs so there is no 13!  But alphabetically St. Kitts and Nevis is 13th.  


#### Remove all rows but the ones with Ranks, and keep only the first 6 columns.
#### Also make two objects that represent only the "High income: OECD" and "High income: nonOECD"

```r
mergedsort3 <- mergedsort2[1:190, c(1:6)]
highincomeOECD <- mergedsort3[mergedsort3$`Income Group` == "High income: OECD", 
    ]
highincomenonOECD <- mergedsort3[mergedsort3$`Income Group` == "High income: nonOECD", 
    ]

## Gets rid of NA rows
highincomeOECD <- highincomeOECD[complete.cases(highincomeOECD$GDP), ]
highincomenonOECD <- highincomenonOECD[complete.cases(highincomenonOECD$GDP), ]
```


### Answers to Question 3:
#### The averages of the Ranks for the "High income: OECD" and "High income: nonOECD".

```r
## Question 3 Answers:
mean(highincomeOECD$Rank)
```

```
## [1] 32.96667
```

```r
mean(highincomenonOECD$Rank)
```

```
## [1] 91.91304
```

```r
## Average of GDPs as well. Why not?
mean(highincomeOECD$GDP)
```

```
## [1] 1483917
```

```r
mean(highincomenonOECD$GDP)
```

```
## [1] 104349.8
```


#### Cleaning up everything else now. Making an object with only countries with Ranks, and getting rid of all the columns I don't seem to need.

```r
GDPall <- mergedsort2[1:190, c(1:6)]

## Clean up GDPall and get rid of all the factors
GDPall$`Income Group` <- GDPall$`Income Group` <- as.character(GDPall$`Income Group`)
GDPall$`Long Name.x` <- as.character(GDPall$`Long Name.x`)
GDPall$`Long Name.y` <- as.character(GDPall$`Long Name.y`)
GDPall$CountryCode <- as.character(GDPall$CountryCode)
```


### Answer to question 4:
#### Make a plot of GDP vs. Income Group colored by Income Group.

```r
plot1a <- ggplot(GDPall) + geom_point(aes(y = GDP, x = `Income Group`, colour = `Income Group`)) + 
    scale_y_log10()
plot1a + labs(title = "GDP vs Income Group", x = "Income Groups", y = "GDP-millions", 
    colour = "Income Group") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

```
## Warning: Removed 1 rows containing missing values (geom_point).
```

<img src="DResnick_CaseStudy_I_Final4d_files/figure-html/unnamed-chunk-15-1.png" width="1000px" />


#### One row has an NA in the Income Group column so we will replace it with "NA-South Sudan" and plot again.


```r
count(is.na(GDPall$`Income Group`))
```

```
##       x freq
## 1 FALSE  189
## 2  TRUE    1
```

```r
GDPall$`Income Group`[is.na(GDPall$`Income Group`)] <- "NA-South Sudan"
count(is.na(GDPall$`Income Group`))
```

```
##       x freq
## 1 FALSE  190
```

```r
plot1a <- ggplot(GDPall) + geom_point(aes(y = GDP, x = `Income Group`, colour = `Income Group`)) + 
    scale_y_log10()
plot1a + labs(title = "GDP vs Income Group", x = "Income Groups", y = "GDP-millions", 
    colour = "Income Group") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

<img src="DResnick_CaseStudy_I_Final4d_files/figure-html/unnamed-chunk-16-1.png" width="1000px" />


#### Making objects for the other income groups. Why not?

```r
lowincome <- mergedsort3[mergedsort3$`Income Group` == "Low income", ]
lowermiddleincome <- mergedsort3[mergedsort3$`Income Group` == "Lower middle income", 
    ]
uppermiddleincome <- mergedsort3[mergedsort3$`Income Group` == "Upper middle income", 
    ]

## Gets rid of NA rows I don't think there are any left now.
lowincome <- lowincome[complete.cases(lowincome$GDP), ]
lowermiddleincome <- lowermiddleincome[complete.cases(lowermiddleincome$GDP), ]
uppermiddleincome <- uppermiddleincome[complete.cases(uppermiddleincome$GDP), ]
```


### Answers to Question 5:
#### Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income Group. How many countries are Lower middle income but among the 38 nations with highest GDP?
#### Use quantile function to break up the data into 5 Rank Quantiles

```r
data.quant <- quantile(GDPall$Rank, seq(0, 1, 0.2))
data.quant
```

```
##    0%   20%   40%   60%   80%  100% 
##   1.0  38.8  76.6 114.4 152.2 190.0
```

```r
## This gave us 38.8 as the cuttoff, so below are two ways to get the answer
lowermiddleincome[which(lowermiddleincome$Rank < 38.8), c(1, 2, 3, 4, 6)]
```

```
##     CountryCode Rank      Long Name.x     GDP        Income Group
## 62          EGY   38 Egypt, Arab Rep.  262832 Lower middle income
## 211         THA   31         Thailand  365966 Lower middle income
## 94          IDN   16        Indonesia  878043 Lower middle income
## 96          IND   10            India 1841710 Lower middle income
## 38          CHN    2            China 8227103 Lower middle income
```

```r
GDPall[which(GDPall$Rank < 38.8 & GDPall$`Income Group` == "Lower middle income"), 
    c(1, 2, 3, 4, 6)]
```

```
##     CountryCode Rank      Long Name.x     GDP        Income Group
## 62          EGY   38 Egypt, Arab Rep.  262832 Lower middle income
## 211         THA   31         Thailand  365966 Lower middle income
## 94          IDN   16        Indonesia  878043 Lower middle income
## 96          IND   10            India 1841710 Lower middle income
## 38          CHN    2            China 8227103 Lower middle income
```

```r
nrow(GDPall[which(GDPall$Rank < 38.8 & GDPall$`Income Group` == "Lower middle income"), 
    ])
```

```
## [1] 5
```

```r
## Another way to do it is to make a table, first figure out the quantile cutoff
## points
brk <- with(GDPall, quantile(GDPall$GDP, probs = c(0, 0.2, 0.4, 0.6, 0.8, 1)))
data.quant2 <- within(GDPall, quantile <- cut(GDPall$GDP, breaks = brk, labels = 1:5, 
    include.lowest = TRUE))

## Checking
nrow(data.quant2[which(data.quant2$quantile == 5 & data.quant2$`Income Group` == 
    "Lower middle income"), ])
```

```
## [1] 5
```

```r
## Table answers question 5.
table(data.quant2$`Income Group`, data.quant2$quantile)
```

```
##                       
##                         1  2  3  4  5
##   High income: nonOECD  2  4  8  5  4
##   High income: OECD     0  1  1 10 18
##   Low income           11 16  9  1  0
##   Lower middle income  16  8 12 13  5
##   NA-South Sudan        0  1  0  0  0
##   Upper middle income   9  8  8  9 11
```

```r
## You can see that there are only 5 total countries in the Lower middle income
## group that are also in the 5th and highest quantile Those countries are again
GDPall[which(GDPall$Rank < 38.8 & GDPall$`Income Group` == "Lower middle income"), 
    c(1, 2, 3, 4, 6)]
```

```
##     CountryCode Rank      Long Name.x     GDP        Income Group
## 62          EGY   38 Egypt, Arab Rep.  262832 Lower middle income
## 211         THA   31         Thailand  365966 Lower middle income
## 94          IDN   16        Indonesia  878043 Lower middle income
## 96          IND   10            India 1841710 Lower middle income
## 38          CHN    2            China 8227103 Lower middle income
```
.  


### Summary of Answers  

#### Question 1)
#### Merge the data based on the country shortcode. How many of the IDs match?     

```r
## Answer to question 1:
length(intersect(gdpa$CountryCode, feda$CountryCode))
```

```
## [1] 210
```
- Answer: 210 Country codes match using the intersect function.  


#### Question 2)
#### Sort the data frame in ascending order by GDP (so United States is last). What is the 13th country in the resulting data frame?

```r
mergedsort2[c(12, 13, 14), c(2, 3, 4)]
```

```
##     Rank         Long Name.x GDP
## 82   178             Grenada 767
## 111  178 St. Kitts and Nevis 767
## 231  177             Vanuatu 787
```

```r
mergedsort2[c(13), c(2, 3, 4)]
```

```
##     Rank         Long Name.x GDP
## 111  178 St. Kitts and Nevis 767
```
- Answer: As you can see there are 2 12th to last GDPs so there is no 13!  But alphabetically St. Kitts and Nevis is 13th.  


#### Question 3)
#### What are the average GDP rankings for the "High income: OECD" and "High income:nonOECD" groups?

```r
mean(highincomeOECD$Rank)
```

```
## [1] 32.96667
```

```r
mean(highincomenonOECD$Rank)
```

```
## [1] 91.91304
```
- Answer: The "High income: OECD" has an average Rank of 32.97, and the "High income:nonOECD" has an average Rank of 91.91.  


#### Question 4)
#### Plot the GDP for all of the countries. Use ggplot2 to color your plot by Income Group.

```r
plot1a <- ggplot(GDPall) + geom_point(aes(y = GDP, x = `Income Group`, colour = `Income Group`)) + 
    scale_y_log10()
plot1a + labs(title = "GDP vs Income Group", x = "Income Groups", y = "GDP-millions", 
    colour = "Income Group") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

<img src="DResnick_CaseStudy_I_Final4d_files/figure-html/unnamed-chunk-22-1.png" width="1000px" />



- Answer: The plot shows all five income groups as well as South Sudan which was not assigned an Income Group.  


#### Question 5)
#### Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income Group. How many countries are Lower middle income but among the 38 nations with highest GDP?

```r
table(data.quant2$`Income Group`, data.quant2$quantile)
```

```
##                       
##                         1  2  3  4  5
##   High income: nonOECD  2  4  8  5  4
##   High income: OECD     0  1  1 10 18
##   Low income           11 16  9  1  0
##   Lower middle income  16  8 12 13  5
##   NA-South Sudan        0  1  0  0  0
##   Upper middle income   9  8  8  9 11
```

```r
# Display the first 5 rows of dataframe
GDPall[which(GDPall$Rank < 38.8 & GDPall$`Income Group` == "Lower middle income"), 
    c(1, 2, 3, 4, 6)]
```

```
##     CountryCode Rank      Long Name.x     GDP        Income Group
## 62          EGY   38 Egypt, Arab Rep.  262832 Lower middle income
## 211         THA   31         Thailand  365966 Lower middle income
## 94          IDN   16        Indonesia  878043 Lower middle income
## 96          IND   10            India 1841710 Lower middle income
## 38          CHN    2            China 8227103 Lower middle income
```


- Answer: The table shows that there are only five total countries in the upper 38, or 5th quantile, of GDP assigned to the Lower middle income group.  



### Summary and Conclusions
Gross Domestic product and Education data was downloaded from the World Bank website. The data was cleaned and merged together to form a dataset that could be analyzed to answer five questions.  The presentation of the code, values, tables, and plots help to demonstrate the usefulness of R and different R packages.  The main point here is to clean and tidy your data as soon as possible to make answering questions about it and with it much easier.  



##### I would like to thank the instructor and others for help creating this RMD file.



