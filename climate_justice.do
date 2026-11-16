* =============================================================================
*  Climate Justice Between Countries: Responsibility, Vulnerability, and Growth
*
*  Master 1 thesis - Hawa KEBE
*  M1 International Economics Studies, Universite Paris-Est Creteil (UPEC)
*  Supervised by Patrick LENAIN. May 2025.
*
*  Data:    Dataset.xlsx (cross-section of 214 countries, 2022; sources in
*           the README and in the variable dictionary)
*  Outputs: output/  (log file, figures .png, tables .doc)
*
*  Structure:
*    0. Setup
*    1. Labels
*    2. Complementary variables
*    3. Pre-estimation statistics
*    4. Visualization                 (Figures 1-5)
*    5. Results: correlation matrix   (Table 1)
*               Model 1, responsibility and Model 2, vulnerability (Table 2)
* =============================================================================

* -----------------------------------------------------------------------------
*	Setup
* -----------------------------------------------------------------------------
version 14
clear all
set more off
capture log close

cd "/Users/hawakebe/Library/Mobile Documents/com~apple~CloudDocs/M1 International Economics Studies/Cours/S2 M1IES/Master 1 Thesis/Master 1 Thesis — Hawa KEBE"

capture mkdir "output"
log using "output/climate_justice.log", replace text

import excel "/Users/hawakebe/Library/Mobile Documents/com~apple~CloudDocs/M1 International Economics Studies/Cours/S2 M1IES/Master 1 Thesis/Master 1 Thesis — Hawa KEBE/Dataset.xlsx", sheet("Dataset") firstrow

* -----------------------------------------------------------------------------
*	Data Inspection & Labeling
* -----------------------------------------------------------------------------

* br

label variable gdp_pc_ppp "GDP per capita, PPP (current US$)"

label variable income_group "World Bank Income Group"

	label define income_group_labels 1 "LIC" 2 "LMIC" 3 "UMIC" 4 "HIC"

	label values income_group income_group_labels

label variable industrialization_stage "UNIDO Industrial Development Stage"

	label define industrialization_stage_labels	1 "Low-Income" 2 "Middle-Income Industrializing" 3 "Middle-Income Industrial" 4 "High-Income Industrializing" 5 "High-Income Industrial"

	label values industrialization_stage industrialization_stage_labels

label variable government_effectiveness "Government Effectiveness Index (WGI)"

label variable ndgain "ND-GAIN Climate Adaptation Index"

label variable latitude "Latitude of country centroid"

label variable cumulative_co2_emissions "Cumulative CO₂ Emissions (in tons)"

label variable cumulative_co2_emissions_share "Share of Global Cumulative CO₂ Emissions (%)"

label variable carbon_price "Carbon Pricing Mechanism Dummy (1=Yes, 0=No)"

label variable nuclear_electricity_share "Share of Electricity from Nuclear (%)"

codebook 

* -----------------------------------------------------------------------------
*	Complementary Variables
* -----------------------------------------------------------------------------

gen ln_cumulative_co2_emissions = ln(cumulative_co2_emissions)

gen nuclear_squared = nuclear_electricity_share^2

gen tropics = .

	replace tropics = 1 if latitude >= -23.5 & latitude <= 23.5

	replace tropics = 0 if latitude < -23.5 | latitude > 23.5

* br

* -----------------------------------------------------------------------------
*	Pre-estimation Statistics
* -----------------------------------------------------------------------------
	
*	Continuous Variables

sum gdp_pc_ppp government_effectiveness ndgain latitude cumulative_co2_emissions cumulative_co2_emissions_share nuclear_electricity_share, de

*	Categorical Variables

tab income_group

tab industrialization_stage

tab carbon_price

tab income_group carbon_price, chi2

tab industrialization_stage carbon_price, chi2

* -----------------------------------------------------------------------------
*	Visualization
* -----------------------------------------------------------------------------

*	Pie Chart - Share of Global Cumulative CO₂ Emissions by Income Group

graph pie cumulative_co2_emissions_share, over(income_group) pie(1, explode) pie(2, explode) pie(3, explode) pie(4, explode) plabel(_all percent, format(%9.2f)) title("Share of Global Cumulative CO₂ Emissions by Income Group", size(Medium)) note("Sources: World Bank (2022) & Our World in Data (1750-2022)", size(small)) legend(cols(2) size(small)) 
graph export "output/fig1_emissions_by_income_group.png", replace width(2000)

*	Scatterplot - Historical Responsibility vs. Climate Vulnerability

twoway (scatter cumulative_co2_emissions ndgain, mlabel(Countries) mlabsize(vsmall)) (lfit cumulative_co2_emissions ndgain), title("Are the Most Responsible Countries the Least Vulnerable?", size(medium)) xlabel(, labsize(small)) ylabel(, labsize(small)) xtitle("ND-GAIN Climate Adaptation Index (0–100)", size(small)) ytitle("Cumulative CO₂ Emissions (in tons)", size(small)) note("Sources: ND-GAIN (2022) & Our World in Data (1750-2022)", size(small)) legend(off)
graph export "output/fig2_responsibility_vs_vulnerability.png", replace width(2000)

*	Scatterplot - Historical Responsibility vs. Climate Vulnerability (log-linearized)

twoway (scatter ln_cumulative_co2_emissions ndgain, mlabel(Countries) mlabsize(vsmall)) (lfit ln_cumulative_co2_emissions ndgain), title("Are the Most Responsible Countries the Least Vulnerable?", size(medium)) xlabel(, labsize(small)) ylabel(, labsize(small)) xtitle("ND-GAIN Climate Adaptation Index (0–100)", size(small)) ytitle("Log of Cumulative CO₂ Emissions (in tons)", size(small)) note("Sources: ND-GAIN (2022) & Our World in Data (1750-2022)", size(small)) legend(off)
graph export "output/fig3_responsibility_vs_vulnerability_log.png", replace width(2000)

*	Stacked Bar Chart - Carbon Pricing by Income Group

graph bar (percent), over(income_group, label(angle(45) labsize(medium small))) over(carbon_price, label(labsize(vsmall))) title("Carbon Pricing Implementation by Income Group", size(medium)) ytitle("Percent of Countries", size(small)) note("Source: World Bank & Our World in Data (2022)", size(small)) legend(cols(2) size(small)) stack
graph export "output/fig4_carbon_pricing_by_income_group.png", replace width(2000)

*	Stacked Bar Chart - Carbon Pricing by Industrialization Stage

graph bar (percent), over(industrialization_stage, label(angle(45) labsize(vsmall))) over(carbon_price, label(labsize(vsmall))) title("Carbon Pricing Implementation by Industrialization Stage", size(medium)) ytitle("Percent of Countries", size(small)) note("Source: UNIDO, World Bank & Our World in Data (2022)", size(small)) legend(cols(2) size(small)) stack
graph export "output/fig5_carbon_pricing_by_industrialization.png", replace width(2000)

* -----------------------------------------------------------------------------
*	Exportation Tools
* -----------------------------------------------------------------------------

capture which outreg2
if _rc ssc install outreg2

capture which asdoc
if _rc ssc install asdoc

* -----------------------------------------------------------------------------
*	Results
* -----------------------------------------------------------------------------

*	Correlation Matrix

pwcorr gdp_pc_ppp government_effectiveness ndgain latitude cumulative_co2_emissions nuclear_electricity_share, sig star(0.05)

asdoc pwcorr gdp_pc_ppp government_effectiveness ndgain latitude cumulative_co2_emissions nuclear_electricity_share, sig star(0.05) save(output/CorrelationMatrixCJBC.doc) replace 

*	First Regression - Responsibility

reg ln_cumulative_co2_emissions income_group industrialization_stage carbon_price nuclear_electricity_share nuclear_squared, robust

vif

outreg2 using "output/RegressionsCJBC.doc", replace ctitle(Model 1)

*	Second Regression - Vulnerability

reg ndgain gdp_pc_ppp government_effectiveness tropics, robust

vif

outreg2 using "output/RegressionsCJBC.doc", append ctitle(Model 2)

* -----------------------------------------------------------------------------
log close
