# remotes::install_github("njtierney/ukpolice")
library(ukpolice)
library(tidyverse)
library(showtext)
library(ggtext)
library(leaflet)

font_add_google("Lato", "Lato")

## Automatically use showtext to render text for future devices
showtext_auto()

# Get the crime data with ukp_crime()
# ukp_crime() draws crimes from within a one mile radius of the location. When no date is specified, 
# it uses the latest month available, which can be found using ukp_last_update().
# I use LBS's address NW1 4SA which has lat/lon = 

crime_data <- ukp_crime(lat = 51.52626, 
                        lng = -0.16075)


# to specify a month, use
crime_data_date <- ukp_crime(lat = 51.52626, 
                             lng = -0.16075,
                             date = "2023-08")

# types of crime
crime_data %>%
  count(category) %>%
  mutate(percent = round(100*n/sum(n), digits = 1)) %>% 
  
  
  ggplot(aes(x = reorder(category, n),
             y = n)) + 
  geom_col() + 
  geom_text(
    aes(label = paste0(percent,"%"), y = n - .25),
    colour = "white",
    size = 3,
    hjust = 1
  ) +
  labs(x = NULL,
       y = NULL,
       title = paste0("Crimes commited in ",crime_data$date[1])) +
  coord_flip() +
  theme_minimal()+
  theme(
    text=element_text(size=12, family="Lato"),
    plot.title.position = "plot",
    plot.title = element_textbox_simple(size=26),
    axis.text = element_text(size=10),
    legend.position = "none") +
  # removve blank space between legend and graph
  scale_y_continuous(expand = c(0,0))+
  NULL


# quick map using leaflet

# get top ten crime categories
top_categories <- crime_data %>%
  count(category, sort=TRUE) %>%
  slice(1:10) %>%
  select(category) %>%
  pull()

crime_data <- crime_data %>% 
  mutate(map_category = ifelse(
    category %in% top_categories, category, "Other"
  ))

# lets us choose how to colour each point. What palette and colours to use? 
# A great site to get the relevant color hex codes for maps is 
# https://colorbrewer2.org/#type=qualitative&scheme=Set3&n=11
my_colours <- c('#e41a1c','#ffffb3','#bebada','#fb8072','#80b1d3','#fdb462','#b3de69','#fccde5','#d9d9d9','#bc80bd','#ccebc5')


# create a function point_fill, that assigns `my_colours` to different location types
# you can read more here https://rstudio.github.io/leaflet/colors.html
point_fill <- colorFactor(palette = my_colours,  
                          crime_data$map_category)

crime_data %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addCircleMarkers(lng = ~long, 
                   lat = ~lat, 
                   radius = 3, 
                   color = ~point_fill(map_category), 
         #          fillOpacity = 0.99, 
                   popup = ~street_name,
                   label = ~category)  %>%
  
  addLegend("bottomright", pal = point_fill, 
            values = ~map_category,
            title = "Category",
            opacity = 0.5)

