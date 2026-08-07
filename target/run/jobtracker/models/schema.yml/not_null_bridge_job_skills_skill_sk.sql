
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select skill_sk
from JOB_DB.MARTS.bridge_job_skills
where skill_sk is null



  
  
      
    ) dbt_internal_test