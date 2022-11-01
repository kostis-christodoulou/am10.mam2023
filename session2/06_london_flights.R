library(tidyverse)
library(sf)
library(rnaturalearth)
library(eurostat)
library(lubridate)
library(opencage)
library(hrbrthemes)
library(gridExtra)

# get a medium resolution vector map of world countries excl. Antarctica
world <- ne_countries(scale = "medium", returnclass = "sf") %>%
  filter(name != "Antarctica") 


# Air passenger transport between the main airports of the United Kingdom 
# and their main partner airports (routes data)
# https://ec.europa.eu/eurostat/web/products-datasets/-/avia_par_uk

flights_UK <- get_eurostat(id="avia_par_uk", 
                                select_time = "M") #get monthly data


# filter passengers only
flights <- flights_UK %>% 
  dplyr::filter(unit == "PAS") %>% 
  mutate(
    origin = str_sub(airp_pr, 1, 7),
    destination = str_sub(airp_pr, -7), 
    from = str_sub(origin, 4,7),
    to = str_sub(destination, 4,7),
    year = year(time),
    month_name = month(time, label = TRUE)
  ) 


flights %>% 
  filter(year>=2018) %>% 
  group_by(origin,year) %>% 
  summarise(totalpassengers = sum(values)) %>% 
  arrange(desc(totalpassengers))
# 
# origin   year totalpassengers
# <chr>   <dbl>           <dbl>
#   1 UK_EGLL  2019       315616656
# 2 UK_EGLL  2018       314171004
# 3 UK_EGKK  2019       174720542
# 4 UK_EGKK  2018       173091550
# 5 UK_EGCC  2019       102403412
# 6 UK_EGSS  2019       101440212
# 7 UK_EGSS  2018       100518160
# 8 UK_EGCC  2018        98376330
# 9 UK_EGLL  2020        64403150
# 10 UK_EGGW  2019        62841150

london_airports <- c("UK_EGLL","UK_EGKK","UK_EGSS","UK_EGGW")

london_flights <- flights %>% 
  dplyr::filter(origin %in% london_airports) %>% 
  distinct()





# count number of flights from origins to destinations
origins <- london_flights %>% 
  count(from, sort=TRUE) %>% 
  mutate(prop = n/sum(n))

destinations <- london_flights %>% 
  count(to, sort=TRUE)  %>% 
  mutate(prop = n/sum(n))

# geocode origin/destination airports
origins <- origins %>% 
  mutate(
    origin_geo = purrr::map(from, opencage_forward, limit=1)
  ) %>% 
  unnest_wider(origin_geo) %>% 
  unnest(results) %>% 
  rename(from_y = geometry.lat,
         from_x = geometry.lng)

destinations <- destinations %>% 
  mutate(
    destination_geo = purrr::map(to, opencage_forward, limit=1)
  ) %>% 
  unnest_wider(destination_geo) %>% 
  unnest(results) %>% 
  rename(to_y = geometry.lat,
         to_x = geometry.lng)


#geocode airports

londonflights2018 <- london_flights %>% 
  filter(year==2018) %>% 
  group_by(year, destination, origin, from, to) %>% 
  summarise(totalpassengers = sum(values)) %>% 
  arrange(desc(totalpassengers)) %>% 

  #geocode origin (from_x, from_y)
  mutate(
    origin_geo = purrr::map(from, opencage_forward, limit=1)
  ) %>% 
  unnest_wider(origin_geo) %>% 
  unnest(results) %>% 
  rename(from_y = geometry.lat,
         from_x = geometry.lng) %>% 
  select(destination, from, to, totalpassengers, from_x, from_y) %>% 
  
  #geocode destination (to_x, to_y)
  mutate(
    destination_geo = purrr::map(to, opencage_forward, limit=1)
  ) %>% 
  unnest_wider(destination_geo) %>% 
  unnest(results) %>% 
  rename(to_y = geometry.lat,
         to_x = geometry.lng) %>% 
  select(destination, from, to, totalpassengers, from_x, from_y, to_x, to_y)


# for displaying a data table as annotation next to the map
table <- as_tibble(londonflights2018 %>% group_by(destination) %>%  head(20)) %>%
  select(Origin = origin, Destination = destination, Passengers = totalpassengers) %>%
  mutate(Passengers = glue::glue("{scales::comma(Passengers)}")) %>%
  tableGrob(
    rows = NULL,
    theme = ttheme_default(
      core = list(
        fg_params = list(
          fontfamily = "Lato",
          hjust = c(rep(0, 20), rep(1, 20)),
          x = c(rep(0.1, 20), rep(0.9, 20))
        )
      )
    )
  )


ggplot() +
  geom_sf(data = world, size = 0.125) +
  geom_curve(
    data = londonflights2018 %>% head(20), 
    aes(x = from_x, y = from_y, xend = to_x, yend = to_y, 
        size= totalpassengers, colour = totalpassengers),
    curvature = 0.2, arrow = arrow(length = unit(3, "pt"), type = "closed"),
  )+
  theme_void()+
  
  annotation_custom(table, xmin=-165, xmax=-160, ymin=-120, ymax=90) + 
  labs(
    x = NULL, y = NULL,
    title = "Top 20 destinations for London flights in 2018",
    subtitle = "Data source: Eurostat , id=avia_par_uk"
  ) +
  
  theme(
    text=element_text(size=16, family="Lato"),
    plot.title = element_text(),
    plot.title.position = "plot",
    axis.text.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none"
  ) +
  NULL


