
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select employer_name
from JOB_DB.MARTS.dim_employer
where employer_name is null



  
  
      
    ) dbt_internal_test