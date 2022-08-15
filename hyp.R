library(tidyverse)
library(tsibble)
library(fable)
library(ggplot2)
library(GGally)
library(lubridate)
library(fpp3)
library(slider)
library(reshape2)

Hypoteky <- read_csv("hypo_pocty.csv")

Hypoteky$Obdobi <- 
  parse_date(Hypoteky$Obdobi, format = "%d.%m.%Y")

Hypoteky <- 
  select(Hypoteky, "Obdobi":"BytJinak")

Hypoteky <-
  Hypoteky %>% 
  mutate(
    "PodilNakup" = BytNakup/Byt,
    "PodilStavba" = BytStavba/Byt,
    "PodilJine" = 1-PodilNakup-PodilStavba,
    "Proporce" = BytStavba/BytNakup
  )

Hypoteky_ts <- as_tsibble(Hypoteky)

hypo_long <- melt(Hypoteky_ts,
                  id.vars=c("Obdobi"),
                  measure.vars=c("PodilJine", "PodilNakup", "PodilStavba"))

ggplot(hypo_long, aes(x=Obdobi, y=value, fill=variable)) +
     geom_bar(position="stack", stat="identity")
