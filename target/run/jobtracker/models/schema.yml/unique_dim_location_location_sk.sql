
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    location_sk as unique_field,
    count(*) as n_records

from JOB_DB.MARTS.dim_location
where location_sk is not null
group by location_sk
having count(*) > 1



  
  
      
    ) dbt_internal_test