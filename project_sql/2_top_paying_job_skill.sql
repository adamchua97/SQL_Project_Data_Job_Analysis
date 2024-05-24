/*
Question: What are the required skills for the top-paying data analyst jobs?
 - Use the top 10 highest-paying Data Analyst jobs from the first query
 - Add the specific skills required for these positions
 - Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop to match with the top paying positions
*/


-- REMOTE
(WITH top_paying_roles AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name,
        job_location
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
    LIMIT 10
)

SELECT
    top_paying_roles.*,
    skills_dim.skills,
    skills_dim.type AS skill_type,
    job_location
FROM top_paying_roles
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_roles.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg DESC)

UNION ALL

-- Los Angeles
(WITH top_paying_roles AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name,
        job_location
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
    LIMIT 10
)

(SELECT
    top_paying_roles.*,
    skills_dim.skills,
    --skills_dim.type as skill_type,
    job_location
FROM top_paying_roles
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_roles.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg DESC))