library(RColorBrewer)
display.brewer.all()
display.brewer.all(colorblindFriendly = TRUE)

toy_data <- tibble(
  x = c(1:5),
  y = c(5:1),
  count = seq(10, 50, by=10),
  group = c("A", "B", "C", "D", "E")
)

toy_data


# 2. Scatterplots: mapping group to color aesthetic ----
# 2.a) Simple scatterplot with size set to 5 for all points (i.e. not mapping
# to a variable in toy_data)
ggplot(toy_data, aes(x = x, y = y)) +
  geom_point(size = 5)

# 2.b) Default color scheme: map group variable to color
ggplot(toy_data, aes(x = x, y = y, colour = group)) +
  geom_point(size = 5)

# 2.c) Change color palette from default to "Set2": No assumed ordering to group
ggplot(toy_data, aes(x = x, y = y, color = group)) +
  geom_point(size = 5) +
  scale_color_brewer(palette = "Set2")

# scale_color_brewer palettes that are available for use with these scales:
#   
# Diverging Scale
# BrBG, PiYG, PRGn, PuOr, RdBu, RdGy, RdYlBu, RdYlGn, Spectral
# 
# Qualitative Scale
# Accent, Dark2, Paired, Pastel1, Pastel2, Set1, Set2, Set3
# 
# Sequential Scale
# Blues, BuGn, BuPu, GnBu, Greens, Greys, Oranges, OrRd, PuBu, PuBuGn, PuRd, Purples, RdPu, Reds, YlGn, YlGnBu, YlOrBr, YlOrRd


# 2.d) Change color palette from default to "Blues": Assumed ordering to group
ggplot(toy_data, aes(x = x, y = y, color = group)) +
  geom_point(size = 5) +
  scale_color_brewer(palette = "Blues")

# 3. Barplots: mapping group to fill aesthetic ----
# 3.a) Simple barplot
ggplot(toy_data, aes(x = group, y = count)) +
  geom_col()

# 3.b) colour aesthetic is the outline of bars
ggplot(toy_data, aes(x = group, y = count, colour = group)) +
  geom_col()

# 3.c) The color of bars corresponds to fill aesthetic
ggplot(toy_data, aes(x = group, y = count, fill = group)) +
  geom_col()

# 3.d) Change color palette from default to "Set2": No assumed ordering to group
ggplot(toy_data, aes(x = group, y = count, fill = group)) +
  geom_col() +
  scale_fill_brewer(palette = "Set1")

# 3.e) Change color palette from default to "YlOrBr": Assumed ordering to group
ggplot(toy_data, aes(x = group, y = count, fill = group)) +
  geom_col() +
  scale_fill_brewer(palette = "YlOrBr")

# use manual scale with 5 levels from gka.github.io/palletes
# sequential: c('#00429d', '#4771b2', '#73a2c6', '#a5d5d8', '#ffffe0')

ggplot(toy_data, aes(x = group, y = count, fill = group)) +
  geom_col() +
  scale_fill_manual(values=c('#00429d', '#4771b2', '#73a2c6', '#a5d5d8', '#ffffe0'))

# diverging: c('#00429d', '#73a2c6', '#ffffe0', '#f4777f', '#93003a')
ggplot(toy_data, aes(x = group, y = count, fill = group)) +
  geom_col() +
  scale_fill_manual(values=c('#00429d', '#73a2c6', '#ffffe0', '#f4777f', '#93003a'))

ggplot(toy_data, aes(x = group, y = count, fill = group)) +
  geom_col() +
  scale_fill_brewer(palette = "Reds")


ggplot(toy_data, aes(x = group, y = count, fill = group)) +
  geom_col() +
  scale_fill_brewer(palette = "Pastel1")


ggplot(toy_data, aes(x = group, y = count, fill = group)) +
  geom_col() +
  scale_fill_brewer(palette = "Spectral")


# geom_jitter
origin <- tibble(
  x = rep(0, times = 10),
  y = rep(0, times = 10)
)

#geom_point will only plot one point, as for all points x=0, y=0
ggplot(origin, aes(x=x, y=y))+
  geom_point(size=5, colour="orange")

# geom_jitter will randomly spread the points around (0.0)
# every time you run it, you get a slightly different jitter

ggplot(origin, aes(x=x, y=y))+
#  geom_point(size=5, colour="orange")+
  geom_jitter()

