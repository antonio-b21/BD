--1
select s.s_id COD, s.s_first || ' ' || s.s_last "STUDENT SAU CURS", 'STUDENT' TIP
from student s
where s.f_id = (select f_id from faculty where f_last = 'Brown')
union
select c.course_no COD, c.course_name "STUDENT SAU CURS", 'CURS' TIP
from course c
where c.course_no in (select course_no
                      from course_section 
                      where f_id = (select f_id from faculty where f_last = 'Brown'));


--2
select distinct s_id COD, s.s_first || ' ' || s.s_last NUME
from student s
join enrollment using (s_id)
join course_section cs using (c_sec_id)
where cs.course_no in (select course_no
                       from course c
                       where c.course_name = 'Database Management'
                       minus
                       select course_no
                       from course c
                       where c.course_name = 'Programming in C++');

--3
select distinct s.s_id COD, s.s_first || ' ' || s.s_last NUME
from student s
where s.s_id in (select distinct s_id from enrollment where grade = 'C' or grade is null);

--4
select l.loc_id, l.bldg_code, l.capacity
from location l
where l.capacity = (select max(capacity) from location);

--5
select min(t.id)+1 VAL
from t t
where t.id+1 not in (select id from t)
union
select max(t.id)-1 VAL
from t t
where t.id-1 not in (select id from t);

--6 --gresit
select f_id "cod profesor", f_last "nume profesor",
    case
        when (select count(distinct s_id)
              from enrollment
              join course_section using (c_sec_id)
              join faculty using (f_id)
              where f_id = f.f_id) != 0
        then 'Da(' || (select count(distinct s_id)
                       from enrollment
                       join course_section using (c_sec_id)
                       join faculty using (f_id)
                       where f_id = f.f_id) || ')'
        when (select count(distinct s_id)
              from enrollment
              join course_section using (c_sec_id)
              join faculty using (f_id)
              where f_id = f.f_id) = 0
        then 'Nu'
    end "student",
    case
        when (select count(distinct course_no)
              from course_section
              join faculty using (f_id)
              where f_id = f.f_id) != 0
        then 'Da(' || (select count(distinct course_no)
                       from course_section
                       join faculty using (f_id)
                       where f_id = f.f_id) || ')'
        when (select count(distinct course_no)
              from course_section
              join faculty using (f_id)
              where f_id = f.f_id) != 0
        then 'Nu'
    end "curs"
from faculty f
group by f_id, f_last, 1;

--7
select t1.term_desc, t2.term_desc
from term t1, term t2
where substr(t1.term_desc, 1, length(t1.term_desc)-1) = substr(t2.term_desc, 1, length(t2.term_desc)-1)
  and substr(t1.term_desc, -1) != substr(t2.term_desc, -1)
  and t1.term_id <= t2.term_id;

--8
with participation as (select s_id, course_no
                      from enrollment e
                      join course_section cs using (c_sec_id)
                      join course c using (course_no))
select distinct s_id--, p1.course_no, p2.course_no
from participation p1 join participation p2 using (s_id)
where substr(p1.course_no, 1) != substr(p2.course_no, 1)
  and p1.course_no < p2.course_no;

--9
select distinct c1.course_no, c2.course_no
from course_section c1, course_section c2
where c1.term_id = c2.term_id
  and c1.course_no > c2.course_no;

--10
select distinct course_no, c.course_name, t.term_desc, cs.max_enrl
from course c
join course_section cs using (course_no)
join term t using (term_id)
where cs.max_enrl < all (select max_enrl from course_section where loc_id = 1);

--11
select distinct course_name, max_enrl
from course c
join course_section cs using (course_no)
where max_enrl = (select min(max_enrl) from course_section);

--12
select f.f_last,
    round((select avg(max_enrl) from  course_section where f_id = f.f_id))
from faculty f;

--13
select f.f_last, count(s.s_id)
from faculty f
join student s using (f_id)
group by f.f_last
having count(s.s_id) >= 3;

--14
select distinct c.course_name, l.capacity, loc_id
from location l
join course_section cs using (loc_id)
join course c using (course_no)
order by 1, 2;

--15

select term_id, avg(max_enrl)
from term t
join course_section cs using (term_id)
where term_desc like '%2007'
group by term_id;

