
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select employer_sk
from JOB_DB.MARTS.dim_employer
where employer_sk is null



  
  
      
    ) dbt_internal_test