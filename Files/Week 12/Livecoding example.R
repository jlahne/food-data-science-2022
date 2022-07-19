# Workshop script for FST 5984, Week 12, Thursday
# Jacob Lahne, April 7, 2022

library(tidyverse)

# First, let's see where we are -------------------------------------------

getwd()

# Now close R and reopen it BY DOUBLECLICKING THIS FILE -------------------

getwd()

# Now let's examine some practices for opening files ----------------------

read_csv("berry_data.csv") # this is a "relative path"
read_csv("~/Dropbox/Work/Teaching/Virginia Tech/2022 - FST 5984/Data Analytics for Food and Ag Science/Files/Week 11/berry_data.csv") # this is an absolute path

# which one works for you?


# Shifting gears, here are two approaches to resampling ANOVA -------------

berry_data <- read_csv("berry_data_2.csv")
