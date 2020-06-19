--I
--1
select count(*)
from employees
where last_name like 'K%';

--2
select employee_id, last_name, first_name, salary
from employees
where salary = (
                select min(salary)
                from employees
                );

--3
select distinct m.employee_id, m.last_name
from employees e
join employees m on (e.manager_id = m.employee_id)
where e.department_id = 30
order by 2;

--4
select m.employee_id, m.last_name, m.first_name, count(e.employee_id)
from employees e
join employees m on (e.manager_id = m.employee_id)
group by m.employee_id, m.last_name, m.first_name;

--5
select distinct e.employee_id, e.last_name, e.first_name
from employees e
join employees c on (e.last_name = c.last_name and e.employee_id != c.employee_id)
order by 1;

--6
select distinct department_id, d.department_name
from departments d
join employees e using (department_id)
group by department_id, d.department_name
having count(distinct e.job_id) >= 2;

--II
--7
select prod_id, sum(o.qty)
from orders_tbl o
natural join products_tbl p
where p.prod_desc like '%PLASTIC%'
group by prod_id;


--8
select e.first_name || ' ' || e.last_name, 'ANGAJAT'
from employee_tbl e
union
select c.cust_name, 'CLIENT'
from customer_tbl c
order by 2, 1;

--9
select distinct p.prod_desc
from products_tbl p
natural join orders_tbl o
where o.sales_rep in (  select distinct sales_rep
                        from orders_tbl
                        natural join products_tbl
                        where prod_desc like '% %'
                          and substr(prod_desc, instr(prod_desc, ' ')+1) like 'P%'
                        );

--10
select distinct c.cust_name
from customer_tbl c
natural join orders_tbl o
where to_char(o.ord_date, 'dd') = 17;

--11
select e.last_name, e.first_name, s.salary, s.bonus
from employee_tbl e
natural join employee_pay_tbl s
where ( case
        when nvl(s.salary, 0) > nvl(s.bonus, 0)*17 then s.salary
        when nvl(s.bonus, 0)*17 > nvl(s.salary, 0) then s.bonus*17
        else 0
        end) < 32000;

--12
select e.last_name, sum(o.qty)
from employee_tbl e
left join orders_tbl o on (e.emp_id = o.sales_rep)
group by e.last_name, e.emp_id
having sum(o.qty) > 50;

--13
select e.last_name, s.salary, max(o.ord_date)
from employee_tbl e
natural join employee_pay_tbl s
join orders_tbl o on (emp_id = o.sales_rep)
group by e.last_name, s.salary
having count(o.ord_date) >= 2;

--14
select p.prod_desc
from products_tbl p
where p.cost  > (select avg(cost)
                from products_tbl
                );

--15
select e.last_name, e.first_name, s.salary, s.bonus,
    (select sum(salary) from employee_pay_tbl) "TOTAL SALARY",
    (select sum(bonus) from employee_pay_tbl) "TOTAL BONUS"
from employee_tbl e
natural join employee_pay_tbl s;

--16
select distinct e.city
from employee_tbl e
join orders_tbl o on (o.sales_rep = e.emp_id)
group by e.city, e.emp_id
having count(e.emp_id) = (  select max(count(*))
                            from orders_tbl
                            group by sales_rep);

--17
select e.emp_id, e.last_name,
    count(decode(to_char(o.ord_date, 'mm'),  9, o.sales_rep, null)) SEP,
    count(decode(to_char(o.ord_date, 'mm'), 10, o.sales_rep, null)) OCT
from employee_tbl e
left join orders_tbl o on (e.emp_id = o.sales_rep)
group by e.emp_id, e.last_name;

--18
select c.cust_name, c.cust_city, c.cust_zip
from customer_tbl c
left join orders_tbl o using (cust_id)
where regexp_like(c.cust_zip, '^[0-9]')
  and o.ord_num is null;

--19
select distinct e.emp_id EID, e.last_name || ' ' || e.first_name ENAME, e.city ECITY,
                c.cust_id CID, c.cust_name CNAME, c.cust_city CCITY
from employee_tbl e
join orders_tbl o on (o.sales_rep = e.emp_id)
join customer_tbl c on (c.cust_id = o.cust_id and e.city != c.cust_city);

--20
select avg(nvl(salary, 0))
from employee_pay_tbl;

--21
SELECT CUST_ID, CUST_NAME
FROM  CUSTOMER_TBL              -- este corecta deoarece ord_num este unic si deci 
WHERE CUST_ID = (SELECT CUST_ID -- nu este nevoie de in in loc de =
                FROM ORDERS_TBL
                WHERE ORD_NUM = '16C17');


SELECT EMP_ID, SALARY
FROM EMPLOYEE_PAY_TBL
WHERE SALARY BETWEEN '20000' AND (  SELECT SALARY    -- este gresita
                                    FROM EMPLOYEE_ID -- trebuia FROM EMPLOYEE_PAY_TBL
                                    WHERE SALARY = '40000');

--22
select e.last_name, s.pay_rate
from employee_tbl e
natural join employee_pay_tbl s
where s.pay_rate > all (select s.pay_rate -- sau max(s.pay_rate) in loc de all
                        from employee_pay_tbl s
                        natural join employee_tbl e
                        where e.last_name like '%LL%');
