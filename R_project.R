library(tidyverse)
library(dplyr)
library(knitr)
library(dplyr)
library(ggplot2)

#https://www.kaggle.com/datasets/leonardopena/top-spotify-songs-from-20102019-by-year

rm(list = ls())


top10s <- read_csv("top10s.csv")
skimr::skim(top10s)

top10s <- top10s %>% 
  rename(genre = `top genre`)

names(top10s)

top10s %>%
  filter(genre=="pop") %>%
  print(n=Inf)

top10s %>%
  dplyr::count(genre) %>%
  print(n=Inf)

top10s %>%
  dplyr::count(genre) %>%
  dplyr::arrange(desc(n)) %>%
  print(n=Inf)

top10s %>%
  arrange(desc(year)) %>%
  print(n=Inf)

plot(x = top10s$year, y = top10s$bpm, type = "p", main = "Bpm throughout the years", xlab = "Year", ylab = "Bpm")

boxplot(top10s$bpm ~ top10s$year,
        main = "BPM Throughout the Years",
        xlab = "Year", ylab = "BPM")

model <- lm(bpm ~ year, data = top10s)

summary(model)

plot(top10s$year, top10s$bpm,
     main = "BPM Over the Years with Regression Line",
     xlab = "Year", ylab = "BPM", pch = 19, col = "blue")

abline(model, col = "red", lwd = 2)

plot(x = top10s$year, y = top10s$dur, type = "p", main = "Duration over the years", xlab = "Year", ylab = "Duration")

boxplot(top10s$bpm ~ top10s$year,
        main = "BPM Throughout the Years",
        xlab = "Year", ylab = "BPM")

boxplot(top10s$val ~ top10s$year,
        main = "BPM Throughout the Years",
        xlab = "Year", ylab = "BPM")

model <- lm(val ~ year, data = top10s)
summary(model)

plot(top10s$year, top10s$val,
     main = "Valence over the Years",
     xlab = "Year", ylab = "Valence", pch = 19, col = "blue")


abline(model, col = "red", lwd = 2)

model_multi <- lm(val ~ year + nrgy + dnce + acous, data = top10s)
summary(model_multi)

top10s$genre <- as.factor(top10s$genre)
model_genre <- lm(val ~ year + nrgy + dnce + acous + genre, data = top10s)
summary(model_genre)

par(mfrow = c(2, 2))
plot(model_multi)
par(mfrow = c(1, 1))

boxplot(val ~ genre, data = top10s,
        main = "Valence by Genre", xlab = "Genre", ylab = "Valence",
        las = 2, col = "lightblue")

library(ggplot2)

ggplot(top10s, aes(x = reorder(genre, val, FUN = median), y = val)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Valence by Genre (Ordered)",
       x = "Genre", y = "Valence") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

library(dplyr)
library(stringr)

library(dplyr)
library(stringr)

top10s <- top10s %>%
  mutate(
    genre_grouped = case_when(
      str_detect(genre, regex("pop", ignore_case = TRUE)) ~ "Pop",
      str_detect(genre, regex("hip|rap|trap", ignore_case = TRUE)) ~ "Hip-Hop / Rap",
      str_detect(genre, regex("edm|electro|dance|house", ignore_case = TRUE)) ~ "EDM / Dance",
      str_detect(genre, regex("latin|reggaeton", ignore_case = TRUE)) ~ "Latin",
      str_detect(genre, regex("r&b|soul", ignore_case = TRUE)) ~ "R&B / Soul",
      str_detect(genre, regex("rock", ignore_case = TRUE)) ~ "Rock",
      str_detect(genre, regex("boy band|girl group", ignore_case = TRUE)) ~ "Pop Group",
      TRUE ~ "Other"
    )
  )


top10s$genre_grouped <- factor(top10s$genre_grouped)

boxplot(val ~ genre_grouped, data = top10s,
        main = "Valence by Genre Group",
        xlab = "Genre", ylab = "Valence",
        las = 2, col = "lightblue")


library(dplyr)

other_genres <- top10s %>%
  filter(genre_grouped == "Other") %>%
  distinct(genre) %>%
  arrange(genre)

print(other_genres)

