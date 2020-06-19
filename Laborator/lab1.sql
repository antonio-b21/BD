--5
select employee_id, last_name, job_id, hire_date from employees;
--6
select employee_id as cod, last_name as nume, job_id as "cod job", hire_date as "data angajarii" from employees;
--7
select distinct job_id from employees order by job_id;
--8
select first_name || ' ' || last_name || ', ' || job_id as "Angajat si titlu" from employees;
--10
select first_name, last_name, salary from employees where salary > 2850 order by salary;
--11
select first_name, last_name, department_id from employees where employee_id = 104;
--12
select first_name, salary from employees where salary not between 1500 and 2850;
--13
select first_name, job_id, hire_date from employees where hire_date between '20-02-1987' and '1-05-1989' order by hire_date;
--14
select first_name, department_id from employees where department_id in (10, 30, 50) order by first_name;
--16
select TO_CHAR(sysdate, 'DD-MM-YY-SSSSS') as "Data si ora" from dual;
--17
select first_name, hire_date from employees where hire_date like ('%87%');
select first_name, hire_date from employees where to_char(hire_date, 'YYYY')=1987;
select first_name, hire_date from employees where extract(year from hire_date)=1987;
--18
    select first_name, hire_date from employees where to_char(hire_Date, 'MM')=to_char(sysdate, 'MM');
--19
select first_name, employee_id from employees where manager_id is null;
--20
select first_name, salary, commission_pct from employees where commission_pct is not null order by salary desc, commission_pct desc;
--21
select first_name, salary, commission_pct from employees order by salary desc, commission_pct desc;
--22
select first_name from employees where lower(first_name) like ('__a%');
--23
select first_name from employees where (lower(first_name) like('%l%l%') and (department_id='30' or manager_id='102')); 
--24
select first_name, job_id, salary from employees where ((job_id like('%CLERK%') or job_id like('%REP%')) and salary not in (1000, 2000, 3000));
--25
select department_name from departments where manager_id is null;