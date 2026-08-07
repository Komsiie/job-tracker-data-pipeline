
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select skill_category
from JOB_DB.STAGING.skill_lookup
where skill_category is null



  
  
      
    ) dbt_internal_test