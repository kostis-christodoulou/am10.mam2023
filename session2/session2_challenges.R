library(tidyverse)
library(sf)
library(here)
library(ggtext)
library(showtext)
library(ggrepel)

## Loading Google fonts (https://fonts.google.com/)
font_add_google("Montserrat", "Montserrat")
font_add_google("Ubuntu", "Ubuntu")
font_add_google("Fira Sans Condensed", "Fira")


# you must try to recreate
# 1. session2_challenge.png (a static image where you have to use a shapefile and country results)
# 2. interactive_margins20-16.html. You have to create a chart, and pass it to plotly::ggplotly().
# 3. interactive_margins_vs_votes_cast.html. Similar to 2, noth are interactive charts with ploty
# For 3 and 4, you have to change the text that appears as you move your mouse over each point


# colour scale I used in the map
my_scale <- c('#00429d', '#4771b2', '#73a2c6', '#a5d5d8', '#ffffe0', '#ffbcaf', '#f4777f', '#cf3759', '#93003a')

# Hex colour codes for Democrat Blue and Republican Red
party_colours <- c("#2E74C0", "#CB454A")

# Use the urbnmapr package to get shapefile for all US counties
# remotes::install_github("UrbanInstitute/urbnmapr")
library(urbnmapr)

counties_sf <- get_urbn_map("counties", sf = TRUE)

class(counties_sf)
counties_sf$geometry

# having loaded the shapefile, let me print the map, 
# where fill = grey70, and colour (the outline of each state) = white

counties_sf %>% 
  ggplot(aes()) +
  geom_sf(fill = "grey70", colour = "#ffffff")

# get latest NYT county-level data for the US 2020 election from this GitHub repository.
# https://github.com/favstats/USElection2020-NYT-Results/tree/master/data/2020-11-10%2014-35-07

results_president <- vroom::vroom(here("data", "results_president.csv"))
