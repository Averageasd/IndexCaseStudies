--Another Example of Left Anti Semi Join

select CustomerID,StoreID,TerritoryID from Sales.Customer where CustomerID=22222
select CustomerID,OrderDate,DueDate,ShipDate from Sales.SalesOrderHeader where CustomerID=22222


--Correlated SubQuery

select c.CustomerID,c.StoreID,c.TerritoryID from Sales.Customer c   --Customers who don't have details in SalesOrderHeader
where
not exists(
select 1 from Sales.SalesOrderHeader h
where h.CustomerID=c.CustomerID)