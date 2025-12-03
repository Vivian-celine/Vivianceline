-- Data cleaning

select *
from layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values and blank values
-- 4. Remove any columns

CREATE TABLE layoff_staging
like layoffs;

select *
from layoff_staging;

insert layoff_staging
select *
from layoffs;

select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoff_staging;

with duplicate_cte AS
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoff_staging
)
select *
from duplicate_cte
where row_num > 1;

select *
from layoff_staging
where company = 'casper';

create table `layoffs_staging2`  (
`company` text,
`location` text,
`industry` text,
`total_laid_off` int default null,
`percentage_laid_off` text,
`date` text,
`stage` text,
`country` text,
`funds_raised_millions` int default null,
`row_num` int);


select *
from layoffs_staging2
where row_num > 1;

insert into layoffs_staging2 
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoff_staging;

delete
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2;