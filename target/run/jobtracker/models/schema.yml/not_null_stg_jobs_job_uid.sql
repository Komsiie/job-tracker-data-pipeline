
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select job_uid
from JOB_DB.STAGING.stg_jobs
where job_uid is null



  
  
      
    ) dbt_internal_test