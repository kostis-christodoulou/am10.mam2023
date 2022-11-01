# you  have to install an older version 1.3.8 of Rttf2pt1 as follows
# remotes::install_version("Rttf2pt1", version = "1.3.8")

# https://github.com/wch/extrafont
library(Rttf2pt1)
library(extrafont)



library(tidyverse)
library(patchwork)

# import fonts - only once-- will look at system font folder
font_import()


# to get fonts from goole, go to https://fonts.google.com/ 
#if you use FontBase to get all Google fonts
font_import(paths="C:/Users/kchristodoulou/FontBase")

# Alternatively, you can download all of google fonts, by downloading and extracting 
# https://github.com/google/fonts/archive/master.zip (over 300 Mb) from https://github.com/google/fonts

#if you have a mac, use 
extrafont::loadfonts(device="pdf")

#if you have a windows machine, use
extrafont::loadfonts(device="win")


# Vector of font family names
fonts()

plot <- 
ggplot(mtcars, aes(x=wt, y=mpg)) + 
  geom_point() +
  labs(
    title = "Fuel Efficiency of 32 Cars",
    x= "Weight (x1000 lb)",
    y = "Miles per Gallon"
  )+
  theme_minimal()+
  NULL

p1 <- plot + theme(text=element_text(size=16, family="Montserrat"))
p2 <- plot + theme(text=element_text(size=16, family="Bahnschrift"))
p3 <- plot + theme(text=element_text(size=16, family="Oswald"))
p4 <- plot + theme(text=element_text(size=16, family="Rock Salt"))


# Use patchwork to arrange  4 graphs on same page
(p1 + p2) / (p3 + p4)


plot + theme(text=element_text(size=16, family="Montserrat"))


