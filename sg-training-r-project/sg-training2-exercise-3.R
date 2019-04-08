# Exercise 3 of Day 2 - Making a simple Shiny application

# load the libraries

library(ggplot2)
library(dplyr)

# load the data

recycling_data <- read.csv("recycling_data.csv",stringsAsFactors = F)

ui <- navbarPage("Scotland Test", id = "nav",
                 
                 tabPanel("Demonstration Shiny",
                          h3("Hello World!"),
                          br(),
                          h2(textOutput("yearlabel")),
                          plotOutput("recyclechart")
                          )
)
  

server <- function(input, output, session) {
  
  # filter the data to one year, remove Scotland and keep only the 'Waste Recycled' measures
  sel_year <- "2009/2010"
  recycling_data_year <- recycling_data %>%
    filter(Indicator..municipal.waste. == 'Waste Recycled') %>%
    filter(DateCode == sel_year) %>%
    filter(FeatureCode != 'S92000003')
  
  
  
  # draw the chart for the page on load
  output$yearlabel <- renderText(paste0(sel_year))
  output$recyclechart <- renderPlot({ggplot(data = recycling_data_year, aes(x = reorder(FeatureCode, Value), y = Value, fill = FeatureCode)) +
                            geom_bar(stat = 'identity') +
                            theme_bw() + 
                            theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
  
}

shinyApp(ui = ui, server = server)
