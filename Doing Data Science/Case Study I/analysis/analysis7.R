
### Answers to Question 5:
#### Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income Group. How many countries are Lower middle income but among the 38 nations with highest GDP?
#### Use quantile function to break up the data into 5 Rank Quantiles
data.quant<-quantile(GDPall$Rank,seq(0, 1, 0.2))
data.quant

## This gave us 38.8 as the cuttoff, so below are two ways to get the answer
lowermiddleincome[which(lowermiddleincome$Rank<38.8), c(1,2,3,4,6)]
GDPall[which(GDPall$Rank < 38.8 & GDPall$IncomeGroup == "Lower middle income"), c(1,2,3,4,6)]
nrow(GDPall[which(GDPall$Rank < 38.8 & GDPall$IncomeGroup == "Lower middle income"),])


## Another way to do it is to make a table, first figure out the quantile cutoff points
brk<-with(GDPall, quantile(GDPall$GDP, probs = c(0, 0.20, 0.4, 0.6, 0.8, 1.0)))
data.quant2 <- within(GDPall, quantile <- cut(GDPall$GDP, breaks = brk, labels = 1:5, include.lowest = TRUE))

## Checking
nrow(data.quant2[which(data.quant2$quantile == 5 & data.quant2$IncomeGroup == "Lower middle income"),])

## Table answers question 5.
table(data.quant2$IncomeGroup, data.quant2$quantile)
## You can see that there are only 5 total countries in the Lower middle income group that are also in the 5th and highest quantile
## Those countries are again
GDPall[which(GDPall$Rank < 38.8 & GDPall$IncomeGroup == "Lower middle income"), c(1,2,3,4,6)]

#### Saves the cleaned file to the Data directory inside the working directory. (Commented out of the markdown file.)
# cleanedGDPallDatafile <- GDPall[,c(1,2,3,4,6)]
# dir.create("./Data", recursive = dir.exists("./Data"))
# write.table(cleanedGDPallDatafile, file="./Data/cleanedGDPall.csv", sep = ",")

        