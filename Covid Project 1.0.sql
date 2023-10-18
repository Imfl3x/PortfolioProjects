/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
ORDER BY  3,4


--Select Data that we are going to be using

SELECT 
 Location
,Date
,total_Cases
,new_cases
,total_deaths
,population
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likeliehood of dying if you catch Covid in United States

SELECT 
 Location
,Date
,total_cases Total_Cases
,total_deaths Total_Deaths
,(Round(total_deaths / total_cases,3) * 100 )Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%States%'
AND continent is NOT NULL
ORDER BY 1,2

--Looking a Total Cases vs Total Population
--Shows what percentage of population got Covid

SELECT 
 Location
,Date
,total_cases Total_Cases
,population Population
,(Round(total_cases / population,4) * 100 )Percent_Population_Infected
FROM PortfolioProject..CovidDeaths
WHERE location like '%States%'
AND continent is NOT NULL
ORDER BY 1,2

-- What Countries have the highest infection rate compared to Population

SELECT 
 Location
,population Population
,MAX(total_cases) Highest_Infection_Count
,MAX(total_cases / population) * 100 Percent_Population_Infected
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY Location,Population
ORDER BY Percent_Population_Infected DESC

--Countries with Highest Death Count per Population

SELECT 
 Location
,MAX(Cast(total_deaths AS int)) Total_Death_Count
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY Location
ORDER BY Total_Death_Count DESC


--Breaking information down by Contitnet
--Showing continetents with the highest death count per population

SELECT 
 continent Continent
,MAX(Cast(total_deaths AS int)) Total_Death_Count
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC

--Global Numbers

SELECT
 SUM(new_cases) Total_Cases
,SUM(CAST(new_deaths AS int)) Total_Deaths
,SUM(CAST(new_deaths AS int)) / SUM(New_Cases) * 100 Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 1,2

--Looking at Total Population vs Vaccinations

SELECT dea.continent
,dea.location
,dea.date
,dea.population
,vac.new_vaccinations
,SUM (CAST(vac.new_vaccinations as int)) OVER (Partition By dea.location 
	ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
ORDER BY 2,3



--- USE CTE

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations,Rolling_People_Vaccinated)
AS
(
SELECT dea.continent
,dea.location
,dea.date
,dea.population
,ISNULL(vac.new_vaccinations,0)new_vaccinations
,SUM (CAST(vac.new_vaccinations as int)) OVER (Partition By dea.location 
	ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
)
SELECT * 
,ISNULL(Rolling_People_Vaccinated,0/Population * 100) Percentage_People_Vaccinated
FROM PopvsVac


-- TEMP Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(Continent nvarchar(255) 
,Location  nvarchar(255)
,Date  datetime
,Population numeric
,new_vaccinations numeric
,Rolling_People_Vaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent
,dea.location
,dea.date
,dea.population
,ISNULL(vac.new_vaccinations,0)new_vaccinations
,SUM (CAST(vac.new_vaccinations as int)) OVER (Partition By dea.location 
	ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL

SELECT * 
,(Rolling_People_Vaccinated/Population * 100) Percentage_People_Vaccinated
FROM #PercentPopulationVaccinated


--- Creating View to store data for latter visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent
,dea.location
,dea.date
,dea.population
,ISNULL(vac.new_vaccinations,0)new_vaccinations
,SUM (CAST(vac.new_vaccinations as int)) OVER (Partition By dea.location 
	ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac 
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL

SELECT *
FROM PercentPopulationVaccinated
