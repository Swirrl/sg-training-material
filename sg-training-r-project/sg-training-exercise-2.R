# Exercise 2 - 2 datasets from a datacart and scatter

library(tidyverse)

housing_pop <- read.csv("data/exercise_2_data_1.csv", stringsAsFactors = F)

housing_pop_tidy <- housing_pop %>%
                rename(population = 3) %>%
                rename(dwellings = 4) %>%
                select(2:4)
                

scatterplot <-ggplot(housing_pop_tidy, aes(x=population, y = dwellings)) +
                geom_point()

scatterplot




