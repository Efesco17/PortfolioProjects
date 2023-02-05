use PortfolioProject;
#1
select *
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
order by location, date;


#2
-- DEMONSTRATING ABILITY TO CREATE BASIC QUERIES 
	-- Select all countries metrics 
select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject.coviddeaths
order by location, date;


# 3
-- DEMONSTRATING ABILITY TO PEFORM CALCULATIONNS AND USE ALIASES IN QUERIES
	-- looking at total cases v total deaths
		-- shows the likelihood of dying if you contract covid in your country
select location,date,total_cases,population, (total_cases/population)*100 as Death_percentage
from PortfolioProject.coviddeaths
#where location like '%states%'
where continent is not null and continent!=''
order by location, date;

# create view for deathpercentage per country

create view deathpercentagepercountry as 
select location,date,total_cases,population, (total_cases/population)*100 as Death_percentage
from PortfolioProject.coviddeaths
where location like '%states%'
order by location, date;


# 4 
-- DEMONSTRATING ABILITY TO USE AGGREGATE FUNCTIONS AND USE GROUP BY STATEMENTS 
	-- looking at countries with highest infection rate compared to population 
select location,population,MAX(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentofpopulationinfected
from PortfolioProject.coviddeaths
group by location, population
# where location like '%states%'
order by percentofpopulationinfected desc ;

# creating view for highest infection rate compared to population

create view highestinfectionratecomparedtopop as 
select location,population,MAX(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentofpopulationinfected
from PortfolioProject.coviddeaths
group by location, population
# where location like '%states%'
order by percentofpopulationinfected desc ;


# 5
-- DEMONSTRATING ABILITY TO CONVERT DATATYPES USING CAST FUNCTION
	-- showing the continents with the highest death counts
select continent,MAX(cast(total_deaths as unsigned)) as highestdeathcount, max((total_deaths/population))*100 as percentofdead
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
group by continent
# where location like '%states%'
order by highestdeathcount desc ;

-- DEMONSTRATING ABILITY TO CREATE VIEWS
create view highestdeathcount as 
select continent,MAX(cast(total_deaths as unsigned)) as highestdeathcount, max((total_deaths/population))*100 as percentofdead
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
group by continent
# where location like '%states%'
order by highestdeathcount desc ;


# 6 
# showing countries with highest death count per population
select location,MAX(cast(total_deaths as unsigned)) as highestdeathcount, max((total_deaths/population))*100 as percentofdead
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
group by location, population
# where location like '%states%'
order by highestdeathcount desc ;


# 7
# Global numbers
select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as unsigned))as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
group by date
order by 1,2;

# looking at total population v vaccination


# 8 
-- DEMONSTRATING ABILITY TO CREATE & USE COMMON TABLE EXPRESSIONS and OVER & PARTITION BY CLAUSES
	-- rolling people vaccinated way to add up or accumulate rows in a certain column
use PortfolioProject;
With PopvsVac (continent,location, date, population, new_vaccinations, rolling_people_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as UNSIGNED))
 over ( partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
 
from coviddeaths dea
join covidvaccinations vac
	on dea.location= vac.location
    and dea.date=vac.date
#where dea.location ='albania'
where dea.continent is not null and dea.continent!='' 
#order by 2,3
)
# use cte
select *, (rolling_people_vaccinated/population)*100 as PopvsVacpercentage
from PopvsVac;

-- DEMONSTRATING AILITY TO CREATE AND USE TEMP TABLES
-- 	temp table
-- 		declare/create the temp table


create temporary table percentpopulationvaccinated
(
continent varchar(255),
location varchar(255),
date  datetime,
population numeric,
new_vaccinations numeric,
Rolling_people_vaccinated numeric
);

-- copy data into temp table

Insert into percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as UNSIGNED))
 over ( partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
 
from coviddeaths dea
join covidvaccinations vac
	on dea.location= vac.location
    and dea.date=vac.date
where dea.continent is not null and dea.continent!='' 
;
-- Select data from the temporary table


 # 9
select *, (rolling_people_vaccinated/population)*100 as PopvsVacpercentage
from percentpopulationvaccinated;

# creating view to store data for later visualizations
create view percentpopulationvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as UNSIGNED))
 over ( partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
from coviddeaths dea
join covidvaccinations vac
	on dea.location= vac.location
    and dea.date=vac.date
where dea.continent is not null and dea.continent!='' ;
