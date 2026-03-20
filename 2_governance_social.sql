/*
================================================================================
QUERY 2: Governance-Social Correlation Analysis
================================================================================
Business Question:
"Is there a measurable correlation between a country's Governance scores 
('Control of Corruption') and its Social scores ('Female Labor Force Participation')?"

Business Context:
Tests the hypothesis that countries with stronger governance tend to have 
higher female workforce participation. Important for ESG integration strategies.

Methodology:
- Compare top 5 and bottom 5 governance performers
- Analyze Control of Corruption Index vs Female Labor Force Participation
- Latest available data (2020)
================================================================================
*/

-- TOP 5: Highest Governance Scores
SELECT 
    country_name,
    MAX(CASE WHEN series_name LIKE '%Control%' THEN value END) AS control_of_corruption_index,
    MAX(CASE WHEN series_name LIKE '%Female%' THEN value END) AS female_labor_force_pct
FROM climate_data
WHERE (series_name LIKE '%Control%' OR series_name LIKE '%Female%') 
    AND year = 2020
GROUP BY 1
ORDER BY control_of_corruption_index DESC
LIMIT 5;

/*
================================================================================
TOP 5 RESULTS:
country_name        control_of_corruption_index    female_labor_force_pct
El Salvador         2.35                            85.35
Greece              2.34                            46.91
Cuba                1.95                            48.77
Italy               1.88                            37.81
Israel              1.80                            55.59
================================================================================
*/

-- BOTTOM 5: Lowest Governance Scores
SELECT 
    country_name,
    MAX(CASE WHEN series_name LIKE '%Control%' THEN value END) AS control_of_corruption_index,
    MAX(CASE WHEN series_name LIKE '%Female%' THEN value END) AS female_labor_force_pct
FROM climate_data
WHERE (series_name LIKE '%Control%' OR series_name LIKE '%Female%') 
    AND year = 2020
GROUP BY 1
ORDER BY control_of_corruption_index
LIMIT 5;

/*
================================================================================
BOTTOM 5 RESULTS:
country_name        control_of_corruption_index    female_labor_force_pct
Guatemala           -2.49                           70.00
Ghana               -2.47                           48.37
Chile               -2.40                           98.66
China               -2.30                           96.81
Afghanistan         -2.27                           60.29

KEY INSIGHTS:
- No clear correlation between governance scores and female labor force participation
- Top governance: El Salvador (2.35) has 85% female participation
- Bottom governance: Guatemala (-2.49) still has 70% female participation
- Cultural and historical context matter more than governance scores alone
================================================================================
*/
