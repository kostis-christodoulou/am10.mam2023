library(osmdata)
library(here)
library(tidyverse)
library(sf)

pubs_osm <- opq ("London UK") %>%
  add_osm_feature(key = "amenity", value = "pub") %>%
  # return the data in Simple Features (sf) format
  osmdata_sf()

pubs <- pubs_osm$osm_points  


st_geometry(pubs)
# geographic CRS: WGS 84


london_wards <- read_sf(here("data/London-wards-2018_ESRI/London_Ward.shp"))
st_geometry(london_wards)
# projected CRS:  OSGB 1936 / British National Grid


ggplot()+
  geom_sf(data=london_wards)+
  geom_sf(data=pubs)


#need to have common CRS, so convert london_wards to WGS 84

london_wards <- london_wards %>% 
  st_transform(4326)
st_geometry(london_wards)
# geographic CRS: WGS 84


ggplot()+
  geom_sf(data=london_wards)+
  geom_sf(data=pubs, alpha = 0.25)+
  theme_minimal()

## what if we wanted to calculate number of pubs in each London ward

london_pubs_ward <- london_wards %>%
  mutate(count = lengths(
    st_contains(london_wards, 
                pubs)))

# https://www.morningadvertiser.co.uk/Article/2019/08/27/How-many-pubs-are-in-London
# they claim about 3500 

ggplot(data = london_pubs_ward, aes(fill = count)) +
  geom_sf() +
  scale_fill_gradient(low = "#ffffe0", high = "#6e0000")

tmap::tmap_mode("view")
tmap::tm_shape(london_pubs_ward) +
  tm_polygons("count")
