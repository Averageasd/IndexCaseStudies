use tempdb
go


 create table DEPARTMENT
 (Departmentid int  primary key,
  Departmentname varchar(20))
  go

  create table GeographyTable
  (
     Geographyid int  primary key,
	 City varchar(50),
	 State varchar(50)
  )
  go

create table employee
(id int identity primary key,
 name varchar(50),
 gender char(1) not null check (gender in ('M','F')),
 DeptID int not null foreign key references DEPARTMENT(Departmentid),
 GeogID int not null foreign key references GeographyTable(Geographyid)
 )
 go

 insert into department(Departmentid,Departmentname) values (1,'IT')

 insert into GeographyTable (Geographyid,City,State) values(1,'Udaipur','Rajasthan')
 go

 --You can now check the execution plan of the following command
 insert into employee (name,gender,DeptID,GeogID) values('Alan','M',1,1)
 go
   

select * from employee
select * from GeographyTable
go

 --You can now check the execution plan of the following command
delete from geographytable where Geographyid=1
go

drop table employee
drop table GeographyTable
drop table DEPARTMENT