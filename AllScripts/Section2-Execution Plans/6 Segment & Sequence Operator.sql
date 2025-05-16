use AdventureWorks2022
go

select top(1000) ProductID,LineTotal into Demo
from Sales.SalesOrderDetail

select  RANK() over (partition by ProductID order by LineTotal) as LineTotalRank,ProductID,LineTotal 
from  Demo

drop table Demo