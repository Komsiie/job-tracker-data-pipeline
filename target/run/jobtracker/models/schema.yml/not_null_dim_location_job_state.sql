
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select job_state
from JOB_DB.MARTS.dim_location
where job_state is null



  
  
      
    ) dbt_internal_test