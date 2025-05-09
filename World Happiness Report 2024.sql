WITH original AS (
    SELECT country_name, ladder_score, log_gdp_per_capita, freedom_to_make_life_choices, perceptions_of_corruption
    FROM happiness2024
),
updated AS (
    SELECT `Country name` AS country_name, `Life Ladder` AS ladder_score, `Log GDP per capita` AS log_gdp_per_capita, 
           `Freedom to make life choices` AS freedom_to_make_life_choices, `Perceptions of corruption` AS perceptions_of_corruption,
           year
    FROM happiness
),
comparison AS (
    SELECT 
        o.country_name,
                u.year,
        o.ladder_score AS old_ladder,
        u.ladder_score AS new_ladder,
        (u.ladder_score - o.ladder_score) AS ladder_change,
        o.log_gdp_per_capita AS old_gdp,
        u.log_gdp_per_capita AS new_gdp,
        (u.log_gdp_per_capita - o.log_gdp_per_capita) AS gdp_change,
        o.freedom_to_make_life_choices AS old_freedom,
        u.freedom_to_make_life_choices AS new_freedom,
        (u.freedom_to_make_life_choices - o.freedom_to_make_life_choices) AS freedom_change,
        o.perceptions_of_corruption AS old_corruption,
        u.perceptions_of_corruption AS new_corruption,
        (u.perceptions_of_corruption - o.perceptions_of_corruption) AS corruption_change
    FROM original o
    JOIN updated u ON o.country_name = u.country_name
),
ranked_improvements AS (
    SELECT country_name, year, ladder_change,
           RANK() OVER (ORDER BY ladder_change DESC) AS improvement_rank
    FROM comparison
    WHERE ladder_change IS NOT NULL
),
ranked_declines AS (
    SELECT country_name, year, ladder_change,
           RANK() OVER (ORDER BY ladder_change ASC) AS decline_rank
    FROM comparison
    WHERE ladder_change IS NOT NULL
),
regional_change AS (
    SELECT 
        c.country_name, c.year,
        AVG(c.ladder_change) OVER (PARTITION BY c.country_name) AS avg_ladder_change
    FROM comparison c
),
dual_change AS (
    SELECT country_name, year, ladder_change, gdp_change
    FROM comparison
    WHERE ladder_change > 0 AND gdp_change > 0
),
freedom_down_ladder_up AS (
    SELECT country_name, year, ladder_change, freedom_change
    FROM comparison
    WHERE ladder_change > 0 AND freedom_change < 0
),

stability AS (
    SELECT country_name, year, ABS(ladder_change) AS abs_ladder_change
    FROM comparison
),
full_rank AS (
    SELECT country_name, year, ladder_change,
           RANK() OVER (ORDER BY ladder_change DESC) AS ladder_rank
    FROM comparison
)

-- Complete ranking of all countries
-- SELECT * FROM full_rank ORDER BY ladder_rank;

-- Top 10 Improvements
-- SELECT * FROM ranked_improvements ORDER BY improvement_rank LIMIT 10;

-- Top 10 Declines
-- SELECT * FROM ranked_declines ORDER BY decline_rank LIMIT 10;

-- The most stable countries
-- SELECT * FROM stability ORDER BY abs_ladder_change ASC LIMIT 10;

-- Countries with positive change in both Ladder & GDP
-- SELECT * FROM dual_change ORDER BY ladder_change DESC;

-- Countries that rose in Ladder but fell in Freedom
-- SELECT * FROM freedom_down_ladder_up ORDER BY ladder_change DESC;

-- Region with the greatest increase
-- SELECT * FROM regional_change ORDER BY avg_ladder_change DESC;