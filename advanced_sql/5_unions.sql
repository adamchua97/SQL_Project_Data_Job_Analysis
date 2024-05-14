 
 -- UNION
 -- make sure queries have the same amount of columns
 -- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION -- combine with results from query below

 -- Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION -- combine with results from query below

 -- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;



-- UNION ALL
-- returns all rows, even duplicates

 -- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION ALL-- combine with results from query below

 -- Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION ALL-- combine with results from query below

 -- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;


-- PRACTICE PROBLEM
/*  - Get the corresponding skill and skil type for each job posting in q1
    - includes those without any skills, too
    - Why? Look at the skills and the type for each job in the first quarter that has a salary > $70,000
*/

WITH job_posts_q1 AS (
     -- Get job postings from January
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        job_posted_date
    FROM 
        january_jobs

    UNION ALL-- combine with results from query below

    -- Get job postings from February
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        job_posted_date
    FROM 
        february_jobs

    UNION ALL-- combine with results from query below

    -- Get job postings from March
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        job_posted_date
    FROM 
        march_jobs
)

SELECT
    C.job_title_short,
    A.skills,
    A.type,
    C.salary_year_avg,
    C.job_posted_date::DATE
FROM skills_dim AS A 
INNER JOIN skills_job_dim AS B ON A.skill_id = B.skill_id
INNER JOIN  job_posts_q1 AS C ON C.job_id = B.job_id
WHERE
    C.salary_year_avg > 70000 AND
    C.job_title_short = 'Data Analyst'
ORDER BY
    C.salary_year_avg DESC;