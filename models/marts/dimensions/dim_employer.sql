Select DISTINCT
    {{dbt_utils.generate_surrogate_key(['employer_name'])}} as employer_sk,
    employer_name
from {{ref('int_jobs')}}
where employer_name is not null
    AND TRIM(employer_name)<> ''