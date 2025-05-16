--Parallelism - A single sql statement will be executed by multiple processors

use AdventureWorks2022
go

select * from 
Sales.SalesOrderDetail s inner join Production.Product p
on p.ProductID=s.ProductID
order by unitprice desc
go

sp_configure
go

sp_configure 'show advanced options',1
reconfigure
go

sp_configure
go