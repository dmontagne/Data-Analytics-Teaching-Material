<style>


.reveal section p {
  color: black;
  font-size: .7em;
  font-family: 'Helvetica'; #this is the font/color of text in slides
}


.section .reveal .state-background {
    background: white;}
.section .reveal h1,
.section .reveal p {
    color: black;
    position: relative;
    top: 4%;}


.wrap-url pre code {
  word-wrap:break-word;
}

</style>

Intro to R
========================================================
autosize: true
transition: fade
  github: https://github.com/dmontagne
  

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
![](images/r_session.png)


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

![](images/set_wd.png)

Setting a work directory
========================================================
When I paste this info into R. At first, I get:

```r
/Users/dmontagne/Desktop/Data_analytics_Class_R files/data
```
But I want to put that info into the *setwd* function. The path name should be in quotes, and all backslashes need to be forward slashes.


```r
setwd("~/Desktop/Data Analytics for Business/data")
```




Reading the data into R
========================================================
Now that we know where the data is, we will want to read it into R.

The SFC file is a *sas7bdat* file. R  cannot natively read this file, but we can get tools to do this. The following function installs a package for reading this file:


```r
install.packages("haven")
```

Reading the data into R
========================================================
The *haven* package has a function for reading our dataset. Although we have it installed, whenever we want to use it, we need to tell R to load it. To do this, we will use the library function.

```r
library(haven)
```

Reading the data into R
========================================================
Finally, we can now read the dataset into R with *haven*'s *read_sas* function. Since we have already set our work directory, we just need to tell R the name of the file, and assign this dataset a name within R.


```r
scf <- read_dta("rscfp2016.dta")
```

Let's take a quick break
========================================================
We have now done something that we will want to be run every time we start class. We can save what we've written so far so that we never have to do the above steps again. Yay!

If interested, you can manually browse the dataset with R's *View* function.


```r
View(scf)
```

Browsing the data
========================================================
It's often easier to tell R to just show us a few lines of data.


```r
head(scf)
```

```
# A tibble: 6 x 348
    YY1    Y1   wgt hhsex   age agecl  educ  edcl married  kids    lf
  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl> <dbl> <dbl>
1     1    11 6427.     2    71     5    10     3       2     0     0
2     1    12 6428.     2    71     5    10     3       2     0     0
3     1    13 6414.     2    71     5    10     3       2     0     0
4     1    14 6428.     2    71     5    10     3       2     0     0
5     1    15 6425.     2    71     5    10     3       2     0     0
6     2    21 6501.     1    20     1     8     2       1     0     1
# … with 337 more variables: lifecl <dbl>, famstruct <dbl>, racecl <dbl>,
#   RACECL4 <dbl>, race <dbl>, OCCAT1 <dbl>, OCCAT2 <dbl>, indcat <dbl>,
#   foodhome <dbl>, foodaway <dbl>, fooddelv <dbl>, income <dbl>,
#   wageinc <dbl>, bussefarminc <dbl>, intdivinc <dbl>, kginc <dbl>,
#   ssretinc <dbl>, transfothinc <dbl>, penacctwd <dbl>, norminc <dbl>,
#   wsaved <dbl>, saved <dbl>, SAVRES1 <dbl>, SAVRES2 <dbl>,
#   SAVRES3 <dbl>, SAVRES4 <dbl>, SAVRES5 <dbl>, SAVRES6 <dbl>,
#   SAVRES7 <dbl>, SAVRES8 <dbl>, SAVRES9 <dbl>, spendmor <dbl>,
#   spendless <dbl>, expenshilo <dbl>, late <dbl>, LATE60 <dbl>,
#   hpayday <dbl>, BNKRUPLAST5 <dbl>, knowl <dbl>, yesfinrisk <dbl>,
#   nofinrisk <dbl>, crdapp <dbl>, turndown <dbl>, feardenial <dbl>,
#   turnfear <dbl>, FORECLLAST5 <dbl>, emergborr <dbl>, emergsav <dbl>,
#   emergpstp <dbl>, emergcut <dbl>, hborrff <dbl>, hborrcc <dbl>,
#   hborralt <dbl>, hborrfin <dbl>, hsavfin <dbl>, hsavnfin <dbl>,
#   hpstppay <dbl>, hpstpln <dbl>, hpstpoth <dbl>, hcutfood <dbl>,
#   hcutent <dbl>, hcutoth <dbl>, finlit <dbl>, bshopnone <dbl>,
#   bshopgrdl <dbl>, bshopmodr <dbl>, ishopnone <dbl>, ishopgrdl <dbl>,
#   ishopmodr <dbl>, bcall <dbl>, bmagznews <dbl>, bmailadtv <dbl>,
#   binternet <dbl>, bfriendwork <dbl>, bfinpro <dbl>, bself <dbl>,
#   bdont <dbl>, bother <dbl>, icall <dbl>, imagznews <dbl>,
#   imailadtv <dbl>, iinternet <dbl>, ifriendwork <dbl>, ifinpro <dbl>,
#   iself <dbl>, idont <dbl>, iother <dbl>, bfinplan <dbl>,
#   ifinplan <dbl>, internet <dbl>, checking <dbl>, hcheck <dbl>,
#   nochk <dbl>, ehchkg <dbl>, whynockg <dbl>, dontwrit <dbl>,
#   minbal <dbl>, dontlike <dbl>, svcchg <dbl>, cantmang <dbl>, …
```

Browsing the data
========================================================
It's even more convenient to look at just a few lines of a particular variable. Let's start with net worth. We will want to use R's dollar sign ($) syntax for referencing a variable within the scf dataset.


```r
head(scf$networth)
```

```
[1] 176720 176830 176730 176730 176830     10
```

Browsing the data
========================================================
We discussed in class how there are discrete and continuous variables. R uses a slightly different language for classifying variables, but the logic is similar. Which type of variable is net worth?


```r
class(scf$networth)
```

```
[1] "numeric"
```

Good Coding Practice
========================================================

R is case sensitive, so it is often easiest to keep variable names and other objects all lowercase. Please run the following in your class code


```r
#3) Make life easier by making all variable names in lower case
  #a) Assign the variable names of scf to a new object "VarNames"
    var_names<-names(scf)
  #b) Look at the first few variable names
    head(var_names)
  #c) make a new object "NewNames" consisting of VarNames in lower case
    new_names<-tolower(var_names)
  #d) Look at the first few variable names of this object
    head(new_names)
  #e) Replace the variable names in the scf with NewNames 
    names(scf)<-new_names
```

Summary statistics
========================================================
Let's get some summary statistics on the age of our sample


```r
mean(scf$age)
```

```
[1] 52.70359
```

```r
median(scf$age)
```

```
[1] 54
```

```r
sd(scf$age)
```

```
[1] 16.21476
```

Standard deviation
========================================================
What would it mean if the standard deviation on age was higher?

Standard deviation
========================================================
Let's compare rolling two standard 6-sided dies (D6) vs one 12-sided die (D12)

![plot of chunk unnamed-chunk-14](intro_to_R-figure/unnamed-chunk-14-1.png)

Standard deviation
========================================================
Let's compare rolling two standard 6-sided dies (D6) vs one 12-sided die (D12)

![plot of chunk unnamed-chunk-15](intro_to_R-figure/unnamed-chunk-15-1.png)

Interquartile range
========================================================

```r
summary(scf$age)
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   18.0    40.0    54.0    52.7    64.0    95.0 
```

Survey weights
========================================================
The SCF oversamples the rich, so unweighted estimates are not representative of national trends

```r
mean(scf$income)
```

```
[1] 799817.4
```

Instead we need to calculate the mean using survey weights. Luckily, R can do this for us with this simple function:

```r
weighted.mean(scf$income,scf$wgt)
```

```
[1] 102252
```

Exercise
========================================================
Estimate the mean and weighted mean of any one variable in the SCF


Visualizing data
========================================================
Let's generate a table of number of kids in the scf

```r
table(scf$kids)
```

```

    0     1     2     3     4     5     6     7 
18215  5495  4595  2060   640   175    40    20 
```

Visualizing data
========================================================
Now let's visualize this as a histogram

```r
hist(scf$kids)
```

![plot of chunk unnamed-chunk-20](intro_to_R-figure/unnamed-chunk-20-1.png)

Making new variables
========================================================
Let's look at a table of race in the scf.

```r
table(scf$race)
```

```

    1     2     3     5 
22401  4177  3059  1603 
```

Making new variables
========================================================
What do these categories mean? As you go along in this class (and possibly as future data analysts), you will need to reference your data's codebook:

![](images/codebook_ex.png)

Making new variables
========================================================
Let's make a new variable for whether someone is white with the *ifelse* function.

```r
scf$white<-ifelse(scf$race==1,1,0)
table(scf$white)
```

```

    0     1 
 8839 22401 
```

Making new variables
========================================================
We could also make race new race variable with the same logic.

```r
scf$race2<-ifelse(scf$race==1,"White",
           ifelse(scf$race==2,"Black",
           ifelse(scf$race==3,"Latino",
           "Other")))
table(scf$race2)
```

```

 Black Latino  Other  White 
  4177   3059   1603  22401 
```


When closing RStudio, save changes to your code, but not to the data!
========================================================

![](images/dont_save_image.png) 


Due next week
========================================================
- Identify 10 asset and debt variables you think look interesting (use the SDA tool to look at the options)
- Clean and recode the variables so you can use them; run univariate statistics on the variables.

