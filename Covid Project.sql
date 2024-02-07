Select*
From CovidDeaths$
Where continent	is not null
order BY 3,4

--Select*
--From CovidVaccinations$
--Order By 3,4

--Select Data that we are going to Use

Select location , date, total_cases, new_cases, total_deaths , population
From CovidDeaths$
Order BY 1,2

-- Looking at Total Cases Vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country 

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from CovidDeaths$
Where location like '%Egypt%'
order by 1,2

Create view EgyptTotalCasesVsDeaths as
Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from CovidDeaths$
Where location like '%Egypt%'

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from CovidDeaths$
Where location like '%States%'
order by 1,2

-- Looking at the Total Cases VS Population
-- Shows what percentage of the population got COVID

Select location,date, population, total_cases, (total_cases/population) *100 as PercentPopulationInfected
From CovidDeaths$
Where location like '%Egypt%'
Order by 1,2

Create View EgyptCasePercentage as
Select location,date, population, total_cases, (total_cases/population) *100 as PercentPopulationInfected
From CovidDeaths$
Where location like '%Egypt%'

Select location,date, population, total_cases, (total_cases/population) *100 as PercentPopulationInfected
From CovidDeaths$
Where location like '%states%'
Order by 1,2

-- Looking at Countries with Highest Infection rate compared to Population

Select location,population, Max(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 as
PercentPopulationInfected
From CovidDeaths$
Group BY population,location
order by PercentPopulationInfected Desc

Create View HighestInfectionRatePerCountry as
Select location,population, Max(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 as
PercentPopulationInfected
From CovidDeaths$
Group BY population,location

-- Showing Countries with Highest Death Count per Population

Select location, Max(total_deaths) as TotalDeathCount
From CovidDeaths$ 
Where continent is not Null
Group by location
Order BY TotalDeathCount Desc

Create View HighestDeathCountPerCountry as
Select location, Max(total_deaths) as TotalDeathCount
From CovidDeaths$ 
Where continent is not Null
Group by location
--Order BY TotalDeathCount Desc


--LET'S BREAK THINGS DOWN BY CONTINENT



Select location,Max(total_deaths) as TotalDeathCount
From CovidDeaths$
Where continent is Null
Group by location
order by TotalDeathCount DESC

--Showing the Continents with the highest death count per population

Select continent, Max(total_deaths) AS TotalDeathCount
From CovidDeaths$
Where continent is not Null
Group by continent
order by TotalDeathCount DESC

Create View HighestDeathCountPerPopulationPerContinent as
Select continent, Max(total_deaths) AS TotalDeathCount
From CovidDeaths$
Where continent is not Null
Group by continent
--order by TotalDeathCount DESC


--Global Numbers

Select date, Max(total_cases) as total_cases, Max(total_deaths) as total_deaths, Max(total_deaths)/MAX(total_cases) as DeathPercentage
From CovidDeaths$
Where continent is not Null
Group By date 
order by 1,2

Select Max(total_cases) as total_cases, Max(total_deaths) as total_deaths, Max(total_deaths)/MAX(total_cases) as DeathPercentage
From CovidDeaths$
Where continent is not Null
order by 1,2

Create View GlobalNumbers as
Select date, Max(total_cases) as total_cases, Max(total_deaths) as total_deaths, Max(total_deaths)/MAX(total_cases) as DeathPercentage
From CovidDeaths$
Where continent is not Null
Group By date 
--order by 1,2

-- Now to Join our Tables 
-- Looking at Total Population VS Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Now to show the total number of vaccinations in each location

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) over (partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3


-- Use -CTE

With PopsVsVac(Continent, Location, Date , Population,New_vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(float,vac.new_vaccinations)) over (partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
Select* , (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopsVsVac


--TEMP TABLE
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(float,vac.new_vaccinations)) over (partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2, 3

Select* , (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From #PercentPopulationVaccinated

--Creating View to store data for later Visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(float,vac.new_vaccinations)) over (partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3