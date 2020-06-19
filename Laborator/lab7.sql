--1 metoda 1
select distinct employee_id
from works_on a
where not exists (select 1
                  from project p
                  where to_char(start_date, 'yyyy') = '2006' and to_char(start_date, 'mm') <=6 and not exists (select 'x'
                                                                                                               from works_on b
                                                                                                               where p.project_id=b.project_id and b.employee_id=a.employee_id))
and exists (select 1
            from project p
            where to_char(start_date, 'yyyy') = '2006' and to_char(start_date, 'mm') <=6);                                                                                              

--metoda 2
select distinct employee_id
from works_on
where project_id in (select project_id
                     from project
                     where to_char(start_date, 'yyyy') = '2006' and to_char(start_date, 'mm') <=6)
group by employee_id
having count(project_id) = (select count(*)
                            from project
                            where to_char(start_date, 'yyyy') = '2006' and to_char(start_date, 'mm') <=6);

--metoda 4
select distinct employee_id
from works_on a
where not exists (select project_id
                  from project
                  where to_char(start_date, 'yyyy') = '2006' and to_char(start_date, 'mm') <=6
                  minus
                  select project_id
                  from project p join works_on b using(project_id)
                  where b.employee_id = a.employee_id)
and exists (select 1
            from project p
            where to_char(start_date, 'yyyy') = '2006' and to_char(start_date, 'mm') <=6); 

--2 metoda 1
select *
from project p
where not exists (select 1
                  from works_on a
                  where employee_id in (select employee_id
                                        from job_history
                                        group by employee_id
                                        having count(distinct job_id) = 2)
                    and not exists (select 1
                                    from works_on b
                                    where p.project_id = b.project_id and b.employee_id = a.employee_id))
and exists (select employee_id
            from job_history
            group by employee_id
            having count(distinct job_id) = 2);

--metoda 2
select project_id, project_name
from  project
join works_on a using (project_id)
where employee_id  in (select employee_id
                       from job_history
                       group by employee_id
                       having count( distinct job_id)=2)
group by project_id, project_name                               	
having count(employee_id) = (select count(*)
                             from (select employee_id
                                   from job_history
                                   group by employee_id
                                   having count( distinct job_id)=2));

--metoda 3
select project_id , project_name
from project p
where not exists (select employee_id
                  from job_history
                  group by employee_id
                  having count( distinct job_id)=2
                  minus
                  select employee_id
                  from works_on
                  where project_id=p.project_id);   

--3
select count(count(employee_id))
from (select employee_id, job_id
      from employees
      union
      select employee_id, job_id
      from job_history)
group by employee_id 
having count(distinct job_id) >= 3;

--4
select country_name, count(employee_id)
from employees e
right join departments d using(department_id)
right join locations l using (location_id)
right join countries c using (country_id)
group by country_id, country_name;

--5
select employee_id, e.last_name
from employees e
join works_on a using(employee_id)
join project p using(project_id)
where p.delivery_date > p.deadline
group by employee_id, e.last_name
having count(project_id) >= 2;

--6
select employee_id, w. project_id
from employees e
left join works_on w using (employee_id)
order by 1;

--7
select employee_id
from employees
where department_id in( select department_id
                    	from employees join project on(project_manager=employee_id));
select employee_id
from employees
where department_id in( select department_id
                    	from employees
                    	where employee_id in(select project_manager from project ));
select employee_id
from employees e
where exists ( select 1
        	from employees join project on(project_manager=employee_id)
        	where department_id=e.department_id);

--8 veronica
select employee_id
from employees
where nvl(department_id,-1) not in( select nvl(department_id,-1)
                                    from employees join project on(project_manager=employee_id));
select employee_id
from employees
where nvl(department_id,-1) not in( select nvl(department_id,-1)
                                    from employees
                                    where employee_id in(select project_manager from project ));
select employee_id
from employees e
where  not exists ( select 1
                    from employees join project on(project_manager=employee_id)
                    where department_id=e.department_id);

--9
select e.department_id
from employees e
group by department_id
having avg(e.salary) > &p;

--10
select e.last_name, e.first_name, e.salary, count(p.project_id)
from employees e
join project p on (e.employee_id = p.project_manager)
group by e.last_name, e.first_name, e.salary
having count(p.project_id) >= 2;

select e.last_name, e.first_name, e.salary, p.project_no
from employees e
join (select project_manager, count(project_id) project_no
      from project
      group by project_manager) p on (e.employee_id = p.project_manager)
where p.project_no >= 2;

--11
select distinct e.*
from employees e
join works_on w on (e.employee_id = w.employee_id)
where not exists (select project_id
                  from works_on
                  where employee_id = e.employee_id
                  minus
                  select project_id
                  from project
                  where project_manager = 102);

--12a
select distinct e.*
from employees e
join works_on w on (e.employee_id = w.employee_id)
where not exists (select project_id
                  from works_on
                  where employee_id = 200
                  minus
                  select project_id
                  from works_on
                  where employee_id = e.employee_id);

--12b
select distinct e.*
from employees e
join works_on w on (e.employee_id = w.employee_id)
where not exists (select project_id
                  from works_on
                  where employee_id = e.employee_id
                  minus
                  select project_id
                  from works_on
                  where employee_id = 200);

--13
select distinct e.*
from employees e
join works_on w on (e.employee_id = w.employee_id)
where not exists (select project_id
                  from works_on
                  where employee_id = 200
                  minus
                  select project_id
                  from works_on
                  where employee_id = e.employee_id)
  and not exists (select project_id
                  from works_on
                  where employee_id = e.employee_id
                  minus
                  select project_id
                  from works_on
                  where employee_id = 200);

--14a
desc job_grades;
select * from job_grades;

--14b
select e.employee_id, e.last_name, e.salary, j.grade_level
from employees e
join job_grades j on (salary between lowest_sal and highest_sal)
order by 3, 1;

--15 --desc

--16
show linesize;
show pagesize;

--17
I.
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &p_cod;
II.
DEFINE p_cod = 170;
define p_cod;
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &p_cod;
UNDEFINE p_cod;
III.
DEFINE p_cod=100;
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &&p_cod;
UNDEFINE p_cod;
IV.
ACCEPT p_cod PROMPT "cod= ";
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &p_cod;

--18
accept p_job prompt "Cod job: ";
select e.last_name, e.department_id, e.salary*12
from employees e
where e.job_id = '&p_job';

--19
accept p_date prompt "Data (dd//mm/yyyy): ";
select e.last_name, e.department_id, e.salary*12
from employees e
where e.hire_date > to_date('&p_date', 'dd/mm/yyyy');







