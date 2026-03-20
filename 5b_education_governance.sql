/*
================================================================================
QUERY 5B: Governance Impact Analysis - Educational Access Outcomes
================================================================================
Business Question:
"Do countries that improved their 'Rule of Law' score the most between 2000 and 2020 
also tend to show above-average improvements in primary school enrollment?"

Business Context:
Tests whether governance improvements drive better educational outcomes.
Complements the life expectancy analysis for comprehensive social impact assessment.

Methodology:
- Analyze 20-year changes in Rule of Law and Primary School Enrollment
- Segment countries into 4 strategic quadrants based on global averages
- Identify Education & Governance Leaders vs other segments
================================================================================
*/

WITH school_enrollment_data AS (
    SELECT 
        country_name,
        year,
        MAX(CASE WHEN series_name LIKE '%Primary%' THEN value END) AS enrollment_value,
        MAX(CASE WHEN series_name LIKE '%Rule%' THEN value END) AS rule_value
    FROM climate_data
    WHERE (series_name LIKE '%Primary%' OR series_name LIKE '%Rule%') 
        AND year IN (2000, 2020)
    GROUP BY country_name, year
),
school_enrollment_segmentation AS (
    SELECT 
        country_name,
        MAX(CASE WHEN year = 2020 THEN enrollment_value END) AS enrollment_2020,
        MAX(CASE WHEN year = 2020 THEN rule_value END) AS rule_2020,
        MAX(CASE WHEN year = 2000 THEN enrollment_value END) AS enrollment_2000,
        MAX(CASE WHEN year = 2000 THEN rule_value END) AS rule_2000
    FROM school_enrollment_data
    GROUP BY country_name
),
avg_difference AS (
    SELECT
        country_name,
        ROUND(enrollment_2020 - enrollment_2000, 2) AS enrollment_change,
        ROUND(rule_2020 - rule_2000, 2) AS rule_change,
        ROUND(((enrollment_2020 - enrollment_2000) / NULLIF(enrollment_2000, 0)) * 100, 2) AS enrollment_percent_change,
        ROUND(((rule_2020 - rule_2000) / NULLIF(rule_2000, 0)) * 100, 2) AS rule_percent_change,
        ROUND(AVG(enrollment_2020 - enrollment_2000) OVER (), 2) AS avg_enrollment_increase,
        ROUND(AVG(rule_2020 - rule_2000) OVER (), 2) AS avg_rule_increase
    FROM school_enrollment_segmentation
    WHERE enrollment_2000 IS NOT NULL AND rule_2000 IS NOT NULL
    GROUP BY 1, enrollment_2020, enrollment_2000, rule_2020, rule_2000
),
strategic_segmentations AS (
    SELECT
        country_name,
        enrollment_change,
        rule_change,
        CASE
            WHEN enrollment_change > avg_enrollment_increase AND rule_change > avg_rule_increase THEN 'Education and Governance Leaders'
            WHEN enrollment_change > avg_enrollment_increase AND rule_change <= avg_rule_increase THEN 'Education Champions'
            WHEN enrollment_change <= avg_enrollment_increase AND rule_change > avg_rule_increase THEN 'Governance Champions'
            WHEN enrollment_change <= avg_enrollment_increase AND rule_change <= avg_rule_increase THEN 'Systemic Challenges'
        END AS strategic_segment
    FROM avg_difference
),
segmentation_rankings AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY strategic_segment ORDER BY enrollment_change DESC) AS rn
    FROM strategic_segmentations
)
SELECT
    country_name,
    enrollment_change,
    rule_change,
    strategic_segment
FROM segmentation_rankings
WHERE rn <= 3  -- Top 3 from each segment
ORDER BY strategic_segment, enrollment_change DESC;

/*
================================================================================
EXPECTED RESULTS:
country_name        enrollment_change   rule_change     strategic_segment
Colombia            44.04               2.54            Education and Governance Leaders
Algeria             39.95               1.49            Education and Governance Leaders
Bhutan              26.86               -0.29           Education and Governance Leaders
Honduras            41.87               -0.42           Education Champions
Italy               34.22               -1.51           Education Champions
France              30.62               -4.00           Education Champions
Iraq                2.70                1.93            Governance Champions
Bangladesh          -0.38               -0.17           Governance Champions
Finland             -2.24               3.20            Governance Champions
Armenia             2.63                -1.61           Systemic Challenges
Bulgaria            2.15                -2.16           Systemic Challenges
Chile               -0.20               -1.17           Systemic Challenges

KEY INSIGHTS:
- Education & Governance Leaders: Colombia (+44% enrollment, +2.54 rule of law)
- Education Champions: Honduras (+42% enrollment) - progress despite weak governance
- Governance Champions: Iraq (+1.93 rule of law) - governance improving, education stagnant
- Systemic Challenges: Armenia, Bulgaria, Chile - both education and governance lagging
================================================================================
*/
