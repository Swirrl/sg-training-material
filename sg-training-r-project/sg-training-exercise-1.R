# exercise 1 - I do / we do

# install the libraries that we need for this exercise

library(tidyr)
library(ggplot2)

# get the population data from the csv file that we saved before and put into a variable
# if this path doesn't work - browse to the file using the Files panel, then click
# import dataset and get the path from there
# notice the column headers in the dataframe - columns can't begin with numbers, so the X gets added
# in this case, we'll remove them leter on, but we could change the column names

population <- read.csv("data/exercise_1_data.csv",stringsAsFactors = F)

# ggplot prefers data in a tidy format - one observation per row
# the gather function makes data tidy

population_tidy <- population %>%
                    gather("year","value",3:9)

# get the single year from the year column of the dataframe (using substr(ing) function)

population_tidy$year <- substr(population_tidy$year,2,6)

# now we filter the dataframe to only scotland. There are different ways to do this 
# - subset, filter by row reference, and dplyr. We'll look at 'which' first, then dplyr later on

population_tidy_scotland <- population_tidy[which(population_tidy$Reference.Area == 'Scotland'),]

# now we draw a chart using ggplot - raw, ggplot defaults

population_chart <- ggplot(population_tidy_scotland, aes(x=year, y=value, group = Reference.Area)) + 
                    geom_line()
  
# view the chart                  
population_chart

# alternative with styling

library(scales)
population_chart_styled <- ggplot(population_tidy_scotland, aes(x=year, y=value, group = Reference.Area)) + 
                              geom_line(size = 1, aes(color=value)) +
                              geom_point(size = 3, aes(color = value)) +
                              theme_bw() +
                              scale_y_continuous(labels = comma) +
                              scale_colour_gradient(labels = comma, low ="yellow", high ="blue") +
                              labs(color = "Population", title="Estimated Population in Scotland", subtitle = "Data source: statistics.gov.scot", x = "Year", y = "Number of People") +
                              geom_label(aes(label = comma(value)), 
                                        data = tail(population_tidy_scotland,1),
                                        nudge_x = -1)

population_chart_styled
