-- What are the most in-demand skills for Data Analyst?
SELECT
    sd.skills AS skill_name,
    COUNT(*) AS demand_count
FROM job_postings_fact jpf
JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
WHERE jpf.job_title_short = 'Data Analyst'
GROUP BY sd.skills
ORDER BY demand_count DESC
LIMIT 10;