# ESG Country Analysis - Sustainability Analytics Portfolio

## Overview
This project analyzes country-level ESG (Environmental, Social, Governance) data to answer real-world investment and policy questions. The analysis demonstrates core skills required for ESG Analyst, Sustainability Analyst, and Climate Data Analyst roles by translating complex business questions into technical analysis with actionable insights.

---

## Business Questions

1. **Climate Leaders Screening:** Which developed countries balance high renewable energy with low CO₂ emissions?
2. **ESG Correlation Analysis:** Does strong governance correlate with higher female labor force participation?
3. **Green Transition Opportunities:** Which emerging markets are decarbonizing fastest?
4. **Carbon Risk Assessment:** Which countries face highest exposure to future carbon regulations?
5. **Governance Impact Analysis:** Do governance improvements drive better health and education outcomes?

---

## Analysis Approach

### 1. Climate Leaders Screening
- Filtered developed countries (OECD + high-income nations)
- Analyzed renewable energy percentage vs CO₂ emissions per capita for 2020
- Identified the "sweet spot" quadrant for climate-focused investment

**🖥️ Query**: [1_climate_leaders.sql](/1_climate_leaders.sql)

**📈 Visualization:**
![Climate Leaders Portfolio](/visualizations/1_visualization_1_climate_leaders.png.png)

📊 **Key Findings:**
- Austria leads with 96% renewable energy and only 0.75 tCO₂ per capita
- Iceland and Canada have high renewables (88-92%) but high emissions (13-14 tCO₂) due to heavy industries
- Ireland and Belgium represent the "sweet spot" at 84-82% renewables with 4.6-6.8 tCO₂

💡 **Business Insights:**
- **Investment Priority:** Focus on Austria, Ireland, Belgium for "green growth" exposure in developed markets
- **Further Due Diligence:** Investigate Iceland and Canada's emissions sources - high renewables but high emissions suggests industrial sectors need targeted decarbonization
- **Portfolio Construction:** Include Austria as anchor holding for climate-focused funds

---

### 2. ESG Correlation Analysis
- Analyzed Control of Corruption Index vs Female Labor Force Participation for 2020
- Compared top 5 and bottom 5 governance performers
- Tested hypothesis that stronger governance drives better social outcomes

**🖥️ Query**: [2_governance_social.sql](/2_governance_social.sql)

**📈 Visualization:**
![Governance-Social Correlation](/outputs/visualization_2_governance_social.png)

📊 **Key Findings:**
- **No clear correlation** between governance scores and female workforce participation
- Top governance: El Salvador (2.35) has 85% female participation
- Bottom governance: Guatemala (-2.49) still has 70% female participation
- Cultural and historical context appear more influential than governance scores alone

💡 **Business Insights:**
- **ESG Analysis Complexity:** Simple correlation analysis is insufficient - country-specific context matters
- **Risk Management:** Don't assume strong governance guarantees strong social outcomes
- **Investment Screening:** Social metrics require independent assessment, not just proxy through governance scores

---

### 3. Green Transition Opportunities
- Analyzed CO₂ emissions per capita change from 2000 to 2020
- Focused on major emerging markets (Brazil, China, India, Indonesia, Egypt, Argentina, Colombia)
- Calculated percentage change to identify rapid decarbonizers

**🖥️ Query**: [3_green_transition.sql](/3_green_transition.sql)

**📈 Visualization:**
![Green Transition Slope Chart](/outputs/visualization_3_green_transition.png)

📊 **Key Findings:**
- **Egypt:** -73% CO₂ reduction (8.42 → 2.27 tCO₂/capita)
- **India:** -46% reduction (9.89 → 5.36 tCO₂/capita)
- **China:** -33% reduction (19.93 → 13.31 tCO₂/capita)
- **Red Flags:** Argentina (+1185%), Indonesia (+176%) moving wrong direction

💡 **Business Insights:**
- **Thematic Investment:** Egypt and India represent genuine decarbonization momentum
- **Avoid/Engage:** Argentina and Indonesia need engagement or avoidance until emissions trend reverses
- **Policy Analysis:** Investigate drivers of Egypt's success (renewable investments? energy subsidies?) for potential replication

---

### 4. Carbon Risk Assessment
- Identified countries with high CO₂ emissions + low renewable energy adoption
- Calculated transition risk based on regulatory exposure
- Ranked countries by risk profile for carbon tax sensitivity

**🖥️ Query**: [4_carbon_risk.sql](/4_carbon_risk.sql)

**📈 Visualization:**
![Carbon Risk Heat Map](/outputs/visualization_4_carbon_risk.png)

📊 **Key Findings:**
- **Czech Republic:** Highest risk (19.6 tCO₂/capita, 22% renewable)
- **Bulgaria:** Similar emissions (19.6 tCO₂) but lower risk due to 87% renewable
- **Brazil:** High emissions (19.6 tCO₂) but low risk (98% renewable)
- Risk formula: High CO₂ + Low Renewable = Highest regulatory exposure

💡 **Business Insights:**
- **Risk Management:** Czech Republic faces highest carbon tax exposure - screen out of climate-sensitive portfolios
- **Portfolio Construction:** Brazil can stay in portfolios despite high emissions due to renewable buffer
- **Engagement Opportunity:** Bulgaria offers engagement potential - high renewable mix already in place, emissions reduction needed

---

### 5. Governance Impact Analysis
- Analyzed 20-year changes (2000-2020) in Rule of Law vs:
  - Life expectancy (health outcomes)
  - Primary school enrollment (educational access)
- Segmented countries into 4 strategic quadrants based on performance relative to global averages

**🖥️ Queries**: 
- [5a_life_expectancy_governance.sql](/5a_life_expectancy_governance.sql)
- [5b_education_governance.sql](/5b_education_governance.sql)

**📈 Visualizations:**
![Life Expectancy Matrix](/outputs/visualization_5a_life_strategic_matrix.png)
![Education Matrix](/outputs/visualization_5b_education_strategic_matrix.png)


📊 **Key Findings:**
- **Star Performers** (↑ Governance + ↑ Social): Iran, Finland, Afghanistan
- **Health Champions** (↑ Social only): Cameroon, Azerbaijan, Guatemala
- **Governance Champions** (↑ Governance only): Germany, Brazil, Cuba
- **Needs Attention** (No improvement): Belgium, Italy, Dominican Republic
- **Education Segment:** Colombia (+44% enrollment) and Algeria (+40%) lead while improving governance

💡 **Business Insights:**
- **Impact Investing:** Star Performers offer dual impact - governance and social outcomes improving together
- **Policy Focus:** Health Champions show social progress is possible without governance reform
- **Caution:** Governance Champions need targeted social investments - governance alone doesn't guarantee social outcomes
- **Education Opportunity:** Colombia demonstrates that education gains can accelerate alongside governance improvements

---

## Strategic Recommendations

### 1. Climate & Energy Transition
- **Portfolio Construction:** Anchor climate-focused funds with Austria, Ireland, Belgium
- **Risk Management:** Screen out Czech Republic from carbon-sensitive portfolios; engage with Bulgaria on emissions reduction
- **Thematic Investment:** Target Egypt and India for green transition exposure; avoid Argentina and Indonesia until trends reverse

### 2. ESG Integration
- **Debunked Assumption:** Governance scores alone don't predict social outcomes - require independent social metric assessment
- **Country-Specific Analysis:** Replace simplistic correlation models with context-aware analysis
- **Materiality Focus:** Prioritize metrics relevant to each country's development stage and industry mix

### 3. Impact & Policy Analysis
- **Star Performer Replication:** Study Iran and Finland's governance-social linkages for policy insights
- **Education Investment:** Colombia's 44% enrollment growth shows education can drive broader development
- **Targeted Interventions:** Governance Champions need social investments; Health Champions need governance reform

---

## Technical Details

| Category | Details |
|----------|---------|
| **Database** | PostgreSQL / MySQL |
| **Analysis Tools** | SQL, Python (Pandas, NumPy) |
| **Visualization** | Matplotlib, Seaborn, Plotly |
| **Interactive Dashboard** | Plotly HTML with hover interactions |
| **Version Control** | Git, GitHub |
| **Data Sources** | World Bank, IMF, UN SDG Database |

---

## Repository Structure
