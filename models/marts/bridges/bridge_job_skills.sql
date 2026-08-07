Select 
distinct j.job_posting_sk,
{{dbt_utils.generate_surrogate_key(['s.skill_name'])}}as skill_sk

from {{ref('int_jobs')}} j
join {{ref('skill_lookup')}} s
    on lower(j.job_description) like '%' || lower(s.match_text) || '%'