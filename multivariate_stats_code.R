# Multivariate Statistics

#  Prepare R Session
# - Same steps as before:
# + Set working directory
# + Load libraries
# + Read in data
# + Create convienent functions 

#EDIT
setwd( "~/Documents/GitHub/Data-Analytics-Teaching-Material/") 

library(haven)
library(tidyverse)
library(Hmisc)
library(ggplot2)
# read data
scf <- read_dta("rscfp2016.dta")
# lower case variable names
names(scf)<-tolower(names(scf))
# create convenient functions
weighted.median<-function(var,weight) {as.numeric(wtd.quantile(var, weight,.5))}
weighted.sd<-function(var,weight) {sqrt(wtd.var(var,weight))}


# Create New Variables
# For simplicity, let's create a variable for age that bins people into different age _groups_
# Age categories
scf <- scf %>% 
mutate(age.cat = ifelse(scf$age>60,"60+",
ifelse(scf$age>=45,"45-60",
ifelse(scf$age>=30,"30-45",
"18-30"))))
table(scf$age.cat)

# Repeat rounding steps
# Number of kids
scf <- scf %>% 
mutate(kids = round(kids))
table(scf$kids)

scf <- scf %>% 
mutate(race_labs = ifelse(scf$race == 1, "White",
ifelse(scf$race == 2,"Black",
ifelse(scf$race == 3,"Hispanic",
"Other"))),
white = ifelse(race == 1, 1, 0))

table(scf$race_labs)
table(scf$white)

# More Involved Variable Creation
# How can we see who is in the top 1% of wealth?
# What number represents the cuttoff for the top 1%:
quantile(scf$networth, 0.99)

# Use above to create binary variable of who is in the top 1%:
scf <- scf %>% 
mutate(top1 = ifelse(networth >= quantile(scf$networth, 0.99), 1, 0))

table(scf$top1)

# Bivariate Frequency Tables
# For better legibility, we assign the frequency table to temp1, use temp to get a table of proportions (which we assign to temp2), and print the rounded results.

#Age by number kids
temp1<-table(scf$age.cat, scf$kids)
temp2<-prop.table(temp1, 1)
round(100*temp2)

# Counts, not proportion:
table(scf$age.cat[scf$top1==0],scf$kids[scf$top1==0])
table(scf$age.cat[scf$top1==1],scf$kids[scf$top1==1])

# Proportions 
round(100*prop.table(table(scf$age.cat[scf$top1==0],
scf$kids[scf$top1==0]),1))
round(100*prop.table(table(scf$age.cat[scf$top1==1],
scf$kids[scf$top1==1]),1))

round(100*prop.table(table(scf$age.cat[scf$top1==0],
scf$kids[scf$top1==0]),1))
round(100*prop.table(table(scf$age.cat[scf$top1==1],
scf$kids[scf$top1==1]),1))

round(100*prop.table(table(scf$age.cat[scf$top1==0],
scf$kids[scf$top1==0]),1))
round(100*prop.table(table(scf$age.cat[scf$top1==1],
scf$kids[scf$top1==1]),1))
#This code is not easily readable.

# Lets try again
temp1<-table(scf$age.cat[scf$top1==0],scf$kids[scf$top1==0])
temp2<-prop.table(temp1, 1)
round(100*temp2)

# Other Multivariate Information
# What do you want to show?
# 
# - What are our variables of interest?
# - "married", "kids", "age", "race"
# 
# - What statistics do we want?
# - Mean, Median, SD
# 
# - What do we want to stratify these by?
# - Wealth Percentile

# Fill in table by hand
df99 <- data.frame(
Variable=c("married","kids","age","white"),
Mean=NA,
Median=NA,
SD=NA)
df99$Mean[1]<-weighted.mean(scf99$married,scf99$wgt)
df99$Mean[2]<-weighted.mean(scf99$kids,scf99$wgt)
df99$Mean[3]<-weighted.mean(scf99$age,scf99$wgt)
df99$Mean[4]<-weighted.mean(scf99$white,scf99$wgt)
df99$Median[1]<-weighted.median(scf99$married,scf99$wgt)
df99$Median[2]<-weighted.median(scf99$kids,scf99$wgt)
df99$Median[3]<-weighted.median(scf99$age,scf99$wgt)
df99$Median[4]<-weighted.median(scf99$white,scf99$wgt)
df99$SD[1]<-weighted.sd(scf99$married,scf99$wgt)
df99$SD[2]<-weighted.sd(scf99$kids,scf99$wgt)
df99$SD[3]<-weighted.sd(scf99$age,scf99$wgt)
df99$SD[4]<-weighted.sd(scf99$white,scf99$wgt)
df99$Mean<-round(df99$Mean,2)
df99$SD<-round(df99$SD,2)

# Fill in table with a `for` loop

2. You can use an `for` loop
df99 <- data.frame(
Variable=c("married","kids","age","white"),
Mean=NA,
Median=NA,
SD=NA)
for(i in 1:nrow(df99)){
df99$Mean[i]<-weighted.mean(scf99[,df99$Variable[i]],scf99$wgt)
df99$Median[i]<-weighted.median(scf99[,df99$Variable[i]],scf99$wgt)
df99$SD[i]<-weighted.sd(scf99[,df99$Variable[i]],scf99$wgt)
}
df99$Mean<-round(df99$Mean,2)
df99$SD<-round(df99$SD,2)
df99

# Make table with dplyr

scf99<-scf[scf$top1==0,]
scf1<-scf[scf$top1==1,]

bottom99_summary <- scf99 %>% select(married, kids, age) %>% 
summarise_all(list(mean = mean, median = median, sd = sd)) %>% 
gather(variable) %>% 
separate(variable, into = c("var", "statistic"), sep = "_") %>% 
spread(statistic, value)
bottom99_summary

# The top 1% of wealth owners:
top1_summary <- scf1 %>% select(married, kids, age) %>% 
summarise_all(list(mean = mean, median = median, sd = sd)) %>% 
gather(variable) %>% 
separate(variable, into = c("var", "statistic"), sep = "_") %>% 
spread(statistic, value)
top1_summary

# Scatter Plot
ggplot(data = scf99,aes(x=income,y=networth))+ geom_point()

ggplot(data = scf99,aes(x=age,y=income))+ geom_point()

pairs(scf99[,c("age","income","networth")])

# Other Multivariate Plots
ggplot(data = scf99,aes(x=income,y=networth,color=age)) +
geom_point()

ggplot(data=scf99,aes(x=age,y=networth,color=as.factor(married))) + 
geom_smooth()

