

# Setting a working directory
# ========================================================
# We need to tell R where to find our data and where to save our data. This is called our work directory.
# R sets a location by default. We can see where R had set the work directory with the following:

getwd()

# The path name should be in quotes, and all backslashes need to be forward slashes.

setwd("~/Desktop/Data Analytics for Business/data") #CHANGE THIS FOR YOUR OWN COMPUTER

# Now that we know where the data is, we will want to read it into R.
# The SFC file is a `.dta` file. R  cannot natively read this file, 
# but we can get tools to do this. The following function installs a package for reading this file:

install.packages("haven")

# The `haven` package has a function for reading our dataset. 
# Although we have it installed, whenever we want to use it, 
# we need to tell R to load it. To do this, we will use the library function.

library(haven)

# Finally, we can now read the dataset into R with `haven`'s `read_dta` function. 
# Since we have already set our work directory, we just need to tell R the name of the file, 
# and assign this dataset a name within R.

scf <- read_dta("rscfp2016.dta")

# We have now done something that we will want to be run every time we start class. 
# We can save what we've written so far so that we never have to do the above steps again. Yay!
# If interested, you can manually browse the dataset with R's `View` function.

View(scf)

# It's often easier to tell R to just show us a few lines of data.

head(scf)

# It's even more convenient to look at just a few lines of a particular variable. 
# Let's start with net worth. We will want to use R's dollar sign ($) syntax for referencing a variable within the scf dataset.

head(scf$networth)

# We discussed in class how there are discrete and continuous variables. 
# R uses a slightly different language for classifying variables, but the logic is similar. 
# Which type of variable is net worth?
  
class(scf$networth)

# R is case sensitive, so it is often easiest to keep variable names and other objects all lowercase.
# Please run the following in your class code
# Make life easier by making all variable names in lower case
# Assign the variable names of scf to a new object "VarNames"
var_names<-names(scf)
# Look at the first few variable names
head(var_names)
# make a new object "NewNames" consisting of VarNames in lower case
new_names<-tolower(var_names)
# Look at the first few variable names of this object
head(new_names)
#  Replace the variable names in the scf with NewNames 
names(scf)<-new_names

# Let's get some summary statistics on the age of our sample

mean(scf$age)
median(scf$age)
sd(scf$age)

summary(scf$age)
mean(scf$income)

# Instead we need to calculate the mean using survey weights. Luckily, R can do this for us with this simple function:

weighted.mean(scf$income,scf$wgt)

# Let's generate a table of number of kids in the scf
table(scf$kids)

# Now let's visualize this as a histogram
hist(scf$kids)

# Making new variables

table(scf$race)
scf$white<-ifelse(scf$race==1,1,0)
table(scf$white)
scf$race2<-ifelse(scf$race==1,"White",
                  ifelse(scf$race==2,"Black",
                         ifelse(scf$race==3,"Latino",
                                "Other")))
table(scf$race2)






