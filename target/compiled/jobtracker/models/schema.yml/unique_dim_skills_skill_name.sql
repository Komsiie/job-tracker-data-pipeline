
    
    

select
    skill_name as unique_field,
    count(*) as n_records

from JOB_DB.MARTS.dim_skills
where skill_name is not null
group by skill_name
having count(*) > 1


