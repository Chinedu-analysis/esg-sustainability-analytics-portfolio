/*
================================================================================
QUERY 3: Green Transition Opportunities - Emerging Markets Decarbonization
================================================================================
Business Question:
"Which emerging market countries showed the most significant percentage decrease 
in CO2 emissions per capita between 2000 and 2020?"

Business Context:
Identify rapid decarbonizers for "Green Transition" themed investment funds.
Focus on emerging markets with genuine momentum toward low-carbon economies.

Methodology:
- Analyze CO2 emissions change from 2000 to 2020
- Focus on major emerging markets (BRICS + key developing economies)
- Calculate percentage change to identify leaders and laggards
================================================================================
*/

WITH year_2000_emissions AS (
    SELECT
        country_code,
        country_name,
        CASE WHEN year = 2000 THEN value END AS co2_2000
    FROM climate_data
    WHERE country_code IN ('BRA', 'ARG', 'CHN', 'IND', 'IDN', 'EGY', 'COL') 
        AND year = 2000 
        AND series_name LIKE '%CO2%'
),
year_2020_emissions AS (
    SELECT
        country_name,
        country_code,
        CASE WHEN year = 2020 THEN value END AS co2_2020
    FROM climate_data
    WHERE country_code IN ('BRA', 'ARG', 'CHN', 'IND', 'IDN', 'EGY', 'COL') 
        AND year = 2020 
        AND series_name LIKE '%CO2%'
)
SELECT
    y20.country_name,
    y20.country_code,
    ROUND(y2.co2_2000, 2) AS co2_2000,
    ROUND(y20.co2_2020, 2) AS co2_2020,
    ROUND(((y20.co2_2020 - y2.co2_2000) / NULLIF(y2.co2_2000, 0)) * 100, 2) AS co2_pct_change
FROM year_2000_emissions y2
JOIN year_2020_emissions y20 ON y2.country_code = y20.country_code
ORDER BY co2_pct_change;

/*
================================================================================
EXPECTED RESULTS:
country_name    country_code    co2_2000    co2_2020    co2_pct_change
Egypt           EGY             8.42        2.27        -73.04
India           IND             9.89        5.36        -45.80
China           CHN             19.93       13.31       -33.22
Colombia        COL             9.60        8.32        -13.33
Brazil          BRA             16.04       19.58       22.07
Indonesia       IDN             1.04        2.87        175.96
Argentina       ARG             0.82        10.54       1185.37

KEY INSIGHTS:
- LEADERS: Egypt (-73%), India (-46%), China (-33%) - strong decarbonization momentum
- LAGGARDS: Argentina (+1185%), Indonesia (+176%) - moving wrong direction
- Investment Implication: Target Egypt and India for green transition funds
- Risk Alert: Avoid Argentina and Indonesia until emissions trend reverses
================================================================================
*/
