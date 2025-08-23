-- What are the top skills based on salary for Data Analyst?
SELECT
    sd.skills AS skill_name,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact jpf
JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
ORDER BY avg_salary DESC
LIMIT 10;