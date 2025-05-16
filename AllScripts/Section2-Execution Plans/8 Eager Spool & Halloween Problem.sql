use tempDB
go

create table EmployeeUpdate
(
   EmpID int primary key,
   EmpName varchar(50),
   EmpSalary int
)

create index IX_EmployeeUpdate_EmpSalary on EmployeeUpdate(EmpSalary)

insert into EmployeeUpdate (EmpID,EmpName,EmpSalary) values
(1,'Alan',40000),(2,'Harry',38000),(3,'Gary',60000),(4,'Mike',50000)

update e set EmpSalary=EmpSalary+(EmpSalary*0.1)
from EmployeeUpdate e
with(INDEX (IX_EmployeeUpdate_EmpSalary))

select * from EmployeeUpdate

drop table EmployeeUpdate