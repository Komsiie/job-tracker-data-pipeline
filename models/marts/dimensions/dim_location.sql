SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key([
        'job_city',
        'job_state',
        'job_country'
    ]) }} AS location_sk,
    job_city,
    job_state,
    job_country
FROM (
    SELECT
        COALESCE(job_city, 'Unknown') AS job_city,
        COALESCE(job_state, 'Unknown') AS job_state,
        COALESCE(job_country, 'Unknown') AS job_country
    FROM {{ ref('int_jobs') }}
) src
