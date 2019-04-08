# Exercise 3 of Day 2 - Making a Shiny application that responds to user input

# load the libraries we need

library(ggplot2)
library(dplyr)

#load the data

recycling_data <- read.csv("recycling_data.csv",stringsAsFactors = F)

# populate the year drop down list with available years (2nd part of this exercise)

# yearChoices <- recycling_data[order(recycling_data$DateCode),]
# yearChoices <- unique(yearChoices$DateCode)

ui <- navbarPage("Scotland Test", id = "nav",
                 
                 tabPanel("Demonstration Shiny",
                          h3("Hello World!"),
                          #selectInput("selYear", "Choose a year:", choices = yearChoices, selected = "2009/2010"), # 2nd part of the exercise
                          selectInput("selYear", "Choose a year:", choices = c("2009/2010","2010/2011","2011/2012")),
                          actionButton("updatechart","Go!"),
                          br(),
                          h2(textOutput("yearlabel")),
                          plotOutput("recyclechart")
                          )
)
  

server <- function(input, output, session) {
  
  # filter it to remove Scotland and keep only the 'Waste Recycled' measures
  sel_year <- "2009/2010"
  recycling_data_year <- recycling_data %>%
    filter(Indicator..municipal.waste. == 'Waste Recycled') %>%
    filter(FeatureCode != 'S92000003') %>%
    filter(DateCode == sel_year)

  
  # draw the chart for the page on load
  output$yearlabel <- renderText(paste0(sel_year))
  output$recyclechart <- renderPlot({ggplot(data = recycling_data_year, aes(x = reorder(FeatureCode, Value), y = Value, fill = FeatureCode)) +
                            geom_bar(stat = 'identity') +
                            theme_bw() + 
                            #theme(legend.position = "none") +
                            theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
  
  # listener for the button
  observeEvent(input$updatechart, {
    sel_year <- input$selYear
    recycling_data_year <- recycling_data %>%
      filter(Indicator..municipal.waste. == 'Waste Recycled') %>%
      filter(FeatureCode != 'S92000003') %>%
      filter(DateCode == sel_year)
    output$yearlabel <- renderText(sel_year)
    output$recyclechart <- renderPlot({ggplot(data = recycling_data_year, aes(x = reorder(FeatureCode, Value), y = Value, fill = FeatureCode)) +
                            geom_bar(stat = 'identity') +
                            theme_bw() +
                            #theme(legend.position = "none") +
                            theme(axis.text.x = element_text(angle = 90, hjust = 1))
    })

  })
  
  
  
  
}

shinyApp(ui = ui, server = server)