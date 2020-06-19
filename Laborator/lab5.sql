--1
select department_id, job_id, sum(salary)
from employees
group by department_id, job_id
order by 1, 2;

--2
select department_id, d.department_name, job_id, j.job_title, sum(salary)
from employees e join departments d using (department_id) join jobs j using(job_id)
group by department_id, d.department_name, job_id, j.job_title
order by 1, 3;

--3
select d.department_name, min(e.salary)
from employees e join departments d using (department_id)
group by d.department_name
having avg(e.salary) = (
                        select max(avg(salary))
                        from employees
                        group by department_id
                        );
                        
--4
select department_id, d.department_name, count(e.employee_id)
from employees e right join departments d using(department_id)
group by department_id, d.department_name
having count(e.employee_id) <= 4;

select department_id, d.department_name, count(e.employee_id)
from employees e right join departments d using(department_id)
group by department_id, d.department_name
having count(e.employee_id) = (
                                select max(count(employee_id))
                                from employees
                                group by department_id
                                );
                                
--5
select employee_id
from employees
where to_char(hire_date, 'dd') = (  select to_char(hire_date, 'dd')
                                    from employees
                                    group by to_char(hire_date, 'dd')
                                    having count(*) = ( select max(count(*))
                                                        from employees
                                                        group by to_char(hire_date, 'dd')
                                                        )
                                    );
--6
select count(count(department_id))
from employees
group by department_id
having count(employee_id) >= 15;

--7
select department_id, sum(salary)
from employees
where department_id != 30
group by department_id
having count(employee_id) > 10
order by department_id;

--9
select l.city, d.department_name, j.job_title, nvl(sum(e.salary), 0)
from jobs j
join employees e using(job_id)
right join departments d using (department_id)
join locations l using (location_id)
where department_id > 80
group by l.city, d.department_name, j.job_title;

--10
select employee_id, e.last_name
from employees e
join job_history h using (employee_id)
group by employee_id, e.last_name
having count(distinct h.job_id) >= 2
order by 1;

--11
select round(avg(nvl(e.commission_pct, 0)), 3)
from employees e;

--12
select j.job_title JOB,
    sum(decode(e.department_id, 30, e.salary, 0)) DEP30,
    sum(decode(e.department_id, 50, e.salary, 0)) DEP50,
    sum(decode(e.department_id, 80, e.salary, 0)) DEP80,
    sum(e.salary) TOTAL
from jobs j
join employees e using (job_id)
group by j.job_title, job_id;

--13
select count(e.employee_id) TOTAL,
    count(decode(to_char(e.hire_date, 'yyyy'), 1997, e.employee_id)) A1997,
    count(decode(to_char(e.hire_date, 'yyyy'), 1998, e.employee_id)) A1998,
    count(decode(to_char(e.hire_date, 'yyyy'), 1999, e.employee_id)) A1999,
    count(decode(to_char(e.hire_date, 'yyyy'), 2000, e.employee_id)) A2000
from employees e;

--14
select department_id, d.department_name, d2.total_salary
from departments d
natural join (select e.department_id, sum(e.salary) total_salary
              from employees e
              group by e.department_id) d2;

--15
select j.job_title, j2.avg_salary,
    (j.min_salary + j.max_salary)/2 - j2.avg_salary DIFFERENCE
from jobs j
natural join (select job_id, avg(salary) avg_salary
              from employees
              group by job_id) j2;

--16
select j.job_title, j2.employees, j2.avg_salary,
    (j.min_salary + j.max_salary)/2 - j2.avg_salary DIFFERENCE
from jobs j
natural join (select job_id, avg(salary) avg_salary, count(employee_id) employees
              from employees
              group by job_id) j2;

--17
select d.department_name, e.last_name, d2.min_salary
from departments d
join employees e on (e.department_id = d.department_id)
join (select department_id, min(salary) min_salary
      from employees
      group by department_id) d2 on (d2.department_id = d.department_id and d2.min_salary = e.salary);


