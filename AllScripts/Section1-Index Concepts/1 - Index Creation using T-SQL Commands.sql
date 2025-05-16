use tempdb
go

create table product
(id int primary key,
pname varchar(50) ,
productdatetime datetime)
go

select * from sys.indexes
where object_name(object_id) = 'product'
go

-- Creating Non Clustered Index. Following is the Syntax
--create index IX_TableName_Col1_Col2 on TableName(Col1 Asc, Col2 Desc) 
create index IX_product_productdatetime on product(productdatetime)

select * from sys.indexes
where object_name(object_id) = 'product'
go

drop table product
go

create table product
(id int not null,
pname varchar(50) ,
productdatetime datetime)
go

alter table product
add constraint IX_product_id
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)
go


create index IX_product_productdatetime on product(productdatetime)
go


select * from sys.indexes
where object_name(object_id) = 'product'
go



drop table product