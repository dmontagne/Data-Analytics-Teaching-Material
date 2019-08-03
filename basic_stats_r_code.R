
# Basic Statistics in R


install.packages("Hmisc")
install.packages("tidyverse")
install.packages("ggplot2")


# Prepare R Session: working directory, load packages, et c

#EDIT
setwd("~/Documents/GitHub/Data-Analytics-Teaching-Material/") 


library(haven)
library(tidyverse)
library(Hmisc)
library(ggplot2)

# Read in data
scf <- read_dta("rscfp2016.dta")

# lower case variable names
names(scf)<-tolower(names(scf))

# read data
scf <- read_dta("rscfp2016.dta")

# lower case variable names
names(scf)<-tolower(names(scf))

# create convenient functions
weighted.median<-function(var,weight) {as.numeric(wtd.quantile(var, weight,.5))}
weighted.sd<-function(var,weight) {sqrt(wtd.var(var,weight))}

# Lets look at the variable `mma`. First, we need to know what this variable means...
# Then, lets compare the unweighted and weighted means

mean(scf$mma)
weighted.mean(scf$mma,scf$wgt)

sd(scf$mma)
weighted.sd(scf$mma,scf$wgt)

median(scf$mma)
weighted.median(scf$mma,scf$wgt)
summary(scf$mma)

# What if we want to know info just about people who own money market accounts?

head(scf$mma)
head(scf$mma==0)
head(scf$mma!=0)
head(scf$mma>0)
head(scf$mma>=0)

# Subsetting
scf$mma[scf$mma!=0]

head(scf$mma[scf$mma!=0])

money_market_account_only <- scf %>% 
  filter(mma != 0)

summary(money_market_account_only$mma)
median(money_market_account_only$mma)
weighted.median(money_market_account_only$mma,money_market_account_only$wgt)

table(scf$edcl)

# Back to Data Prep

scf$edcl<-round(scf$edcl)
table(scf$edcl)

# Creating New Variables
# ifelse syntax:
# ifelse("if this condition is met", "then do this", "else, do this")`

scf <- scf %>% 
  mutate(married.gender = ifelse(married == 1 & hhsex == 1, "Married Men",
                                 ifelse(married == 1 & hhsex == 2, "Married Women",  
                                        ifelse(scf$married==0 & scf$hhsex==1, "Single Men", "Single Women"))))

table(scf$married.gender) # No married men?


scf$education<-scf$edcl
scf$education[scf$education==1]<-"Less Than HS"
scf$education[scf$education==2]<-"High School"
scf$education[scf$education==3]<-"Some College"
scf$education[scf$education==4]<-"College"
table(scf$education)


# Married/Gender by Education
table(scf$education,scf$married.gender)
prop.table(table(scf$education,scf$married.gender),2)

# Wealth By Race?
weighted.median(scf$networth,scf$wgt)
weighted.median(scf$networth[scf$race==1],scf$wgt[scf$race==1])
weighted.median(scf$networth[scf$race==2],scf$wgt[scf$race==2])

# Correlation of Wealth and Income
cor(scf$networth,scf$income)

#Graphing Wealth and Income
ggplot(data=scf,aes(x=income,y=networth))+
  geom_smooth()

ggplot(data=scf,aes(x=income,y=networth))+
  geom_smooth()

# Example: Number Kids and Number Vehicles
scf$kids<-round(scf$kids)
scf$nvehic<-round(scf$nvehic)
table(scf$kids)
table(scf$nvehic)

table(scf$kids,scf$nvehic)

table(scf$kids[scf$nvehic==1])
table(scf$kids[scf$nvehic==3])

cor(scf$kids,scf$nvehic)

# Scatter Plot
ggplot(data=scf,aes(x=kids,y=nvehic))+
  geom_jitter(size=2)

ggplot(data=scf,aes(x=kids,y=nvehic))+
  geom_jitter(stat = 'summary', fun.y = 'mean',size=5)

# Line Graph
ggplot(data=scf,aes(x=kids,y=nvehic))+
  geom_line(stat = 'summary', fun.y = 'mean',size=2)

# Cap Outliers
scf$nvehic[scf$nvehic>5]<-5
scf$kids[scf$kids>4]<-4

ggplot(data=scf,aes(x=kids,y=nvehic))+
  geom_jitter(stat = 'summary', fun.y = 'mean',size=5)

ggplot(data=scf,aes(x=kids,y=nvehic))+
  geom_line(stat = 'summary', fun.y = 'mean',size=2)

# Missing Data
summary(scf$saving)

scf$with_saving <- scf$saving
scf$with_saving[scf$with_saving == 0]<- NA

# How NAs Cause Problems
mean(scf$with_saving)
mean(scf$with_saving,na.rm = T)






