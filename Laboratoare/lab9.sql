create table angajati_abi(
    cod_ang number(4), nume varchar2(20), prenume varchar2(20), email char(15), data_ang date,
    job varchar2(10), cod_sef number(4), salariu number(8, 2), cod_dep number(2)
);
desc angajati_abi;
drop table angajati_abi;
create table angajati_abi(
    cod_ang number(4) primary key, nume varchar2(20) not null, prenume varchar2(20), email char(15),
    data_ang date default sysdate, job varchar2(10), cod_sef number(4), salariu number(8, 2) not null,
    cod_dep number(2)
);
create table angajati_abi(
    cod_ang number(4) constraint pk_angajati_abi primary key,
    nume varchar2(20) constraint nn_nume_ang_abi not null,
    prenume varchar2(20), email char(15), data_ang date default sysdate, job varchar2(10), cod_sef number(4),
    salariu number(8, 2) constraint nn_sal_ang_abi not null, cod_dep number(2)
);

--2
insert into angajati_abi(cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, cod_dep)
values (100, 'Nume1', 'Prenume1', null, null, 'Director', null, 20000, 10);
insert into angajati_abi
values (101, 'Nume2', 'Prenume2', 'Nume2', '02-FEB-2014', 'Inginer', 100, 10000, 10);
insert into angajati_abi
values (102, 'Nume3', 'Prenume3', 'Nume3', '05-JUN-2010', 'Programator', 101, 5000, 20);
insert into angajati_abi(cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, cod_dep)
values (103, 'Nume4', 'Prenume4', null, null, 'Inginer', 100, 9000, 20);
insert into angajati_abi
values (104, 'Nume5', 'Prenume5', 'Nume5', null, 'Programator', 101, 3000, 30);
commit;
select * from angajati_abi;

--3
create table angajati10_abi as select * from angajati_abi where cod_dep = 10;
select * from angajati10_abi;
desc angajati10_abi;

--4
alter table angajati_abi
add comision number(4, 2);
desc angajati_abi;

--5
alter table angajati_abi
modify salariu number(4, 2);

--6
alter table angajati_abi
modify salariu default 1000;

--7
alter table angajati_abi
modify (comision number(2, 2), salariu number(10, 2));

--8
update angajati_abi
set comision = 0.1
where job like 'I%';
select * from angajati_abi;

--9
alter table angajati_abi
modify email varchar2(20);
select * from angajati_abi;

--10
alter table angajati_abi
add nr_telefon varchar2(13) default '0722222222';
desc angajati_abi;

--11
select * from angajati_abi;
alter table angajati_abi
drop column nr_telefon;

--12
rename angajati_abi to angajati3_abi;

--13
select * from tab;
rename angajati3_abi to angajati_abi;

--14
truncate table angajati10_abi;

--15
create table departamente_abi(
    cod_dep number(2), nume varchar2(15) not null, cod_director number(4)
);
desc departamente_abi;

--16
insert into departamente_abi values(10, 'Administrativ', 100);
insert into departamente_abi values(20, 'Proiectare', 101);
insert into departamente_abi values(30, 'Programator', null);

--17
alter table departamente_abi
add constraint pk_dep_abi primary key(cod_dep);

--18
alter table angajati_abi
add constraint fk_cod_dep_ang_abi foreign key (cod_dep) references departamente_abi(cod_dep);
drop table angajati_abi;
create table angajati_abi(
    cod_ang number(4) constraint pk_angajati_abi primary key,
    nume varchar2(20) constraint nn_nume_ang_abi not null, prenume varchar2(20), 
    email char(15) constraint u_email_ang_abi unique,  data_ang date default sysdate,  job varchar2(15), 
    cod_sef number(4) constraint fk_cod_sef_ang_abi references angajati_abi(cod_ang), 
    salariu number(8, 2) constraint nn_sal_ang_abi not null, comision number(2,2),
    cod_dep number(2) constraint ck_cod_dep_0_ang_abi check(cod_dep > 0)
                      constraint fk_cod_dep_ang_abi references departamente_abi(cod_dep),
    constraint u_nume_prenume_ang_abi unique(nume, prenume),
    constraint ck_sal_com_ang_abi check (salariu > comision *100)
);
desc angajati_abi;

--19
drop table angajati_abi;
create table angajati_abi(
    cod_ang number(4),
    nume varchar2(20) constraint nn_nume_ang_abi not null,
    prenume varchar2(20), 
    email char(15),
    data_ang date default sysdate, 
    job varchar2(15), 
    cod_sef number(4), 
    salariu number(8, 2) constraint nn_sal_ang_abi not null,
    comision number(2,2),
    cod_dep number(2),
    constraint pk_angajati_abi primary key(cod_ang),
    constraint u_nume_prenume_ang_abi unique(nume, prenume),
    constraint u_email_ang_abi unique(email),
    constraint fk_cod_sef_ang_abi foreign key(cod_sef) references angajati_abi(cod_ang),
    constraint ck_sal_com_ang_abi check (salariu > comision *100),
    constraint ck_cod_dep_0_ang_abi check(cod_dep > 0),
    constraint fk_cod_dep_ang_abi foreign key(cod_dep) references departamente_abi(cod_dep)
);
desc angajati_abi;

--20
insert into angajati_abi(cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, cod_dep)
values (100, 'Nume1', 'Prenume1', null, null, 'Director', null, 20000, 10);
insert into angajati_abi
values (101, 'Nume2', 'Prenume2', 'Nume2', '02-FEB-2014', 'Inginer', 100, 10000, null ,10);
insert into angajati_abi
values (102, 'Nume3', 'Prenume3', 'Nume3', '05-JUN-2010', 'Programator', 101, 5000, null, 20);
insert into angajati_abi(cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, cod_dep)
values (103, 'Nume4', 'Prenume4', null, null, 'Inginer', 100, 9000, 20);
insert into angajati_abi
values (104, 'Nume5', 'Prenume5', 'Nume5', null, 'Programator', 101, 3000, null, 30);
commit;
select * from angajati_abi;

--21
drop table departamente_abi;

--22
desc user_tables;
desc tab;
desc user_constraints;
select * from tab;
select table_name from user_tables order by table_name;

--23
select constraint_name, constraint_type, table_name
from user_constraints
where table_name in ('ANGAJATI_ABI', 'DEPARTAMENTE_ABI');

--b
desc user_cons_columns;
select table_name, constraint_name, column_name
from user_cons_columns
where table_name in ('ANGAJATI_ABI', 'DEPARTAMENTE_ABI');

SELECT uc.table_name, constraint_name, column_name, constraint_type, search_condition
FROM user_cons_columns ucc join user_constraints uc using (constraint_name)
WHERE LOWER(uc.table_name) IN ('angajati_abi', 'departamente_abi');

--24
desc angajati_abi;

update angajati_abi
set email = nume
where email is null;

alter table angajati_abi
modify email not null;

alter table angajati_abi
add constraint nn_email_ang_abi check (email is not null);

--25
insert into angajati_abi (cod_ang, nume, salariu, email, cod_dep) values (200, 'Nume200', 1000,
                            'Nume200', 50);
select * from departamente_abi;

--26
insert into departamente_abi values (60, 'Testare', null);
commit;

--27
delete from departamente_abi where cod_dep = 20;

--28
delete from departamente_abi where cod_dep = 60;
rollback;

--29
desc angajati_abi;
insert into angajati_abi(cod_ang, nume, email, cod_sef, salariu, cod_dep)
values (201, 'Nume201', 'Nume201', 114, 1000, 10);

--30
insert into angajati_abi(cod_ang, nume, email, salariu, cod_dep)
values (114, 'Nume114', 'Nume114', 1000, 10);
rollback;

--31
SELECT uc.table_name, constraint_name, column_name, constraint_type, search_condition
FROM user_cons_columns ucc join user_constraints uc using (constraint_name)
WHERE LOWER(uc.table_name) IN ('angajati_abi', 'departamente_abi');

alter table angajati_abi
drop constraint fk_cod_dep_ang_abi;

alter table angajati_abi
add constraint FK_COD_DEP_ANG_ABI foreign key(cod_dep) references departamente_abi(cod_dep) on delete cascade;

--32
delete from departamente_abi where cod_dep = 20;
select * from departamente_abi;
select * from angajati_abi;
rollback;

--33
alter table departamente_abi
add constraint fk_cod_director_dep_ang_abi foreign key(cod_director) references angajati_abi(cod_ang) on delete set null;

--34
update departamente_abi
set cod_director = 102
where cod_dep = 30;
commit;
delete from angajati_abi where cod_ang = 102;
select * from departamente_abi;
select * from angajati_abi;
rollback;
delete from angajati_abi where cod_ang = 101;

--35
alter table angajati_abi
add constraint ck_sal_30000_abi check(salariu <= 30000);

--36
update angajati_abi
set salariu = 35000
where cod_ang = 100;

--37
alter table angajati_abi
modify constraint ck_sal_30000_abi disable;
update angajati_abi
set salariu = 35000
where cod_ang = 100;
alter table angajati_abi
modify constraint ck_sal_30000_abi enable;





