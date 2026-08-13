WITH employers as(
    SELECT DISTINCT 
        TRIM(UPPER(COALESCE(employer_name, 'Unknown'))) as employer_name
    from JOB_DB.INTERMEDIATE.int_jobs
)
Select 
md5(cast(coalesce(cast(employer_name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as employer_sk,
employer_name,
from employers