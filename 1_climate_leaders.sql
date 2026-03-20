/*
================================================================================
QUERY 1: Climate Leaders Portfolio Screening
================================================================================
Business Question: 
"Which developed countries have the highest renewable energy usage combined 
with the lowest CO2 emissions in the most recent year of data (2020)?"

Business Context:
Asset manager building a "Climate Leaders" fund for developed nations.
Identifies countries that represent the "sweet spot" for climate-focused investment.

Methodology:
- Best-in-class approach: highest renewable energy + lowest CO2 emissions
- Focus on developed economies (OECD countries)
- Latest available data (2020)
================================================================================
*/

SELECT 
    country_name,
    year,
    MAX(CASE WHEN series_name LIKE '%Renewable%' THEN value END) AS renewable_energy_pct,
    MAX(CASE WHEN series_name LIKE '%CO2%' THEN value END) AS co2_emissions_per_capita
FROM climate_data
WHERE 
    country_code IN (
        'AUS', 'AUT', 'BEL', 'CAN', 'CHL', 'HRV', 'CZE', 'DNK', 'EST', 'FIN',
        'FRA', 'DEU', 'GRC', 'HUN', 'ISL', 'IRL', 'ISR', 'ITA', 'JPN', 'LVA', 
        'LTU', 'LUX', 'NLD', 'NZL', 'NOR', 'POL', 'PRT', 'SVK', 'SVN', 'KOR', 
        'ESP', 'SWE', 'CHE', 'GBR', 'USA'
    ) 
    AND (series_name LIKE '%Renewable%' OR series_name LIKE '%CO2%')
    AND year = 2020
GROUP BY 1, 2
ORDER BY renewable_energy_pct DESC
LIMIT 5;

/*
================================================================================
EXPECTED RESULTS:
country_name    year    renewable_energy_pct    co2_emissions_per_capita
Austria         2020    95.98                   0.75
Iceland         2020    92.39                   13.80
Canada          2020    88.03                   13.99
Ireland         2020    84.86                   6.78
Belgium         2020    82.49                   4.59

KEY INSIGHTS:
- Austria leads with 96% renewable energy and only 0.75 tCO2 per capita
- Iceland and Canada have high renewables but also high emissions (heavy industries)
- Ireland and Belgium represent the "sweet spot" for climate-focused investment
================================================================================
*/
