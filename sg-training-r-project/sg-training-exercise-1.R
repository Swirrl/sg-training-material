population <- read.csv("data/exercise_1_data.csv",stringsAsFactors = F)

library(tidyr)

population_tidy <- population %>%
                    gather("year","value",3:9)

population_tidy$year <- substr(population_tidy$year,2,6)

population_tidy_scotland <- population_tidy[which(population_tidy$Reference.Area == 'Scotland'),]

library(ggplot2)

population_chart <- ggplot(population_tidy_scotland, aes(x=year, y=value, group = Reference.Area)) + 
                    geom_line()
                    
population_chart

