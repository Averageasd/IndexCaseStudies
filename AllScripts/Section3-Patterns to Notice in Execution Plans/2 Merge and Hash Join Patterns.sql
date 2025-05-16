--Points to note in Merge Join and  Hash Join
use AdventureWorks2022
go

select * into DemoCustomer from Sales.Customer 
go

select * into DemoOrderHeader from  Sales.SalesOrderHeader 
go

update statistics DemoCustomer with rowcount=500, pagecount=10 
update statistics DemoOrderHeader with rowcount=500, pagecount=10
go

--Merge Join Example
select * from DemoCustomer c inner merge join DemoOrderHeader o on c.CustomerID=o.CustomerID
option (maxdop 1)
go

--HAsh Join Example
select * from DemoCustomer c inner hash join DemoOrderHeader o on c.CustomerID=o.CustomerID
go

drop table DemoCustomer
drop table DemoOrderHeader


