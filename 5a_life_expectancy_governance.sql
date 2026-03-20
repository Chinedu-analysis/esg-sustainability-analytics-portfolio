/*
================================================================================
QUERY 5A: Governance Impact Analysis - Life Expectancy Outcomes
================================================================================
Business Question:
"Do countries that improved their 'Rule of Law' score the most between 2000 and 2020 
also tend to show above-average improvements in life expectancy?"

Business Context:
Tests whether governance improvements drive better health outcomes.
Important for impact investing and development policy analysis.

Methodology:
- Analyze 20-year changes in Rule of Law and Life Expectancy
- Segment countries into 4 strategic quadrants based on global averages
- Identify Star Performers (improved both) vs other segments
================================================================================
*/

WITH life_expectancy_data AS (
    SELECT 
        country_name,
        year,
        MAX(CASE WHEN series_name LIKE '%Life%' THEN value END) AS life_value,
        MAX(CASE WHEN series_name LIKE '%Rule%' THEN value END) AS rule_value
    FROM climate_data
    WHERE (series_name LIKE '%Life%' OR series_name LIKE '%Rule%') 
        AND year IN (2000, 2020)
    GROUP BY country_name, year
),
life_expectancy_segmentation AS (
    SELECT 
        country_name,
        MAX(CASE WHEN year = 2020 THEN life_value END) AS life_2020,
        MAX(CASE WHEN year = 2020 THEN rule_value END) AS rule_2020,
        MAX(CASE WHEN year = 2000 THEN life_value END) AS life_2000,
        MAX(CASE WHEN year = 2000 THEN rule_value END) AS rule_2000
    FROM life_expectancy_data
    GROUP BY country_name
),
avg_difference AS (
    SELECT
        country_name,
        ROUND(life_2020 - life_2000, 2) AS life_change,
        ROUND(rule_2020 - rule_2000, 2) AS rule_change,
        ROUND(((life_2020 - life_2000) / NULLIF(life_2000, 0)) * 100, 2) AS life_percent_change,
        ROUND(((rule_2020 - rule_2000) / NULLIF(rule_2000, 0)) * 100, 2) AS rule_percent_change,
        ROUND(AVG(life_2020 - life_2000) OVER (), 2) AS avg_life_increase,
        ROUND(AVG(rule_2020 - rule_2000) OVER (), 2) AS avg_rule_increase
    FROM life_expectancy_segmentation
    WHERE life_2000 IS NOT NULL AND rule_2000 IS NOT NULL
    GROUP BY 1, life_2020, life_2000, rule_2020, rule_2000
),
strategic_segmentations AS (
    SELECT
        country_name,
        life_change,
        rule_change,
        CASE
            WHEN life_change > avg_life_increase AND rule_change > avg_rule_increase THEN 'Star Performers'
            WHEN life_change > avg_life_increase AND rule_change <= avg_rule_increase THEN 'Health Leaders'
            WHEN life_change <= avg_life_increase AND rule_change > avg_rule_increase THEN 'Governance Leaders'
            WHEN life_change <= avg_life_increase AND rule_change <= avg_rule_increase THEN 'Needs Attention'
        END AS strategic_segment
    FROM avg_difference
),
segmentation_rankings AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY strategic_segment ORDER BY life_change DESC) AS rn
    FROM strategic_segmentations
)
SELECT
    country_name,
    life_change,
    rule_change,
    strategic_segment
FROM segmentation_rankings
WHERE rn <= 3  -- Top 3 from each segment
ORDER BY strategic_segment, life_change DESC;

/*
================================================================================
EXPECTED RESULTS:
country_name        life_change     rule_change     strategic_segment
Iran                40.55           0.63            Star Performers
Finland             37.83           3.20            Star Performers
Afghanistan         27.36           0.11            Star Performers
Cameroon            31.75           -2.79           Health Leaders
Azerbaijan          28.70           -2.48           Health Leaders
Guatemala           27.59           -2.35           Health Leaders
Germany             0.47            1.32            Governance Leaders
Brazil              -2.22           1.70            Governance Leaders
Cuba                -2.74           0.23            Governance Leaders
Belgium             1.69            -2.13           Needs Attention
Italy               -0.45           -1.51           Needs Attention
Dominican Republic  -1.03           -1.63           Needs Attention

KEY INSIGHTS:
- Star Performers (25%): Improved both governance and life expectancy
- Health Leaders (25%): Life expectancy improved despite weak governance
- Governance Leaders (25%): Governance improved, life expectancy stagnant
- Needs Attention (25%): Neither improved
================================================================================
*/
