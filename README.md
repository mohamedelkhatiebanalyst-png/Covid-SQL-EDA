COVID Data Analysis SQL Scripts

This repository contains a collection of SQL queries for exploring and analyzing COVID-19 data, including cases, deaths, and vaccinations, across countries and continents. The scripts are designed for data exploration, aggregation, and visualization preparation.

All queries were executed on the portfolio_project database and are ready to run in MySQL 8+.

📂 Repository Contents

COVID deaths exploration
Queries analyzing:

Total cases vs total deaths

Death rates by country and continent

Infection percentages relative to population

Global and summarized totals

Vaccination data analysis
Queries analyzing:

Daily and cumulative vaccinations

Percentage of population vaccinated

Rolling vaccination totals using window functions

Advanced analytics

Joining death and vaccination data on country and date

Calculating cumulative vaccinations per country

Creating temporary tables and views for visualization

🔹 Key Features

Data Exploration

Examine total cases, new cases, total deaths, and population.

Identify countries with the highest infection or death rates.

Population-Level Analysis

Calculate percentage of population infected or deceased.

Aggregate metrics per continent and globally.

Vaccination Analysis

Use window functions (SUM() OVER (PARTITION BY … ORDER BY …)) for running totals.

Calculate percentage of population vaccinated per country over time.

Temporary Tables & Views

Create temporary tables (percentpopulationvaccinated) for session-level analysis.

Create persistent views for visualization purposes.

🔹 Sample Queries

```
Deaths vs Cases by Country:

SELECT location, date, total_cases, total_deaths,
       (total_deaths / total_cases) * 100 AS deaths_percentage
FROM covid_deaths
WHERE location LIKE '%Egypt%'
ORDER BY date;
```

```
Percentage of Population Infected:

SELECT location, FORMAT(population,2) AS population, date, total_cases,
       (total_cases / population) * 100 AS population_infected_percentage
FROM covid_deaths
WHERE location LIKE '%Egypt%'
ORDER BY date;
```
```
Rolling Vaccinations using Window Functions:

SELECT location, date, population, new_vaccinations,
       SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY date) AS rolling_people_vaccinated
FROM covid_deaths
JOIN covid_vaccinations USING (location, date)
WHERE continent IS NOT NULL;
```
```
Temporary Table for Visualization:

CREATE TEMPORARY TABLE percentpopulationvaccinated AS
SELECT location, date, population, new_vaccinations,
       SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY date) AS rolling_people_vaccinated
FROM covid_deaths
JOIN covid_vaccinations USING (location, date)
WHERE continent IS NOT NULL;
```

🔹 Requirements

MySQL 8+ (for window functions and CTE support)

portfolio_project database containing:

covid_deaths

covid_vaccinations

🔹 Notes

Window functions are used to calculate cumulative vaccination counts without collapsing rows.

Temporary tables exist only during the session; views persist for visualization purposes.

Queries are modular, so you can pick and run them based on your analysis needs.

🔹 Repository Purpose

This repository is intended for:

Exploratory Data Analysis (EDA) on COVID-19 data

Learning SQL aggregation, window functions, and joins

Preparing data for dashboards or visualizations in Tableau, Power BI, or similar tools.

🔹 License

This repository is open for educational purposes.
