#Netflix Movies and TV Shows Data Analysis using SQL 
![Netflix Logo](https://github.com/AishwaryaV6/Portfolio-projects/blob/main/logo.png)
OVERVIEW: 
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

OBJECTIVES:
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.

Dataset
The data for this project is sourced from the Kaggle dataset:

Dataset Link: [Dataset] (https://github.com/AishwaryaV6/Portfolio-projects/blob/main/netflix_titles.csv)

SCHEMA


DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
Business Problems and Solutions

--1. Count the number of TV shows vs movies.
Select 
*
from 
netflix;

Select 
type_,
count(*) as total_content
from netflix
group by 
type_;

--2. Find the most common rating for movies and TV shows.

Select 
type_,
rating
from
(Select type_,
rating,
count(*),
rank()over (partition by type_ order by count(*)Desc) as ranking
from netflix
group by 1,2)
as t1
where ranking =1;

--3. List all movies released in a specific year (e.g., 2020)

Select * from netflix
where type_='Movie' 
and release_year='2020';


-- 4. Find the top 5 countries with the most content on Netflix

Select UNNEST(STRING_TO_ARRAY(country,',')) as new_country ,
count(show_id) as total_content 
from 
netflix 
group by new_country
order by total_content desc
limit  5;

-- 5. Identify the longest movie

select * from netflix 
where to_number(replace(duration,'min',''),'9G999g999') = (
select max(to_number(replace(duration,'min',''),'9G999g999')) from netflix where type_<>'TV Show')
and type_ <> 'TV Show';


-- 6. Find content added in the last 5 years

Select min(date_added),max(date_Added) from netflix
where TO_DATE( date_added,'Month DD,YYYY')>= CURRENT_DATE- INTERVAL'5 years';
select max(date_Added) from netflix;

--7. List TV Shows and Movies which was released in the year 2021 in India.

Select type_,title
from netflix
where country='India' 
and release_year='2021';

--8. List the  TV hsows according to their release year.

Select count(type_) as Total_TV_Show, release_year
from netflix
where type_='TV Show'
group by release_year;



--9. List all TV shows with more than 5 seasons

Select *
from netflix 
where type_= 'TV Show'
and split_part (duration,' ',1) :: numeric >5;


--10. Identify the TV show the most number of seasons 

select * from netflix 
where to_number(replace(duration,'Seasons',''),'9G999g999') = (
select max(to_number(replace(duration,'Seasons',''),'9G999g999')) from netflix where type_='TV Show')
and type_='TV Show';

--11.Count the number of items in each genre.

Select unnest (string_to_array (listed_in,',')) as genre,
count(show_id)as total_content
from netflix 
group by genre;



--12 Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release.
select * from netflix;

Select
extract(year from to_date (date_added,'Month DD, YYYY')) as date,
count(*)as yearly_content,
Round((count(*)::numeric/(select count(*) from netflix where country='India')::numeric *100),2)avg_content_year
from netflix
where country='India'
group by 1
order by avg_content_year
desc
limit 5;

--13. List all movies that are documentaries

Select * from netflix where 
listed_in like '%Documentaries';

--14. Find all content without a director

Select * from netflix where 
director is null;



--15.Find how many movies actor 'Salman Khan' appeared in last 10 years!


Select * 
from netflix 
where 
casts like '%Salman Khan%'
and 
release_year > (extract (year from current_date)) -  10 ;



--16 Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

With category_table 
as 
(
Select *,
case when   description ilike'%kill%' or description ilike '%violence%'
then 'BAD'
else 
'GOOD'
end category
from netflix) 

Select 
count (*) as total_content,
category
from category_table 
group by 2;


FINDINGS AND CONCLUSIONS 

Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
