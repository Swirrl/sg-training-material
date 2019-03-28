# get the data for an entire cube by the url
library(ggplot2)
library(tidyverse)

# find the url of the cube that you want to download and paste it in here

alcohol_data <- read.csv(url("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Falcohol-related-discharge"))

# let's filter the data down to show only discharges for scotland

alcohol_data_scot_disch <- alcohol_data %>%
                        filter(FeatureCode == "S92000003") %>%
                        filter(Units == "Hospital Discharges")
# make the chart

alco_chart <- ggplot(alcohol_data_scot_disch, aes(x=DateCode, y = Value, group = FeatureCode)) +
          geom_line()

# view the chart in the plot viewer

alco_chart
