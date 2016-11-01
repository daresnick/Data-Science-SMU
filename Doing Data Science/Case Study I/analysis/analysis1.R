
gdpa <- gdpraw
feda <- fedraw

## remove all the other columns
gdpa <- gdpa[,c(1,2,4,5)]
head(gdpa)

## rename header
names.gdpa<- names(gdpa)
# names.feda
names(gdpa) <- c("CountryCode", "Rank", "LongName", "GDP")
names(gdpa)

## remove rows without country codes, only the first 215 have country codes
gdpa <- gdpa[1:215,]
# str(gdpa)

## remove all the other columns
feda <- feda[,c(1,2,3)]
head(feda)

## rename header
names.feda<- names(feda)
# names.feda
names(feda) <- c("CountryCode", "LongName", "IncomeGroup")
names(feda)
# str(feda)
