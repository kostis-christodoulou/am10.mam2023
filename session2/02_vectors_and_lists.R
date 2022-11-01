library(tidyverse)
library(gapminder)

# Vectors - one dimensional, one type
my_colours <- c("grey80", "tomato")

# subset and get the first element from this character vector
my_colours[1]
# [1] "grey80"

gapminder %>%
  mutate(rwanda = ifelse(country == "Rwanda", TRUE, FALSE)) %>%
  ggplot(aes(x = year, y = lifeExp, colour = rwanda, group = country)) +
  geom_line(

    # the data is a function that takes the original df, and filter(x,!rwanda)
    data = function(x) filter(x, !rwanda),
    
    # all lines where rwanda==FALSE, will be coloured 'grey80'
    colour = my_colours[1] 
  ) +
  geom_line(
    data = function(x) filter(x, rwanda),

    # all lines where rwanda==TRUE, will be coloured 'tomato' and be size=3
    colour = my_colours[2],
    size = 3
  ) +
  theme_minimal()


# Lists - many dimensions, many types
fubar <- list(a = "Hello world", b = 1, c = TRUE, d = rnorm(100), e = mean)

glimpse(fubar)
# List of 5
# $ a: chr "hello"
# $ b: num 1
# $ c: logi TRUE
# $ d: num [1:100] 3.361 1.246 0.549 1.334 -1.274 ...
# $ e:function (x, ...) 

skimr::skim(fubar)
# Error in as.data.frame.default(x[[i]], optional = TRUE) : 
#   cannot coerce class ‘"function"’ to a data.frame


grades <- list(
     a = rnorm(20, mean = 78, sd = 8.3),
     b = rnorm(15, mean = 87, sd = 5.6),
     c = rnorm(18, mean = 82, sd = 6.7)
)

grades[1]
grades$a
grades[[1]]

class(grades[1])
class(grades$a)
class(grades[[1]])


# dataframes/tibbles are lists, so when you subset with [] you get a tibble
head(gapminder["pop"])     

# when you subset with [[]] or $ you get a vector
head(gapminder[["pop"]])
head(gapminder$pop)

# vectorized operations work on vectors
sum(grades$a)
sum(grades[[1]])

# vectorized operations don't work on lists
sum(grades[1])


# on to to purrr:map()

library(purrr)
set.seed(42)

x_list <- list(x = rnorm(100), # generates 100 random numbers from N(0,1)
               y = rnorm(100), 
               z = rnorm(100))

map(x_list, mean) # take the list and apply the function 'mean' to each item on list


# find the standard deviation (sd) for all numeric variables in gapminder
# using map() returns a list
gapminder %>%
  dplyr::select_if(is.numeric) %>%
  map(sd) 


# find the standard deviation (sd) for all numeric variables in gapminder
# using map_dbl() returns a vector
gapminder %>%
  dplyr::select_if(is.numeric) %>%
  map_dbl(sd) 
