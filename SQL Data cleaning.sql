select *
from layoffs

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values and blank values

USE [DC_Cleaning]
GO

/****** Object:  Table [dbo].[layoffs]    Script Date: 28/10/2025 17:48:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Drop table layoffs_copy

CREATE TABLE [dbo].[layoffs_copy](
	[company] [nvarchar](50) NOT NULL,
	[location] [nvarchar](50) NOT NULL,
	[industry] [nvarchar](50) NULL,
	[total_laid_off] [smallint] NULL,
	[percentage_laid_off] [float] NULL,
	[date] [date] NULL,
	[stage] [nvarchar](50) NOT NULL,
	[country] [nvarchar](50) NOT NULL,
	[funds_raised_millions] [varchar](50) NULL
) ON [PRIMARY]
GO



select *
from layoffs_copy

insert into layoffs_copy
select * from layoffs

select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions order by company) as row_num
from layoffs_copy;

with duplicate_row AS
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions order by company) as row_num
from layoffs_copy
)
--select *
--from duplicate_row
--where row_num > 1;

delete 
from duplicate_row
where row_num > 1;

--Standardizing data
select company,TRIM(company) as trim_company
from layoffs_copy

Update layoffs_copy
set company = TRIM(company)

select distinct industry
from layoffs_copy 
order by 1

Update layoffs_copy
set industry = 'Crypto'
where industry like 'Crypto%'

select distinct country
from layoffs_copy 
order by 1

Update layoffs_copy
set country = 'United states'
where country like 'United%'

select *
from layoffs_copy
where total_laid_off is Null

select *
from layoffs_copy
where industry is NUll

select *
from layoffs_copy
where company = 'carvana'

update layoffs_copy
set industry = 'Travel'
where company like 'Airbnb%' and total_laid_off = 30

update layoffs_copy
set industry = 'Consumer'
where company like 'Juul%' and total_laid_off = 400

update layoffs_copy
set industry = 'Transportation'
where company like 'Carvana%' and total_laid_off = 2500

select *
from layoffs_copy
where total_laid_off is Null 
And percentage_laid_off is Null
order by company

delete
from layoffs_copy
where total_laid_off is Null 
And percentage_laid_off is Null


-- Exploratory data Analysis
SELECT * 
FROM layoffs_copy

-- EASIER QUERIES

SELECT MAX(total_laid_off)
FROM layoffs_copy

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_copy

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_copy
WHERE  percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoffs_copy
WHERE  percentage_laid_off = 1;

--Companies with the highest number lay off
SELECT company, total_laid_off
FROM layoffs_copy
ORDER BY 2 DESC

--The top 5 companies with the highest lay off
SELECT company, total_laid_off
from
     (SELECT company, total_laid_off,
      ROW_NUMBER() Over(ORDER BY total_laid_off DESC) Rows_number
      FROM layoffs_copy) As A
where rows_number <=5

-- now that's just on a single day

-- Companies with the most Total Layoffs
Select Company,Highest_LD_OFF
from
      (SELECT Company,SUM(total_laid_off) as Highest_LD_OFF,
       Row_number() over(order by SUM(total_laid_off) desc) rows_number
       from layoffs_copy
       group by company) As A
Where rows_number <= 10

-- by location
Select Location,Highest_LD_OFF
from
      (SELECT location,SUM(total_laid_off) as Highest_LD_OFF,
       Row_number() over(order by SUM(total_laid_off) desc) rows_number
       from layoffs_copy
       group by location) As Q
Where rows_number <= 10

-- this it total in the past 3 years or in the dataset
SELECT country,SUM(total_laid_off) as Highest_LD_OFF,
Row_number() over(order by SUM(total_laid_off) desc) rows_number
from layoffs_copy
group by country

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_copy
GROUP BY YEAR(date)
ORDER BY 1 ASC;


SELECT industry, SUM(total_laid_off) as Highest_LD_OFF
FROM layoffs_copy
GROUP BY industry
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off) as Highest_LD_OFF
FROM layoffs_copy
GROUP BY stage
ORDER BY 2 DESC;

WITH Company_Year AS 
                    (SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
                     FROM layoffs_copy
                     GROUP BY company, YEAR(date)),
                     Company_Year_Rank AS (
                     SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
                     FROM Company_Year)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

WITH company_year AS 
                    (SELECT industry, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
                     FROM layoffs_copy
                     GROUP BY industry, YEAR(date)),
                     company_Year_Rank AS (
                     SELECT industry, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
                     FROM Company_Year)
SELECT industry, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

WITH Company_Year AS 
                    (SELECT country, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
                     FROM layoffs_copy
                     GROUP BY country, YEAR(date)),
                     Company_Year_Rank AS (
                     SELECT country, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
                     FROM Company_Year)
SELECT country, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
