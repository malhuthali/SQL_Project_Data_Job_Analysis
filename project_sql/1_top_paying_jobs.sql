-- What are the top-paying jobs for Data Analyst?
SELECT
    job_id,
    job_title,
    name AS company_name,
    salary_year_avg,
    job_posted_date::DATE
FROM job_postings_fact jpf
LEFT JOIN company_dim cd ON cd.company_id = jpf.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;