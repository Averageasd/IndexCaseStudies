create database NewDB
go

use NewDB
go

ALTER DATABASE CURRENT SET COMPATIBILITY_LEVEL = 160; --2022--This will enable PSPO. 
GO

create table Customer
(
   CustomerID int identity primary key,
   CustomerName varchar(200),
   BloodGroup char(3),
   RecordInsertDatetime datetime default getdate()
)
go

create index IX_CustomerName_Customer on Customer (CustomerName)
go

--The Indexes present in the Customer table
SELECT * FROM sys.indexes WHERE OBJECT_NAME(object_id) = N'Customer';
go

--IMPORTANT -> The following command may take 4-5 minutes to execute 
declare @i int =1
while @i<=500000
begin
insert into  Customer (CustomerName,BloodGroup) values ('Name 1','O+')
set @i=@i+1
end
go


insert into  Customer (CustomerName,BloodGroup) values ('Name 2','B+')
insert into  Customer (CustomerName,BloodGroup) values ('Name 2','A+')
insert into  Customer (CustomerName,BloodGroup) values ('Name 3','A-')
insert into  Customer (CustomerName,BloodGroup) values ('Name 4','AB+')
go

select CustomerName,count(*) as TotalCustomers 
from Customer 
Group By CustomerName

select * from Customer

select * from Customer where CustomerName='Name 1'
go

create proc usp_Demo
@CustomerName varchar(200)
as
select * from Customer where CustomerName=@CustomerName
go


exec usp_Demo @CustomerName='Name 4'
exec usp_Demo @CustomerName='Name 1'
go

drop table Customer
drop proc usp_Demo
go

drop database NewDB


