# Top10s_Spotify
#R analysis of Top10s Spotify dataset

https://www.kaggle.com/datasets/leonardopena/top-spotify-songs-from-20102019-by-year

#Results
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
