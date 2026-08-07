
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Every distinct (city, state, country) combo — including partial nulls —
-- present in int_jobs should have a row in dim_location.
With source_combo as(
    Select distinct
    coalesce(job_city, 'Unknown') as job_city,
    coalesce(job_state, 'Unknown') as job_state,
    coalesce(job_country, 'Unknown') as job_country

    from JOB_DB.INTERMEDIATE.int_jobs
),
dim_combo as(
    Select distinct job_city, job_state, job_country
    from JOB_DB.MARTS.dim_location
)
Select 
    s.*
from source_combo s
left join dim_combo l
    on s.job_city = l.job_city
    and s.job_state = l.job_state
    and s.job_country = l.job_country
where l.job_city is null
  
  
      
    ) dbt_internal_test