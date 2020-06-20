--1
select e1.last_name Nume, to_char(e1.hire_date, 'month') Luna, 
to_char(e1.hire_date, 'yyyy') An
from employees e1, employees e2
where lower(e1.last_name) like '%a%' and e2.last_name = 'Gates' and 
e1.department_id = e2.department_id;
select e1.last_name Nume, to_char(e1.hire_date, 'month') Luna, 
to_char(e1.hire_date, 'yyyy') An
from employees e1
join employees e2 using (department_id)
where instr(lower(e1.last_name), 'a') != 0 and e2.last_name = 'Gates';

--2
select distinct e1.employee_id Ang#, e1.last_name Angajat, d.department_id Dep#, 
d.department_name Dep
from employees e1, departments d, employees e2
where e1.department_id = d.department_id 
    and e1.department_id = e2.department_id
    and instr(lower(e2.last_name), 't') != 0
order by 2;
select distinct e1.employee_id Ang#, e1.last_name Angajat, department_id Dep#, 
d.department_name Dep
from employees e1
join employees e2 using (department_id)
join departments d using (department_id)
where lower(e2.last_name) like '%t%'
order by 2;

--3
select e.last_name Angajat, e.salary Salariu, j.job_title Job, l.city Oras,
c.country_name Tara
from employees e, jobs j, departments d, locations l, countries c, employees m
where e.job_id = j.job_id
    and e.department_id = d.department_id(+)
    and d.location_id = l.location_id(+)
    and l.country_id = c.country_id(+)
    and e.manager_id = m.employee_id
    and m.last_name = 'King';
select e.last_name Angajat, e.salary Salariu, j.job_title Job, l.city Oras,
c.country_name Tara
from employees e
join jobs j using (job_id)
left join departments d using(department_id)
left join locations l using (location_id)
left join countries c using (country_id)
join employees m on (e.manager_id = m.employee_id)
where m.last_name = 'King';
select e.last_name Angajat, e.department_id
from employees e, employees m
where e.manager_id = m.employee_id
    and m.last_name = 'King';

--4
select d.department_id Dep#, d.department_name Departament, e.last_name Angajat, 
j.job_title Job, to_char(e.salary, '$999,999.00') Salariu
from employees e, departments d, jobs j
where e.department_id = d.department_id
    and e.job_id = j.job_id
    and lower(d.department_name) like '%ti%'
order by 2, 3;
select department_id Dep#, d.department_name Departament, e.last_name Angajat, 
j.job_title Job, to_char(e.salary, '$99,999.00') Salariu
from employees e
join departments d using (department_id)
join jobs j using (job_id)
where lower(d.department_name) like '%ti%'
order by 2, 3;


--5
select e.last_name Angajat, department_id Dep#, d.department_name Departament,
l.city Oras, j.job_title Job
from employees e
join departments d using (department_id)
join locations l using (location_id)
join jobs j using(job_id)
where l.city = 'Oxford';

--6
select distinct e1.employee_id Ang#, e1.last_name Angajat, 
e1.salary Salariu
from employees e1
join employees e2 using (department_id)
join departments d using (department_id)
join jobs j on (e1.job_id = j.job_id)
where lower(e2.last_name) like '%t%'
    and e1.salary > (j.max_salary + j.min_salary ) / 2
order by 2;


--7 
select e.last_name Angajat, d.department_name Departament
from employees e
left join departments d using (department_id);
select e.last_name Angajat, d.department_name Departament
from employees e, departments d
where e.department_id = d.department_id(+);

--8
select e.last_name Angajat, d.department_name Departament
from employees e
right join departments d using (department_id);
select e.last_name Angajat, d.department_name Departament
from employees e, departments d
where e.department_id(+) = d.department_id;

--9
select e.employee_id, e.last_name Angajat, d.department_name Departament
from employees e, departments d
where e.department_id = d.department_id(+)
union
select e.employee_id, e.last_name Angajat, d.department_name Departament
from employees e, departments d
where e.department_id(+) = d.department_id
order by 2, 1;
select e.last_name Angajat, d.department_name Departament
from employees e
full join departments d using (department_id)
order by 2, 1;

--10
select department_id Departament
from departments d
where lower(department_name) like '%re%'
union
select department_id Departament
from employees e
where job_id = 'SA_REP';

--11
select department_id Departament
from departments
minus
select department_id Departament
from employees;
select department_id Departament
from departments
where department_id not in (
    select department_id
    from employees
    where department_id is not null
    );

--12
select department_id Departament
from departments d
where lower(d.department_name) like '%re%'
intersect
select department_id Departament
from employees e
where e.job_id = 'HR_REP';


--13
select e.employee_id Ang#, e.job_id Job#, e.last_name Angajat
from employees e
where e.salary > 3000
union
select e.employee_id Ang#, job_id Job#, e.last_name Angajat
from employees e
join jobs j using (job_id)
where e.salary = (j.max_salary + j.min_salary) / 2;

--14
select distinct 'Departamentul ' || d.department_name || ' este condus de ' ||
nvl(to_char(d.manager_id), 'nimeni') || ' si ' || 
nvl2(to_char(employee_id),'are salariati','nu are salariati') Informatii
from departments d
left join employees e using (department_id);
select distinct 'Departamentul ' || d.department_name || ' este condus de ' ||
nvl(to_char(d.manager_id), 'nimeni') || ' si ' ||
decode(nvl(e.employee_id, -1), -1, 'nu are salariati', 'are salariati') Informatii
from departments d
left join employees e using (department_id);

--15
select last_name Nume, first_name Prenume, nullif(length(last_name), 
length(first_name)) Lungime
from employees;

--16
select last_name Nume, hire_date Angajare, salary Salariu, 
decode(to_char(hire_date, 'yyyy'), '1989', salary * 1.20, '1990', 
salary * 1.15, '1991', salary * 1.10, salary) Salariu2
from employees;
select last_name Nume, hire_date Angajare, salary Salariu, 
(case to_char(hire_date, 'yyyy')
    when '1989' then salary * 1.20
    when '1990' then salary * 1.15
    when '1991' then salary * 1.10
    else salary
end) Salariu2
from employees;
select last_name Nume, hire_date Angajare, salary Salariu, 
(case 
    when to_char(hire_date, 'yyyy') = '1989' then salary * 1.20
    when to_char(hire_date, 'yyyy') = '1990' then salary * 1.15
    when to_char(hire_date, 'yyyy') = '1991' then salary * 1.10
    else salary
end) Salariu2
from employees;