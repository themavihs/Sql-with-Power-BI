select *
from [Portfolio Project]..CovidDeaths
order by location, date


select *
from [Portfolio Project]..CovidVaccinations$
order by location, date



select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..CovidDeaths
order by location, date


--Looking for total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country


select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 deathpercentage
from [Portfolio Project]..CovidDeaths
--where location like '%india%'
order by location, date


--Looking at totalcases vs population
-- Shows what percentage of population infected with Covid

select location, date, population, total_cases,(total_cases/population)*100 percentpopulationinfected
from [Portfolio Project]..CovidDeaths
--where location like '%india%'
order by location, date


-- Countries with Highest Infection Rate compared to Population

select location, population, MAX(total_cases) highestinfectioncount, Max((total_cases/population))*100 percentpopulationinfected
from [Portfolio Project]..CovidDeaths
group by location, population
order by percentpopulationinfected desc


-- Countries with Highest Death Count per Population


select location, max(cast(total_deaths as int)) totaldeathcount
from [Portfolio Project]..CovidDeaths
where continent is not null
group by location
order by totaldeathcount desc


-- Showing contintents with the highest death count per population


select continent, max(cast(total_deaths as int)) totaldeathcount
from [Portfolio Project]..CovidDeaths
where continent is not null
group by continent
order by totaldeathcount desc


-- GLOBAL NUMBERS

select sum(new_cases) totalcases, sum(cast(new_deaths as int)) totaldeath, sum(cast(new_deaths as int))/sum(new_cases)*100 deathpercentage
from [Portfolio Project]..CovidDeaths
where continent is not null
order  by 1,2


-- Shows Percentage of Population that has recieved at least one Covid Vaccine


select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) rollingpeoplevaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations$ vac
on vac.location = dea.location and vac.date = dea.date
where dea.continent is not null
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

with popvsvac (continent,location,date,population,new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) rollingpeoplevaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations$ vac
on vac.location = dea.location and vac.date = dea.date
where dea.continent is not null
)

select*, (rollingpeoplevaccinated/population)*100
from popvsvac






-- Using Temp Table to perform Calculation on Partition By in previous query


drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)


insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) rollingpeoplevaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations$ vac
on vac.location = dea.location and vac.date = dea.date
where dea.continent is not null




select*, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated




-- Creating View to store data for later visualizations

Create View percentpopulationvaccinated as

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) rollingpeoplevaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations$ vac
on vac.location = dea.location and vac.date = dea.date
where dea.continent is not null



Create View hdp as
select continent, max(cast(total_deaths as int)) totaldeathcount
from [Portfolio Project]..CovidDeaths
where continent is not null
group by continent














--view
  select*
  from percentpopulationvaccinated

 select *
  from hdp