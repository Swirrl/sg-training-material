# Exercise 2 - 2 datasets from a datacart and scatter

# trying tidyverse - there's an alternative exercise without it
# install.packages("tidyverse")
library(tidyverse)
library(ggplot2)

# as with the previous exercise,  bring in the data

housing_pop <- read.csv("data/exercise_2_data_1.csv", stringsAsFactors = F)

# sort the data out - using dplyr this time  - rename those long column names

housing_pop_clean <- housing_pop %>%
                rename(population = 3) %>%
                rename(dwellings = 4) %>%
                select(2:4)
                
# now we draw a scatterplot - notice we aren't using tidy data now -
# to draw a scatterplot we need two columns - data should be as wide as it needs to be, no wider
scatterplot <-ggplot(housing_pop_clean, aes(x=population, y = dwellings)) +
                geom_point()

scatterplot





