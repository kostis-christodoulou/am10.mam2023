library(tidyverse)
library(lubridate)
bikes <- vroom::vroom("data/londonBikes.csv") 

# from london_bikes data, that has avg_temp
bikes <- vroom::vroom("londonBikes.csv")%>% 
  mutate(date = dmy(date),
         year = year(date))

# from london_bikes data, that contains avg_temp
bikes %>% 
  filter(year == 2019 ) %>% 
  ggplot(aes(x = date, y = avg_temp)) +
  geom_line() +
  geom_smooth() +
  labs(
    title = "Average temperature in London, 2019", 
    x = NULL, 
    y= "Celsius")+
  scale_y_continuous(
    sec.axis = 
      sec_axis(trans = ~ (1.8 * .) +32,
               name = "Fahrneheit")
  ) +
  theme_minimal()+
  NULL


car_counts <- mpg %>% 
  group_by(drv) %>% 
  summarize(total = n())

total_cars <- sum(car_counts$total)

ggplot(car_counts,
       aes(x = drv, y = total, 
           fill = drv)) +
  geom_col() +
  scale_y_continuous(
    sec.axis = sec_axis(
      trans = ~ . / total_cars,
      labels = scales::percent,
      name = "%")
  ) +
  guides(fill = FALSE)+
  theme_minimal()+
  NULL

