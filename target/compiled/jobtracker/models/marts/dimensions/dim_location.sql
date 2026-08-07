SELECT DISTINCT
    md5(cast(coalesce(cast(job_city as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(job_state as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(job_country as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS location_sk,
    job_city,
    job_state,
    job_country
FROM (
    SELECT
        COALESCE(job_city, 'Unknown') AS job_city,
        COALESCE(job_state, 'Unknown') AS job_state,
        COALESCE(job_country, 'Unknown') AS job_country
    FROM JOB_DB.INTERMEDIATE.int_jobs
) src