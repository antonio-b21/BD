--1
select concat(first_name || ' ', last_name) || ' castiga ' || 
        salary || ' lunar dar doreste ' || salary*3 as "Salariu ideal" 
from employees;
--2
 select initcap(first_name), upper(last_name), length(last_name)
 from employees
 where lower(last_name) like 'j%' or lower(last_name) like 'm%'
        or lower(last_name) like '__a%'
 order by 3 desc;
  select initcap(first_name), upper(last_name), length(last_name)
 from employees
 where substr(lower(last_name), 1, 1)='j' or substr(lower(last_name), 1, 1)='m'
        or substr(lower(last_name), 3, 1)='a'
 order by 3 desc;
 --3
 select employee_id, last_name, department_id
 from employees
 where trim(both ' ' from lower(first_name))='steven';
 --4
 select employee_id Cod, last_name Nume, length(last_name) "Lungime nume",
 instr(lower(last_name), 'a') Pozitie
 from employees
 where substr(lower(last_name), -1)='e';
 --5
 select *
 from employees
 where mod(floor(sysdate - hire_date), 7)=0;
  select *
 from employees
 where to_char(sysdate, 'd') = to_char(hire_date, 'd');
 --6
 select employee_id, last_name, salary, round(salary*(1.15), 2) "Salariu nou",
 round(salary*(1.15/100), 2) "numar sute"
 from employees
 where mod(salary, 1000)!=0;
 --7
 select last_name "Nume angajat", rpad(hire_date, 20) "Data angajarii"
 from employees
 where commission_pct is not null;
 --8
 select to_char(sysdate + 30, 'mon.dd.yyyy hh24:mi:ss') from dual;
 --9
 select to_date('01-01-'||(to_number(to_char(sysdate, 'yyyy'))+1),
 'dd-mm-yyyy') - trunc(sysdate+1)
 from dual;
 --10
 select to_char(sysdate + 1/24*12, 'dd.mm.yyyy hh24:mi:ss')
 from dual;
 select to_char(sysdate + 1/24/60*5, 'dd.mm.yyyy hh24:mi:ss')
 from dual;
 --11
 select last_name || ' ' || first_name Nume, hire_date "DATA ANGAJARE",
 next_day(add_months(hire_date, 6), 'luni') Negociere
 from employees;
 --12
 select last_name NUME, 
 round(months_between(sysdate, hire_date)) "LUNI LUCRATE"
 from employees
 order by 2;
 --13
 select last_name NUME, hire_date "DATA ANGAJARII",
 to_char(hire_date, 'DAY') ZI
 from employees
 order by to_char(hire_date, 'D');
 --14
 select last_name NUME, 
 NVL(to_char(commission_pct), 'Nu are comision') COMISION
 from employees;
 --15
 select last_name NUME, salary SALARIU, commission_pct COMISION
 from employees
 where salary * (1 + NVL(commission_pct, 0)) > 10000
 order by salary * (1 + NVL(commission_pct, 0));
 --16
 select last_name NUME, job_id "COD JOB", salary SALARIU, 
 decode(upper(job_id), 'IT_PROG', salary * 1.2, 'SA_REP', 
 salary * 1.25, 'SA_MAN', salary * 1.35, salary) "SALARIU RENEGOCIAT"
 from employees
 order by 4;
 --17
 select e.last_name NUME, e.department_id "CODUL DEPARTAMENTULUI", 
 d.department_name "NUME DEPARTAMENT"
 from employees e, departments d
 where e.department_id = d.department_id;
 --18
 select distinct e.job_id "COD JOB", j.job_title "DENUMIRE JOB"
 from employees e, jobs j
 where e.department_id = 30 and e.job_id = j.job_id;
 --19
 select e.last_name NUME, d.department_name DEPARTAMENT, l.city ORAS
 from employees e, departments d, locations l
 where e.commission_pct is not null 
    and e.department_id = d.department_id
    and d.location_id = l.location_id;
 --20
 select e.last_name NUME, d.department_name DEPARTAMENT
 from employees e, departments d
 where lower(e.last_name) like '%a%' 
    and e.department_id = d.department_id;
 --21
 select e.last_name Nume, j.job_title Job, d.department_name Departament
 from employees e, jobs j, departments d, locations l
 where e.job_id = j.job_id 
    and e.department_id = d.department_id 
    and d.location_id = l.location_id 
    and l.city = 'Oxford';
 select e.last_name Nume, j.job_title Job, d.department_name Departament
 from employees e
 join jobs j using (job_id)
 join departments d using (department_id)
 join locations l using (location_id)
 where l.city = 'Oxford';
 --22
 select e.employee_id Ang#, e.last_name Angajat, m.employee_id Mgr#,
 m.last_name Manager
 from employees e, employees m
 where e.manager_id = m.employee_id;
 --23
 select e.employee_id Ang#, e.last_name Angajat, m.employee_id Mgr#,
 m.last_name Manager
 from employees e, employees m
 where e.manager_id = m.employee_id(+);
 --24
 select e1.last_name Nume, e1.department_id Departament, e2.last_name Colegi
 from employees e1, employees e2
 where e1.department_id = e2.department_id(+) 
    and e1.employee_id != e2.employee_id
 order by e1.employee_id;
 --25
 select e.last_name Nume, j.job_id Job#, j.job_title Job, 
 d.department_name Departament, e.salary
 from employees e, jobs j, departments d
 where e.job_id = j.job_id and e.department_id = d.department_id(+);
 --26
 select e1.last_name Nume, e1.hire_date Angajare
 from employees e1, employees e2
 where lower(e2.last_name) = 'gates' and e1.hire_date > e2.hire_date
 order by 2;
 select * from employees where lower(last_name) = 'gates';
 --27
 select e1.last_name Angajat, e1.hire_Date Data_ang, e2.last_name Manager,
 e2.hire_date Data_mgr
 from employees e1, employees e2
 where e1.manager_id = e2.employee_id and e1.hire_date < e2.hire_date
 order by e1.employee_id;