#  Non-linear Models

# Prepare data
# - Set the working directory
# - Run all the library commands
# - Run the data editing commands

library(haven)
library(tidyverse)
library(Hmisc)
library(ggplot2)
library(scales)
# read data
scf <- read_dta("rscfp2016.dta")
# lower case variable names
names(scf)<-tolower(names(scf))
# create convenient functions
weighted.median<-function(var,weight) {as.numeric(wtd.quantile(var,
                                                               weight,.5))}
weighted.sd<-function(var,weight) {sqrt(wtd.var(var,weight))}

# some edits to the data we might want
scf<-as.data.frame(scf)
scf <- scf %>% rename(number_cars = nvehic,
                      owncar = own) %>% 
  mutate(nochk = round(nochk),
         kids = round(kids), 
         owncar = round(owncar))

# Identify variables
# Dependent variables:
# - Number of cars owned or leased (`number_cars`)
# - Own any cars (`owncar`)
# Independent variables:
# - Number kids (`kids`)
# - Does not own checking account (`nochk`)

# Try OLS for owncar
summary(glm(owncar ~ kids+nochk, data=scf, weights=wgt))$coefficient

# Logit for owncar
summary(glm(owncar ~ kids+nochk, data=scf, family=binomial(link='logit'), 
            weights=wgt/mean(wgt)))$coefficient

# Distribution of Cars Owned or Leased
hist(scf$number_cars, right=F)

# Try OLS for Cars Owned or Leased
summary(glm(number_cars ~ kids+nochk, data=scf,weights=wgt))$coefficient

# Poisson for Cars Owned or Leased
summary(glm(number_cars ~ kids+nochk, data=scf, family="poisson",
            weights=wgt/mean(wgt)))$coefficient

# Problematic Assumption of OLS
set.seed(1);ggplot(data=scf,aes(x=jitter(kids,.00001),y=number_cars,weight=wgt))+
  geom_smooth(span=.999,se=F,size=2)+
  geom_smooth(method="glm",color="red",se=F,size=2)+
  labs(title="OLS slope vs. Real slope",x="Kids",y="Number Cars", color="OLS")+
  scale_y_continuous(breaks=pretty_breaks())+
  scale_x_continuous(breaks=pretty_breaks())+
  theme(
    plot.title = element_text(size=18),
    axis.title.x = element_text(size=15),
    axis.title.y = element_text(size=15),
    axis.text = element_text(size=12),
    legend.title = element_text(size=12),
    legend.text = element_text(size=10)
  )