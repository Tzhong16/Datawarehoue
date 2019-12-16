use DW4
Create table dimCustomer
(CustomerID int primary key,
FullName nvarchar(50),
AccountNumber varchar(10),
Address nvarchar(60),
PhoneNumber nvarchar(25),
EmailPromotion int)

use DW4
Create table dimSalesOrder
(
SalesOrderKey int identity(1,1) primary key,
SalesOrderID int,
OrderQty smallint,
ProductID int,
ProductName nvarchar(50),
ProductSubCategory nvarchar(50),
ProductCategory nvarchar(50))

use DW4
Create table dimTerritory
(
TerritoryID int primary key,
TerritoryName varchar(50),
CountryRegionCode nvarchar(3)
)


use DW4
CREATE TABLE dimDate (
 [OrderDate] date primary key,
 [Year] int NOT NULL, 
 [Month] int NOT NULL,
 [Day] int NOT NULL,
 [QuarterNumber] int NOT NULL,
)
-- declare variables to hold the start and end date
DECLARE @StartDate datetime
DECLARE @EndDate datetime

--- assign values to the start date and end date we 
-- want our reports to cover (this should also take
-- into account any future reporting needs)
SET @StartDate = '01/01/2011'
SET @EndDate = '12/31/2014' 

-- using a while loop increment from the start date 
-- to the end date
DECLARE @LoopDate datetime
SET @LoopDate = @StartDate

WHILE @LoopDate <= @EndDate
BEGIN
 -- add a record into the date dimension table for this date
 INSERT INTO dbo.DimDate VALUES (
  @LoopDate,
  Year(@LoopDate),
  Month(@LoopDate), 
  Day(@LoopDate), 
  CASE WHEN Month(@LoopDate) IN (01, 02, 03) THEN 1
   WHEN Month(@LoopDate) IN (04, 05, 06) THEN 2
   WHEN Month(@LoopDate) IN (07, 08,09) THEN 3
   WHEN Month(@LoopDate) IN (10, 11, 12) THEN 4
  END   
 )  
 -- increment the LoopDate by 1 day before
 -- we start the loop again
 SET @LoopDate = DateAdd(d, 1, @LoopDate)
END

use AdventureWorks2014
insert into DW4.dbo.dimCustomer(
	CustomerID,
	FullName,
	AccountNumber,
	Address,
	City,
	PostalCode,
	PhoneNumber,
	EmailPromotion)
Select
distinct Sales.Customer.CustomerID,
CONCAT(Person.Person.FirstName,Person.Person.MiddleName,Person.Person.LastName) as 'Full Name', 
Sales.Customer.AccountNumber,
CONCAT(Person.Address.AddressLine1,Person.Address.AddressLine2) as 'newaddress',
Person.Address.City,
Person.Address.PostalCode,
Person.PersonPhone.PhoneNumber,
Person.Person.EmailPromotion
from Sales.SalesOrderHeader
join Sales.Customer on Sales.Customer.CustomerID = Sales.SalesOrderHeader.CustomerID
join Person.Person on Sales.Customer.PersonID = Person.Person.BusinessEntityID
join Person.Address on Sales.SalesOrderHeader.ShipToAddressID = Person.Address.AddressID
join Person.PersonPhone on Person.Person.BusinessEntityID = Person.PersonPhone.BusinessEntityID

use AdventureWorks2014
insert into DW4.dbo.dimTerritory(
TerritoryID,
TerritoryName,
CountryRegionCode
)
select
Sales.SalesTerritory.TerritoryID,
Sales.SalesTerritory.Name,
Sales.SalesTerritory.CountryRegionCode
from Sales.SalesTerritory

use AdventureWorks2014
insert into dw4.dbo.dimSalesOrder(
SalesOrderID,
OrderQty,
ProductID,
ProductName,
ProductSubCategory,
ProductCategory)
Select 
Sales.SalesOrderHeader.SalesOrderID,
Sales.SalesOrderDetail.OrderQty,
Sales.SalesOrderDetail.ProductID,
Production.Product.Name,
Production.ProductSubcategory.Name, 
Production.ProductCategory.Name
from Sales.SalesOrderHeader
join Sales.SalesOrderDetail on Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
join Production.Product on Sales.SalesOrderDetail.ProductID = Production.Product.ProductID


use DW4
Create table FactOrder
(
SalesOrderKey int identity(1,1) primary key,
Customer_ID int,
OrderDate date,
Territory_ID int,
SalesOrder_ID int ,
TotalOrderQuantity_discount int,
AvgOrderQuantity_discount int,
Count_ProductID_discount int,
Count_ProductCategories_discount int,

TotalOrderQuantity_nodiscount int,
AvgOrderQuantity_nodiscount int,
Count_ProductID_nodiscount int,
Count_ProductCategories_nodiscount int,

PurchaseGreaterWhenDiscount int,

Count_ProductID_March int,
Count_ProductID_April int,
Count_ProductQty_March int,
Count_ProductQty_April int,
Count_CategoryIncreased int,
Count_ProductIncreased int
)

use DW4
Alter Table dbo.FactOrder ADD CONSTRAINT
FK_Customer_ID FOREIGN KEY (Customer_ID)  references dbo.dimCustomer(CustomerID)

use DW4
Alter Table dbo.FactOrder ADD CONSTRAINT
FK_SalesOrderKey FOREIGN KEY (SalesOrderKey) references dbo.dimSalesOrder(SalesOrderKey)

use DW4
Alter Table dbo.FactOrder ADD CONSTRAINT
FK_Territory_ID FOREIGN KEY (Territory_ID) references dbo.dimTerritory(TerritoryID)

use DW4
Alter table dbo.FactOrder  ADD CONSTRAINT 
FK_OrderDate Foreign Key (OrderDate) references dbo.dimDate(OrderDate)