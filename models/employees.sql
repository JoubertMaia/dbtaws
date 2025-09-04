with calc_employees as(
    Select 
    date_part (year,current_date) - date_part(year, birth_date) age,
    date_part (year,current_date) - date_part (year, hire_date) lenghtofservice,
    first_name || ' ' || last_name as name, *
    from {{ source('sources', 'employees') }}
)
Select * from calc_employees