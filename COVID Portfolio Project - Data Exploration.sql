SELECT 
			*
FROM 
			CovidDeaths$

SELECT 
			*
FROM 
			CovidVaccinations$
ORDER BY 
			3, 4;

--SELECT USEFUL DATA
SELECT 
			CovidDeaths$.location, CovidDeaths$.date, CovidDeaths$.total_cases, CovidDeaths$.new_cases, 
			CovidDeaths$.total_deaths, CovidDeaths$.population
FROM		CovidProject..CovidDeaths$
ORDER BY 
			1, 2;

--TOTAL CASES vs TOTAL DEATH
--Shows the likelihood of dying if you get covid in your country
SELECT 
		CovidDeaths$.location, CovidDeaths$.date, CovidDeaths$.total_cases, 
		CovidDeaths$.total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM 
		CovidProject..CovidDeaths$
--WHERE location LIKE '%states%'
ORDER BY 
		1, 2;

--TOTAL CASES vs POPULATION
--Shows what Percentage has gotten covid in a country 
SELECT 
		CovidDeaths$.location, CovidDeaths$.date, CovidDeaths$.population, CovidDeaths$.total_cases, 
		(total_cases/population)*100 AS ContractedPercentage
FROM	CovidProject..CovidDeaths$
ORDER BY
		1, 2;

--COUNTRY WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT 
		CovidDeaths$.location, CovidDeaths$.population, MAX(CovidDeaths$.total_cases) AS HighestInfectionCount, 
		MAX((total_cases/population))*100 AS InfectedPopulationPercentage
FROM 
		CovidProject..CovidDeaths$
GROUP BY 
		location, population
ORDER BY 
		InfectedPopulationPercentage DESC;

--COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT 
		continent, MAX(cast(CovidDeaths$.total_deaths as int)) AS TotalDeathCount
FROM	
		CovidProject..CovidDeaths$
WHERE	
		continent IS NOT NULL
GROUP BY 
		continent
ORDER BY 
		TotalDeathCount DESC;


--SHOWING CONTINENT WITH HIGHEST DEATH COUNT
SELECT 
		continent, MAX(cast(CovidDeaths$.total_deaths as int)) AS TotalDeathCount
FROM 
		CovidProject..CovidDeaths$
WHERE 
		continent IS NOT NULL
GROUP BY 
		continent
ORDER BY TotalDeathCount DESC;

--GLOBAL NUMBERS
SELECT 
		SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_death, 
		SUM(cast(new_deaths as int))/SUM(new_cases)* 100 AS DeathPercentage
FROM 
		CovidProject..CovidDeaths$
WHERE 
		continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2;

--JOINING DEATHS & VACCINATED TABLE
SELECT 
		*
FROM 
		CovidProject..CovidDeaths$ AS Dea
		JOIN CovidProject..CovidVaccinations$ AS Vac
			ON dea.location = Vac.location
		AND dea.date = Vac.date

--TOTAL POPULATION VS VACCINATED 
SELECT 
		dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS NumVaccinatedPerLocal
		-- SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location) //This also convert to integers
FROM 
		CovidProject..CovidDeaths$ AS Dea
		JOIN CovidProject..CovidVaccinations$ AS Vac
			ON dea.location = Vac.location
		AND dea.date = Vac.date
WHERE 
		dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
ORDER BY
		2, 3;

--CREATING A C.T.E FOR THE ABOVE QUERY
WITH POPvsVAC (Continent, Location, Date, Population, New_Vaccinations, NumVaccinatedPerLocal) AS
(
	
SELECT 
		dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS NumVaccinatedPerLocal
		-- SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location) //This also convert to integers
		--0,(NumVaccinatedPerLocal/Population)*100
FROM 
		CovidProject..CovidDeaths$ AS Dea
		JOIN CovidProject..CovidVaccinations$ AS Vac
			ON dea.location = Vac.location
		AND dea.date = Vac.date
WHERE 
		dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
--ORDER BY 2, 3
)

SELECT 
		*, 
		(NumVaccinatedPerLocal/Population)*100
FROM 
		POPvsVAC


--SELECT		*
--FROM		CovidProject..CovidVaccinations$
--SELECT		location, SUM(population), SUM(cast(new_vaccinations as int))
--FROM		CovidProject..CovidDeaths$
--GROUP BY	location
--ORDER BY	population ASC;

-- CREATING A TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated -- This will drop the table and recreate it each time, reason is, incase I want to alter a part of the query below 
CREATE TABLE #PercentPopulationVaccinated 
(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	NumVaccinatedPerLocal numeric
									)

INSERT INTO #PercentPopulationVaccinated
	SELECT 
		dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS NumVaccinatedPerLocal
		-- SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location) //This also convert to integers
		--0,(NumVaccinatedPerLocal/Population)*100
FROM 
		CovidProject..CovidDeaths$ AS Dea
		JOIN CovidProject..CovidVaccinations$ AS Vac
			ON dea.location = Vac.location
		AND dea.date = Vac.date
-- WHERE 
		--dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
--ORDER BY 2, 3

SELECT 
		*, 
		(NumVaccinatedPerLocal/Population)*100
FROM 
		#PercentPopulationVaccinated


--CREATING A VIEW
-- PercentPopulationVaccinated
CREATE VIEW  PercentPopulationVaccinated AS
	SELECT 
		dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS NumVaccinatedPerLocal
		-- SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location) //This also convert to integers
		--0,(NumVaccinatedPerLocal/Population)*100
FROM 
		CovidProject..CovidDeaths$ AS Dea
		JOIN CovidProject..CovidVaccinations$ AS Vac
			ON dea.location = Vac.location
		AND dea.date = Vac.date
WHERE 
		dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
--ORDER BY 2, 3

-- USEFUL DATA
CREATE VIEW UseFulData AS 
SELECT 
			CovidDeaths$.location, CovidDeaths$.date, CovidDeaths$.total_cases, CovidDeaths$.new_cases, 
			CovidDeaths$.total_deaths, CovidDeaths$.population
FROM		CovidProject..CovidDeaths$
-- ORDER BY 
			--1, 2;

SELECT *
FROM PercentPopulationVaccinated