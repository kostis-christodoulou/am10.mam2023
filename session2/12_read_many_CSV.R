library(tidyverse)
library(lubridate)
library(janitor)
library(vroom)
library(skimr)
library(sf)

# read many CSV files
# Adapted from https://www.gerkelab.com/blog/2018/09/import-directory-csv-purrr-readr/

# assuming all your files are within a directory called 'data/stop-search'
data_dir <- "data/stop-search"

files <- fs::dir_ls(path = data_dir, regexp = "\\.csv$", recurse = TRUE) 
#recurse=TRUE will recursively look for files further down into any folders

files

#read them all in using vroom::vroom()
stop_search_data <- vroom(files, id = "source")

# Uncomment the following lines if you want to see how much faster vroom is

# library(microbenchmark)
# mbm = microbenchmark(
#   readr =  map_dfr(files, read_csv, .id = "source"),
#   vroom =  vroom(files, id = "source"),
#   times=10
# )
# mbm

# Unit: milliseconds
# expr       min        lq      mean    median        uq       max neval cld
# readr 3676.9319 3761.8027 3944.5699 3791.1760 4055.4460 4626.9870    10   b
# vroom  855.9414  864.9085  910.1052  905.8456  948.0134  975.8617    10  a 

#read them all in using vroom::vroom()
stop_search_data <- vroom(files, id = "source")



# Use janitor to clean names, and add more variables
stop_search_all <- stop_search_data %>%
  janitor::clean_names() %>% 
  mutate(month = month(date),
         month_name = month(date, label=TRUE, abbr = TRUE),
         year= year(date),
         month_year = paste0(year, "-",month_name)
  ) %>% 

# rename longitude/latitude to lng/lat
rename(lng = longitude,
       lat = latitude)
  
# skimr::skim() to inspect and get a feel for the data         
skim(stop_search_all)

# some quick counts...
stop_search_all %>% 
  count(gender, sort=TRUE)

stop_search_all %>% 
  count(object_of_search, sort=TRUE)

stop_search_all %>% 
  count(officer_defined_ethnicity, sort=TRUE)

stop_search_all %>% 
  count(age_range)



# concentrate in top  searches, age_ranges, and officer defined ethnicities
which_searches <- c("Controlled drugs", "Offensive weapons","Stolen goods" )
which_ages <- c("10-17", "18-24","25-34", "over 34")
which_ethnicity <- c("White", "Black", "Asian")

stop_search_offence <- stop_search_all %>% 
  
  # filter out those stop-and-search where no further action was taken
  filter(outcome != "A no further action disposal") %>% 
  
  #filter out those rows with no latitude/longitude
  drop_na(lng,lat) %>% 
  
  # concentrate in top searches, age_ranges, and officer defined ethnicities
  filter(object_of_search %in% which_searches) %>% 
  filter(age_range %in% which_ages) %>% 
  filter(officer_defined_ethnicity %in% which_ethnicity) %>% 
  
  # relevel factors so everything appears in correct order
  mutate(
    object_of_search = fct_relevel(object_of_search, 
                                   c("Controlled drugs", "Offensive weapons","Stolen goods")), 
    age_range = fct_relevel(age_range, 
                            c("10-17", "18-24", "25-34", "over 34")), 
    officer_defined_ethnicity = fct_relevel(officer_defined_ethnicity, 
                                            c("White", "Black", "Asian"))
  )


# make it a shape file using WGS84 lng/lat coordinates
stop_search_offence_sf <-  st_as_sf(stop_search_offence, 
                              coords=c('lng', 'lat'), 
                              crs = 4326)

st_geometry(stop_search_offence_sf) # what is the geometry ?
# stop_search_offence_sf = geographic CRS: WGS 84

# make sure you have the same direcory stucture to get London wards shapefile
london_wards_sf <- read_sf(here::here("data/London-wards-2018_ESRI","London_Ward.shp"))

st_geometry(london_wards_sf) # what is the geometry ?
# london_wards_sf = projected CRS:  OSGB 1936 / British National Grid

# change the CRS to use WGS84 lng/lat pairs
london_wgs84 <-  london_wards_sf %>% 
  st_transform(4326) # transform CRS to WGS84, latitude/longitude

st_geometry(london_wgs84) # what is the geometry ?