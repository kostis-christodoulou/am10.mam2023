## find the main streets of a city: 
# do random 1000 x 1000 routes and plot thickness of overlapping lines

library(sf)
library(dplyr)
library(osrm)
library(stplanr)
library(leaflet)
library(htmltools)
library(mapview)
library(viridis)

# get 1000 random routings

#use sf::read_sf() to read in London Wards shapefile
london_wards_sf <- read_sf(here("data/London-wards-2018_ESRI/London_Ward.shp"))

# transfrom CRS to 4326, or pairs of latitude/longitude numbers
london <-  london_wards_sf %>% 
  st_transform(4326) # transform CRS to WGS84, latitude/longitude

# pick 100 random starting and ending points
start_points <- st_sample(london,size=1000) %>% st_as_sf
end_points <- st_sample(london,size=1000) %>% st_as_sf

# the routing will take a few minutes, as it needs to find 1000 routes
routes <- route(from = start_points, 
                to = end_points, 
                route_fun = osrmRoute,
                returnclass = "sf")

# Just do a quick visualisation of the 1000 routes
mapview(routes)


routes <- routes %>% 
  mutate(count = 1) # add a number that keeps track of each unique path

# stplanr::overline() takes a series of overlapping lines and converts them into a single route network.
overlapping_segments <- overline(routes, 
                                 attrib = "count") # attrib: column names in sl to be aggregated


leaflet(overlapping_segments) %>% 
  addProviderTiles(providers$CartoDB.DarkMatter) %>%
  addPolylines(weight = overlapping_segments$count / 5, color = "white") %>% 
  addControl(html = paste(tags$h2(HTML("What are the major streets in London?")),
                          tags$div(HTML("Routing of 1000 random start points to 1000 random end points reveals the most commonly used streets.")),
                          tags$div(HTML("Made possible by the <a href= 'https://github.com/ropensci/stplanr'>stplanr package</a>"))),
             position = "bottomleft")

