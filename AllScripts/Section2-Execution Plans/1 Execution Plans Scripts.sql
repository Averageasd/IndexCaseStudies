--Heap Scan
select * from databaselog
select * from databaselog where [Schema]='HumanResources'

--Clustered Index Scan
select * from Production.Product

select * from Production.Product
where ListPrice=1364.50

--Clustered Index Seek
select * from Production.Product 
where ProductID=320

--Index Seek (Key LookUp)
select * from Production.Product where Name='Down Tube'

--Index Seek (RowID Lookup)
select * from databaselog where DatabaseLogID=31

--Wild Card is also supported
select * from Production.Product where Name like 'Mountain-500 Silver%'

--Index Scan
select * from Production.Product where Name like 'Mountain%'

--Sort
select * from [Production].[Product] order by ListPrice

select * from  [Production].[ProductSubcategory]
order by ProductSubcategoryID desc

select * from  [Production].[ProductSubcategory]
order by Name

select * from databaselog order by DatabaseLogID

--Joins
select sd.SalesOrderID,sd.OrderQty,sh.ShipMethodID,sh.CreditCardID 
from Sales.SalesOrderDetail  sd 
inner join Sales.SalesOrderHeader  sh 
ON sd.SalesOrderID = sh.SalesOrderID

select c.StoreID,c.TerritoryID,sh.ShipMethodID,sh.CreditCardID  
from Sales.SalesOrderHeader  sh 
inner join Sales.Customer  c
ON sh.CustomerID = c.CustomerID

select c.StoreID,c.TerritoryID,sh.CustomerID  
from Sales.SalesOrderHeader  sh 
inner join Sales.Customer  c
ON sh.CustomerID = c.CustomerID

select c.StoreID,c.TerritoryID,sh.ShipMethodID,sh.CreditCardID  
from Sales.SalesOrderHeader  sh 
inner join Sales.Customer  c
ON sh.CustomerID = c.CustomerID
where c.customerid=22222

--Compute Scalar
select  BusinessEntityID,upper(firstName +' '+ LastName)  as FullName
from [Person].[Person]
order by FullName

select  BusinessEntityID,upper(firstName +' '+ LastName)  as FullName
from [Person].[Person]
order by LastName,FirstName


--aGGREGATE
select StoreID,count(*) as TotalStores from Sales.Customer 
group by StoreID

create index IX_Customer_StoreID on Sales.Customer(StoreID)

drop Index IX_Customer_StoreID on Sales.Customer



