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

# 1. Bootstrapping means and comparing overlapped distributions
# We are going to estimate the mean us_overall for different age groups

berry_data %>%
  drop_na(age) %>%
  group_by(age) %>%
  summarize(mean_us = mean(us_overall, na.rm = TRUE),
            sd_us = sd(us_overall, na.rm = TRUE)) 

boot_strap_res <- tibble(boot_id = numeric(),
                         age = character(),
                         mean_us = numeric())
for(i in 1:100){
  berry_data %>%
    drop_na(age) %>%
    group_by(age) %>%
    slice_sample(prop = 1, replace = TRUE) %>%
    summarize(mean_us = mean(us_overall, na.rm = TRUE)) %>%
    mutate(boot_id = i) %>%
    relocate(boot_id) %>%
    bind_rows(boot_strap_res, .) ->
    boot_strap_res
}

# 2. Permuting the age assignments and calculating means, comparing variance
# We are going to look at the actual (between group) variance and compare that
# to the variance that we see if age group is meaningless

berry_data %>%
  drop_na(age) %>%
  group_by(age) %>%
  summarize(mean_us = mean(us_overall, na.rm = TRUE)) %>%
  pull(mean_us) %>%
  var() %>%
  as_tibble() ->
  actual_var

permuted_vars <- numeric(0)

berry_data %>%
  drop_na(age) %>%
  select(age, us_overall) %>%
  mutate(permuted_us_overall = sample(us_overall))

for(i in 1:100){
  berry_data %>%
    drop_na(age) %>%
    mutate(permuted_us_overall = sample(us_overall)) %>%
    group_by(age) %>%
    summarize(mean_permuted = mean(permuted_us_overall, na.rm = TRUE)) %>%
    pull(mean_permuted) %>%
    var() %>%
    c(permuted_vars, .) ->
    permuted_vars
}

permuted_vars %>%
  as_tibble() %>%
  ggplot(aes(x = value)) +
  geom_histogram() + 
  geom_point(data = actual_var, aes(y = 0), color = "red")






