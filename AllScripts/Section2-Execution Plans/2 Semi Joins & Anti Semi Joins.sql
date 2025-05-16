use tempdb
go


CREATE TABLE [dbo].[table1](
	[EmpID] [int] PRIMARY KEY,
	[EmpName] [varchar](50) NULL
) 

GO

insert into table1(empid,empname) values (1,'vikas'),(2,'ashish'),(3,'manoj') 

CREATE TABLE [dbo].[table2](
	[EmpID] [int] PRIMARY KEY,
	[EmpName] [varchar](50) NULL
) 

GO

insert into table2(empid,empname) values (4,'alok'),(2,'ashish'),(5,'rajat')

select * from table1
select * from table2


select * from table1
intersect
select * from table2


select * from table1
select * from table2

select * from table1
except
select * from table2



DROP TABLE TABLE1
DROP TABLE TABLE2