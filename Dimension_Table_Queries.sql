use DWAssign2

Create table Product(
ProductID int primary key identity,
ProductName nvarchar(50),
ProductSubCategory nvarchar(50),
ProductCategory nvarchar(50))

SET IDENTITY_INSERT DWAssign2.dbo.Product ON
use AdventureWorks2014
Insert into DWAssign2.dbo.Product (ProductID, ProductName, ProductSubCategory, ProductCategory)
Select Production.Product.ProductID,Production.Product.Name,Production.ProductSubcategory.Name, Production.ProductCategory.Name
from Production.Product
join Production.ProductSubcategory on Production.Product.ProductSubcategoryID = Production.ProductSubcategory.ProductSubcategoryID
join Production.ProductCategory on Production.ProductSubcategory.ProductCategoryID = Production.ProductCategory.ProductCategoryID
SET IDENTITY_INSERT DWAssign2.dbo.Product OFF

Create table Customer(
CustomerID int primary key identity,
FullName nvarchar(50) not null,
TerritoryName nvarchar(50) not null,
EmailPromotion int not null)

SET IDENTITY_INSERT DWAssign2.dbo.Customer ON
use AdventureWorks2014
Insert into DWAssign2.dbo.Customer(CustomerID,FullName,TerritoryName,EmailPromotion)
Select Sales.Customer.CustomerID,CONCAT(Person.Person.FirstName,Person.Person.MiddleName,Person.Person.LastName) as 'Full Name', Sales.SalesTerritory.Name, Person.Person.EmailPromotion
from Sales.Customer
join Person.Person on Sales.Customer.PersonID = Person.Person.BusinessEntityID
join Sales.SalesTerritory on Sales.Customer.TerritoryID = Sales.SalesTerritory.TerritoryID
SET IDENTITY_INSERT DWAssign2.dbo.Customer OFF



use DWAssign2
Create table SalesOrder(
SalesOrderDetailsID int primary key identity,
SalesOrderID int  not null,
OrderQty smallint not null,
UnitPrice money not null,
StartDate datetime not null,
EndDate datetime not null,
SalesTerritoryName nvarchar(50) not null,
Discount int not null)


SET IDENTITY_INSERT DWAssign2.dbo.SalesOrder ON

use AdventureWorks2014
Insert into DWAssign2.dbo.SalesOrder(SalesOrderDetailsID,SalesOrderID,OrderQty,UnitPrice,StartDate,Enddate,SalesTerritoryName,Discount)
Select Sales.SalesOrderDetail.SalesOrderDetailID,Sales.SalesOrderDetail.SalesOrderID,Sales.SalesOrderDetail.OrderQty, Sales.SalesOrderDetail.UnitPrice,
Sales.SpecialOffer.StartDate, Sales.SpecialOffer.EndDate,Sales.SalesTerritory.Name, 
CASE 
WHEN Sales.SalesOrderDetail.UnitPriceDiscount > 0.00 THEN  1
else
 0
END as 'Discount'
from Sales.SalesOrderDetail
join Sales.SalesOrderHeader on Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
join Sales.SpecialOffer on Sales.SalesOrderDetail.SpecialOfferID = Sales.SpecialOffer.SpecialOfferID
join Sales.SalesTerritory on Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID


Select * from DWAssign2.dbo.Product
Select * from DWAssign2.dbo.Customer
Select * from DWAssign2.dbo.SalesOrder

use DWAssign2
Create table FactOrder
(
Customer_ID int,
SalesOrderDetails_ID int,
Product_ID int,
OrderDate datetime,
TotalOrderQuantity int ,
AvgOrderQuantity int ,
Total_ProductID int ,
Total_ProductCategories int)


drop table  DwAssign2.dbo.FactOrder

Alter table FactOrder  ADD CONSTRAINT 
FK_Customer_ID FOREIGN KEY (Customer_ID)REFERENCES DWAssign2.dbo.Customer(CustomerID);

Alter table FactOrder  ADD CONSTRAINT 
FK_Product_ID FOREIGN KEY (Product_ID) REFERENCES DWAssign2.dbo.Product(ProductID);

Alter table FactOrder  ADD CONSTRAINT 
FK_SalesOrderDetails_ID FOREIGN KEY (SalesOrderDetails_ID) REFERENCES DWAssign2.dbo.SalesOrder(SalesOrderDetailsID);



use DWAssign2

use DWAssign2
Select dbo.Customer.FullName , dbo.SalesOrder.SalesOrderID
from dbo.Customer 
inner join dbo.FactOrder on dbo.Customer.CustomerID = dbo.FactOrder.Customer_ID
inner join dbo.SalesOrder on dbo.SalesOrder.SalesOrderDetailsID = dbo.FactOrder.SalesOrderDetails_ID

