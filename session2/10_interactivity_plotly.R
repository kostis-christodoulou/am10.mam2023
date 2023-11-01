library(tidyverse)
library(plotly)
library(htmlwidgets)
library(gapminder)

gapminder2007 <- filter(gapminder, 
                         year == 2007)

# Works with most geometries. geom_point()
gapminder_plot <- ggplot(
  data = gapminder2007,
  mapping = aes(x = gdpPercap, 
                y = lifeExp, 
                colour = continent)) +
  geom_point() +
  scale_x_log10() +
  theme_minimal()

ggplotly(gapminder_plot)


# Works with most geometries. geom_histogram()
lifeexp_histogram <- ggplot(gapminder2007,
                            aes(x = lifeExp,
                                fill = continent)) +
  geom_histogram(binwidth = 5, 
                 colour = "white", 
                 boundary = 50)+
  guides(fill=FALSE)+
  theme_bw()+
  facet_wrap(~continent)+
  theme(legend.position = "none")+
  NULL

ggplotly(lifeexp_histogram)


# change what is displayed as you mouse over the points
gapminder2007 <- filter(gapminder, 
                        year == 2007)

# Works with most geometries. geom_point()
gapminder_plot2 <- ggplot(
  data = gapminder2007,
  mapping = aes(x = gdpPercap, 
                y = lifeExp, 
                colour = continent)) +
  geom_point(aes(text=country)) +
  scale_x_log10() +
  theme_minimal()

ggplotly(gapminder_plot2, tooltip = "text")



# YOu can save using htmlwidgets::saveWidget()
# This is like ggsave, but for interactive HTML plots

interactive_gapminder_plot <- ggplotly(gapminder_plot)
htmlwidgets::saveWidget(interactive_gapminder_plot, "interactive_gapminder_plot.html")
