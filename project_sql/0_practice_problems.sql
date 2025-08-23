-- Find companies that do not require a degree (using join)
SELECT DISTINCT
    cd.company_id,
    cd.name AS company_name
FROM job_postings_fact jpf
JOIN company_dim cd ON jpf.company_id = cd.company_id
WHERE jpf.job_no_degree_mention IS TRUE
ORDER BY cd.company_id;

-- Find companies that do not require a degree (using subquaery)
SELECT
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention IS TRUE
)
ORDER BY company_id;



-- Count the number of jobs for each company (using join)
SELECT
    cd.name AS company_name,
    COUNT(*) AS total_jobs
FROM job_postings_fact jpf
JOIN company_dim cd ON cd.company_id = jpf.company_id
GROUP BY cd.name
ORDER BY total_jobs DESC;

-- Count the number of jobs for each company (using CTE)
WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) as total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT
    cd.name AS company_name,
    cjc.total_jobs
FROM company_job_count cjc
LEFT JOIN company_dim cd ON cd.company_id = cjc.company_id
ORDER BY total_jobs DESC;



-- Get the top 5 skills (using subquaery)
SELECT
    sd.skills,
    top5.total
FROM (
    SELECT
        skill_id,
        COUNT(*) AS total
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY total DESC
    LIMIT 5
) AS top5
JOIN skills_dim sd ON sd.skill_id = top5.skill_id
ORDER BY top5.total DESC;



-- Get the top 5 skills work from home jobs in Data Analysis (using CTE)
WITH count_remote_jobs AS (
    SELECT
        sjd.skill_id,
        COUNT(*) AS total
    FROM job_postings_fact jpf
    JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
    WHERE
        jpf.job_work_from_home IS TRUE
        AND jpf.job_title_short = 'Data Analyst'
    GROUP BY sjd.skill_id
    ORDER BY total DESC
)
SELECT
    sd.skills AS skill_name,
    crj.total AS posting_count
FROM count_remote_jobs crj
JOIN skills_dim sd ON sd.skill_id = crj.skill_id
ORDER BY crj.total DESC
LIMIT 5;



-- Categorize Companies by Job Posting Count
SELECT
    cd.name AS company_name,
    CASE
        WHEN companies.total_job < 10 THEN 'Small'
        WHEN companies.total_job BETWEEN 10 AND 50 THEN 'Medium'
        WHEN companies.total_job > 50 THEN 'Large'
        ELSE NULL
    END AS size_category,
    companies.total_job
FROM (
    SELECT
        company_id,
        COUNT(*) AS total_job
    FROM job_postings_fact
    GROUP BY company_id
    ) AS companies
JOIN company_dim cd ON cd.company_id = companies.company_id
ORDER BY companies.total_job DESC;