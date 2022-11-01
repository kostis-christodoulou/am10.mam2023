library(tidyverse)
library(treemapify)
library(ggalluvial)
library(ggridges)
library(ggthemes)


# Treemaps
# further treemap examples https://github.com/wilkox/treemapify 

mpg %>%
  filter(year == 1999) %>%
  count(manufacturer) %>%
  ggplot(aes(area = n,
             fill = manufacturer,
             label = manufacturer)) +
  geom_treemap() +
  geom_treemap_text() +
  theme(legend.position = "none")


#-------------------------------------------------------------------

# Alluvial or flow/Sankey diagrams
# https://corybrunson.github.io/ggalluvial/articles/ggalluvial.html

data(vaccinations)
ggplot(vaccinations,
       aes(x = survey, y = freq, 
           alluvium = subject, stratum = response,
           fill = response, label = response)) +
  scale_x_discrete(expand = c(.1, .1)) +
  geom_flow() +
  geom_stratum(alpha = .5) +
  geom_text(stat = "stratum", size = 3) +
  theme(legend.position = "none") +
  labs(title = "Vaccination survey response at three times")


#-------------------------------------------------------------------

# distributions - ggridges

l2 <- c("subcompact","midsize","compact",
        "2seater","minivan","pickup","suv")
mpg %>%
  mutate(class = factor(class, levels = l2)) %>%
  ggplot(aes(x = hwy, y = class, fill = class))+
  geom_density_ridges(alpha = 0.4) +
  theme_minimal() +
  theme(legend.position = "none")

#-------------------------------------------------------------------

# X-Y relationships 
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point(aes(color = trans), size = 0.5) +
  facet_wrap(~trans, nrow=2) +
  theme_minimal() +
  theme(legend.position = "none",
        text = element_text(size=10))


library(nycflights13)
# just filter to have first 2 months
df <- flights %>%
  mutate(day=as.Date(time_hour)) %>%
  filter(day < "2013-03-01") %>%
  count(day,origin)
# and ggplot
ggplot(df, aes(x=day, y=n, color=origin)) +
  geom_line(aes(group=origin)) +
  geom_point() +
  theme_bw()+
  theme(legend.position="bottom")


filter(mpg, class != "2seater") %>%
  ggplot(aes(x = cty, y = hwy)) +
  geom_density_2d()


filter(mpg, class != "2seater") %>%
  ggplot(aes(x = cty, y = hwy)) +
  geom_density_2d(aes(color = class)) +
  facet_wrap(~class) +
  theme(legend.position = "none")

filter(mpg, class != "2seater") %>%
  ggplot(aes(x = cty, y = hwy)) +
  geom_hex(aes(color = class), bins = 10) +
  facet_wrap(~class) +
  theme(legend.position = "none")


#-------------------------------------------------------------------
# Uncertainty 

l3 <- c("compact","subcompact","midsize",
        "2seater","minivan","suv","pickup")
# avg highway mpg with boostrapped 95% CI
mpg %>%
  mutate(class = factor(class, levels = l3)) %>%
  ggplot(aes(x = class, y = hwy, color = class))+
stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.data = mean_cl_boot,
                geom = "pointrange") +
  theme_bw() +
  coord_flip() +
  theme(legend.position = "none") +
  labs(x = " ", y = "Highway MPG with 95% CI")

l3 <- c("compact","subcompact","midsize",
        "2seater","minivan","suv","pickup")
# avg highway mpg with boostrapped 95% CI
mpg %>%
  mutate(class = factor(class, levels = l3)) %>%
  ggplot(aes(x = class, y = hwy, color = class))+
stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.data = mean_cl_boot,
               geom = "errorbar") +
  theme_bw() +
  coord_flip() +
  theme(legend.position = "none") +
  labs(x = " ", y = "Highway MPG with 95% CI")
