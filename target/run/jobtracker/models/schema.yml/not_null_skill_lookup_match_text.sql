
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select match_text
from JOB_DB.STAGING.skill_lookup
where match_text is null



  
  
      
    ) dbt_internal_test