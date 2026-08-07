
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select job_posting_sk
from JOB_DB.MARTS.bridge_job_skills
where job_posting_sk is null



  
  
      
    ) dbt_internal_test