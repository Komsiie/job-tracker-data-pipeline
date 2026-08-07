Select DISTINCT
md5(cast(coalesce(cast(skill_name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))as skill_sk,
skill_name,
skill_category

from JOB_DB.STAGING.skill_lookup
    where skill_name is not null
    AND TRIM(skill_name)<>''