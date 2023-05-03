


--SELECT * FROM CovidVaccinations
--ORDER BY 3,4

-- Data to be used

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2


-- total cases vs total deaths
-- %age of you might die

SELECT location, date, total_cases,  total_deaths, (total_deaths/total_cases)  * 100 AS death_rate
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
and continent is not NULL
ORDER BY 1,2


-- total cases vs population
-- ratio of ppl who got infected

SELECT location, date, total_cases, population, (total_cases/population) * 100 AS infection_ratio
FROM PortfolioProject..CovidDeaths
WHERE location like 'Pakistan'
ORDER BY 1,2


-- highest infection rate of counties compared to population

SELECT location, MAX(cast(total_deaths)) AS highest_death_count 
FROM PortfolioProject..CovidDeaths
GROUP BY location
ORDER BY highest_death_count desc



-- highest death rate of counties compared to population


SELECT location, MAX(total_cases) AS highest_infection_count, population, MAX((total_cases/population)) * 100 AS percentage_infection_ratio
FROM PortfolioProject..CovidDeaths
GROUP BY population, location
ORDER BY percentage_infection_ratio DESC


--SELECT *
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--order by 3,4

-- max death order by location

SELECT location, MAX(cast(total_deaths as int)) AS DeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
GROUP BY location
ORDER BY DeathCount DESC


-- TOTAL DEATHS BY CONTINENT

SELECT continent, MAX(cast(total_deaths as int)) AS DeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY DeathCount DESC




-- continents with hight death count per population


SELECT continent, MAX(cast(total_deaths as int)) AS DeathCount , population
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY DeathCount DESC



-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases) * 100 AS death_rate
FROM PortfolioProject..CovidDeaths
-- WHERE location like '%states%'
WHERE continent is not NULL
--GROUP BY date
ORDER BY 1,2



-- total population vs vaccinations


-- USE CTE

WITH popVsvac (continent,location,date,population,new_vaccinations,Rolling_People_Vac)
AS
(
SELECT  dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as Rolling_People_Vac
-- 
FROM PortfolioProject..CovidDeaths as dea
	Join PortfolioProject..CovidVaccinations as vac
	ON dea.location = vac.location AND dea.date = vac.date
	WHERE dea.continent is not NULL
	--ORDER BY 2,3
)

SELECT *, (Rolling_People_Vac/population) *100
FROM popVsvac








