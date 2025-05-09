# World-Happiness-Report_SQL-Project

This project analyzes changes in country happiness scores using SQL, based on the World Happiness Report 2024 data.

##  Tools Used
- MySQL
- World Happiness Report (2024 original & updated datasets)

##  Techniques Used
- SQL (MySQL)
- CTEs
- Window Functions 
- Multi-source JOINs & yearly comparison logic

## Key Insights

### Improvements & Declines

- **Afghanistan**, **Venezuela**, and **Brazil** showed some of the largest increases in their happiness scores across specific years.
- Several countries, despite improved **GDP per capita**, experienced **declines in happiness**, indicating a decoupling between economic and emotional well-being.
- The **top 10 most improved** countries were identified using window functions and year-by-year comparisons.

### Dual Changes

- A distinct group of countries showed **positive changes in both GDP and happiness**, making them strong examples of balanced development.
- Conversely, some nations saw gains in happiness **despite decreasing freedom scores**, suggesting the influence of other social support structures.

### Stability

- Countries with **minimal changes year-over-year** were highlighted as socially and economically **stable**, potentially ideal for long-term policy modeling.

## Dataset Source

- [World Happiness Report 2024 - Kaggle (original version)](https://www.kaggle.com/datasets/sazidthe1/world-happiness-report-2024)



