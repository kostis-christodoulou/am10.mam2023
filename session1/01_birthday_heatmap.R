library(tidyverse)
library(showtext)
library(ggtext)
library(viridis)

# load fonts we will use
font_add_google("Montserrat", "Montserrat") 
font_add_google("Lato", "Lato")

## Automatically use showtext to render text for future devices
showtext_auto()

births_1994_2014 <- read_csv("data/births_1994_2014.csv") |> 
  janitor::clean_names() |> 
  mutate(
    full_date = make_date(year = year, 
                          month = month, 
                          day = date_of_month),
    
    day_of_year = yday(full_date)
  ) |> 
  mutate(
    month_categorical = month(full_date, label = TRUE, abbr = TRUE)
  )

glimpse(births_1994_2014)

# to learn more about the viridis package and the colours used see
# https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html#the-color-scales 




# calculate avg_births_month_day
births_1994_2014 |> 
  group_by(??????) |>  
  summarize(avg_births = mean(births)) |> 
  
# pass to ggplot
  ggplot()+
  
  aes(x = , 
      y = , 
      fill = +
  geom_tile() +
  scale_fill_viridis_c(
    option = "magma", # or whatever from https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html#the-color-scales 
    labels = scales::label_comma(),
    guide = guide_colorbar(barwidth = 20, barheight = 0.5, position = "bottom")
  ) +
  labs(
    x = NULL, y = NULL,
    title = "Average births per day",
    subtitle = "1994–2014",
    fill = "Average births"
  ) +
  coord_equal() +
  theme_minimal(base_family = "Montserrat") +
  theme(
    panel.grid = element_blank(),
    axis.title.x = element_text(hjust = 0),
    plot.title.position = "plot",
    legend.justification.bottom = "left",
    plot.title = element_textbox_simple(size=16),
    axis.text = element_text(size=10),
  )


prob_per_day <- births_1994_2014 |> 
  group_by(day_of_year) |> 
  summarize(total = sum(births)) |> 
  mutate(prob = total / sum(total)) |> 
  mutate(full_date = ymd("2024-01-01") + days(day_of_year - 1)) |> 
  mutate(yearless_date = format(full_date, "%B %d"))

glimpse(prob_per_day)

# least popular days
prob_per_day |> 
  dplyr::select(yearless_date, prob) |> 
  slice_min(order_by = prob, n = 20)

# most popular days
prob_per_day |> 
  dplyr::select(yearless_date, prob) |> 
  slice_max(order_by = prob, n = 20)


