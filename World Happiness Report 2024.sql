WITH original AS (
    SELECT 
        country_name, 
        ladder_score, 
        log_gdp_per_capita, 
        freedom_to_make_life_choices, 
        perceptions_of_corruption
    FROM happiness2024
),
updated AS (
    SELECT 
        `Country name` AS country_name, 
        `Life Ladder` AS ladder_score, 
        `Log GDP per capita` AS log_gdp_per_capita, 
        `Freedom to make life choices` AS freedom_to_make_life_choices, 
        `Perceptions of corruption` AS perceptions_of_corruption,
        year
    FROM happiness
)

-- Base comparison query
SELECT 
    o.country_name,
    u.year,
    u.ladder_score AS old_ladder,
    o.ladder_score AS ladder_2024,
    (o.ladder_score - u.ladder_score) AS ladder_change,
    u.log_gdp_per_capita AS old_gdp,
    o.log_gdp_per_capita AS new_gdp,
    (o.log_gdp_per_capita - u.log_gdp_per_capita) AS gdp_change,
    u.freedom_to_make_life_choices AS old_freedom,
    o.freedom_to_make_life_choices AS new_freedom,
    (o.freedom_to_make_life_choices - u.freedom_to_make_life_choices) AS freedom_change,
    u.perceptions_of_corruption AS old_corruption,
    o.perceptions_of_corruption AS new_corruption,
    (o.perceptions_of_corruption - u.perceptions_of_corruption) AS corruption_change
FROM original o
JOIN updated u ON o.country_name = u.country_name;

-- Top 10 Improvements
SELECT country_name, year, ladder_change,
       RANK() OVER (ORDER BY ladder_change DESC) AS improvement_rank
FROM (
    SELECT 
        o.country_name, u.year,
        (o.ladder_score - u.ladder_score) AS ladder_change
    FROM original o
    JOIN updated u ON o.country_name = u.country_name
) sub
WHERE ladder_change IS NOT NULL
ORDER BY improvement_rank
LIMIT 10;

-- Top 10 Declines
SELECT country_name, year, ladder_change,
       RANK() OVER (ORDER BY ladder_change ASC) AS decline_rank
FROM (
    SELECT 
        o.country_name, u.year,
        (o.ladder_score - u.ladder_score) AS ladder_change
    FROM original o
    JOIN updated u ON o.country_name = u.country_name
) sub
WHERE ladder_change IS NOT NULL
ORDER BY decline_rank
LIMIT 10;

-- The most stable countries
SELECT country_name, year, ABS(ladder_change) AS abs_ladder_change
FROM (
    SELECT 
        o.country_name, u.year,
        (o.ladder_score - u.ladder_score) AS ladder_change
    FROM original o
    JOIN updated u ON o.country_name = u.country_name
) sub
ORDER BY abs_ladder_change ASC
LIMIT 10;

-- Countries with positive change in both Ladder & GDP
SELECT country_name, year, ladder_change, gdp_change
FROM (
    SELECT 
        o.country_name, u.year,
        (o.ladder_score - u.ladder_score) AS ladder_change,
        (o.log_gdp_per_capita - u.log_gdp_per_capita) AS gdp_change
    FROM original o
    JOIN updated u ON o.country_name = u.country_name
) sub
WHERE ladder_change > 0 AND gdp_change > 0
ORDER BY ladder_change DESC;

-- Countries that rose in Ladder but fell in Freedom
SELECT country_name, year, ladder_change, freedom_change
FROM (
    SELECT 
        o.country_name, u.year,
        (o.ladder_score - u.ladder_score) AS ladder_change,
        (o.freedom_to_make_life_choices - u.freedom_to_make_life_choices) AS freedom_change
    FROM original o
    JOIN updated u ON o.country_name = u.country_name
) sub
WHERE ladder_change > 0 AND freedom_change < 0
ORDER BY ladder_change DESC;

-- Complete ranking of all countries
SELECT country_name, year, ladder_change,
       RANK() OVER (ORDER BY ladder_change DESC) AS ladder_rank
FROM (
    SELECT 
        o.country_name, u.year,
        (o.ladder_score - u.ladder_score) AS ladder_change
    FROM original o
    JOIN updated u ON o.country_name = u.country_name
) sub
ORDER BY ladder_rank;
