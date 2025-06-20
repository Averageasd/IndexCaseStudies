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
--smaller table should be on topa
select sd.SalesOrderID,sd.OrderQty,sh.ShipMethodID,sh.CreditCardID 
from Sales.SalesOrderDetail  sd 
inner join Sales.SalesOrderHeader  sh 
ON sd.SalesOrderID = sh.SalesOrderID

--sh only has customer id as non-clustered index
--it will have to do key look up in clustered index (salesorderheader clustered index)
--to find complete records for each customer id
--therefore, sql server will instead use hash match
select sh.CustomerID, c.StoreID,c.TerritoryID,sh.ShipMethodID,sh.CreditCardID  
from Sales.SalesOrderHeader  sh 
inner join Sales.Customer  c
ON sh.CustomerID = c.CustomerID

--so for every customer id we use to join
--with customer table, there is no need to do key lookup
--in clustered index to find extra information, so
--sql server will use merge join here
select c.StoreID,c.TerritoryID,sh.CustomerID
from Sales.SalesOrderHeader  sh 
inner join Sales.Customer  c
ON sh.CustomerID = c.CustomerID

/**
index seek + key look up in the sh table to find records for 
customer. then clustered index seek to find records in customer
table. then from outer table (customer) we find correnspoding
records from inner table (sh) and we use nesteed loops to join because we only have 1 record.
**/
select c.StoreID,c.TerritoryID,sh.ShipMethodID,sh.CreditCardID  
from Sales.SalesOrderHeader  sh 
inner join Sales.Customer  c
ON sh.CustomerID = c.CustomerID
where c.customerid=22222

--Compute Scalar
select BusinessEntityID, upper(firstName +' '+ LastName)  as FullName
from [Person].[Person]
order by FullName

--in this case, we fetch title.
--since title is not included in the non-clustered index
--sql server may have to do non-clustered index scan + key look up
--to find title. however, sql server finds that doing clustered
--index scan directly (clustered index ordered by id) + sort
--is cheaper. so sql server will use the clustered index instead
--therefore, will have to use sort to order by 2 non-clustered indexes.
select  BusinessEntityID, Title, upper(firstName +' '+ LastName)  as FullName
from [Person].[Person]
order by LastName,FirstName


--aGGREGATE
--stream aggregate consumes less memory since we don't need
--to build hash for the column we want to aggregate by
--stream aggregate is used if we group by sorted column
--since non-clustered index contains only some columns, 
--sql server will read less pages and thus it will result
--in faster aggregation operations.
select StoreID,count(*) as TotalStores from Sales.Customer 
group by StoreID

create index IX_Customer_StoreID on Sales.Customer(StoreID)

drop Index IX_Customer_StoreID on Sales.Customer



