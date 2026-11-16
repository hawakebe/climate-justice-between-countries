# Climate Justice Between Countries: Responsibility, Vulnerability, and Growth

Master 1 thesis, M1 International Economics Studies, Université Paris-Est Créteil (2024-2025).
Author: Hawa Kebe. Supervisor: Patrick Lenain.

## Summary

Are the countries most responsible for climate change the least vulnerable to it? The thesis uses a cross-section of 214 countries in 2022. Responsibility is measured by cumulative CO2 emissions and vulnerability by the ND-GAIN index. Two OLS models with robust standard errors are estimated:

1. Responsibility: log cumulative CO2 emissions on income group, industrialisation stage, carbon pricing and the nuclear share of electricity.
2. Vulnerability: ND-GAIN index on GDP per capita, government effectiveness and a tropics dummy.

High-income countries account for nearly 58 percent of cumulative emissions and low-income countries for 0.6 percent. GDP per capita, government effectiveness and location explain 86 percent of the cross-country variation in the ND-GAIN index.

## Contents

| File | Description |
|---|---|
| `Master_1_Thesis_Climate_Justice_Between_Countries.pdf` | Thesis |
| `climate_justice.do` | Stata do-file: labels, descriptive statistics, figures, correlation matrix, regressions |
| `Dataset.xlsx` | Country-level dataset assembled for the thesis |
| `Variable_Dictionary.pdf` | Definition and source of each variable |
| `figures/` | The five figures of the thesis |

## Data sources

The dataset was assembled from public sources: World Bank (GDP per capita, income groups, Worldwide Governance Indicators), Our World in Data (cumulative CO2 emissions, nuclear share of electricity, carbon pricing), the Notre Dame Global Adaptation Initiative (ND-GAIN index) and UNIDO (industrial development stages). See the variable dictionary for details.

## How to run

Software: Stata 14 or later, with the user-written commands `outreg2` and `asdoc` (installed by the do-file if missing).

1. Set Stata's working directory to this folder.
2. Run `climate_justice.do`. The log, figures and tables are written to an `output` sub-folder.
