
    
    

select
    employer_sk as unique_field,
    count(*) as n_records

from JOB_DB.MARTS.dim_employer
where employer_sk is not null
group by employer_sk
having count(*) > 1


