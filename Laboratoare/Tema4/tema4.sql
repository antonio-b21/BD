--1
select s.s_last
from student s
join enrollment e on (e.s_id = s.s_id)
where e.grade is not null
group by s.s_last, s.s_id
having count(e.grade) = (select count(*)
                        from enrollment
                        where s_id = s.s_id);

--2
select l.bldg_code
from location l
where l.loc_id in ( select loc_id
                    from course_section)
group by l.bldg_code
having count(l.loc_id) = (select count(loc_id)
                        from location
                        where bldg_code = l.bldg_code);

--3
select f_id, f_last
from faculty f
where exists (  select 1
                from student s
                where f_id = f.f_id and exists (select 1
                                                from enrollment
                                                where grade like 'A' and s_id = s.s_id))
        and exists ( select 1
                    from course_section cs
                    join course c using (course_no)
                    where cs.f_id = f.f_id and c.course_name like 'Database%');

--4
select f_last
from faculty f
join course_section cs using (f_id)
join location l on (l.loc_id = cs.loc_id)
where cs.max_enrl = (select max(max_enrl) from course_section)
   or l.capacity = (select max(capacity) from location);

--5
select f_last
from faculty f
join location l using (loc_id)
where l.capacity = (select min(capacity) from location)
  and f_id in ( select cs.f_id
                from course_section cs
                where cs.loc_id in (select loc_id
                                    from location
                                    where capacity = (select max(capacity) from location))
                  and cs.max_enrl = (select min(max_enrl)
                                    from course_section cs
                                    where cs.loc_id in (select loc_id
                                                        from location
                                                        where capacity = (select max(capacity) from location))));

--6
select avg(capacity)
from location
where loc_id in (select distinct loc_id
                from location l
                join course_section cs using (loc_id)
                where cs.f_id = (select f_id from faculty where f_last = 'Marx'))
union
select avg(max_enrl)
from course_section
where c_sec_id in ( select distinct c_sec_id
                    from enrollment
                    join student using (s_id)
                    where s_last = 'Jones');

--7
select avg(l.capacity), l.bldg_code
from location l
where l.bldg_code in (  select bldg_code
                        from location
                        join course_section using (loc_id)
                        join course using (course_no)
                        where course_name like '%Systems%')
group by l.bldg_code;

--8
select avg(l.capacity)
from location l
where l.bldg_code in (  select bldg_code
                        from location
                        join course_section using (loc_id)
                        join course using (course_no)
                        where course_name like '%Systems%');

--9
select course_no, course_name
from course
where ( select count(*)
        from course
        where course_name like '%Java%') = 0
    or course_name like '%Java%';

--10
with cursuri as (select
                    case
                        when (  select count(loc_id)
                                from location
                                join course_section using (loc_id)
                                where course_no = c.course_no
                                  and capacity = 42) != 0
                        then 1
                        else 0
                    end CAPACITATE,
                    case
                        when (  select count(c_sec_id)
                                from course_section
                                where course_no = c.course_no
                                  and f_id = (  select f_id
                                                from faculty
                                                where f_last = 'Brown')) != 0
                        then 1
                        else 0
                    end BROWN,
                    case
                        when (  select count(c_sec_id)
                                from course_section
                                where course_no = c.course_no
                                  and c_sec_id in (select c_sec_id
                                                    from enrollment
                                                    where s_id = (select s_id
                                                                    from student
                                                                    where s_last = 'Jones'))) != 0
                        then 1
                        else 0
                    end JONES,
                    case
                        when (  select count(course_name)
                                from course
                                where course_no = c.course_no
                                  and course_name like '%Database%') != 0
                        then 1
                        else 0
                    end DATABASE,
                    case
                        when (  select count(term_desc)
                                from course_section
                                join term using (term_id)
                                where course_no = c.course_no
                                  and term_desc like '%2007%'
                                  and status = 'OPEN') != 0
                        then 1
                        else 0
                    end SEMESTRE2007,
                    course_no
                from course c group by course_no)
select *
from cursuri
natural join course
where capacitate + brown + jones + database + semestre2007 >= 3;

--11
with frecventa as  (select count(c_sec_id) nr, term_id
                    from course_section
                    join course using (course_no)
                    where course_name like '%Database%'
                    group by term_id
                    order by 1)
select distinct term_desc, (select nr from frecventa where rownum <= 1) NUMAR
from term
where term_id = (select term_id
                from frecventa
                where rownum <=1);


--12
with frecventa as  (select count(s_id) nr, grade
                    from enrollment
                    where grade is not null
                    group by grade
                    order by 1)
select distinct grade, (select nr from frecventa where rownum<=1) NUMAR
from enrollment
where grade = (select grade
                from frecventa
                where rownum <=1);

--13
select t.term_desc
from term t
join course_section cs using (term_id)
join course c using (course_no)
where credits = 3
group by term_desc
having count(course_no) = ( select max(count(course_no))
                            from term
                            join course_section using (term_id)
                            join course using (course_no)
                            where credits = 3
                            group by term_desc);

--14
select distinct cs.loc_id
from course_section cs
where cs.course_no in ( select course_no
                        from course c
                        where course_name like '%Database%')
intersect
select distinct cs.loc_id
from course_section cs
where cs.course_no in ( select course_no
                        from course c
                        where course_name like '%C++%');

--15
select l.bldg_code
from location l
group by l.bldg_code
having count(loc_id) < 2;