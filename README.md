# Introduction
This project dives into the data job market, focusing on data analyst roles. **The analysis explores top-paying positions and the skills associated with them, in-demand and highest-paying skills, and the optimal skills where high demand intersects with high salary in data analyst roles**. The project is also focused on **Remote** and **Los Angeles** for job locations to further narrow down the analysis. Insights from this project can lead to better decision-making when strategizing what skills, companies and specific data analyst positions to strive for top-salaries. 
# Background
As an aspiring Data Analyst, I was interested in the various data-related roles that are in today's job market. I was curious to see what specific positions were there, the companies that hire them, the skills they possess and the salaries they make.

The data comes from Luke Barousse's [SQL Course](https://www.lukebarousse.com/sql). It's filled with data on job titles, salaries, locations and important skills and technologies.

### The strategic questions I wanted to answer and used for analysis:
1. *What are the highest-paying data analyst roles?*
2. *What are the skills associated in these highest-paying roles?*
3. *What are the most in-demand skills for Data Analysts?*
4. *What are the top-paying skills for Data Analysts?*
5. *What are the optimal skills (both high-demand + high-paying)?*

# Tools Used
- ***SQL:*** The core tool used for my analysis; writing SQL queries enabled me to filter and procure relevant data from the database and discover important insights. 
- ***PostgreSQL:*** The selected database management system; ideal for handling the datasets for this project.
- ***Visual Studio Code:*** The IDE used to write and execute the SQL queries and connect to the PostrgreSQL database.
- ***Power BI:*** Popular visualization tool from Microsoft; used to visualize the data for each strategic question.
- ***Git + GitHub:*** Essential for version control and sharing the SQL scripts and analysis, ensuring collaboration and project tracking.
# Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market:
## 1. What are the highest-paying data analyst roles?
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs and Los Angeles. This query highlights the high paying opportunities in the field.

**SQL Code Query:**
```sql
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
LIMIT 10)
```
![Top Paying Roles - Remote](assets\top_paying_roles_remote.png)
![Top Paying Roles - LA](assets\top_paying_roles_la.png)

*Horizontal Bar graphs showing the salary for the top 10 salaries for data analysts in remote positions and in Los Angeles.*
### Breakdown:
- **Remote vs. Location-Based Salaries:** Remote roles generally offer higher salaries compared to location-based roles in Los Angeles. This is evident as the highest remote salary is $650,000, significantly higher than the top Los Angeles salary of $222,500.

- **Company Trends:** TikTok is a prominent employer in Los Angeles, offering several high-paying roles. This indicates a robust demand for data analysts within their operations, especially focused on US Data Security (USDS).
- Companies like SmartAsset and Meta are notable for their competitive salaries for remote roles, indicating a high value placed on data analytics leadership.

- **Role Hierarchies and Pay:** Leadership and senior roles (e.g., Director, Associate Director) command higher salaries both remotely and in Los Angeles. For instance, Meta’s Director of Analytics offers $336,500 remotely, and TikTok’s Director roles in LA range around $222,500.

- **Industry Variations:** Diverse industries are hiring for data analytics, from tech giants like Meta and TikTok to healthcare providers like UCLA Health. This reflects the universal demand for data-driven decision-making across sectors.

- **Hybrid/Remote Opportunities:** Some positions offer hybrid/remote options, such as the Data Analyst role at UCLA Health, suggesting flexibility in work arrangements which might be a factor in salary negotiations.

## 2. What are the skills associated in the highest-paying roles?
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

**SQL Code Query:**
```sql
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
```
![Top Skills in the Top Paying Roles - Remote](assets\top_paying_job_skills_remote.png)
![Top Skills in the Top Paying Roles - LA](assets\top_paying_job_skills_la.png)

*Vertical bar charts visualizing the skills for the highest-paying jobs for data analysts in remote positions and Los Angeles; also shows the total average annual salary the skills yield.*

### Breakdown:
- **Common Skills:** **Pandas** appears in both remote and Los Angeles roles, highlighting its importance in data manipulation and analysis in Python across different work environments.

- **Specialized Skills for Remote Roles:**
    - **Emerging Technologies and AI:** Remote roles often list skills like Watson (AI) and DataRobot (automated ML), suggesting a focus on advanced analytics and AI-driven solutions.
    - **Version Control & Collaboration:** Tools like Bitbucket and GitLab are crucial, possibly due to the collaborative nature of remote work.

- **Big Data and Real-Time Processing in LA:** Hadoop, Spark, Kafka are skills in big data processing and real-time data streaming are emphasized in Los Angeles, indicating a focus on handling large-scale data and real-time analytics.

- **Databases and NoSQL Technologies:** Both environments value database management but with different preferences. Remote roles favor Couchbase, while Los Angeles roles emphasize MongoDB and Cassandra, reflecting diverse data storage solutions.

- **Programming Languages:** Remote roles require Swift and Golang, showcasing a demand for versatile programming skills, possibly for mobile app development and efficient backend services.

- **Data Compliance in LA:** GDPR knowledge is specifically mentioned for LA roles, underscoring the importance of data protection and privacy compliance in this market.

- **Data Integration and Web Frameworks in LA:** SSIS is crucial for data integration tasks, and Express for building web applications, suggesting a need for comprehensive data management and web development skills.


## 3. What are the most in-demand skills for Data Analysts?
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

**SQL Code Query:**
```sql
(SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    job_location
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE -- same as job locations = 'Anywhere'
GROUP BY
    skills, job_location
ORDER BY
    demand_count DESC
LIMIT 5)

UNION ALL

(SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    job_location
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Los Angeles, CA'
GROUP BY
    skills, job_location
ORDER BY
    demand_count DESC
LIMIT 5)
```

![Top demanded skills - Remote](assets\top_demanded_skills_remote.png)
![Top demanded skills - Remote](assets\top_demanded_skills_la.png)

*Donut charts visualizing the most in-demand skills for Data Analysts in remote jobs and in Los Angeles*

### Breakdown:
- **Core Skills:** SQL and Excel, these skills are universally essential across both remote and Los Angeles positions, emphasizing their foundational role in data analysis.

- **Programming and Analysis:** The demand for Python in both remote and LA roles shows its broad applicability in data science, automation, and machine learning tasks.

- **SAS in LA:** Unique to Los Angeles, SAS indicates a niche demand in industries that rely heavily on statistical analysis and legacy systems.

- **Data Visualization:** Tableau and Power BI, these tools are crucial for translating complex data into understandable insights, with Tableau being particularly prominent in both markets.

- **Remote vs. Local Demand:**
    - **Higher Demand Remotely:** Skills like SQL, Excel, and Python have significantly higher demand counts for remote positions compared to Los Angeles. This suggests a larger number of remote job opportunities or a broader application of these skills across various remote roles.
    - **Specialized Tools in LA:** The presence of SAS in LA-specific roles suggests specialized requirements in local industries that may not be as prominent in remote roles.

## 4. What are the top-paying skills for Data Analysts?
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

**SQL Code Query:**
```sql
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
```

![Top Paying Skills - Remote](assets\top_paying_skills_remote.png)
![Top Paying Skills - LA](assets\top_paying_skills_la.png)

*Treemap chart displaying the top-paying skills for Data Analysts in remote jobs and in Los Angeles; the higher-paying skills have the bigger squares/rectangles and are towards the left side, and descends to the right*

### Breakdown:
- **High-Value Big Data and Cloud Technologies:** Expertise in tools like PySpark, Hadoop, and Databricks is highly valued, with top salaries reflecting the industry's emphasis on handling large-scale data efficiently.

- **Data Management and NoSQL Databases:** Skills in managing Couchbase, MongoDB, Cassandra, and PostgreSQL are well-compensated, highlighting their critical role in data management.

- **Advanced Data Analysis and Machine Learning:** Proficiency in DataRobot, Pandas, Scikit-Learn, and Jupyter commands high salaries, underscoring the importance of machine learning and advanced analytics capabilities.

- **DevOps, CI/CD Tools, and Programming Languages:** Knowledge of Bitbucket, GitLab, Jenkins, Kubernetes, Swift, Golang, and Scala is valuable, reflecting the integration of DevOps practices and the demand for software development skills in data operations.

## 5. What are the optimal skills (both high-demand + high-paying)?
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

**SQL Code Query**:
```sql
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
    COUNT(skills_job_dim.job_id) > 5 -- since there's not as many jobs with LA locations, we narrow down less with job demand count
ORDER BY
    average_salary DESC,
    skill_demand_count DESC)
```

![Optimal Skills - Remote](assets\optimal_skills_remote.png)
![Optimal Skills - LA](assets\optimal_skills_la.png)

*Tables showing the optimal skills for Data Analysts in remote jobs and in Los Angeles*

### Breakdown:
- **High-Paying Technical Skills:** Express and Go: High salaries associated with Express and Go indicate a demand for skills in full-stack development and efficient backend programming.

- **Cloud and Big Data Technologies:** Azure, Snowflake, BigQuery, AWS; Cloud platforms and big data technologies are highly valued in remote roles, reflecting the shift towards cloud-based solutions and large-scale data processing.

- **Visualization and BI Tools:** Power BI and Tableau are significant as markets emphasize the importance of visualization tools, essential for translating data into actionable insights.

- **Statistical and Analytical Tools:** High demand for Python and R in both markets highlights their significance in data analysis, machine learning, and statistical modeling.

- **Foundational Skills:** SQL and Excel, these skills are consistently in high demand, essential for data management and analysis across both remote and Los Angeles roles.

- **Project Management and Collaboration:** Jira and Confluence, these tools are important for managing projects and fostering collaboration, particularly in remote work environments.


# Conclusion
## Summary of Insights
**1.** Remote roles generally offer higher salaries compared to location-based roles in Los Angeles, with the highest remote salary at $650,000 versus $222,500 in Los Angeles. TikTok is a major employer in Los Angeles, while companies like SmartAsset and Meta offer competitive remote salaries, emphasizing the value of data analytics leadership. Leadership roles command higher pay in both settings, with Meta's remote Director of Analytics at $336,500 and TikTok's LA roles around $222,500. The demand for data analysts spans various industries, from tech giants to healthcare. Hybrid/remote options, like those at UCLA Health, suggest work arrangement flexibility that could influence salaries.

**2.** Both remote and Los Angeles data analyst roles prioritize Pandas for Python-based data manipulation. Remote positions focus on emerging technologies like Watson and DataRobot, along with version control tools like Bitbucket and GitLab, while Los Angeles roles emphasize big data processing skills such as Hadoop and Spark, along with MongoDB and Cassandra for database management. Los Angeles roles also require GDPR knowledge and highlight the importance of SSIS for data integration and Express for web development.

**3.** SQL and Excel are universally crucial for data analysis in both remote and Los Angeles roles, while Python's demand indicates its versatility across various data tasks. SAS is uniquely sought after in Los Angeles, suggesting specialized needs in certain industries. Additionally, Tableau's prominence in both markets highlights the importance of data visualization, while differences in demand counts for core skills like SQL and Python imply varying job opportunities between remote and local settings.

**4.** Proficiency in high-value big data and cloud technologies like PySpark, Hadoop, and Databricks commands top salaries, emphasizing the industry's focus on efficient handling of large-scale data. Skills in managing NoSQL databases such as Couchbase, MongoDB, and Cassandra are well-compensated, underlining their critical role in data management. Additionally, expertise in advanced data analysis tools like DataRobot, Pandas, and machine learning frameworks like Scikit-Learn is highly valued, alongside knowledge of DevOps practices and programming languages like Swift, Golang, and Scala, reflecting the integration of software development skills in data operations.

**5.** High-paying technical skills like Express and Go indicate a demand for full-stack development and efficient backend programming. Cloud platforms and big data technologies such as Azure, Snowflake, and BigQuery are highly valued in remote roles, reflecting the industry's move towards cloud-based solutions and large-scale data processing. Additionally, visualization tools like Power BI and Tableau are significant for translating data into actionable insights, while the consistent demand for foundational skills like SQL and Excel underscores their importance in data management and analysis across both remote and Los Angeles roles. Collaboration tools like Jira and Confluence play a vital role in project management and fostering collaboration, particularly in remote work environments.

## Learnings
Throughout this project, I've enhanced my SQL skills and arsenal:

- **Complex Query Crafting:** Mastered the art of advanced SQL; got comfortable with merging tables and WITH clauses for using Common Table Expressions.

- **Data Aggregation:** Got more familiar with GROUP BY and aggregate functions like COUNT() and AVG().

- **Analytical Thinking:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.
## Closing Remarks
This project improved my SQL abilities and gave useful information about the data analyst job market. The results of the analysis can help figure out what skills to prioritize on developing and improving for high-paying Data Analyst roles, as well as aiding in job search efforts and marketability. People who aim to become data analysts can increase their chances in a tough job market by concentrating on skills that are in demand and pay well. This project also shows how important it is to keep learning and stay updated on new trends in data analytics to stay competitive.