-- SUBQUERY EXAMPLE
SELECT *
FROM ( -- SUBQUERY STARTS HERE
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS january_jobs;
    -- SUBQUERY ENDS HERE


--COMMON TABLE EXPRESSIONS(CTE) EXAMPLE:
WITH january_jobs AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) -- CTE definition ends here

SELECT *
FROM january_jobs;


-- MORE EXAMPLES
/* FIND COMPANIES WITH JOB POSTINGS
THAT DO NOT MENTION A DEGREE REQUIREMENT
*/
SELECT
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
    ORDER BY
        company_id
)

/* FIND COMPANIES THAT HAVE THE MOST JOB OPENINGS:
    - GET TOTAL NUMBER OF JOB POSTINGS PER COMPANY ID(job_posting_fact)
    - RETURN TOTAL NUMBER OF JOBS WITH THE COMPANY NAME (company_dim)
*/

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
-- RUN CTE AND SELECT QUERY TOGETHER
SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY 
    company_job_count.total_jobs DESC;



-- PRACTICE PROBLEMS

/*
Identify the top 5 skills that are most frequently mentioned in job postings. Use a subquery to find the skill IDs with the highest counts
in the skills_job_dim table and then join this result with the skills_dim table to get the skill names.
*/

SELECT
    skill_id,
    skills,
    type
FROM skills_dim
WHERE skill_id IN (
    SELECT
        skill_id
    FROM skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        COUNT(*) DESC
    LIMIT 5
)

/*
Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying the number of job postings they have.
Use a subquery to calculate the total job postings per company. A company is considered 'Small' if it has less than 10 job postings.
'Medium' if the number of job postings is between 10 and 50, and 'Large' if it has more than 50 job postings. Implement a
subquery to aggregate job counts per company before classifying them based on size.
*/

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs,
    CASE
        WHEN company_job_count.total_jobs < 10 THEN 'Small'
        WHEN company_job_count.total_jobs BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS size
FROM 
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY 
    company_job_count.total_jobs DESC;

/*
Find the count of the number of remote job postings per skill:
    - Display the top 5 skills by their demand in remote jobs
    - Include skill ID, name and count of postings requiring the skill
*/

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
    WHERE 
        job_postings.job_work_from_home = TRUE
    GROUP BY
        skill_id
    ORDER BY
        skill_count DESC
)
SELECT
    remote_job_skills.skill_id,
    skills,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim ON skills_dim.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;
