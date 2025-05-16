use AdventureWorks2022
go

select top(1000) ProductID,LineTotal into Demo
from [Sales].[SalesOrderDetail]

select  productid,LineTotal from Demo ORDER BY ProductID

--ALL PRODUCTS WHICH HAVE LINETOTAL LESS THAN THEIR AVERAGE LINETOTAL
select a.ProductID,a.LineTotal from Demo a
where LineTotal <=
(
    select AVG(b.LineTotal) from Demo b
	where b.ProductID=a.ProductID
)
go

drop table Demo
