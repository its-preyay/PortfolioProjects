select * 
from CovidDeaths$ 

select * 
from [covid vaccinations]

select location,date,total_cases, new_cases, total_deaths, population 
from CovidDeaths$ 
--where location like '%Nigeria%'
order by 1,2

-- checking the total cases vs total deaths, which is also the % likelihood of dying from covid

select location,date,total_cases,total_deaths, (total_deaths/total_cases) *100
    as percentagedeathpertotalcase
    from CovidDeaths$ 
--where location like '%Nigeria%'
order by 1,2
 
-- lets see the percentage of population that waas infected

select location, Max(total_cases)  highestinfectioncount,population, Max(total_cases/population) * 100 as highestinfectionrate
    from CovidDeaths$ 
	--where location like '%Nigeria%'
group by location, population
order by highestinfectionrate desc

--showing hioghest death rate per population by country

select location, Max(cast(total_deaths as int)) as highestdeathcount,population, Max(cast(total_deaths as int)/population) * 100 
as highestdeathpercentage
    from CovidDeaths$ 
	where continent is not null
group by location, population
order by highestdeathpercentage desc

-- by  continents

select continent,Max(cast(total_deaths as int)) as highestdeathcount, Max(cast(total_deaths as int)/population) * 100 
as highestdeathpercentage
    from CovidDeaths$ 
	where continent is not null
group by continent
order by highestdeathpercentage desc

--global numbers

select *
from CovidDeaths$
--where continent is not null
order by 1,2

--joining both tables

select * from CovidDeaths$ dea
join [covid vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date

--now querying the joined table to get specific data 
-- like checking total population vs vaccination

select dea.location,dea.date,dea.population,vac.new_vaccinations, vac.total_vaccinations from CovidDeaths$ dea
join [covid vaccinations] vac
on dea.location = vac.location
where dea.continent is not null
and dea.date = vac.date
order by 1,2

-- side practice, to create a new table similar in value to total vaccinations using cte or temp tables

select dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over
(partition by dea.location order by dea.location,dea.date) as rollovertotalvaccinations
from CovidDeaths$ dea
join [covid vaccinations] vac
    on dea.location = vac.location
    where dea.continent is not null
	--and dea.location like '%Nigeria%'
and dea.date = vac.date
order by 1,2

-- cte

with popvsvac (location,date,population,new_vaccinations,rollovertotalvaccinations)
as
(
select dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over
(partition by dea.location order by dea.location,dea.date) as rollovertotalvaccinations
from CovidDeaths$ dea
join [covid vaccinations] vac
    on dea.location = vac.location
    --where dea.continent is not null
	and dea.location like '%Nigeria%'
and dea.date = vac.date
--order by 1,2
)
select *,(rollovertotalvaccinations/population)*100
from popvsvac

--using temp tables


Drop table if exists #Percentagepopulationvaxxed
create table #Percentagepopulationvaxxed
(
location nvarchar(255),
date Datetime,
population numeric,
new_vaccinations numeric,
rollovertotalvaccinations numeric
)

insert into #Percentagepopulationvaxxed
select dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over
(partition by dea.location order by dea.location,dea.date) as rollovertotalvaccinations
from CovidDeaths$ dea
join [covid vaccinations] vac
    on dea.location = vac.location
    where dea.continent is not null
	--and dea.location like '%Nigeria%'
and dea.date = vac.date
order by 1,2
select *, (rollovertotalvaccinations/population)* 100 as percentagevaxxed
from #Percentagepopulationvaxxed
where location like '%states%'


-- creating views to store data for later visualisation

create view Percentagepopulationvaxxed as
select dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over
(partition by dea.location order by dea.location,dea.date) as rollovertotalvaccinations
from CovidDeaths$ dea
join [covid vaccinations] vac
    on dea.location = vac.location
	and dea.date = vac.date
    where dea.continent is not null
	--and dea.location like '%Nigeria%'

	select * from Percentagepopulationvaxxed

















 





