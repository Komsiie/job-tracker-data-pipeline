Select DISTINCT
{{dbt_utils.generate_surrogate_key(['skill_name'])}}as skill_sk,
skill_name,
skill_category

from {{ref('skill_lookup')}}
    where skill_name is not null
    AND TRIM(skill_name)<>''