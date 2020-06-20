--I.
--1. A) 1
--2. C) Catch_#22
--3. A) INSTR
--4. C) -
--5. '09-MAR-2009'
--6. 4-1
--7. C) LPAD

--II.
--1.
select emp_id COD, last_name NUME
from employee_tbl
where last_name like 'A%' or last_name like 'B%'
    and state in ('IN', 'OH', 'MI', 'IL')
order by 2;
--2.
--a)
select prod_id COD, prod_desc DESCRIERE, cost
from products_tbl
where cost between 1 and 12.50;
--b)
select prod_id COD, prod_desc DESCRIERE, cost
from products_tbl
where cost not between 1 and 12.50;
--3.
select lower(first_name) || '.' || lower(last_name) || '@ittech.com' "ADRESA DE EMAIL"
from employee_tbl;
--4.
select upper(last_name) || ', ' || upper(first_name) NAME, 
    floor(emp_id/1000000) || '-' || mod(floor(emp_id/10000), 100) || '-' || mod(emp_id,10000) EMP_ID,
    '(' || floor(phone/10000000) || ')' || mod(floor(phone/10000), 1000) || '-' || mod(phone, 10000) PHONE
from employee_tbl;
--5.
select emp_id COD, to_char(date_hire, 'yyyy') "AN ANGAJARE"
from employee_pay_tbl;
--6.
select emp_id COD, e.last_name NUME, e.first_name PRENUME, ep.salary SALARIU, ep.bonus BONUS
from employee_tbl e
natural join employee_pay_tbl ep;
--7.
select c.cust_name "NUME CLIENT", o.ord_num "COD COMANDA", o.ord_date "DATA LANSARE"
from customer_tbl c
natural join orders_tbl o
where c.cust_state like 'I%';
--8.
select o.ord_num "NR COMANDA", o.qty CANTITATE, r.last_name NUME, r.first_name PRENUME, r.city ORAS
from orders_tbl o
join employee_tbl r on (o.sales_rep = r.emp_id);
--9.
select o.ord_num "NR COMANDA", o.qty CANTITATE, r.last_name NUME, r.first_name PRENUME, r.city ORAS
from orders_tbl o
right join employee_tbl r on (o.sales_rep = r.emp_id);
--10.
select *
from employee_tbl
where middle_name is null;
--11.
select emp_id SALARIAT, (NVL(bonus, 0)+salary)*12 "SALARIU ANUAL"
from employee_pay_tbl;
--12
select e.last_name NUME, ep.salary SALARIU, ep.position POZITIE,
salary*decode(ep.position, 'MARKETING', 1.1, 'SALESMAN', 1.15, 1)  "SALARIU MODIFICAT"
from employee_tbl e
natural join employee_pay_tbl ep;
select e.last_name NUME, ep.salary SALARIU, ep.position POZITIE,
    salary*(case ep.position 
        when 'MARKETING' then 1.1 
        when 'SALESMAN' then 1.15 
        else 1 
    end)  "SALARIU MODIFICAT"
from employee_tbl e
natural join employee_pay_tbl ep;



