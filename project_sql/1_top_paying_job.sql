/*
Question: What are the top-paying data analyst jobs?
 - Identify the top 10 highest-paying Data Analyst roles that are remote.
 - Focus on job postings with specified salary ranges (exclude nulls)
 - Why? Highlight the top paying opportunities for Data Analysts, offerings insights into employment 
*/


(SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    name AS company_name,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
-- Narrow to top 10
LIMIT 10)

UNION ALL

(SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    name AS company_name,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Los Angeles, CA' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
-- Narrow to top 10
LIMIT 10)
