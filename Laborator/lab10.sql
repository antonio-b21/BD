--1
desc emp_abi;
create or replace view viz_emp30_abi as
    select employee_id, last_name, email, salary from emp_abi where department_id = 30;
desc viz_emp30_abi;
select * from viz_emp30_abi;
insert into viz_emp30_abi values(300, 'Nume300', 'Nume300', 1234);

--2
create or replace view viz_emp30_abi as
    select employee_id, last_name, email, salary, hire_date, job_id from emp_abi where department_id = 30;
insert into viz_emp30_abi values(300, 'Nume300', 'Nume300', 1234, sysdate, 'IT_PROG');
select * from viz_emp30_abi;
select * from emp_abi;

update viz_emp30_abi
set hire_date = hire_date - 15
where employee_id = 300;

update emp_abi
set department_id = 30
where employee_id = 300;

update viz_emp30_abi
set hire_date = hire_date - 15
where employee_id = 300;

delete from viz_emp30_abi where employee_id = 300;

--3
create or replace view viz_empsal50_abi as
    select employee_id, last_name, email, job_id, hire_date, salary*12 annual_sal from emp_abi where department_id = 50;
desc viz_empsal50_abi;
select * from viz_empsal50_abi;

--4
insert into viz_empsal50_abi values(302, 'nume302', 'nume302', 'IT_PROG', sysdate, 12000);
--b
desc user_updatable_columns;
select * from user_updatable_columns where table_name = 'VIZ_EMPSAL50_ABI';
--c
insert into viz_empsal50_abi(employee_id, last_name, email, job_id, hire_date)
values(302, 'nume302', 'nume302', 'IT_PROG', sysdate);
--d
select * from viz_empsal50_abi where employee_id = 302;
select * from emp_abi where employee_id = 302;

--5
create or replace view viz_emp_dep30_abi as
    select e.*, d.department_name
    from emp_abi e
    join dept_abi d on (e.department_id = d.department_id)
    where e.department_id = 30;
select * from viz_emp_dep30_abi;

select uc.table_name, constraint_name, column_name, constraint_type, search_condition
from user_cons_columns ucc
join user_constraints uc using (constraint_name)
where uc.table_name IN ('EMP_ABI'); 
--b
desc viz_emp_dep30_abi;
insert into viz_emp_dep30_abi(employee_id, last_name, email, phone_number, hire_date, job_id, department_id, department_name)
values(303, 'nume303', 'nume303', 34567, sysdate, 'IT_PROG', 40, 'Testare');
--c
select * from user_updatable_columns where table_name = 'VIZ_EMP_DEP30_ABI';
insert into viz_emp_dep30_abi(employee_id, last_name, email, phone_number, hire_date, job_id, department_id)
values(303, 'nume303', 'nume303', 34567, sysdate, 'IT_PROG', 40);
--d
select * from emp_abi;
delete from viz_emp_dep30_abi where employee_id = 303;

--6
create or replace view viz_dept_sum_abi(department_id, min_salary, max_salary, avg_salary) as
    select department_id, min(salary), max(salary), round(avg(salary), 2) from emp_abi group by department_id; 
select * from viz_dept_sum_abi;

--7
create or replace view viz_emp30_abi as
    select employee_id, last_name, email, salary, hire_date, job_id, department_id
    from emp_abi
    where department_id = 30
    with check option constraint ck_dep_viz_emp30_abi;
desc user_constraints;
select * from user_constraints where table_name = upper('viz_emp30_abi');
desc viz_emp30_abi;
insert into viz_emp30_abi values(301, 'Nume301', 'Nume301', 123456, sysdate, 'IT_PROG', 1);

--8
create or replace view viz_emp_s_abi as
    select *
    from emp_abi
    where department_id in (select department_id from dept_abi where department_name like 'S%');
select * from viz_emp_s_abi;
select * from user_updatable_columns where table_name = upper('viz_emp_s_abi');
--var 2
create or replace view viz_emp_s_abi as
    select e.*
    from emp_abi e
    join dept_abi d on (e.department_id = d.department_id)
    where department_name like 'S%';
select * from viz_emp_s_abi;
select * from user_updatable_columns where table_name = upper('viz_emp_s_abi');

select * from dept_abi;
desc viz_emp_s_abi;
insert into viz_emp_s_abi(employee_id, last_name, email, hire_date, job_id, department_id)
values (210, 'nume210', 'nume210', sysdate, 'IT_PROG', 50);
delete from viz_emp_s_abi where employee_id = 210;
--b
create or replace view viz_emp_s_abi as
    select *
    from emp_abi
    where department_id in (select department_id from dept_abi where department_name like 'S%')
    with read only;
insert into viz_emp_s_abi(employee_id, last_name, email, hire_date, job_id, department_id)
values (210, 'nume210', 'nume210', sysdate, 'IT_PROG', 50);
delete from viz_emp_s_abi where employee_id = 210;

--9
select * from user_views where view_name like '%ABI';

--10
select last_name, salary, department_id,
    (select max(salary) from emp_abi where department_id = e.department_id) max_salary
from emp_abi e;

--11
create or replace view viz_sal_abi as
    select last_name, department_name, salary, city
    from employees e
    join departments d using (department_id)
    join locations l using (location_id);
select * from viz_sal_abi;
select * from user_updatable_columns where table_name = upper('viz_sal_abi');

--12
create or replace view v_emp_abi
    (employee_id primary key disable novalidate, first_name, last_name,
    email unique disable novalidate, phone_number)
as select employee_id, last_name, first_name, email, phone_number
    from emp_abi;
select * from v_emp_abi;
--b
select * from viz_emp_s_abi;
create or replace view viz_emp_s_abi
    (employee_id primary key disable novalidate, first_name, last_name, email, phone_number,
    hire_date, job_id, salary, commission_pct, manager_id, department_id)
as select *
    from emp_abi
    where department_id in (select department_id from dept_abi where department_name like 'S%')
    with read only;

--secvente
select * from user_sequences;
select * from all_sequences;
select * from dba_sequences;--nu merge
select departments_seq.nextval from dual;
select departments_seq.currval from dual;