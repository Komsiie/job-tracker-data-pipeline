
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    employer_name as unique_field,
    count(*) as n_records

from JOB_DB.MARTS.dim_employer
where employer_name is not null
group by employer_name
having count(*) > 1



  
  
      
    ) dbt_internal_test