-- Creates a Snowflake storage integration for the S3 bucket
CREATE STORAGE INTEGRATION IF NOT EXISTS job_integration
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<AWS_ACCOUNT_ID>:role/job_tracker_role'
STORAGE_ALLOWED_LOCATIONS = ('s3://job-tracker-sia/raw/jobs/');