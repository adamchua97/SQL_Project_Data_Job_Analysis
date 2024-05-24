/*
Question: What are the top skills based on salary?
 - Look at the average salary associated with each skill for Data Analyst positions
 - Focuses on roles with specified salaries, regardless of location
 - Why? It revelas how different skills impact salary levels for Data Analysts and
    helps identify the most financnially rewarding skills to acquire or work on
*/


(SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS skill_average_salary,
    job_location
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills,job_location
ORDER BY
    skill_average_salary DESC
LIMIT 25)

UNION ALL

(SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS skill_average_salary,
    job_location
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Los Angeles, CA'
GROUP BY
    skills,job_location
ORDER BY
    skill_average_salary DESC
LIMIT 25)