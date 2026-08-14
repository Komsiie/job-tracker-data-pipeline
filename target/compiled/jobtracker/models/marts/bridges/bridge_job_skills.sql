select
distinct j.job_posting_sk,
md5(cast(coalesce(cast(s.skill_name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as skill_sk

from JOB_DB.INTERMEDIATE.int_jobs j
join JOB_DB.STAGING.skill_lookup s
    on regexp_like(j.job_description, '.*\\b' || lower(s.match_text) || '\\b.*', 'is')