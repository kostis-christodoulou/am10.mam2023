library(tidyverse)
library(gapminder)
library(ggridges)
library(gghalves)

# create gapminder2007, by just looking at 2007 data
gapminder2007 <- filter(gapminder, 
                        year == 2007)

# This makes it very hard to read and understand
ggplot(gapminder2007,
       aes(x = lifeExp,
           fill = continent)) +
  geom_histogram(binwidth = 5, 
                 color = "white", 
                 boundary = 50)+
  theme_minimal()+
  NULL


# Facetting by continent makes it easier to read and understand
ggplot(gapminder2007,
       aes(x = lifeExp,
           fill = continent)) +
  geom_histogram(binwidth = 5, 
                 color = "white", 
                 boundary = 50)+
  guides(fill=FALSE)+
  theme_bw()+
  facet_wrap(~continent)+
  NULL

# pyramid histograms
gapminder_intervals <- gapminder2007 %>% 
  mutate(africa = 
           ifelse(continent == "Africa", 
                  "Africa", "Not Africa")) %>% 
  mutate(age_buckets = 
           cut(lifeExp, 
               breaks = seq(30, 90, by = 5))) %>% 
  group_by(africa, age_buckets) %>% 
  summarize(total = n())

ggplot(gapminder_intervals, 
       aes(y = age_buckets,
           x = ifelse(africa == "Africa", 
                      total, -total),
           fill = africa)) +
  geom_col(width = 1, color = "white")+
  theme_minimal()+
  NULL

# use ggridges::geom_density_ridges() for multiple density plots
ggplot(filter(gapminder2007, 
              continent != "Oceania"),
       aes(x = lifeExp,
           fill = continent,
           y = continent)) +
  geom_density_ridges(alpha = 5/8)+
  theme_minimal()+
  guides(fill=FALSE)+
  NULL

# use gghalves::geom_half_boxplot(), gghalves::geom_half_point()
ggplot(filter(gapminder2007, 
              continent != "Oceania"),
       aes(y = lifeExp,
           x = continent,
           colour = continent)) +
  geom_half_boxplot(side = "l") + # half boxplot to the left
  geom_half_point(side = "r")+    # points to the right
  theme_minimal()+
  guides(fill = FALSE, color = FALSE)+
  NULL

# Raincloud plots
ggplot(filter(gapminder2007, 
              continent != "Oceania"),
       aes(y = lifeExp,
           x = continent,
           colour = continent)) +
  geom_half_point(side = "l", size = 0.3) + 
  geom_half_boxplot(side = "l", width = 0.5, 
                    alpha = 0.3, nudge = 0.1) +
  geom_half_violin(aes(fill = continent), 
                   alpha = 0.8,
                   side = "r") +
  guides(fill = FALSE, color = FALSE) +
  coord_flip()+
  theme_minimal()+
  NULL

