
mergedfile <- merge(gdpa, feda, by = "CountryCode", all=TRUE)

## Count the number of NAs in each column
mergefile.na <- colSums(is.na(mergedfile))
mergefile.na
