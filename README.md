# Job Tracker Data Pipeline

An end-to-end cloud data engineering pipeline that extracts live job postings from the JSearch API (hosted by OpenWebNinja), lands raw data in Amazon S3, auto-ingests it into Snowflake via Snowpipe, and transforms it with dbt into analytics-ready models for viewing the percentage of skills appearing across Data Engineer / Analytics Engineer / BI Engineer job postings.

**Stack:** AWS Lambda · Amazon S3 · Snowflake · Snowpipe · dbt · Python · Airflow (planned)

## Overview

This project simulates a production-style ELT pipeline for job-market analytics. Job postings are pulled on a recurring basis (see Data Source), stored as raw JSON in S3, and automatically ingested into Snowflake using Snowpipe.

The pipeline is designed to accumulate history across ingestion runs (not a one-time load), which surfaces real-world data engineering challenges around identifier stability, deduplication, and slowly changing data — see [Key Engineering Decision](#key-engineering-decision-the-business-key) below.

## Architecture

See [docs/architecture.md](docs/architecture.md) for the full pipeline diagram, materialization strategy (view / incremental / table), and design rationale for the ingestion and transformation layers.

## Data Source

Job postings are pulled from the [JSearch API](https://www.openwebninja.com/) (hosted by OpenWebNinja), which aggregates public job listings from LinkedIn, Indeed, Glassdoor, ZipRecruiter, and others in real-time via Google for Jobs, filtered to data engineering and analytics engineering roles. Each API response is written to S3 as raw JSON, preserving the full payload for reprocessing if the transformation logic changes. The current API plan has a 200 requests/month quota, which constrains run frequency and query/page volume.

## Data Model / Star Schema

A job posting can require multiple skills, and a skill can appear across
many postings — a many-to-many relationship resolved with a bridge table.

- **`FACT_JOB_POSTING_SNAPSHOT`** — grain: one row per (posting, scrape
  date). A posting observed across multiple scrapes produces multiple rows,
  which enables `first_seen_date`, `last_seen_date`, and `is_active` to be
  derived via window functions rather than loaded directly.
- **`DIM_COMPANIES`**, **`DIM_LOCATIONS`**, **`DIM_SKILLS`** — dimensions
- **`BRIDGE_JOB_SKILLS`** — resolves the many-to-many relationship between
  postings and skills

![Star Schema](architecture/job_postings_star_schema.png)

Skill matching is driven by a seed file (`skill_lookup`:`skill_category`, `skill_name`,
`match_text`) mapping raw job-description text to a normalized skill
taxonomy, keyed off a surrogate key generated from `skill_name`.

## dbt Project Structure

```
models/
├── staging/
│   └── stg_jobs.sql          # 1:1 cleanup of raw VARIANT payload (view)
├── intermediate/
│   └── int_jobs.sql          # skill extraction / parsing logic (incremental, merge)
└── marts/
    ├── fact_job_posting_snapshot.sql
    ├── dim_companies.sql
    ├── dim_locations.sql
    ├── dim_skills.sql
    └── bridge_job_skills.sql
seeds/
└── skill_lookup.csv           # skill_category, skill_name, match_text
analyses/
├── skill_demand_by_role.sql
├── remote_roles.sql
└── postings_by_role.sql
```

## Key Engineering Decision: the business key
The source API provides a `job_uid`, but analysis of the source data showed that
`job_uid` is not globally unique across employers.

Rather than assuming the identifier was unique, the pipeline measured how often
the same `job_uid` appeared with multiple employers:

```sql
SELECT
    COUNT_IF(employer_count > 1)
        / NULLIF(COUNT(*), 0)::FLOAT AS multiple_employer_rate
FROM (
    SELECT
        job_uid,
        COUNT(DISTINCT employer_name) AS employer_count
    FROM {{ ref('int_jobs') }}
    WHERE job_uid IS NOT NULL
      AND employer_name IS NOT NULL
    GROUP BY job_uid
);
```
The analysis found that **2.57% of observed `job_uid`s were associated with
multiple employers**. Examples included related employer names such as
`State Street` / `State Street Global Advisors` and
`Amazon` / `Amazon.com Services LLC`.

This showed that using `job_uid` alone could potentially misattribute job
postings to employers.

## Key Engineering Decision: the business key

The source API provides a `job_uid`, but analysis of the source data showed
that `job_uid` is not globally unique across employers.

Rather than assuming the identifier was unique, the pipeline measured how
often the same `job_uid` appeared with multiple employers:

```sql
SELECT
    COUNT_IF(employer_count > 1)
        / NULLIF(COUNT(*), 0)::FLOAT AS multiple_employer_rate
FROM (
    SELECT
        job_uid,
        COUNT(DISTINCT employer_name) AS employer_count
    FROM {{ ref('int_jobs') }}
    WHERE job_uid IS NOT NULL
      AND employer_name IS NOT NULL
    GROUP BY job_uid
);
```

The analysis found that **2.57% of observed `job_uid`s were associated with
multiple employers**. Examples included related employer names such as
`State Street` / `State Street Global Advisors` and `Amazon` /
`Amazon.com Services LLC` — suggesting inconsistent employer-name formatting
across publishers rather than true `job_uid` reuse.

This showed that using `job_uid` alone could misattribute job postings to
employers.

Therefore, the pipeline uses **`job_uid + employer_name`** as the logical
business key for a job posting, generated as `job_posting_sk`

`int_jobs` is materialized as an incremental model (merge strategy) on
`job_uid, employer_name, scraped_at`, preserving one row per job per scrape
rather than collapsing to latest-state — this history is what powers
posting-active-duration analysis.

The fact table's row-level primary key, `fct_job_posting_sk`, extends this
further by combining `job_posting_sk` with the scrape timestamp, since the
fact grain is one row per posting *per scrape*, not per posting.


> **Ongoing data quality guardrail:** a dbt test monitors the percentage of
> `job_uid`s associated with multiple employers. The observed baseline is
> **2.57%**, and the test fails if the rate exceeds **3%** — a small
> tolerance for normal source-data variation while still catching further
> deterioration in the reliability of the source identifier.


## Analyses

- **Role Analysis** — postings by role, including **Total Observed Postings**:
  distinct postings captured across all snapshot runs, including inactive ones
![Number of postings by Role](docs/key_analysis/postings_per_role.png)
- **Skill Demand** — most-requested skills across postings *(caveat: BRIDGE_JOB_SKILLS is regex-matched against the `skill_lookup` seed (a manually curated skill taxonomy), so this measures "% of postings where the taxonomy detected the skill," not "% that truly require it" — descriptions phrased outside the match patterns are undercounted, and the taxonomy requires periodic updates as new technologies and synonyms
  emerge)*
![Skill Demand by Role](docs/key_analysis/skill_demand_per_role.png)
- **Remote Roles** — remote vs. on-site share/trend
![Remote Roles](docs/key_analysis/remote_postings.png)


> Company- and location-level cuts (`DIM_COMPANIES`, `DIM_LOCATIONS`) are modeled but not yet wired into an analysis — flagged under Future Enhancements.

## Setup

> Fill in with your actual commands/env vars before publishing.

1. Clone the repo and configure AWS credentials for the Lambda + S3 resources.
2. Set up a Snowflake account with a Snowpipe object pointed at the S3 bucket (via SQS event notification).
3. Configure `profiles.yml` with your Snowflake connection details.
4. Install dependencies and run dbt:
   ```bash
   dbt deps
   dbt seed
   dbt run
   dbt test
   ```

## Future Enhancements

- Add Airflow scheduler for recurring extraction + dbt runs
- Extend analyses to use `DIM_COMPANIES` and `DIM_LOCATIONS`
- Add avg_time_role_active analysis (posting active-duration, using int_jobs scrape history) — blocked this month by API quota, to resume once quota resets

---

Built as a portfolio project to demonstrate modern cloud data engineering practices using AWS, Snowflake, dbt, Python, and Git.
