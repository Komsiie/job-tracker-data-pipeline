-- Resume warehouse for manual loading
ALTER WAREHOUSE COMPUTE_WH RESUME;

-- Load existing files from the external stage
COPY INTO JOB_DB.JOB_SCHEMA.RAW_JOBS_API
(
    FILENAME,
    SOURCE_INGEST_TIMESTAMP,
    RAW_DATA
)
FROM
(
    SELECT
        METADATA$FILENAME,
        $1:metadata.source_ingest_timestamp::TIMESTAMP_TZ,
        $1
    FROM @JOB_DB.JOB_SCHEMA.JOB_EXTSTAGE
)
FILE_FORMAT = (
    FORMAT_NAME = JOB_DB.JOB_SCHEMA.JSON_FORMAT
);