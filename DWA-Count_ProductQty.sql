--use DW4;
--truncate table tmp2FactOrder

use DW4;
select * from FactOrder; 

use DW4;
select * from tmp3TotalProductQtyMarch;
select * from tmp4TotalProductQtyApril;

--Create table for loading Count_ProductQty For March
Create table tmp3TotalProductQtyMarch
(CustomerID int primary key,
YearTime int ,
MonthTime int ,
Total_ProductQty int
)

--Insert data into tmp3TotalProductQtyMarch
Use AdventureWorks2014;
Insert into DW4.dbo.tmp3TotalProductQtyMarch
Select 
	soh.CustomerID,
	YEAR(soh.OrderDate) as YearTime,
	Month(soh.OrderDate) as MonthTime,
    Sum (OrderQty) as Total_ProductQty
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) = 3 
group by CustomerID,YEAR(soh.OrderDate),Month(soh.OrderDate)


USE DW4;
select * from tmp3TotalProductQtyMarch

--Create table for loading Count_ProductCategories For April
Create table tmp4TotalProductQtyApril
(CustomerID int primary key,
YearTime int ,
MonthTime int ,
Total_ProductQty int
)

--Insert data into tmp6TotalProductQtyApril
Use AdventureWorks2014;
Insert into DW4.dbo.tmp4TotalProductQtyApril
Select 
	soh.CustomerID,
	YEAR(soh.OrderDate) as YearTime,
	Month(soh.OrderDate) as MonthTime,
    Sum (OrderQty) as Total_ProductQty
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) = 4 
group by CustomerID,YEAR(soh.OrderDate),Month(soh.OrderDate)

USE DW4;
select * from tmp3TotalProductQtyMarch;

use DW4;
select * from tmp4TotalProductQtyApril;

--Load data of tmp3TotalProductQtyMarch into FactOrder
--tmp3TotalProductQtyMarch
USE DW4;
update FactOrder
	set FactOrder.Count_ProductQty_March = tmp3TotalProductQtyMarch.Total_ProductQty
	from FactOrder
    inner join tmp3TotalProductQtyMarch
    on FactOrder.Customer_ID = tmp3TotalProductQtyMarch.CustomerID 
	where Year(FactOrder.OrderDate) = 2014 -- and  Month(FactOrder.OrderDate) = 3

--Load data of tmp4TotalProductQtyApril into FactOrder
USE DW4;
update FactOrder
	set FactOrder.Count_ProductQty_April = tmp4TotalProductQtyApril.Total_ProductQty
	from FactOrder
    inner join tmp4TotalProductQtyApril
    on FactOrder.Customer_ID = tmp4TotalProductQtyApril.CustomerID 
	where Year(FactOrder.OrderDate) = 2014 --and  Month(FactOrder.OrderDate) = 4

--Compare tmp3TotalProductQtyMarch and TotalProductQtyApril 
--Check
use DW4;
select f.Customer_ID, f.Count_ProductQty_March, f.Count_ProductQty_April from FactOrder f
where Year(f.OrderDate) = 2014 and f.Customer_ID= 13096
select * from FactOrder
select Customer_ID, OrderDate, f.Count_ProductQty_March, f.Count_ProductQty_April from FactOrder f

--Update NULL TO 0 for those people do not order in April or March 
USE DW4;
Select ISNULL(FactOrder.Count_ProductQty_March, 0) FROM FactOrder
select * from FactOrder

-------UPDATE DATE 
USE DW4;
UPDATE FactOrder
	set Count_ProductQty_March = case 
	when Count_ProductQty_March is null then 0 
	END
 
UPDATE FactOrder
	set Count_ProductQty_April = case 
	when Count_ProductQty_April is null then 0 
	END


select * from FactOrder
/* The follow code is something wrong, dont knot why
USE DW3;
Update DW3.dbo.tmp2FactOrder
	set tmp2FactOrder.Count_ProductCategories_Month1 = (CASE when tmp2FactOrder.Count_ProductCategories_Month1  is null then 0 END)

Update DW3.dbo.tmp2FactOrder
	set tmp2FactOrder.Count_ProductCategories_Month2 = (CASE when tmp2FactOrder.Count_ProductCategories_Month2  is null then 0 END)*/

--set Count_CategoryIncreased by compare Count_ProductCategories_March and Count_ProductCategories_April
use DW4;
Update FactOrder
	set Count_ProductIncreased = case when Count_ProductQty_March >= Count_ProductID_April then 0 else 1 END
--check
use DW4;
Select * from FactOrder

--seleck relative data
use DW4;
use AdventureWorks2014;
select  t.Customer_ID, t.Count_ProductQty_March, t.Count_ProductQty_April, t.Count_ProductIncreased
from DW4.dbo.FactOrder t
Where t.Customer_ID in (select  
	soh.CustomerID
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4) --and CustomerID = 15911
) and t.Count_ProductIncreased = 1   and t.Customer_ID = 13096

--YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4)

use DW4;
select * from FactOrder;
select * from DW4.dbo.FactOrder where Year(DW4.dbo.FactOrder.OrderDate) = 2014 
	and month(DW4.dbo.FactOrder.OrderDate) = 3
select * from tmp3TotalProductQtyMarch 


--Have a look for how many ProductID  in both March and April
use AdventureWorks2014;
Select 
	soh.CustomerID,
	YEAR(soh.OrderDate) as YearTime,
	Month(soh.OrderDate) as MonthTime,
    Count (distinct sod.ProductID) as Count_ProductCategories
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4) and CustomerID = 13096
group by CustomerID,YEAR(soh.OrderDate),Month(soh.OrderDate)

use AdventureWorks2014;
select  distinct t.Customer_ID, t.Count_ProductQty_March, t.Count_ProductQty_April, t.Count_ProductIncreased
from DW4.dbo.tmp2FactOrder t
Where t.Customer_ID in (select  
	soh.CustomerID
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4) and Customer_ID = 11287)
 and t.Count_ProductIncreased = 1   and t.Customer_ID = 13096

 --Check
 use DW4
 Select f.Customer_ID, 
		f.Count_ProductQty_March, 
		f.Count_ProductQty_April, 
		f.Count_ProductIncreased 
from FactOrder f 
where year(f.OrderDate) = 2014 
		and month(f.OrderDate) in (3, 4) 
		and f.Count_ProductIncreased = 1 
		

--check		
 use DW4
 Select f.Customer_ID, 
		f.Count_ProductQty_March, 
		f.Count_ProductQty_April, 
		f.Count_ProductIncreased 
from FactOrder f 
where year(f.OrderDate) = 2014 
		and month(f.OrderDate) in (3, 4) 
		and f.Count_ProductIncreased = 1 
		and f.Customer_ID= 13096