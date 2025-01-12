select * from covid_vacination where handwashing_facilities < 37;
Select * from covid_deaths ;
Select * from covid_vacination order by 3,4;
Select location,date_of_death, total_cases , new_cases, total_deaths, population  
from covid_deaths 
order by 1,2;

Select location,date_of_death, total_cases , total_deaths, (total_deaths/total_cases*100)as percentage_of_deaths
from covid_deaths 
where location like '%India'
order by 1,2 ;

Select location,date_of_death, total_cases , population, (total_cases/population*100)as percentage_of_cases
from covid_deaths 
--where location like '%India'
order by 1,2 ;

--Looking at countries with highest infection rate compared to population

Select location,population, max(total_cases)as max_number_of_cases , max((total_cases/population*100))as percentage_of_cases
from covid_deaths 
--where location like '%India'
group by location,population
order by percentage_of_cases  desc;


--To show the countries having highest death count.

Select location, max(cast(total_deaths as int)) as max_number_of_deaths 
from covid_deaths 
--where location like '%India'
where total_deaths  is not null and 
continent is not NULL
group by location
order by max_number_of_deaths   desc;

--To show the continents having highest death count.

Select location ,  max(cast(total_deaths as int)) as max_number_of_deaths 
from covid_deaths 
--where location like '%India'
where continent is  NULL
group by location
order by max_number_of_deaths   desc;

--looking at countries with highest cases coompared to population;

Select location,population,  max(cast(total_cases as int)) as max_number_of_cases, max(population)max_population
from covid_deaths 
--where location like '%India'
where total_deaths  is not null and 
continent is not NULL
group by location,population
order by max_number_of_cases  desc;


-- Global Numbers 
Select  sum(new_deaths)total_deaths, sum(new_cases)total_cases, (sum(new_deaths)/sum(new_cases)*100)as death_percentage_by_date
from covid_deaths 
--where location like'%India%'
where continent is not null 
--group by date_of_death
order by 1,2 ;


select * from covid_vaccination;
Alter table covid_vacination 
Rename  to covid_vaccination;

--looking at total cases vs vaccinations 

Select dea.continent, dea.location, dea.date_of_death, dea.population , vac.new_vaccinations,
sum( vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date_of_death) rolling_people_vaccinated,
(rolling_people_vaccinated/population)*100
from covid_deaths dea
join covid_vaccination vac 
on dea.location=vac.location
and dea.date_of_death=vac.entry_date
where dea.continent is not NULL
order by 2,3;


---Using CTE 

With Population_vs_Vaccination(continent, location, date_of_death, population, new_vaccinations, rolling_people_vaccinated)
AS
(
Select dea.continent, dea.location, dea.date_of_death, dea.population , vac.new_vaccinations,
sum( vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date_of_death) rolling_people_vaccinated
--(rolling_people_vaccinated/population)*100
from covid_deaths dea
join covid_vaccination vac 
on dea.location=vac.location
and dea.date_of_death=vac.entry_date
where dea.continent is not NULL
--order by 2,3;
)

Select continent, location, date_of_death, population, new_vaccinations, rolling_people_vaccinated,
(rolling_people_vaccinated/population)*100 as percentage_of_rolling_people_vaccinated
from Population_vs_Vaccination;


--TEMP TABLE

Drop table if EXISTS percentagepopulationvaccinated
Create table percentagepopulationvaccinated

( continent varchar(255),
location varchar(255),
date_of_death  date , 
population     number  , 
new_vaccinations   number ,
rolling_people_vaccinated  number
);
Insert into percentagepopulationvaccinated

Select dea.continent, dea.location, dea.date_of_death, dea.population , vac.new_vaccinations,
sum( vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date_of_death) rolling_people_vaccinated
--(rolling_people_vaccinated/population)*100
from covid_deaths dea
join covid_vaccination vac 
on dea.location=vac.location
and dea.date_of_death=vac.entry_date
where dea.continent is not NULL
--order by 2,3;

Select continent, location, date_of_death, population, new_vaccinations, rolling_people_vaccinated,
(rolling_people_vaccinated/population)*100 as percentage_of_rolling_people_vaccinated
from percentagepopulationvaccinated;


---Creating views to store data  for later data visualizations 

Create view percentage_population_vaccinated as

Select dea.continent, dea.location, dea.date_of_death, dea.population , vac.new_vaccinations,
sum( vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date_of_death) rolling_people_vaccinated
--(rolling_people_vaccinated/population)*100
from covid_deaths dea
join covid_vaccination vac 
on dea.location=vac.location
and dea.date_of_death=vac.entry_date
where dea.continent is not NULL
--order by 2,3;

