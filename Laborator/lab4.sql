--1
select e.last_name NUME, e.hire_date ANJGAJARE
from employees e
where e.hire_date > (select hire_date
                        from employees
                        where last_name = 'Gates');
--2
select e.last_name NUME, e.salary SALARIU
from employees e
where e.last_name <> 'Gates'
    and e.department_id = (select department_id
                                from employees
                                where last_name = 'Gates');
--3
select e.last_name NUME, e.salary SALARIU
from employees e
where manager_id = (select employee_id
                        from employees
                        where manager_id is null);
--4
select e.last_name NUME, e.department_id DEPARTAMENT, e.salary SALARIU
from employees e
where (e.department_id, e.salary) in (select department_id, salary
                                        from employees
                                        where commission_pct is not null);
--5
select e.employee_id COD, e.last_name NUME, e.salary SALARIU
from employees e
where e.salary > (select (j.min_salary + j.max_salary) / 2
                    from jobs j
                    where j.job_id = e.job_id)
    and e.department_id in (select department_id
                                from employees
                                where lower(last_name) like '%t%');
--6
select *
from employees e
where e.salary > ALL (select salary
                        from employees
                        where job_id like '%CLERK%')
order by salary desc;
--7
select e.last_name NUME,
    (select department_name from departments d where d.department_id = e.department_id) DEPARTAMENT,
    e.salary SALARIU
from employees e
where e.commission_pct is null
    and (select m.commission_pct from employees m where m.employee_id = e.manager_id) is not null;
--8
select e.last_name NUME,
    (select department_name from departments where department_id = e.department_id) DEPARTAMENT,
    nvl(e.salary, 0) SALARIU,
    (select job_title from jobs where job_id = e.job_id) JOB
from employees e
where (nvl(e.salary, 0), nvl(e.commission_pct, 0)) in 
        (select nvl(salary, 0), nvl(commission_pct, 0)
            from employees
            where department_id in 
                    (select department_id
                        from departments
                        where location_id in
                                (select location_id
                                    from locations
                                    where city = 'Oxford')));
--9
select e.last_name NUME, e.department_id DEPARTAMENT, e.job_id JOB
from employees e
where e.department_id in
        (select department_id
            from departments
            where location_id in
                    (select location_id
                        from locations
                        where city = 'Toronto'));
--10

--11
select max(e.salary) MAXIM, min(e.salary) MINIM, sum(e.salary) SUMA, round(avg(e.salary)) MEDIA, count(*)
from employees e;
--12+13
select e.job_id JOB, max(e.salary) MAXIM, min(e.salary) MINIM, sum(e.salary) SUMA, round(avg(e.salary)) MEDIA, count(e.employee_id) ANGAJATI
from employees e
group by e.job_id;
--14             INCOMPLET
select distinct manager_id
from employees;
--15
select max(e.salary)-min(e.salary) DIFERENTA, e.department_id DEPARTAMENT
from employees e
group by e.department_id;
--16
select d.department_name DEPARTAMENT, l.city LOCATIE, count(e.employee_id) ANGAJATI, nvl(round(avg(e.salary)), 0) MEDIU
from employees e
right join departments d using (department_id)
join locations l using(location_id)
group by d.department_name, l.city, department_id;

--17
select e.employee_id COD, e.last_name NUME
from employees e
where e.salary > (select avg(salary) from employees)
order by e.salary desc;

--18
select e.manager_id SEF, min(e.salary) SALARIU
from employees e
where e.manager_id is not null
group by e.manager_id
having min(e.salary) > 1000
order by 2 desc;

--19
select department_id COD, d.department_name DEPARTMANET, max(e.salary) MAXIM
from employees e
join departments d using (department_id)
group by department_id, d.department_name
having max(e.salary) > 3000;

--20
select min(round(avg(e.salary))) from employees e group by e.job_id;

--21
select department_id COD, d.department_name DEPARTAMENT, nvl(sum(e.salary), 0) SALARII
from employees e
right join departments d using (department_id)
group by department_id, d.department_name;

--22
select max(round(avg(e.salary))) from employees e group by e.department_id;
--23
select job_id COD, j.job_title JOB, round(avg(e.salary)) MEDIU --asta e corecta
from employees e
join jobs j using (job_id)
group by job_id, j.job_title
having round(avg(e.salary)) = (select min(round(avg(salary))) 
                                from employees
                                group by job_id);


select j.job_id COD, j.job_title JOB, round(avg(e.salary)) MEDIU
from employees e
join jobs j on (e.job_id = j.job_id)
group by j.job_id, j.job_title
having round(avg(e.salary)) = (select min_salary from jobs where job_id = j.job_id)
order by 1;

select j.job_id COD, j.job_title JOB, round(j.max_salary - j.min_salary) MEDIU
from jobs j
where round(j.max_salary - j.min_salary) = 
    (select min(round(max_salary - min_salary)) from jobs);
--24
select round(avg(e.salary)) MEDIU
from employees e
having round(avg(e.salary)) > 2500;




