
    
    

select
    location_sk as unique_field,
    count(*) as n_records

from JOB_DB.MARTS.dim_location
where location_sk is not null
group by location_sk
having count(*) > 1


