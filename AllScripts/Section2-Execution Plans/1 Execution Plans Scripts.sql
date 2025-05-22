--Heap Scan
select * from databaselog

--No Index, so it every page in the heap to find the record.
select * from databaselog where [Schema]='HumanResources'

--Clustered Index Scan
select * from Production.Product

SELECT * FROM sys.indexes WHERE OBJECT_NAME(object_id) = N'Product';
go

-- this one still uses clustered index scan since we 
-- we dont have non-clustered index on ListPrice
-- still inefficient since it has to scan all the 
-- leaf pages of the index to find the product with this specific listPrice
select * from Production.Product
where ListPrice=1364.50

--Clustered Index Seek
--find a product with specific ID. since ID is a clustered index col
--it will take mssql a few searches to find it
select * from Production.Product 
where ProductID=320

--Index Seek (Key LookUp)
--look for record in non-clustered index Name
--then use the clustered index column associated with record
--and search for record that contains this clustered index col
--in the clustered index ProductID (process is called key lookup)
--we also use nested loop: so we find rows in the non-clustered index Name
--then find matching rows in inner table (clustered index ProductID)
--=> we search for the record twice (1 in non-clustered index then in clustered index)
select * from Production.Product where Name='Down Tube'

--Index Seek (RowID Lookup)
--Search for rows in Heap using row pointers
--if we have to use RowID Lookup it means that we dont have 
--a clustered index.
--in this case, we search for records in leaf pages that contain
--DatabaseLogID=31 in non-clustered index . then we will use the row
--pointers associated with the records in the index to look for the rows in the heap. 
--better read performance than key ID lookup if we have to deal with a lot of data.
select * from databaselog where DatabaseLogID=31

--Wild Card is also supported
--we have to make sure we dont put wildcard character in front. otherwise, it will scan
--the whole index instead of using non-clustered index seek + key ID look up (since we have clustered index on this table).
--when there is a lot of data, index seek will be preferred. otherwise, mssql may use index scan.
select * from Production.Product where Name like 'Mountain-500 Silver%'

--Index Scan
--In this example, we have 38 rows as result. Mssql will have to do key ID look up
--38 items (search for Name in non-clustered index and then do key lookup in ID clustered index)
--instead, it will just scan the whole clustered index ID and find the records
--with Name in the leaf pages. 
--mssql determines that scanning 500 records in clustered index to get 38 records
--is faster than seeking for records in non-clustered index Name then do key look up 
--using clustered index 38 items
select * from Production.Product where Name like 'Mountain%'

--Sort
--will perform sort on ListPrice since we dont have an index on it
select * from [Production].[Product] order by ListPrice

--will not perform sort on productsubCategoryId since
--we have clustered index on it. and since leaf pages
--are interconnected mssql can just read the data from
--last page to first pgae
select * from  [Production].[ProductSubcategory]
order by ProductSubcategoryID desc

--also no sort here needs to be performed
--since the Name is a non-clustered index
--will do non-clustered index scan + key ID lookup
select * from  [Production].[ProductSubcategory]
order by Name

-- it is faster for mssql to do table scan and sort
-- the data instead of non-clustered index scan then
-- row ID lookup
select * from databaselog order by DatabaseLogID

--Joins

--both tables are sorted by same primary key
--join on this primary key
--sql server will go for merge join
select sd.SalesOrderID,sd.OrderQty,sh.ShipMethodID,sh.CreditCardID 
from Sales.SalesOrderDetail  sd 
inner join Sales.SalesOrderHeader  sh 
ON sd.SalesOrderID = sh.SalesOrderID

--sh only has customer id as non-clustered index
--therefore, it is not sorted by this index
--also, it does not contain ship method ID and credit card id
--it will have to do key look up id from the actual table salesOrderHeader
--therefore, sql server will instead use hash match
select c.StoreID,c.TerritoryID,sh.ShipMethodID,sh.CreditCardID  
from Sales.SalesOrderHeader  sh 
inner join Sales.Customer  c
ON sh.CustomerID = c.CustomerID

--as mentioned above, salesOrderHeader
--does not have customer id has clustered index key
--so it is not sorted by that.
--it will perform a non-clustered index scan 
--however, since we don't include keys where we don't have 
--clustered indexes on, it won't need to do key lookup.
--records from non-clustered index are enough and sorted
--so, sql server will choose merge join. 
select c.StoreID,c.TerritoryID,sh.CustomerID 
from Sales.SalesOrderHeader  sh 
inner join Sales.Customer  c
ON sh.CustomerID = c.CustomerID

--since we only fetch 1 record, sql server might
--go for nested loop instead of merge join or hash match
--sql server will look for customerID from non-clustered index
--of sh then do key Lookup (nested loop) on innner table (actual table of sh)
--to find the record
--then it will do clustered index seek to find customer with
--below id (we have clustered index on customer id)
--then for the outer record (the sales order header)
--it will find the coresponding customer record with below
--id (a nested loop operation).
--for bigger result set, however, hash match/merge join may be used
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



