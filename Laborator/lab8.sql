--1
CREATE TABLE EMP_abi AS SELECT * FROM employees;
CREATE TABLE DEPT_abi AS SELECT * FROM departments;

--2
desc employees;
desc emp_abi;

desc departments;
desc dept_abi;

--3
select * from emp_abi;
select * from dept_abi;

--4
ALTER TABLE emp_abi
ADD CONSTRAINT pk_emp_abi PRIMARY KEY(employee_id);
ALTER TABLE dept_abi
ADD CONSTRAINT pk_dept_abi PRIMARY KEY(department_id);
ALTER TABLE emp_abi
ADD CONSTRAINT fk_emp_dept_abi FOREIGN KEY(department_id) REFERENCES dept_abi(department_id);

--5
INSERT INTO DEPT_abi
VALUES (300, 'Programare'); -- nu sunt suficiente coloane

INSERT INTO DEPT_abi (department_id, department_name)
VALUES (300, 'Programare'); -- pune null pe celelalte coloane

INSERT INTO DEPT_abi (department_name, department_id)
VALUES (300, 'Programare');

INSERT INTO DEPT_abi (department_id, department_name, location_id)
VALUES (300, 'Programare', null); -- e ok

INSERT INTO DEPT_abi (department_name, location_id)
VALUES ('Programare', null); -- nu insereaza si cheia primara

rollback;

--6
desc emp_abi;
insert into emp_abi
values(250, 'prenume1', 'nume1', 'nume1@mail.com', '12345', sysdate, 'ID_PROG', null, null, null, 300);
commit;

--7
insert into emp_abi (employee_id, last_name, email, hire_date, job_id, department_id)
values (251, 'nume2', 'nume2@mail.com', sysdate, 'IT_PROG', 300);
commit;
select * from emp_abi where employee_id >=250;

--8
insert into emp_abi (employee_id, last_name, email, hire_date, job_id, salary, commission_pct)
values (252, 'Nume252', 'nume252@emp.com', sysdate, 'SA_REP', 5000, null);

select employee_id, last_name, email, hire_date, job_id, salary, commission_pct
from emp_abi
where employee_id=252;
rollback;

insert into
    (select employee_id, last_name, email, hire_date, job_id, salary, commission_pct
     from emp_abi)
values (252, 'Nume252', 'nume252@emp.com', sysdate, 'SA_REP', 5000, null);

select employee_id, last_name, email, hire_date, job_id, salary, commission_pct
from emp_abi
where employee_id=252;
rollback;

insert into
    (select employee_id, last_name, email, hire_date, job_id, salary, commission_pct
     from emp_abi)
values ((select max(employee_id)+1 from emp_abi), 'Nume252', 'nume252@emp.com', sysdate, 'SA_REP', 5000, null);
rollback;

--9
with lastId as (select max(employee_id) id from emp_abi)
insert into
    (select employee_id, last_name, email, hire_date, job_id, salary, commission_pct
     from emp_abi)
values (select id + 1 from lastId, 'Nume252', 'nume252@emp.com', sysdate, 'SA_REP', 5000, null);

--10
create table emp1_abi as select * from employees where 1 = 0;
select *
from emp1_abi;
insert into emp1_abi
select *
from employees
where commission_pct > 0.25;
rollback;

--11
desc emp_abi;
insert into emp_abi
values (0, user, user, 'TOTAL', 'TOTAL', sysdate, 'TOTAL',
        (select sum(salary) from emp_abi),
        (select avg(commission_pct) from emp_abi), null ,null);
select * from emp_abi;
commit;
rollback;

--12
rem setari
rem comenzi accept
accept p_cod prompt 'Introduceti codul'
accept p_nume prompt 'Introduceti numele'
accept p_prenume prompt 'Introduceti prenumele'
accept p_salariu prompt 'Introduceti salariul'
insert into emp_abi
values(&p_cod, '&p_prenume', '&p_nume',  substr('&p_prenume', 1, 1) || substr('&p_nume', 1, 7),
        null, sysdate, 'IT_PROG', &p_salariu, null, null, null);
rem suprimarea variabilelor utilizate
rem anularea setarilor, prin stabilirea acestora la valorile implicite
rollback;

--13
create table emp2_abi as select * from employees where 1=0;
create table emp3_abi as select * from employees where 1=0;
insert all
when salary < 5000 then into emp1_abi
when 5000 <= salary and salary <= 10000 then into emp2_abi
when 10000 < salary then into emp3_abi
select  * from employees;
select * from emp3_abi;
delete from emp3_abi;

--14
create table emp0_abi as select * from employees where 1 = 0 ;
insert first
when department_id = 80 then into emp0_abi
when salary < 5000 then into emp1_abi
when 5000 <= salary and salary <= 10000 then into emp2_abi
when 10000 < salary then into emp3_abi
select  * from employees;
select * from emp3_abi;

--15
select * from emp_abi;
update emp_abi
set salary = salary * 1.05;
rollback;

--16
select * from emp_abi;
update emp_abi
set job_id = 'SA_REP'
where commission_pct is not null
  and department_id = 80;
rollback;

--17
select * from emp_abi where first_name = 'Douglas';
update emp_abi
set salary = salary + 1000
where first_name = 'Douglas';
update dept_abi
set manager_id = (select employee_id from emp_abi where first_name = 'Douglas')
where department_id = 20;

--18
select * from emp_abi order by salary;
update emp_abi e
set (salary, commission_pct) = (select salary, commission_pct from emp_abi where employee_id = e.manager_id)
where salary = (select min(salary) from emp_abi);
rollback;

--19
select * from emp_abi e where salary = (select max(salary) from employees where department_id = e.department_id);
update emp_abi e
set email = substr(last_name, 1 , 1) || nvl(first_name, '.')
where salary = (select max(salary) from employees where department_id = e.department_id);
rollback;

--20
select * from emp_abi where hire_date = (select min(hire_date) from employees);
update emp_abi
set salary = (select avg(salary) from emp_abi)
where hire_date = (select min(hire_date) from employees);
rollback;

--21
select * from emp_abi where employee_id = 114 or employee_id = 205;
update emp_abi
set (job_id, department_id) = (select job_id, department_id from emp_abi where employee_id = 205)
where employee_id = 114;
rollback;

--22
accept p_cod prompt 'Cod departament'
--bla bla bla

--23
delete from dept_abi;
delete from emp_abi where department_id is not null;
rollback;

--24
select * from emp_abi;
delete from emp_abi where commission_pct is null;
rollback;

--25
delete from dept_abi
where department_id not in (select distinct nvl(department_id, 1000) from emp_abi);
rollback;

--26
accept p_cod prompt 'Cod angajat'
select * from emp_abi where employee_id = &p_cod;
delete from emp_abi where employee_id = &p_cod;
rollback;

--29
savepoint p;
delete from emp_abi;
select * from emp_abi;
rollback to p;
commit;
