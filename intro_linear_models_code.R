# Introduction to Linear Models

# Prepare Data
# As always...

#EDIT
setwd("~/Documents/GitHub/Data-Analytics-Teaching-Material/") 

# libraries
library(haven)
library(tidyverse)
library(Hmisc)
library(ggplot2)
# read data
scf <- read_dta("rscfp2016.dta")
# lower case variable names
names(scf)<-tolower(names(scf))
# create convenient functions
weighted.median <- function(var,weight) {as.numeric(wtd.quantile(var, weight,.5))}
weighted.sd<-function(var,weight) {sqrt(wtd.var(var,weight))}

# Identify Question
# Do professionals and managers buy more cars?

# -  Dependent = Number cars owned
# - Independent = Professional occupation

scf <- scf %>% rename(number_cars = nvehic)

table(scf$occat2)
table(scf$number_cars)

# We need to make a binary variable of whether or not the respondent has a professional or managerial job

scf <- scf %>%
mutate(prof = ifelse(occat2==1,1,0))

scf <- scf %>%
mutate(number_cars = round(number_cars),
white = ifelse(race == 1, 1, 0))

# Look at Bivariate Descriptives
weighted.mean(scf$number_cars[scf$prof==1], scf$wgt[scf$prof==1])
weighted.mean(scf$number_cars[scf$prof==0], scf$wgt[scf$prof==0])

# Bivariate Models
# Is the difference between professionals and non-professionals real?
summary(glm(number_cars ~ prof, data=scf, weights=wgt))$coefficients

# Any Confounders?
table(scf$kids)
cor(scf$kids,scf$number_cars)
cor(scf$kids,scf$prof)

# Multivariate Model
summary(glm(number_cars ~ prof + kids, data=scf,weights=wgt))$coefficients

summary(glm(number_cars ~ prof, data=scf,weights=wgt))$coefficient

summary(glm(number_cars ~ prof + kids, data=scf,weights=wgt))$coefficient

# Other cofounders
summary(glm(number_cars ~ prof + kids + age, data=scf,weights=wgt))$coefficients

table(scf$edcl)
scf$edcl<-round(scf$edcl)

summary(glm(number_cars ~ prof + kids + age + edcl, data=scf,weights=wgt))$coefficients

# Categorical variables
scf$edcl <- factor(scf$edcl)
summary(glm(number_cars ~ prof + kids + age + edcl, data=scf,weights=wgt))$coefficients

# Full Model
summary(glm(number_cars ~ prof + kids + age + edcl + married + hhsex + white + turndown, data=scf,weights=wgt))$coefficients

# Making Predictions (Decision analysis)
# Let's use a simple model.
m1 <- glm(number_cars ~ prof + kids, data=scf,weights=wgt)

# How many cars might we expect a non-professional with 1 kid to own?
to.predict<-data.frame(prof=0,
                       kids=1)
predict(m1,to.predict)

# How many cars might we expect a professional  with 5 kids to own?
to.predict<-data.frame(prof=1,
                       kids=5)
predict(m1,to.predict)

# Visualizing Predictions
# What if we want to know how many cars professionals and non professionals with 0-5 kids own?
to.predict<-data.frame(prof=c(0,0,0,0,0,0,1,1,1,1,1,1),
                       kids=c(0,1,2,3,4,5,0,1,2,3,4,5))

num.car <- predict(m1,to.predict)
vizdf <- cbind(to.predict,num.car)
vizdf

# Plotting
ggplot(data = vizdf, aes(x = kids, y = num.car, color = factor(prof))) +
  geom_line()

library(scales)
ggplot(data=vizdf,aes(x=kids,y=num.car,group=prof,color=factor(prof)))+
  geom_line(size = 1.5) + 
  labs(title="Predicted Number of Cars by Kids and Professional Status",x="Kids",y="Number Cars", color="Professional")+
  scale_y_continuous(breaks=pretty_breaks())+
  scale_x_continuous(breaks=pretty_breaks(),limits = c(0,5))+
  theme(
    plot.title = element_text(size=18),
    axis.title.x = element_text(size=15),
    axis.title.y = element_text(size=15),
    axis.text = element_text(size=12),
    legend.title = element_text(size=12),
    legend.text = element_text(size=10)
  )

# Visualizing OLS models
ggplot(data=scf,
       aes(x = prof, y = number_cars, weight = wgt))+
  geom_smooth(method = "glm")

ggplot(data=scf,
       aes(x = kids, y = number_cars, weight = wgt, color = factor(prof)))+
  geom_smooth(method = "glm")

ggplot(data=scf, 
       aes(x = kids, y = number_cars, weight = wgt, 
           group = prof, color = factor(prof))) +
  geom_smooth(method = "glm") + 
  labs(title="OLS Slopes for Number of Cars by Kids and Professional Status",
       x="Kids",y="Number Cars", 
       color="Professional")+
  scale_y_continuous(breaks=pretty_breaks())+
  scale_x_continuous(breaks=pretty_breaks(),limits = c(0,5))+
  theme(
    plot.title = element_text(size=18),
    axis.title.x = element_text(size=15),
    axis.title.y = element_text(size=15),
    axis.text = element_text(size=12),
    legend.title = element_text(size=12),
    legend.text = element_text(size=10)
  )