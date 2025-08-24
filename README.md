# 📊 SQL Job Market Analysis

## 🚀 Introduction

Practical SQL project analyzing the **Data Analyst job market**.  
The goal is to answer key hiring questions with clean **PostgreSQL** queries while showcasing core analyst skills:

- 🧩 Joins, subqueries, and CTEs
- 📊 Aggregations and data summarization
- ⚡ Conditional logic with CASE statements

The analysis uncovers:

- 💰 Top-paying Data Analyst roles
- 🔥 Most in-demand skills
- 📈 Skills that balance high demand and high salary

---

## 📚 Background

This project was motivated by a desire to better understand the **Data Analyst job market** and the skills that drive high-paying opportunities. Using a dataset of job postings, salaries, and required skills, I explored questions such as:

- What are the top-paying Data Analyst jobs?
- What skills are required for those roles?
- Which skills are most in demand overall?
- Which skills are linked to higher salaries?
- What are the **optimal skills to learn** (high demand + high salary)?

---

## 🛠️ Tools I Used

- **PostgreSQL** → main database for querying and analysis
- **pgAdmin** → GUI tool to manage and run SQL queries
- **VS Code** → SQL editor + project documentation (README, Git)
- **Git & GitHub** → version control and project sharing

---

## 🔎 The Analysis

### 1) Top-paying jobs for Data Analysts

```sql
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
```

| Job Title                        | Salary (USD, Yearly) |
| -------------------------------- | -------------------- |
| Data Analyst                     | 650,000              |
| Data base administrator          | 400,000              |
| HC Data Analyst , Senior         | 375,000              |
| Director of Safety Data Analysis | 375,000              |
| Sr Data Analyst                  | 375,000              |

### 2) Skills required for the top-paying roles

```sql
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
```

| Skill    | Count |
| -------- | ----- |
| Python   | 5     |
| Excel    | 3     |
| SQL      | 3     |
| R        | 3     |
| Tableau  | 3     |
| Power BI | 2     |

### 3) Most in-demand skills for Data Analysts

```sql
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
```

| Skill    | Demand Count |
| -------- | ------------ |
| SQL      | 92,628       |
| Excel    | 67,031       |
| Python   | 57,326       |
| Tableau  | 46,554       |
| Power BI | 39,468       |

### 4) Top skills by average salary

```sql
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
```

| Skill       | Avg Salary (USD, Yearly) |
| ----------- | ------------------------ |
| SVN         | 400,000                  |
| Solidity    | 179,000                  |
| Couchbase   | 160,515                  |
| DataRobot   | 155,486                  |
| Go (Golang) | 155,000                  |

### 5) Most optimal skills to learn (high demand + high salary)

```sql
SELECT
    sd.skill_id,
    sd.skills AS skill_name,
    COUNT(*) AS demand_count,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact jpf
JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skill_id
HAVING COUNT(*) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 10;
```

| Skill      | Demand Count | Avg Salary (USD, Yearly) |
| ---------- | ------------ | ------------------------ |
| Kafka      | 40           | 129,999                  |
| PyTorch    | 20           | 125,226                  |
| Perl       | 20           | 124,686                  |
| TensorFlow | 24           | 120,647                  |
| Cassandra  | 11           | 118,407                  |

---

## 📝 What I Learned

- Strengthened ability to write complex SQL queries with joins, subqueries, and CTEs
- Learned how to connect **business questions** with **technical SQL solutions**
- Improved understanding of the **data job market** and its skill requirements
- Gained experience in structuring a data project and documenting results clearly

---

## ✅ Conclusions

- SQL is powerful for answering real hiring questions and extracting business value
- Certain skills (e.g., SQL, Python, Excel) dominate in demand, but niche skills can carry higher pay
- The most valuable skills to learn are those that balance **market demand** with **salary growth**
- This project reflects practical data analysis skills employers look for in entry-level Data Analysts

---

## 🙏 Acknowledgments

This project was inspired by the **PostgreSQL Data Analyst Portfolio Project** from [Luke Barousse](https://www.youtube.com/@LukeBarousse) on YouTube.  
Big thanks to him for providing the dataset and guiding structure - I adapted the project to strengthen my SQL skills and add my own insights.
