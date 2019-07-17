Data Analytics for Business: R Basics
========================================================
author: 
date: 
autosize: true

 Today we are going to cover the following topics:
========================================================
- R Basics
- Reading data into R
- Mean, median, mode
- Standard deviation
- Interquartile range
- Weights
- Tables
- Histograms
- Creating new variables

 Running R and RStudio
========================================================

We will need R and RStudio. R is the program that will be running our code, RStudio is an interface ("integrated development environment or IDE") for writing our scripts and seeing our data.

Get and install the most recent version of R at: https://cran.rstudio.com/

Then get and install RStudio at: https://www.rstudio.com/products/rstudio/download/#download

Mac users, update XQuartz at: https://www.xquartz.org/

Familiarizing yourself with R
========================================================

![](~/Documents/GitHub/Data-Analytics-Teaching-Material/images/r_session.png)

Some notes:
========================================================
- The hashtag and green text indicates comments. These have no impact on the program
- You can run a line where your cursor is blinking with ctrl-enter (Mac: command + enter)
- You can run everything in a document by highlighting all lines and typing ctrl-enter (Mac: command + enter)

Setting a work directory
========================================================
We need to tell R where to find our data and where to save our data. This is called our work directory.

R sets a location by default. We can see where R had set the work directory with the following:

```r
getwd()
```

```
[1] "/Users/dmontagne/Documents/GitHub/Data-Analytics-Teaching-Material"
```

 Setting a work directory
========================================================
On Apple:

![~/Documents/GitHub/Data-Analytics-Teaching-Material/images/set_wd.png]

Setting a work directory
========================================================

========================================================

========================================================

