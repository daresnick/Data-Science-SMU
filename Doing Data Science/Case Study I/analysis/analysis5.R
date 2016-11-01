
### Answers to Question 3:
#### The averages of the Ranks for the "High income: OECD" and "High income: nonOECD".

## Question 3 Answers:
mean(highincomeOECD$Rank)
mean(highincomenonOECD$Rank)

## Average of GDPs as well. Why not?
mean(highincomeOECD$GDP)
mean(highincomenonOECD$GDP)

#### Cleaning up everything else now. Making an object with only countries with Ranks, and getting rid of all the columns I don't seem to need.
GDPall <- mergedsort2[1:190, c(1:6)]

## Clean up GDPall and get rid of all the factors
GDPall$IncomeGroup<-GDPall$IncomeGroup <- as.character(GDPall$IncomeGroup)
GDPall$LongName.x <- as.character(GDPall$LongName.x)
GDPall$LongName.y <- as.character(GDPall$LongName.y)
GDPall$CountryCode <- as.character(GDPall$CountryCode)
  