-- Create external stage for raw job files in Amazon S3
CREATE STAGE IF NOT EXISTS JOB_DB.RAW.JOB_EXTSTAGE
    STORAGE_INTEGRATION = JOB_INTEGRATION
    URL = 's3://job-tracker-sia/raw/jobs/'
    FILE_FORMAT = JOB_DB.RAW.JSON_FORMAT;