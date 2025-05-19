use tempdb
go

--by default, id as primary key is created as clustered index.
create table product
(id int primary key,
pname varchar(50) ,
productdatetime datetime)
go

--for the object with id product (table product)
--find all indexes
select * from sys.indexes
where object_name(object_id) = 'product'
go

-- Creating Non Clustered Index. Following is the Syntax
--create index IX_TableName_Col1_Col2 on TableName(Col1 Asc, Col2 Desc) 
--create index -> create non-clustered index
--too many non-clustered indexes are not good.
--we will have to update/delete/insert data from/to non-clustered indexes
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

--create a new clustered index 
--on column id of table product
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