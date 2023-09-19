select * from PortfolioProject..CovidDeaths
order by 3,4

--select * from PortfolioProject..CovidVaccinations
--order by 3,4

--select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths

select location, date, total_cases,total_deaths, (cast(total_deaths as int)/total_cases )*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like 'india'
order by 1,2

--looking at Total Cases VS Population
--shows what percentage of population got Covid

select location, date,Population,total_cases, (total_Cases/Population)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like 'india'
order by 1,2

--Looking at countries with High Infection Rate compared to population
select location,Population,MAX(total_cases) as HighestInfectionCount, MAX((total_Cases/Population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like 'india'
Group by Location, Population
order by PercentPopulationInfected desc

--showing countries with Highest Death Count per population

select location,MAX(cast(total_Deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like 'india'
where continent is not null
Group by Location
order by TotalDeathCount desc

--Let's Break Things Down by Continents
--showing continents with the highest death count per population

select Continent,MAX(cast(total_Deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like 'india'
where continent is not null
Group by Continent
order by TotalDeathCount desc


--Global Numbers
select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
Group By date
order by 1,2

--Looking at total population vs vaccinations 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE
with popvsvac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
From popvsVac


