# DResnick Live Session 11 Assignment
Damon Resnick  
November 18, 2016  

### Introduction
Time series analysis of ukcars data from the basic R packages: Quarterly UK passenger car production (thousands of cars). 1977:1-2005:1.  This example looks at how outliers may effect seasonal changes.  The code goes through the 7 stages:

a)	Plot the time series. Can you identify seasonal fluctuations and/or a trend? 
b)	Use a classical decomposition to calculate the trend-cycle and seasonal indices. 
c)	Do the results support the graphical interpretation from part (a)? 
d)	Compute and plot the seasonally adjusted data. 
e)	Change one observation to be an outlier (e.g., add 500 to one observation), and recompute the seasonally adjusted data. What is the effect of the outlier? 
f)	Does it make any difference if the outlier is near the end rather than in the middle of the time series? 
g)	Use STL to decompose the series. 

The answers are presented within the file below as it becomes convenient to answer them. 

<br>  


##### This first code chunk sets the global options for the all code chunks in this document.  The first sets the width of the code chunks so they fit well and the second sets the size of the figures so that fill up the page well. 

```r
library(knitr)
library(formatR)
opts_chunk$set(tidy.opts=list(width.cutoff=80),tidy=TRUE)
opts_chunk$set(out.width='1000px', dpi=300)
```
<br>


#### Load packages and data I may need.

```r
library(fpp)
```

```
## Loading required package: forecast
```

```
## Loading required package: zoo
```

```
## 
## Attaching package: 'zoo'
```

```
## The following objects are masked from 'package:base':
## 
##     as.Date, as.Date.numeric
```

```
## Loading required package: timeDate
```

```
## This is forecast 7.3
```

```
## Loading required package: fma
```

```
## Loading required package: tseries
```

```
## Loading required package: expsmooth
```

```
## Loading required package: lmtest
```

```r
data(ukcars)
summary(ukcars)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   171.2   267.0   335.1   333.5   391.8   494.3
```

```r
str(ukcars)
```

```
##  Time-Series [1:113] from 1977 to 2005: 330 371 271 344 358 ...
```
<br>  

### Plot the time series. Can you identify seasonal fluctuations and/or a trend? 

```r
# Plot the time series. Can you identify seasonal fluctuations and/or a trend?
plot(ukcars, main = "UK passenger vehicle production", ylab = "Thousands of cars", 
    xlab = "Year")
```

<img src="DResnick_Live_Session_11_Assignment_files/figure-html/unnamed-chunk-3-1.png" width="1000px" />

```r
## Looks like there is a seasonal trend.  Much higher production in the winter.
```
<br> 

### Use a classical decomposition to calculate the trend-cycle and seasonal indices.  

```r
fitdec <- decompose(ukcars)
plot(fitdec)
```

<img src="DResnick_Live_Session_11_Assignment_files/figure-html/unnamed-chunk-4-1.png" width="1000px" />

```r
# There is a definate seasonal trend peaking in the winter.
```
<br> 

### Using stl decomposition.  

```r
# Using stl decomposition
fitstl <- stl(ukcars, s.window = 5)
plot(fitstl)
```

<img src="DResnick_Live_Session_11_Assignment_files/figure-html/unnamed-chunk-5-1.png" width="1000px" />
<br> 

### Compute and plot the seasonally adjusted data. 

```r
# Compute and plot the seasonally adjusted data.
ukadjdec <- seasadj(fitdec)
plot(ukadjdec)
```

<img src="DResnick_Live_Session_11_Assignment_files/figure-html/unnamed-chunk-6-1.png" width="1000px" />

```r
ukadjstl <- seasadj(fitstl)
plot(ukadjstl, main = "Seasonally adjusted with decompose (red) and stl")
lines(ukadjdec, col = "red")
```

<img src="DResnick_Live_Session_11_Assignment_files/figure-html/unnamed-chunk-6-2.png" width="1000px" />
<br> 

### Add outlier to data at the begining, middle, and end.

```r
# Add outlier to data at the begining, middle, and end.
ukcarsb <- ts(c(ukcars[1:8], ukcars[9] + 500, ukcars[10:113]), start = c(1977, 1), 
    end = c(2005, 4), frequency = 4)
ukcarsm <- ts(c(ukcars[1:54], ukcars[55] + 500, ukcars[56:113]), start = c(1977, 
    1), end = c(2005, 4), frequency = 4)
ukcarse <- ts(c(ukcars[1:104], ukcars[105] + 500, ukcars[106:113]), start = c(1977, 
    1), end = c(2005, 4), frequency = 4)
plot(ukcarsb)
lines(ukcarsm, col = "red")
lines(ukcarse, col = "blue")
```

<img src="DResnick_Live_Session_11_Assignment_files/figure-html/unnamed-chunk-7-1.png" width="1000px" />

```r
# See how placement of outlier effects seasonally adjusted data.

fitdecb <- decompose(ukcarsb)
fitdecm <- decompose(ukcarsm)
fitdece <- decompose(ukcarse)
# There is a definate seasonal trend peaking in the winter.

# Using stl decomposition
fitstlb <- stl(ukcarsb, s.window = 5)
fitstlm <- stl(ukcarsm, s.window = 5)
fitstle <- stl(ukcarse, s.window = 5)

# Compute and plot the seasonally adjusted data.
ukadjdecb <- seasadj(fitdecb)
ukadjdecm <- seasadj(fitdecm)
ukadjdece <- seasadj(fitdece)
plot(ukadjdecb)
lines(ukadjdecm, col = "red")
lines(ukadjdece, col = "blue")
```

<img src="DResnick_Live_Session_11_Assignment_files/figure-html/unnamed-chunk-7-2.png" width="1000px" />

```r
# Added outliers change seasonal adjustment data marginally with decompose.

ukadjstlb <- seasadj(fitstlb)
ukadjstlm <- seasadj(fitstlm)
ukadjstle <- seasadj(fitstle)
plot(ukadjstlb)
lines(ukadjstlm, col = "red")
lines(ukadjstle, col = "blue")
```

<img src="DResnick_Live_Session_11_Assignment_files/figure-html/unnamed-chunk-7-3.png" width="1000px" />

```r
# Added outliers change seasonal adjustment data dramatically with stl.
```
<br> 

### Data with the stl trend.

```r
plot(ukcars, col = "gray56", main = "Quarterly UK passenger vehicle production", 
    ylab = "Thousands of cars", xlab = "Year")
lines(fitstl$time.series[, 2], col = "red", ylab = "Trend")
```

<img src="DResnick_Live_Session_11_Assignment_files/figure-html/unnamed-chunk-8-1.png" width="1000px" />





