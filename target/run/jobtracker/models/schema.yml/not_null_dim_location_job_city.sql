
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select job_city
from JOB_DB.MARTS.dim_location
where job_city is null



  
  
      
    ) dbt_internal_test