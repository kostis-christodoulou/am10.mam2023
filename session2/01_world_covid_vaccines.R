library(tidyverse)
library(vroom)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgdal)
library(rgeos)
library(patchwork)
library(mapview)
library(tmap)
library(viridis)

url <- "https://covid.ourworldindata.org/data/owid-covid-data.csv"
covid_data <- vroom(url) %>% 
  mutate(perc = round(100 * people_fully_vaccinated / population, 2)) 


map <- ne_countries(scale = "medium", returnclass = "sf") %>%
  dplyr::select(name, iso_a3, geometry) %>%
  filter(!name %in% c("Greenland", "Antarctica"))

ggplot(data = map) +
  geom_sf()


df <- map %>% 
  rename(iso_code=iso_a3) %>% 
  left_join(
    covid_data %>% 
      select(location, iso_code, date, people_fully_vaccinated, perc, continent) %>% 
      group_by(location) %>% 
      slice_max(order_by = perc, n=1) %>% 
      ungroup(),
  by =  "iso_code") %>% 
  drop_na(date) 


base_map <- ggplot(data = df) +
  geom_sf(
    mapping = aes(
      geometry = geometry, #use Natural Earth World boundaries
      fill = perc#fill colour = percent vaccinated
    ),
    colour = "white",      # white borders between regions
  )+
  scale_fill_gradient(
    low = "#d8b365",
    high = '#5ab4ac',
    na.value = "grey60",
  )+
  labs(
    title = glue::glue("% Vaccinated against Covid- \nData as of {df$date}"),
    caption = "Source: https://github.com/owid/covid-19-data/tree/master/public/data"
  )+
  theme_void()+
  NULL

base_map+
  geom_sf_text(aes(label = perc), size=2) + 
  NULL

# trying different projections

map_lat_lon <- base_map +
  coord_sf(crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_def") +
  labs(title = "Longitude-latitude",
       subtitle = 'crs = "+proj=longlat +ellps=WGS84"')+
  theme(legend.position = "none")

# Robinson
map_robinson <- base_map +
  coord_sf(crs = "+proj=robin") +
  labs(title = "Robinson",
       subtitle = 'crs = "+proj=robin"')

# Mercator (ew)
map_mercator <- base_map +
  coord_sf(crs = "+proj=merc") +
  labs(title = "Mercator",
       subtitle = 'crs = "+proj=merc"')+
  theme(legend.position = "none")

# Azimuthal Equidistant
map_azimuthal_equidistant <- base_map +
  coord_sf(crs = "+proj=aeqd") +  # Gall Peters / Equidistant cylindrical
  labs(title = "Azimuthal Equidistant",
       subtitle = "crs = +proj=aeqd")

#use patchwork to arrange 4 maps in one page
(map_lat_lon / map_mercator) | ( map_robinson / map_azimuthal_equidistant)



# using mapview package- Interactive viewing of spatial objects in R

df  %>%
  mapview::mapview(zcol = "perc", 
                   at = seq(0, max(df$perc, na.rm = TRUE), 10), # cut perc by 10% 
                   legend = TRUE,
                   layer.name = "Fully Vaccinated %")


# use viridis plasma colour scale
df  %>%
  mapview::mapview(zcol = "perc", 
                   at = seq(0, max(df$perc, na.rm = TRUE), 10), 
                   legend = TRUE,
                   col.regions = plasma(n = 8),
                   layer.name = "Fully Vaccinated %")


# Use tmap package

tm_shape(df) + 
  tmap_options(check.and.fix = TRUE)+
  tm_polygons(col = "perc",  
              n = 8,
              title = "Fully Vaccinated %",
              palette = "Blues")

df %>% 
  filter(continent == "Asia") %>% 
  tm_shape() + 
  tm_polygons(col = "perc",  
              n = 5,
              title = "% vaccinated",
              palette = "Blues") 

tmap_mode("view") # for interactive maps

df %>% 
  filter(continent == "Asia") %>% 
  tm_shape() + 
  tm_polygons(col = "perc",  
              n = 5,
              title = "% vaccinated",
              palette = "Blues") 

tmap_mode("plot") # back to static maps for tmap


df %>% 
  filter(continent == "South America") %>% 
  tm_shape() +  
  tm_polygons(col = "perc",  
              n = 5,
              title = "% vaccinated",
              palette = "Greens") + 
  tmap_options(limits = c(facets.view = 13)) + 
  tm_facets(by = "name") 
