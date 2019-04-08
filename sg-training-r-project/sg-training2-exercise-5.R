# Exercise 5 of Day 2 - Making a Shiny application with the map from before

# load the libraries

library(ggplot2)
library(dplyr)
library(leaflet)

# load the data

recycling_data <- read.csv("recycling_data.csv",stringsAsFactors = F)

# load the spatial data

boundary <- readOGR(dsn=getwd(), layer="Local_Authority_Districts_December_2018_Boundaries_UK_BGC")

boundary <- spTransform(boundary, 
                        CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))



ui <- navbarPage("Scotland Test", id = "nav",
                 
                 tabPanel("Demonstration Shiny",
                          h3("Hello World!"),
                          br(),
                          h2(textOutput("yearlabel")),
                          leafletOutput("recyclemap")
                          )
)
  

server <- function(input, output, session) {
  
  
  # filter the data to remove Scotland and keep only the 'Waste Recycled' measures
  
  sel_year <- "2011/2012"
  recycling_data <- recycling_data %>%
    filter(Indicator..municipal.waste. == 'Waste Recycled') %>%
    filter(FeatureCode != 'S92000003') %>%
    filter(DateCode == sel_year)
  
  spatial_recycling <- merge(boundary, recycling_data, by.x = 'lad18cd', by.y = 'FeatureCode', all.x = FALSE)
  
  pal <- colorNumeric(palette = 'viridis', domain = spatial_recycling@data$Value)
  
  # put the year into a textbox
  
  output$yearlabel <- renderText(paste0(sel_year))
  
  # draw the map
  
  output$recyclemap <- renderLeaflet({leaflet(spatial_recycling) %>%
      setView(lng = -3.5, lat = 57.5, zoom = 6) %>%
      addProviderTiles('CartoDB.Positron') %>%
      addPolygons(fillColor = ~pal(Value),
                  popup = ~paste0("<div><h3>",lad18nm,"</h3></div><br/>",Value,"%"),
                  weight = 1.5,
                  fillOpacity = 0.5,
                  opacity = 1,
                  color = "#555555") %>%
      addLegend(pal = pal, values = ~Value, title = "Municipal Recycling Rates 2011/12 (%)")
    })
  
  
  
}

shinyApp(ui = ui, server = server)