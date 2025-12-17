# Top10s_Spotify
R analysis of Top10s Spotify dataset

https://www.kaggle.com/datasets/leonardopena/top-spotify-songs-from-20102019-by-year


library(tidyverse)
library(dplyr)
library(knitr)
library(ggplot2)
library(stringr)

# Clear the environment
rm(list = ls())

# Load dataset
top10s <- read_csv("top10s.csv")
Here I loaded all necessary libraries, including tidyverse which covers most of the work), and cleared the environment. Then I loaded the dataset with Spotify’s top tracks from 2010 to 2019.
skimr::skim(top10s)

top10s <- top10s %>% 
  rename(genre = `top genre`)

names(top10s)
I used skim() to check the structure and summary of the dataset. I also renamed the top genre column to just genre to make the code easier to work with.
top10s %>%
  filter(genre == "pop") %>%
  print(n = Inf)

top10s %>%
  count(genre) %>%
  print(n = Inf)

top10s %>%
  count(genre) %>%
  arrange(desc(n)) %>%
  print(n = Inf)
I looked at all songs classified as "pop" and then counted the number of songs in each genre to see which genres appeared most often in the top charts.

plot(x = top10s$year, y = top10s$bpm, type = "p",
     main = "Bpm throughout the years", xlab = "Year", ylab = "Bpm")

boxplot(top10s$bpm ~ top10s$year,
        main = "BPM Throughout the Years",
        xlab = "Year", ylab = "BPM")

model <- lm(bpm ~ year, data = top10s)

summary(model)

plot(top10s$year, top10s$bpm,
     main = "BPM Over the Years with Regression Line",
     xlab = "Year", ylab = "BPM", pch = 19, col = "blue")

abline(model, col = "red", lwd = 2)

 
Here I explored whether tempo (BPM) has changed over the years. I used a scatter plot, a boxplot, and fitted a linear regression model. The regression line shows a very slight downward trend that is statistically significant, but the effect size is very small, meaning the change in BPM over time is minimal and likely not practically meaningful.
plot(x = top10s$year, y = top10s$dur, type = "p",
     main = "Duration over the years", xlab = "Year", ylab = "Duration")

I also checked for any trend in song duration by plotting it, but no clear pattern or meaningful relationship was found.
boxplot(top10s$val ~ top10s$year,
        main = "Valence Throughout the Years",
        xlab = "Year", ylab = "Valence")

model <- lm(val ~ year, data = top10s)
summary(model)

plot(top10s$year, top10s$val,
     main = "Valence over the Years",
     xlab = "Year", ylab = "Valence", pch = 19, col = "blue")

abline(model, col = "red", lwd = 2)

This section checks how the mood of songs (valence = happy/sad scale) changed over time. The regression model showed a small but significant decrease in valence, meaning songs may be getting a bit sadder.

model_multi <- lm(val ~ year + nrgy + dnce + acous, data = top10s)
summary(model_multi)

I built a multiple regression model to predict valence using year, energy, danceability, and acousticness. The results show that more energetic and danceable songs are happier, while acoustic songs are generally sadder.

top10s$genre <- as.factor(top10s$genre)

model_genre <- lm(val ~ year + nrgy + dnce + acous + genre, data = top10s)
summary(model_genre)

Then I added genre as a categorical variable to the model. This improved the model slightly and confirmed that genre does matter when predicting a song's mood.

boxplot(val ~ genre, data = top10s,
        main = "Valence by Genre", xlab = "Genre", ylab = "Valence",
        las = 2, col = "lightblue")

This boxplot shows how valence (mood) varies by genre. Some genres like "pop" tend to be happier, while others like "hip hop" or "EDM" can be more varied or lower in valence.




ggplot(top10s, aes(x = reorder(genre, val, FUN = median), y = val)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Valence by Genre (Ordered)",
       x = "Genre", y = "Valence") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

I repeated the boxplot using ggplot2 and sorted genres by their median valence. This gives a clearer picture of which genres are generally happier or sadder.

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

I grouped the long list of genres into broader categories like "Pop", "Hip-Hop/Rap", "Latin", etc., so I could analyse genre trends in a more readable way.













boxplot(val ~ genre_grouped, data = top10s,
        main = "Valence by Genre Group",
        xlab = "Genre", ylab = "Valence",
        las = 2, col = "lightblue")

 
This plot shows the mood differences across the grouped genres. It's easier to see that Pop genres are generally more positive, while EDM or Hip-Hop often have lower valence.
Results
This project explores how musical characteristics of top Spotify songs have evolved between 2010 and 2019. The dataset includes the top trending songs for each year, along with features such as tempo (BPM), mood (valence), danceability, energy, acousticness, and genre. 
Research Questions and Hypotheses
1. Has the average tempo (BPM) of top songs changed over time?
●	H₀ (null hypotheses): There is no relationship between year and BPM.

●	H₁ (alternative): BPM has changed over time.

2. Are top-charting songs becoming less emotionally positive (valence) over time?
●	H₀: There is no relationship between year and valence.

●	H₁: Valence is decreasing over time.

3. Which audio features predict a song’s emotional tone (valence)?
●	H₀: Valence is not significantly affected by year, energy, danceability, acousticness, or genre.

●	H₁: These variables significantly predict valence.

Descriptive Statistics
The dataset contains 603 observations, one for each song, and variables like:
●	bpm (tempo),

●	val (valence, 0 = sad, 100 = happy),

●	nrgy (energy),

●	dnce (danceability),

●	acous (acousticness),

●	dur (duration),

●	genre (categorical),

●	year (2010–2019).

Summary of Hypothesis Testing and Regression Results
1. Tempo (BPM) Over Time
A simple linear regression was performed with bpm as the dependent variable and year as the predictor. The results showed a statistically significant negative relationship:
●	Coefficient (year): -0.9915

●	p-value: 0.0104

●	R²: 0.0109

Conclusion: Although the R-squared value indicates a weak effect size, the result is statistically significant (p < 0.05), suggesting that the average tempo of top songs has slightly decreased over the decade.
2. Valence Over Time
A separate linear regression was performed with val as the dependent variable and year as the predictor. This model also produced a significant result:
●	Coefficient (year): -1.0537

●	p-value: 0.0027

●	R²: 0.0149

Conclusion: Valence has significantly decreased over time, indicating that top-charting songs have become less emotionally positive from 2010 to 2019.
3. Multiple Regression: Valence
A multiple linear regression model was constructed to check how well a combination of audio features predicts valence.
Predictor	Coefficient	p-value
Year	-0.750	0.0098
Energy (nrgy)	0.484	< 2e-16
Danceability	0.785	< 2e-16
Acousticness	0.075	0.0838
●	Adjusted R²: 0.3669

●	F-statistic: 88.23 on 4 and 598 degrees of freedom

●	Model p-value: < 2.2e-16

Conclusion:
 All predictors except acousticness were statistically significant. Valence is positively associated with energy and danceability, and negatively associated with year. Acousticness showed a weak positive association but was not statistically significant at the 5% level. This confirms that top songs are becoming less positive over time, and that more energetic, danceable tracks tend to have higher valence.

4. Extended Model with Genre as a Categorical Variable
Adding genre as a factor variable improved the model and showed that genre is a significant predictor of valence. Several genre categories were statistically significant, and the overall model fit improved.
Model summary:
●	Adjusted R²: 0.4119 (an improvement from 0.3669 in the model without genre)

●	F-statistic: 8.957 on 53 and 549 degrees of freedom

●	Overall model p-value: < 2.2e-16 (highly significant)

●	Residual standard error: 17.26

Interpretation:
●	The inclusion of genre significantly improved the model’s explanatory power, accounting for about 41% of variance in valence.

●	Several genre categories were statistically significant predictors of valence (e.g., art pop, australian hip hop, chicago rap, hip hop, hip pop, tropical house), indicating that emotional tone varies substantially across musical genres.

●	Year, energy, and danceability remained significant predictors.

●	Acousticness was not significant in this extended model.
Conclusion: Genre significantly influences the emotional tone of songs, supporting the idea that different styles of music tend to convey distinct moods.
Final Conclusions
●	Tempo (BPM) showed a small but statistically significant decrease over time, though the effect was very weak and explained little variance.

●	Valence (emotional positivity) significantly decreased over the decade, indicating that top songs have become less positive or happy-sounding.

●	Energy and danceability were strong positive predictors of valence, while acousticness had a weaker and non-significant effect when considered alongside other factors.

●	Year remained a significant negative predictor of valence, confirming the downward trend even after accounting for audio features.

●	Including genre as a categorical variable significantly improved the model’s explanatory power, highlighting that genre strongly influences the emotional tone of music. Some genres tend to have higher valence, while others are associated with lower valence.

●	Overall, the regression models demonstrated good fit, with key predictors being statistically significant and meaningful in explaining trends in popular music from 2010 to 2019.
