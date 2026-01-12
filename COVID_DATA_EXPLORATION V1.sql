SELECT * 
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3 , 4 ;


-- SELECT * 
-- FROM covid_vaccinations
-- ORDER BY 3 , 4 

-- select data that we are going to be using 

SELECT location, 
date  , 
total_cases,
new_cases,
total_deaths,
population
FROM portfolio_project.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2 ;


-- Looking at total cases vs total deaths 
-- shows the likelihood of dying if you got covid in your country 
SELECT location,
date,
total_cases,
total_deaths,
(total_deaths / total_cases) * 100 AS deaths_percentage
FROM portfolio_project.covid_deaths
WHERE location LIKE '%egypt%' AND  continent IS NOT NULL
ORDER BY 2 ;



-- Lookig at the total cases vs population
-- percentage of population that had covid at a date
SELECT location,
FORMAT(population , 2) AS population,
date,
total_cases,
(total_cases / population) * 100 AS population_infected_percentage
FROM portfolio_project.covid_deaths
WHERE location LIKE '%egypt%' AND  continent IS NOT NULL
ORDER BY 2 ;

-- looking at countries with higghest infection rate vs population

SELECT location,
population,
MAX(total_cases) As highest_Infection_Count,
MAX((total_cases / population)) * 100 AS population_infected_percentage
FROM portfolio_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY 4 DESC;


-- Looking at countries with hihest death count per population

SELECT location,
MAX(total_deaths) As highest_death_Count
FROM portfolio_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- looking at countries with highest death rate per population

SELECT location,
population,
MAX(total_deaths) As highest_death_Count,
MAX((total_deaths / population)) * 100 AS population_death_percentage
FROM portfolio_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY 4 DESC;


-- BREAKING THINGS UP BY CONTINENT 
-- this one is not correct numbers data issue

SELECT 
continent,
MAX(total_deaths) As highest_death_Count
FROM portfolio_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY  continent
ORDER BY 2 DESC;

--  THE CORRECT NUMBERS 
SELECT 
location,
MAX(total_deaths) As highest_death_Count
FROM portfolio_project.covid_deaths
WHERE continent IS  NULL
GROUP BY  location
ORDER BY 2 DESC;

-- Global Numbers 

-- Looking at total new cases , new deaths &  total death percentage  per date 
-- maybe to look at the fluctuation of death percentages over time 

SELECT date,
SUM(new_cases) AS Total_cases ,
 SUM(new_deaths) AS Total_Deaths ,
SUM(new_deaths) / SUM(new_cases) * 100 AS  death_percentage
FROM portfolio_project.covid_deaths
-- WHERE location LIKE '%egypt%
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2 ;

-- Summarized global total cases , total deaths , total death percentage
SELECT SUM(new_cases) AS Total_cases ,
SUM(new_deaths) AS Tota_Deaths ,
SUM(new_deaths) / SUM(new_cases) * 100 AS  death_percentage
FROM portfolio_project.covid_deaths
-- WHERE location LIKE '%egypt%
WHERE continent IS NOT NULL
ORDER BY 1,2 ;


-- Joining with vaccinations table on both date and location because its a composite join 
-- Looking at  total vaccinations vs population
-- USING CTE

WITH PopVac (continent , location , date , population, new_vaccinations , rolling_people_vaccinated)
as
(
SELECT dea.continent ,
		dea.location , 
		dea.date ,
		dea.population,
		vac.new_vaccinations,
		SUM(vac.new_vaccinations)
		OVER (partition by dea.location 
		ORDER BY dea.location , dea.date)   AS rolling_people_vaccinated 

FROM portfolio_project.covid_deaths dea
JOIN portfolio_project.covid_vaccinations vac
	ON dea.location = vac.location  AND dea.date= vac.date
WHERE dea.continent IS NOT NULL 

)

SELECT * , (PopVac.rolling_people_vaccinated / population) * 100 AS percentage_vaccinated
FROM PopVac;


-- TEMP TABLE 

DROP TABLE IF EXISTS percentpopulationvaccinated;
CREATE TEMPORARY TABLE  percentpopulationvaccinated
(continent varchar(255),
location varchar(255),
date datetime,
population decimal,
new_vaccinations decimal,
rolling_people_vaccinated decimal 
);

INSERT INTO percentpopulationvaccinated
SELECT dea.continent ,
		dea.location , 
		dea.date ,
		dea.population,
		vac.new_vaccinations,
		SUM(vac.new_vaccinations)
		OVER (partition by dea.location 
		ORDER BY dea.location , dea.date)   AS rolling_people_vaccinated 

FROM portfolio_project.covid_deaths dea
JOIN portfolio_project.covid_vaccinations vac
	ON dea.location = vac.location  AND dea.date= vac.date
WHERE dea.continent IS NOT NULL ;

SELECT * 
FROM percentpopulationvaccinated;

-- CREATING VIEWES TO STORE DATA FOR VISUALIZATIONS

CREATE VIEW  percentpopulationvaccinated AS
SELECT dea.continent ,
		dea.location , 
		dea.date ,
		dea.population,
		vac.new_vaccinations,
		SUM(vac.new_vaccinations)
		OVER (partition by dea.location 
		ORDER BY dea.location , dea.date)   AS rolling_people_vaccinated 

FROM portfolio_project.covid_deaths dea
JOIN portfolio_project.covid_vaccinations vac
	ON dea.location = vac.location  AND dea.date= vac.date
WHERE dea.continent IS NOT NULL ;



