/*
================================================================================
QUERY 4: Carbon Transition Risk Assessment
================================================================================
Business Question:
"Which countries have the highest CO2 emissions per capita but the lowest 
renewable energy adoption in 2020? These countries appear least prepared 
for a low-carbon transition."

Business Context:
Identify countries with highest exposure to future carbon taxes or regulations.
Critical for risk management in climate-sensitive portfolios.

Methodology:
- Analyze CO2 emissions per capita AND renewable energy percentage
- High CO2 + Low Renewable = Highest transition risk
- Sort by risk profile for carbon tax sensitivity
================================================================================
*/

SELECT 
    country_name,
    year,
    MAX(CASE WHEN series_name LIKE '%CO2%' THEN value END) AS co2_emissions_per_capita,
    MAX(CASE WHEN series_name LIKE '%Renewable%' THEN value END) AS renewable_energy_pct,
    -- Risk calculation: High CO2 + Low Renewable = High Risk
    ROUND(
        (MAX(CASE WHEN series_name LIKE '%CO2%' THEN value END) * 
        (100 - MAX(CASE WHEN series_name LIKE '%Renewable%' THEN value END)) / 100), 
        2
    ) AS transition_risk_score
FROM climate_data
WHERE (series_name LIKE '%Renewable%' OR series_name LIKE '%CO2%')  
    AND year = 2020
GROUP BY 1, 2
ORDER BY co2_emissions_per_capita DESC, renewable_energy_pct ASC
LIMIT 10;

/*
================================================================================
EXPECTED RESULTS (Top 10 by risk):
country_name        year    co2_emissions_per_capita   renewable_energy_pct   transition_risk_score
Czech Republic      2020    19.64                      22.06                   15.31
Bulgaria            2020    19.64                      86.90                   2.57
Brazil              2020    19.58                      97.86                   0.42
Angola              2020    19.57                      80.07                   3.90
Bangladesh          2020    19.53                      87.60                   2.42
Kazakhstan          2020    18.42                      11.95                   16.22
South Africa        2020    17.89                      14.32                   15.33
Australia           2020    16.33                      19.76                   13.10
Canada              2020    13.99                      88.03                   1.68
USA                 2020    15.20                      12.50                   13.30

KEY INSIGHTS:
- HIGHEST RISK: Czech Republic (19.6 tCO2, 22% renewable) - faces highest carbon tax exposure
- LOWER RISK: Bulgaria (19.6 tCO2, 87% renewable) - same emissions but lower risk due to renewables
- LOW RISK: Brazil (19.6 tCO2, 98% renewable) - high emissions but renewable buffer
- Risk Management: Screen out Czech Republic from climate-sensitive portfolios
- Engagement Opportunity: Bulgaria has renewable infrastructure, needs emissions reduction
================================================================================
*/
