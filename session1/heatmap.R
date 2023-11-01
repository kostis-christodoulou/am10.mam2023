library(tidyverse)
library(wbstats)

# https://data.worldbank.org/indicator/IT.NET.USER.ZS
# Download data for Individuals Using Internet (% Of Population) IT.NET.USER.ZS 
# using the wbstats package

internet <- wb_data(country = "countries_only", 
                      indicator = "IT.NET.USER.ZS", 
                      start_date = 1995, end_date = 2021)

glimpse(internet)

country_list = c("United States", "China", "India", "Japan", "Algeria",
                 "Brazil", "Germany", "France", "United Kingdom", "Italy", "New Zealand",
                 "Canada", "Mexico", "Chile", "Argentina", "Norway", "South Africa", "Kenya",
                 "Israel", "Iceland")

internet_short <- filter(internet, country %in% country_list) %>%
  rename(value = IT.NET.USER.ZS) %>% 
  mutate(users = ifelse(is.na(value), 0, value),
         year = as.numeric(date))

internet_summary <- internet_short %>%
  group_by(country) %>%
  summarize(year1 = min(year[users > 0]),
            last = users[n()]) %>%
  arrange(last, desc(year1))

internet_short <- internet_short %>%
  mutate(country = factor(country, levels = internet_summary$country))

ggplot(filter(internet_short, year > 1993),
       aes(x = year, y = country, fill = users)) +
  geom_tile(color = "white", size = 0.25) +
  scale_fill_viridis_c(
    option = "A", begin = 0.05, end = 0.98,
    limits = c(0, 100),
    name = "internet users / 100 people",
    guide = guide_colorbar(
      direction = "horizontal",
      label.position = "bottom",
      title.position = "top",
      ticks = FALSE,
      barwidth = grid::unit(3.5, "in"),
      barheight = grid::unit(0.2, "in")
    )
  ) +
  scale_x_continuous(expand = c(0, 0), name = NULL) +
  scale_y_discrete(name = NULL, position = "right") +
  theme(
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    axis.ticks.length = grid::unit(1, "pt"),
    legend.position = "top",
    legend.justification = "left",
    legend.title.align = 0.5,
    legend.title = element_text(size = 12*12/14)
  )
