
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select skill_sk as from_field
    from JOB_DB.MARTS.bridge_job_skills
    where skill_sk is not null
),

parent as (
    select skill_sk as to_field
    from JOB_DB.MARTS.dim_skills
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test