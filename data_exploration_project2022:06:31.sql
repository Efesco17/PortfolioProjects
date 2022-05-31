use PortfolioProject;

select *
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
order by location, date;

# select data we are going to be using here

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject.coviddeaths
order by location, date;

# looking at total cases v total deaths
# shows the likelihood of dying if you contract covid in your country
select location,date,total_cases,population, (total_cases/population)*100 as Death_percentage
from PortfolioProject.coviddeaths
where location like '%states%'
order by location, date;

# create view for deathpercentage per country

create view deathpercentagepercountry as 
select location,date,total_cases,population, (total_cases/population)*100 as Death_percentage
from PortfolioProject.coviddeaths
where location like '%states%'
order by location, date;




# looking at countries with highest infection rate compared to population 
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




# showing the continents with the highest death counts
select continent,MAX(cast(total_deaths as unsigned)) as highestdeathcount, max((total_deaths/population))*100 as percentofdead
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
group by continent
# where location like '%states%'
order by highestdeathcount desc ;

create view highestdeathcount as 
select continent,MAX(cast(total_deaths as unsigned)) as highestdeathcount, max((total_deaths/population))*100 as percentofdead
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
group by continent
# where location like '%states%'
order by highestdeathcount desc ;




# showing countries with highest death count per population
select location,MAX(cast(total_deaths as unsigned)) as highestdeathcount, max((total_deaths/population))*100 as percentofdead
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
group by location, population
# where location like '%states%'
order by highestdeathcount desc ;


# Global numbers

select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as unsigned))as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
from PortfolioProject.coviddeaths
where continent is not null and continent!=''
group by date
order by 1,2;

# looking at total population v vaccination

use PortfolioProject;

# rolling people vaccinated way to add up or accumulate rows in a certain column

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


# temp table
# declare the temp table


create temporary table percentpopulationvaccinated
(
continent varchar(255),
location varchar(255),
date  datetime,
population numeric,
new_vaccinations numeric,
Rolling_people_vaccinated numeric
);

# copy data into temp table

Insert into percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as UNSIGNED))
 over ( partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
 
from coviddeaths dea
join covidvaccinations vac
	on dea.location= vac.location
    and dea.date=vac.date
where dea.continent is not null and dea.continent!='' 
;
# Select data from the temporary table

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