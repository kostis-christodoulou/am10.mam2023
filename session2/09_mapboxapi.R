library(mapboxapi)
library(mapdeck)
library(tidyverse)
library(leaflet)

# copy/paste your mapbox access token below
mb_access_token("pk.ey......", install = TRUE)

# mb_isochrone
walk_5min <- mb_isochrone("Schlossplatz 1, Berlin",
                          profile = "walking",
                          time = 7)

leaflet(walk_5min) %>%
  addMapboxTiles(style_id = "streets-v11",
                 username = "mapbox") %>%
  addPolygons()


# mb_isochrone + mapdeck interactive map
isochrones <- mb_isochrone("Schlossplatz 1, Berlin", 
                           time = c(5, 10, 20),
                           profile = "cycling") 

mapdeck(style = mapdeck_style("light")) %>%
  add_polygon(data = isochrones, 
              fill_colour = "time",
              fill_opacity = 0.5,
              legend = TRUE)


# routing
my_route <- mb_directions(
  origin = "Schlossplatz 1, Berlin",
  destination = "British Library, London",
  profile = "driving",
  steps = TRUE,
  language = "en" #https://docs.mapbox.com/api/navigation/directions/#instructions-languages # en is the default option
  # language = "es" #https://docs.mapbox.com/api/navigation/directions/#instructions-languages # en is the default option
  # language = "el-GR" #https://docs.mapbox.com/api/navigation/directions/#instructions-languages
# language = "pl" #https://docs.mapbox.com/api/navigation/directions/#instructions-languages
# language = "zh-CN" #https://docs.mapbox.com/api/navigation/directions/#instructions-languages
)

glimpse(my_route)


leaflet(my_route) %>%
  addMapboxTiles(style_id = "light-v9",
                 username = "mapbox") %>%
  addPolylines()


my_route |> 
  summarise(total_distance = sum(distance),
            total_time = sum(duration))





