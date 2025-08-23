-- What are the skills required for these top-paying roles?
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        name AS company_name,
        salary_year_avg
    FROM job_postings_fact jpf
    LEFT JOIN company_dim cd ON cd.company_id = jpf.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT 
    tpj.*,
    sd.skills AS skill_name
FROM top_paying_jobs tpj
JOIN skills_job_dim sjd ON sjd.job_id = tpj.job_id
JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
ORDER BY tpj.salary_year_avg DESC;