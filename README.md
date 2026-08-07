Job Tracker Data Pipeline
Overview

This project is an end-to-end data engineering pipeline that extracts job postings from the JSearch API, stores the raw JSON responses in Amazon S3, and automatically ingests them into Snowflake using Snowpipe. The data will be transformed into analytics-ready models using dbt.

Technologies
Python
AWS Lambda
Amazon S3
Snowflake
Snowpipe
dbt (work in progress)
Git & GitHub

Project Structure
job-tracker-data-pipeline/
│
├── lambda/          # AWS Lambda extraction code
├── sql/             # Snowflake SQL scripts
├── architecture/    # Architecture diagrams
├── sample_data/     # Sample API response
├── docs/            # Project documentation
├── README.md
├── .gitignore
└── requirements.txt

Current Status

Completed:

Extract job postings from the JSearch API using AWS Lambda
Store raw JSON files in Amazon S3
Automatically ingest files into Snowflake using Snowpipe
Store raw data as VARIANT in Snowflake
Preserve source ingestion and Snowflake load metadata

In Progress:

Build dbt staging and mart models
Add data quality tests
Create dashboards
Repository Contents
lambda/ – Python code for extracting job data and writing raw JSON files to Amazon S3.
sql/ – Snowflake scripts for creating the database, storage integration, stage, file format, raw tables, manual load process, and Snowpipe.

STAR SCHEMA
A job posting can require multiple skills, and a skill can appear in many job postings. This many-to-many relationship is modeled using the BRIDGE_JOB_SKILLS table.
![Star Schema](architecture/job_postings_star_schema.png)

Future Enhancements
Build dbt transformations
Add incremental models
Implement data quality tests
Add CI/CD with GitHub Actions
Create monitoring and alerting
Build analytics dashboards
Author

This project was built as a portfolio project to demonstrate modern cloud data engineering using AWS, Snowflake, dbt, Python, and Git.