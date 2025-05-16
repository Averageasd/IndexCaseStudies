use tempdb
go

create table Customer
(
   CustomerID int identity primary key,
   CustomerName varchar(200),
   BloodGroup char(3),
   RecordInsertDatetime datetime default getdate()
)
go

--The Indexes present in the Customer table
SELECT * FROM sys.indexes WHERE OBJECT_NAME(object_id) = N'Customer';
go

declare @i int =1
while @i<20000
begin
insert into  Customer (CustomerName,BloodGroup) values ('Name 1','O+')
set @i=@i+1
end
go

select * from Customer
go

declare @i int =1
while @i<20000
begin
update Customer set CustomerName ='Name '+ REPLICATE('A',CAST(RAND() * 100 AS int))
where CustomerID = @i
set @i=@i+1
end
go

select CAST(RAND() * 100 AS int)
select REPLICATE('Hello ',3)
select REPLICATE('A',CAST(RAND() * 100 AS int))

select * from Customer

--Following Command Checks the Fragmentation
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('Customer'),NULL,NULL,NULL);
GO

--You can find the name of the Index
SELECT * FROM sys.indexes WHERE OBJECT_NAME(object_id) = N'Customer';
go

--You can replace the IndexName from the name column 
--which is returned by the command Above in the following command 

ALTER INDEX [PK__Customer__A4AE64B803EF1831] ON [dbo].[Customer] REBUILD with (ONLINE = ON)
go

drop table customer	