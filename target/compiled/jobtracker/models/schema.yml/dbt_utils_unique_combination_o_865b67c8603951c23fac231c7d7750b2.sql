





with validation_errors as (

    select
        job_posting_sk, skill_sk
    from JOB_DB.MARTS.bridge_job_skills
    group by job_posting_sk, skill_sk
    having count(*) > 1

)

select *
from validation_errors


