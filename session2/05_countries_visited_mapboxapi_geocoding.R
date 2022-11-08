library(googlesheets4)
library(sf)
library(opencage) # for geocoding addresses
library(tidyverse)
library(mapboxapi)
library(rnaturalearth)
library(tmap)

googlesheets4::gs4_auth() # google sheets authorisation

#load countries_visited googlesheets
countries_visited <- read_sheet("https://docs.google.com/spreadsheets/d/14k4xrwrMRfabnyqQ2y_mTNdf-gT5KBDMAAS42H44V7E/edit?usp=sharing
") 

geocoded <- countries_visited %>% 
  mutate(
    address_geo = purrr::map(country, mb_geocode) # the beauty of purrr:map()
  ) %>% 
  
  unnest_wider(address_geo) %>% # returns a list, hence we unnest it...
  rename(lng = `...1`, # rename  to lng/lat
         lat = `...2`) 
