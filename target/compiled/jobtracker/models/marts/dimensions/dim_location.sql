WITH locations as(
    Select distinct
    TRIM(UPPER(COALESCE(job_city, 'Unknown'))) AS job_city,
    TRIM(UPPER(COALESCE(job_state, 'Unknown'))) As job_state,
    TRIM(UPPER(COALESCE(job_country, 'Unknown'))) As job_country
     FROM JOB_DB.INTERMEDIATE.int_jobs
)
Select 
md5(cast(coalesce(cast(job_city as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(job_state as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(job_country as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as location_sk,
    job_city,
    job_state,
    job_country
from locations