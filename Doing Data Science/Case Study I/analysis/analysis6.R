
### Answer to question 4:
#### Make a plot of GDP vs. Income Group colored by Income Group.
plot1a <- ggplot(GDPall) + geom_point(aes(y=GDP,x=IncomeGroup,colour=IncomeGroup)) + scale_y_log10()
plot1a + labs(title="GDP vs. Income Group", x="Income Groups",y="GDP (millions of US dollars)",colour="      Income Groups") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + theme(legend.key = element_rect(fill = "NA"))

#### One row has an NA in the Income Group column so we will replace it with "NA-South Sudan" and plot again.
count(is.na(GDPall$IncomeGroup))
GDPall$IncomeGroup[is.na(GDPall$IncomeGroup)] <- "NA-South Sudan"
count(is.na(GDPall$IncomeGroup))

plot1a <- ggplot(GDPall) + geom_point(aes(y=GDP,x=IncomeGroup,colour=IncomeGroup)) + scale_y_log10()
plot1a + labs(title="GDP vs. Income Group", x="Income Groups",y="GDP (millions of US dollars)",colour="      Income Groups") + theme(axis.text.x = element_text(angle = 60, hjust = 1)) + theme(legend.key = element_rect(fill = "NA"))

#### Making objects for the other income groups. Why not?
lowincome <- mergedsort3[mergedsort3$IncomeGroup == "Low income",]
lowermiddleincome <- mergedsort3[mergedsort3$IncomeGroup == "Lower middle income",]
uppermiddleincome <- mergedsort3[mergedsort3$IncomeGroup == "Upper middle income",]

count(is.na(lowincome$GDP))
count(is.na(uppermiddleincome$GDP))

## Remove NA rows.
lowincome <- lowincome[complete.cases(lowincome$GDP),]
lowermiddleincome <- lowermiddleincome[complete.cases(lowermiddleincome$GDP),]
uppermiddleincome <- uppermiddleincome[complete.cases(uppermiddleincome$GDP),]
count(is.na(lowincome$GDP))
count(is.na(uppermiddleincome$GDP))
   