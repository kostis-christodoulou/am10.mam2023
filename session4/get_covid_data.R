library(tidyverse)
library(vroom)
library(here)

  
# if you want to get an up-to-date version, run the following lines
url <- "https://covid.ourworldindata.org/data/owid-covid-data.csv"
covid_data <- vroom(url) %>% 
  mutate(perc = round(100 * people_fully_vaccinated / population, 2))


fubar <- covid_data %>% 
  group_by(location) %>% 
  filter(total_cases>=100) %>% 
  mutate(total_days = 1:n()) %>% 
  ungroup()

fubar %>% 
  select(location, date, total_cases, total_days) %>% 
  filter(location %in% c("France", "Italy", "United Kingdom" )) %>% 
  ggplot(aes(x=total_days, y= total_cases, colour=location))+
  geom_line() +
  theme_bw() +
  scale_y_continuous(labels = scales::number)
