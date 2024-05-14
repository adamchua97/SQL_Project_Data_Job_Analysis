SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;


SELECT
    job_title_short AS title,
    job_location AS location,
    --Casting timestamp data type to DATE
    job_posted_date::DATE AS date
FROM
    job_postings_fact
LIMIT 10;


-- AT TIME ZONE - converting time zone
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
    -- five hours prior from original
FROM
    job_postings_fact
LIMIT 10;


--EXTRACT - gets field (year, month, day) from date/time value
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date,
    EXTRACT(MONTH FROM job_posted_date) AS month,
    EXTRACT(YEAR FROM job_posted_date) AS year
FROM
    job_postings_fact
LIMIT 10;

-- USE CASE EXAMPLE - FINDING A TREND MONTH TO MONTH FROM JOB POSTING
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    job_posted_count DESC;


-- PRACTICE PROBLEMS

-- 1
-- Write a query to find the average salary both yearly (salary_year_avg) and hourly (salary_hour_avg) for job posting that were posted after -
-- June 1, 2023. Group results by job schedule type.
SELECT
    job_schedule_type,
    AVG(salary_year_avg),
    AVG(salary_hour_avg)
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;



-- 2
-- Write a query to count the number of jobs postings for each month in 2023, adjusting the job_posted_date to be in -
-- 'America/New_York' time zone before extracting the month. Assume job_posted_date is in UTC. Group and order by the month.
SELECT 
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(*) AS job_count
FROM 
    job_postings_fact
WHERE 
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
GROUP BY 
    month
ORDER BY 
    month;

-- 3
-- Write a query to find companies (include company name) that have posted jobs offering health insurance,
-- where these postings were made in the second quarter of 2023. Use date extraction to filter by quarter.
SELECT
    A.name,
    B.job_id,
    B.job_title_short,
    EXTRACT(QUARTER FROM B.job_posted_date) AS quarter

FROM
    company_dim A INNER JOIN job_postings_fact B ON A.company_id = B.company_id
WHERE
    B.job_health_insurance = 'TRUE' AND
    EXTRACT(QUARTER FROM B.job_posted_date) = 2;
