# sg-training2-exercise-2

library(dplyr)
library(leaflet)
library(rgdal)
# maka a choropleth using data from statistics.gov.scot

# get the data from statistics.gov.scot

# something simple by local authority area

recycling_data <- read.csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fmunicipal-waste",stringsAsFactors = F)

# filter it to just get one column of observations

recycling_data_for_map <- recycling_data %>%
                            filter(Indicator..municipal.waste. == 'Waste Recycled') %>%
                            filter(DateCode == '2011/2012') %>%
                            filter(FeatureCode != 'S92000003')

# now we need to prepare the geodata

boundary <- readOGR(dsn=getwd(), layer="Local_Authority_Districts_December_2018_Boundaries_UK_BGC")

boundary <- spTransform(boundary, 
                         CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

#### this is not part of the code to make this - it's to demonstrate how to make a map step by step ####

map <-leaflet()

map

####

map <- leaflet() %>%
        addTiles()

map

####

map <-leaflet() %>%
        addTiles() %>%
        setView(lng = -3.5, lat = 57.5, zoom = 6)

map

####

map <- leaflet() %>%
        setView(lng = -3.5, lat = 57.5, zoom = 6) %>%
        addProviderTiles('CartoDB.Positron')

map

####

map <- leaflet(boundary) %>%
  setView(lng = -3.5, lat = 57.5, zoom = 6) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addPolygons()

map

# merge the boundary file with the data

spatial_recycling <- merge(boundary, recycling_data_for_map, by.x = 'lad18cd', by.y = 'FeatureCode', all.x = FALSE)

# define our palette
pal <- colorNumeric(palette = 'viridis', domain = spatial_recycling@data$Value)

# create a map object with the boundaries coloured according to the value

map <- leaflet(spatial_recycling) %>%
  setView(lng = -3.5, lat = 57.5, zoom = 6) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addPolygons(color = ~pal(Value))

map

# add a legend to this map

map <- leaflet(spatial_recycling) %>%
  setView(lng = -3.5, lat = 57.5, zoom = 6) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addPolygons(color = ~pal(Value)) %>%
  addLegend(pal = pal,
            values = ~Value, 
            title = "Municipal Recycling Rates 2011/12 (%)")

map

# add labels to the map on click

map <- leaflet(spatial_recycling) %>%
  setView(lng = -3.5, lat = 57.5, zoom = 6) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addPolygons(color = ~pal(Value),
              popup = ~lad18nm) %>%
  addLegend(pal = pal, values = ~Value, title = "Municipal Recycling Rates 2011/12 (%)")

map

# better labels

map <- leaflet(spatial_recycling) %>%
  setView(lng = -3.5, lat = 57.5, zoom = 6) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addPolygons(color = ~pal(Value),
              popup = ~paste0(lad18nm," - ",Value,"%")) %>%
  addLegend(pal = pal, values = ~Value, title = "Municipal Recycling Rates 2011/12 (%)")

map

# even with html

map <- leaflet(spatial_recycling) %>%
  setView(lng = -3.5, lat = 57.5, zoom = 6) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addPolygons(color = ~pal(Value),
              popup = ~paste0("<div><h3>",lad18nm,"</h3></div><br/>",Value,"%")) %>%
  addLegend(pal = pal, values = ~Value, title = "Municipal Recycling Rates 2011/12 (%)")

map

# finally we'll style the map to neaten it up a bit

map <- leaflet(spatial_recycling) %>%
  setView(lng = -3.5, lat = 57.5, zoom = 6) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addPolygons(fillColor = ~pal(Value),
              popup = ~paste0("<div><h3>",lad18nm,"</h3></div><br/>",Value,"%"),
              weight = 1.5,
              fillOpacity = 0.5,
              opacity = 1,
              color = "#555555") %>%
  addLegend(pal = pal, values = ~Value, title = "Municipal Recycling Rates 2011/12 (%)")

map

