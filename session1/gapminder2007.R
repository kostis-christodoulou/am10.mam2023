library(tidyverse)
library(gapminder)
library(showtext)
library(ggrepel)

## Loading Google fonts (https://fonts.google.com/)
font_add_google("Montserrat", "Montserrat")
font_add_google("Ubuntu", "Ubuntu")
font_add_google("Fira Sans Condensed", "Fira")

## Automatically use showtext to render text for future devices
showtext_auto()

gapminder %>% 
  filter(year == 2007) %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp))+
  geom_point(
    size = 3,
    alpha = 0.8,
    shape = 21,
    colour = "white",
    fill = "#001e62"
  )+
  geom_text_repel(aes(label=country),
                  family="Montserrat")+
  theme_minimal()+
  theme(text=element_text(size=18, family="Ubuntu"))+
  theme(panel.grid.minor = element_blank())+
  labs(
    title = "Gapminder 2007: Life expectancy vs GDP per capita",
    x = "log(GDP per capita)",
    y = "Life Expectancy"
  )


# too much stuff. let me pick only 20 random countries
set.seed(7)

some_countries <- gapminder$country %>% 
  levels() %>% 
  sample(20) 

gapminder %>%
  filter(year == 2007) %>%
  mutate(
    label = ifelse(country  %in% some_countries, as.character(country), "")
  ) %>%
  ggplot(aes(log(gdpPercap), lifeExp)) +
    geom_point(
    size = 3,
    alpha = 0.8,
    shape = 21,
    colour = "white",
    fill = "#001e62"
  )+
  geom_text_repel(aes(label=label),
                  family = "Fira",
                  size = 5)+
  theme_minimal()+
  theme(panel.grid.minor = element_blank())+
  labs(
    title = "Gapminder 2007: Life expectancy vs GDP per capita",
    x = "log(GDP per capita)",
    y = "Life Expectancy"
  )+
  theme(
    plot.title.position = "plot",
    plot.title = element_textbox_simple(size=16,
                                        family = "Montserrat"),
    legend.position = "none") 


# We can define a base plot
p1 <- gapminder %>%
  filter(year == 2007) %>%
  mutate(
    label = ifelse(
      country %in% some_countries,as.character(country),"")
  ) %>%
  ggplot(aes(log(gdpPercap), lifeExp)) +
  geom_point(
    size = 3,
    alpha = 0.8,
    shape = 21,
    col = "white",
    fill = "#001e62"
  )

p1
