--1a
select e.last_name, e.salary, e.department_id
from employees e
where e.salary > (select avg(salary)
                  from employees
                  where department_id = e.department_id)
order by 3, 2;

--1b
select e.department_id, d.department_name, e.last_name, e.salary,
    (select round(avg(salary), 1) from employees where department_id = e.department_id) AVG_SALARY,
    (select count(employee_id) from employees where department_id = e.department_id) EMPLOYEES
from employees e
join departments d on (d.department_id = e.department_id)
where e.salary > (select avg(salary)
                  from employees
                  where department_id = e.department_id)
order by 1, 4;

select e.department_id, d.department_name, e.last_name, e.salary, d2.avg_salary, d2.employees
from employees e
join departments d on (d.department_id = e.department_id)
join (select department_id, round(avg(salary), 1) avg_salary, count(employee_id) employees
      from employees
      group by department_id) d2 on (d2.department_id = e.department_id)
where e.salary > (select avg(salary)
                  from employees
                  where department_id = e.department_id)
order by 1, 4;

--2
select e.last_name, e.salary
from employees e
where e.salary > all (select avg(salary)
                      from employees
                      group by department_id);

select e.last_name, e.salary
from employees e
where e.salary > (select max(avg(salary))
                  from employees
                  group by department_id);

--3
select e.last_name, e.salary
from employees e
where e.salary = (select min(salary)
                  from employees
                  where department_id = e.department_id)
order by e.employee_id;

select e.last_name, e.salary
from employees e
where (e.department_id, e.salary) in (select department_id, min(salary)
                                      from employees
                                      group by department_id)
order by e.employee_id;

select e.last_name, s.salary
from employees e
join (select department_id, min(salary) salary
      from employees
      group by department_id) s on (s.department_id = e.department_id and s.salary = e.salary)
order by e.employee_id;

--4
select d.department_name, e.last_name
from departments d
join employees e using (department_id)
where (department_id, e.hire_date) in (select department_id, min(hire_date)
                                       from employees
                                       group by department_id)
order by 1;

select d.department_name, e.last_name
from departments d
join employees e on (e.department_id = d.department_id)
where e.hire_date = (select min(hire_date)
                      from employees
                      where department_id = e.department_id)
order by 1;

--5
select e.last_name, e.salary, e.department_id
from employees e
where exists (select distinct 1
              from employees
              where department_id = e.department_id
                and salary = (select max(salary)
                              from employees
                              where department_id = 30))
order by e.department_id, e.salary;

--6
select e.last_name, e.salary
from employees e
where (select count(distinct salary)
        from employees
        where salary > e.salary) < 3;

--7
select e.employee_id, e.last_name, e.first_name
from employees e
where (select count(employee_id)
        from employees
        where manager_id = e.employee_id) >= 2;

--8
select l.city
from locations l
where (select count(department_id)
        from departments d
        where location_id = l.location_id) >= 1;

select l.city
from locations l
where l.location_id in (select distinct location_id
                        from departments);
select l.city
from locations l
where exists (select 1
              from departments d
              where location_id = l.location_id);

--9
select department_id
from departments d
where not exists (select 1
                  from employees
                  where department_id = d.department_id);

--10
WITH val_dep AS (select department_name, sum(salary) total
                 from employees join departments using (department_id)
                 group by department_id, department_name),
val_medie AS (select avg(total) medie from val_dep)
select *
from val_dep
where total > (select medie
               from val_medie)
order by department_name;

--11
with kings_subalterns as (select *
                         from employees
                         where manager_id = (select employee_id
                                             from employees
                                             where last_name = 'King' and first_name = 'Steven')),
     senior_subalterns as (select employee_id
                              from kings_subalterns
                              where hire_date = (select min(hire_date)
                                                 from kings_subalterns))
select employee_id, last_name || ', ' || first_name, hire_date
from employees
where manager_id in (select employee_id
                     from senior_subalterns);


--12
with t1 as (select * from (select * from employees order by salary desc) where rownum <= 7)
select employee_id, last_name, salary 
from employees
where salary >= (select min(salary) from t1)
order by salary desc ;

--13
with job_avg_sal as (select job_id, avg(salary) avg_sal
                     from employees
                     group by job_id
                     order by 2)
select j.job_title, j2.avg_sal
from jobs j
join (select * from job_avg_sal where rownum <= 3) j2 using (job_id)
order by 2;

--14
select e.job_id,
    case
        when e.job_id like 'S%' then (select sum(salary) from employees where job_id = e.job_id)
        when job_id in (select job_id from employees where salary = (select max(salary) from employees)) then avg(salary)
        else (select min(salary) from employees where job_id = e.job_id)
    end Calcul
from employees e
group by e.job_id;




