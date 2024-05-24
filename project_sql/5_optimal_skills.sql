/*
Question: What are the optimal skills to learn (high-demand and high-paying)?
 - Identify skills in high demand and associated with high average salaries for Data Analyst roles
 - Concentrates on remote positions with specified salaries (in my case also LA)
 - Why? Target skills that offer job security(high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analytics
*/



-- Use query 3 and query 4

WITH skills_demand AS ( -- first CTE
    SELECT
        skills_dim.skill_id,
        skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE -- same as job locations = 'Anywhere'
    GROUP BY
        skills_dim.skill_id
), average_salary_skill AS (   --Second CTE  -->  Combining two CTEs: only write the 'WITH' once at the top then just commas after the first CTE
    SELECT
        skills_dim.skill_id,
        skills,
        ROUND(AVG(salary_year_avg), 2) AS skill_average_salary
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
)
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    skill_average_salary
FROM skills_demand
INNER JOIN average_salary_skill ON average_salary_skill.skill_id = skills_demand.skill_id
WHERE
    demand_count > 10
ORDER BY
    skill_average_salary DESC,
    demand_count DESC
LIMIT 25;

-- Rewriting same query concisely
(SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS skill_demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS average_salary,
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
    skills_dim.skill_id, job_location
HAVING
    COUNT(skills_job_dim.job_id)> 10
ORDER BY
    average_salary DESC,
    skill_demand_count DESC
LIMIT 25)


UNION ALL
-- Los Angeles
(SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS skill_demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS average_salary,
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
    skills_dim.skill_id, job_location
HAVING
    COUNT(skills_job_dim.job_id) > 5 -- since there's not as many jobs with LA locations, we narrow down a bit less with job demand count
ORDER BY
    average_salary DESC,
    skill_demand_count DESC)


