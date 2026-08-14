select
distinct j.job_posting_sk,
{{ dbt_utils.generate_surrogate_key(['s.skill_name']) }} as skill_sk

from {{ ref('int_jobs') }} j
join {{ ref('skill_lookup') }} s
    on regexp_like(j.job_description, '.*\\b' || lower(s.match_text) || '\\b.*', 'is')