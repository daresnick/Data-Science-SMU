
library(stats)
library(plyr)
library(ggplot2)
library(repmis)

setwd("C:/Users/hp/Desktop/SMU/Doing Data Science/Homework/Case Studies/Case Study I a")

#setwd(".")
#getwd()

gdpraw <- source_data("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",skip=5,header=FALSE,stringsAsFactors=FALSE)
fedraw <- source_data("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",header=TRUE,stringsAsFactors=FALSE)


# GDPFileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
# FEDFileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

# download.file(GDPFileUrl,destfile="Data/FGDP_Rank_raw.csv")
# download.file(FEDFileUrl,destfile="Data/FEDSTATS_Country_raw.csv")

# gdpraw <- read.csv("./Data/FGDP_Rank_raw.csv",skip=5,header=FALSE)
# fedraw <- read.csv("./Data/FEDSTATS_Country_raw.csv",header=TRUE)

# head(gdpraw)
# head(fedraw)
# str(gdpraw)
# str(fedraw)