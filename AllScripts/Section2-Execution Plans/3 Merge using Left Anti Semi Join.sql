--Another Example of Left Anti Semi Join

select CustomerID,StoreID,TerritoryID from Sales.Customer where CustomerID=22222
select CustomerID,OrderDate,DueDate,ShipDate from Sales.SalesOrderHeader where CustomerID=22222


--Correlated SubQuery
--since there is a huge amount of data and both
--derviced tables are sorted (outer sorted by clustered index key customer id, inner sorted by non-clustered index
--customer id this is because we traverse non-clustered index customer id to find
--matching customers)

--use merge instead of nested loop because we deal
--with a lot of data
--left anti semi join because we find rows in left
--table but not in right table

--stream aggregate because we de-duplicate rows
--from sorted table

--index scan and finally merge join 2 sorted tables
--together is just way more efficient instead of doing
--nested loop index seek for each record from outer table
select c.CustomerID,c.StoreID,c.TerritoryID from Sales.Customer c   --Customers who don't have details in SalesOrderHeader
where
not exists(
select 1 from Sales.SalesOrderHeader h
where h.CustomerID=c.CustomerID)