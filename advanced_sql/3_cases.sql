-- Create three tables:
-- Jan 2023 jobs, Feb 2023 jobs and Mar 2023 jobs

-- Jan 2023
--CREATE TABLE january_jobs AS
    --SELECT *
    --FROM job_postings_fact
    --WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- Feb 2023
--CREATE TABLE february_jobs AS
    --SELECT *
    --FROM job_postings_fact
    --WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- March 2023
--CREATE TABLE march_jobs AS
    --SELECT *
    --FROM job_postings_fact
    --WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

-- ^ TABLES ALREADY CREATED
-- check
SELECT job_posted_date
FROM march_jobs




-- CASES SECTION START
/*
Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'
*/

SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;


-- AGGREGATING AND GROUP BY
-- FINDING OUT HOW MANY DATA ANALYST JOBS CAN BE APPLIED AND THEIR CATEGORY
SELECT
    COUNT(job_id) AS num_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

-- FINDING THE HIGHEST AND LOWEST SALARY RECORDS TO GET AN ESTIMATE OF SALARY RANGES
-- IN THE U.S.
SELECT
    MAX(salary_year_avg) AS highest_salary_record,
    MIN(salary_year_avg) AS lowest_salary_record
FROM job_postings_fact
WHERE
    job_country = 'United States';

-- FINDING RECORD THAT HAS THE HIGHEST SALARY IN THE U.S.
SELECT *
FROM job_postings_fact
WHERE
    job_country = 'United States' AND
    salary_year_avg = 
    (SELECT  MAX(salary_year_avg) FROM job_postings_fact);

/*
PRACTICE PROBLEM: CATEGORIZE SALARIES FROM EACH JOB POSTING
TO SEE IF IT FITS DESIRED SALARY RANGE
- PUT SALARY INTO DIFFERENT BUCKETS: HIGH, STANDARD, LOW
- ONLY DATA ANALYST ROLES; ORDER FROM HIGHEST TO LOWEST
*/

SELECT *,
    CASE
        WHEN salary_year_avg > 200000 THEN 'HIGH'
        WHEN salary_year_avg BETWEEN 90000 AND 200000 THEN 'STANDARD'
        ELSE 'LOW'
    END AS salary_category
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND
    job_country = 'United States' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC;
