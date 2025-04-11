# SARS-CoV-2 Seroprevalence Analysis

This repository contains a comprehensive statistical analysis of SARS-CoV-2 seroconversion detection behavior among U.S. blood donors. The goal of this project was to support a CDC-affiliated research team by identifying demographic and behavioral factors that influence whether individuals self-report a swab within their seroconversion interval.

Using logistic regression models, we analyzed data from over 33,000 blood donors across various subgroups—such as age, race/ethnicity, vaccination status, gender, and geographic region—to determine which factors significantly affect the odds of self-reporting. We also explored differences between primary infection and reinfection cohorts.

## 📂 Contents

- `consulting_memo.pdf` – Full consulting memorandum with background, methods, results, and interpretation  
- `table_1_results.csv` – Logistic regression coefficients and p-values  
- `table_2_odds_ratios.csv` – Adjusted and unadjusted odds ratios with 95% confidence intervals  
- `figures/` – Model diagnostics and variable effect plots  
- `data_description.txt` – Summary of dataset structure and variable meanings  

## 🔧 Tools & Languages

- **SAS Studio** – Data merging, modeling, and output generation  
- **Excel** – Formatting journal-quality tables  
- **R / ggplot2** – Data visualization and effects plots  

## 👥 Authors

Ben Laufer, Sam Ricafrente, Lucas Fonda, Wyatt De Mers  
Cal Poly San Luis Obispo – April 2024
