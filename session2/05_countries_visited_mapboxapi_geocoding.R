library(googlesheets4)
library(sf)
library(opencage) # for geocoding addresses
library(tidyverse)
library(mapboxapi)
library(rnaturalearth)
library(tmap)

googlesheets4::gs4_auth() # google sheets authorisation

#load countries_visited googlesheets
countries_e628 <- read_sheet("https://docs.google.com/spreadsheets/d/1M597P_NWZ88s_kLNL_pxaN2DVKa2Y_aQLfKvwvJYqKo/edit?usp=sharing
") 

countries_e628 <- countries_e628 %>% 
  count(country, sort=TRUE)

geocoded <- countries_e628 %>% 
  mutate(
    address_geo = purrr::map(country, mb_geocode) # the beauty of purrr:map()
  ) %>% 
  unnest_wider(address_geo, # returns a list, hence we unnest it...
               names_sep = ",") %>% 
  janitor::clean_names() %>% 
  
  rename(lng = address_geo_1, # rename  to lng/lat
         lat = address_geo_2) 
