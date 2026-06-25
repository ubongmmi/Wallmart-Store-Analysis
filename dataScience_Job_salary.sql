USE UBONG
go
--1 Data Science Job Salary 2020-2024 analysis

create database DataScience_Salary;
use DataScience_Salary;
show tables from DataScience_Salary;
select count(*) from data_science_salaries;
show columns from  data_science_salaries;

--2 Top 15 Job Titles by Average Salary

WITH job_salary AS (
    SELECT
        job_title,
        AVG(salary_in_usd) AS avg_salary
    FROM data_science_salaries
    GROUP BY job_title
)

SELECT *
FROM (
    SELECT
        job_title,
        ROUND(avg_salary, 2) AS avg_salary,
        DENSE_RANK() OVER (
            ORDER BY avg_salary DESC
        ) AS salary_rank
    FROM job_salary
) ranked_jobs
WHERE salary_rank <= 15
ORDER BY salary_rank;

--3 Salary Spread by Company Size and Experience Level
SELECT
    company_size,
    experience_level,
    MIN(salary_in_usd) AS min_salary,
    MAX(salary_in_usd) AS max_salary,
    MAX(salary_in_usd) - MIN(salary_in_usd) AS salary_spread
FROM data_science_salaries
GROUP BY
    company_size,
    experience_level
ORDER BY
    company_size,
    experience_level;
    
    --4 Percentage Salary Growth from 2020 to 2024 per Role
    

WITH salary_by_year AS (
    SELECT
        job_title,
        AVG(CASE WHEN work_year = 2020 THEN salary_in_usd END) AS salary_2020,
        AVG(CASE WHEN work_year = 2024 THEN salary_in_usd END) AS salary_2024
    FROM data_science_salaries
    GROUP BY job_title
)

SELECT
    job_title,
    salary_2020,
    salary_2024,
    ROUND(
        ((salary_2024 - salary_2020) / salary_2020) * 100,
        2
    ) AS growth_percent
FROM salary_by_year
WHERE salary_2020 IS NOT NULL
  AND salary_2024 IS NOT NULL
ORDER BY growth_percent DESC;