use DW3;
truncate table tmp2FactOrder

use DW3;
select * from tmp2FactOrder;    
   
use DW3;
select * from tmp3TotalProductNTotalQtyMarch;
select * from tmp4TotalProductNTotalQtyApril; 

--Create table for loading Count_ProductCategories For March
Create table tmp5TotalProductCategoriesMarch
(CustomerID int primary key,
YearTime int ,
MonthTime int ,
Total_ProductID int
)

--Insert data into tmp5TotalProductCategoriesMarch
Use AdventureWorks2014;
Insert into DW3.dbo.tmp5TotalProductCategoriesMarch
Select 
	soh.CustomerID,
	YEAR(soh.OrderDate) as YearTime,
	Month(soh.OrderDate) as MonthTime,
    Count (distinct sod.ProductID) as Count_ProductCategories
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) = 3 
group by CustomerID,YEAR(soh.OrderDate),Month(soh.OrderDate)

USE DW3;
select * from tmp5TotalProductCategoriesMarch

--Create table for loading Count_ProductCategories For April
Create table tmp6TotalProductCategoriesApril
(CustomerID int primary key,
YearTime int ,
MonthTime int ,
Total_ProductID int
)

--Insert data into tmp6TotalProductCategoriesApril
Use AdventureWorks2014;
Insert into DW3.dbo.tmp6TotalProductCategoriesApril
Select 
	soh.CustomerID,
	YEAR(soh.OrderDate) as YearTime,
	Month(soh.OrderDate) as MonthTime,
    Count (distinct sod.ProductID) as Count_ProductCategories
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) = 4 
group by CustomerID,YEAR(soh.OrderDate),Month(soh.OrderDate)

USE DW3;
select * from tmp5TotalProductCategoriesMarch;

use DW3;
select * from tmp6TotalProductCategoriesApril;

--Load data of tmp5TotalProductCategoriesMarch into tmp2FactOrder
USE DW3;
update tmp2FactOrder
	set tmp2FactOrder.Count_ProductCategories_Month1 = tmp5TotalProductCategoriesMarch.Total_ProductID
	from tmp2FactOrder
    inner join tmp5TotalProductCategoriesMarch
    on tmp2FactOrder.Customer_ID = tmp5TotalProductCategoriesMarch.CustomerID 
	where Year(tmp2FactOrder.OrderDate_ID) = 2014 and  Month(tmp2FactOrder.OrderDate_ID) = 3

--Load data of tmp6TotalProductCategoriesApril into tmp2FactOrder
USE DW3;
update tmp2FactOrder
	set tmp2FactOrder.Count_ProductCategories_Month2 = tmp6TotalProductCategoriesApril.Total_ProductID
	from tmp2FactOrder
    inner join tmp6TotalProductCategoriesApril
    on tmp2FactOrder.Customer_ID = tmp6TotalProductCategoriesApril.CustomerID 
	where Year(tmp2FactOrder.OrderDate_ID) = 2014 and  Month(tmp2FactOrder.OrderDate_ID) = 4

--Compare tmp5TotalProductCategoriesMarch and TotalProductCategoriesApril 
--Check
use DW3;
select t.Customer_ID, t.Count_ProductCategories_Month1, t.Count_ProductCategories_Month2 from tmp2FactOrder t 
where Year(t.OrderDate_ID) = 2014 and t.Customer_ID = 13096

--Update NULL TO 0 for those people do not order in April or March 
USE DW3;
Select ISNULL(tmp2FactOrder.Count_ProductCategories_Month1, 0) FROM tmp2FactOrder

/* The follow code is something wrong, dont knot why
USE DW3;
Update DW3.dbo.tmp2FactOrder
	set tmp2FactOrder.Count_ProductCategories_Month1 = (CASE when tmp2FactOrder.Count_ProductCategories_Month1  is null then 0 END)

Update DW3.dbo.tmp2FactOrder
	set tmp2FactOrder.Count_ProductCategories_Month2 = (CASE when tmp2FactOrder.Count_ProductCategories_Month2  is null then 0 END)*/

--set Count_CategoryIncreased by compare Count_ProductCategories_March and Count_ProductCategories_April
use DW3;
Update tmp2FactOrder
	set Count_CategoryIncreased = case when Count_ProductCategories_Month1 >= Count_ProductCategories_Month2 then 0 else 1 END
--check
use DW3;
Select * from tmp2FactOrder

--seleck relative data
use DW3;
use AdventureWorks2014;
select  t.Customer_ID, t.Count_ProductCategories_Month1, t.Count_ProductCategories_Month2, t.Count_CategoryIncreased
from DW3.dbo.tmp2FactOrder t
Where t.Customer_ID in (select  
	soh.CustomerID
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4) --and CustomerID = 15911
) and t.Count_CategoryIncreased = 1   and t.Customer_ID = 13096

--YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4)

use dw3;
select * from DW3.dbo.tmp2FactOrder where Year(DW3.dbo.tmp2FactOrder.OrderDate_ID) = 2014 and month(DW3.dbo.tmp2FactOrder.OrderDate_ID) = 3
select * from tmp5TotalProductCategoriesMarch 
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
select  distinct t.Customer_ID, t.Count_ProductCategories_Month1, t.Count_ProductCategories_Month2, t.Count_CategoryIncreased
from DW3.dbo.tmp2FactOrder t
Where t.Customer_ID in (select  
	soh.CustomerID
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4) --and CustomerID = 15911
) and t.Count_CategoryIncreased = 1   and t.Customer_ID = 13096   
--Check who oder both in March and April
use AdventureWorks2014;
select t.CustomerID, Count(*) as OrderInMarchNApril
from 
(Select 
	soh.CustomerID,
	YEAR(soh.OrderDate) as YearTime,
	Month(soh.OrderDate) as MonthTime,
    Count (distinct sod.ProductID) as Count_ProductCategories
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4)
group by CustomerID,YEAR(soh.OrderDate),Month(soh.OrderDate)) AS t
Group by CustomerID
HAVING COUNT(*) > 1

--CustomerID = 13096

--Check Count_ProductCategory in both March and April for specific Customer_ID
use DW3;
select t.Customer_ID, t.Count_ProductID_Month1, t.Count_ProductD_Month2 from tmp2FactOrder t 
where Year(t.OrderDate_ID) = 2014 and t.Customer_ID = 19076; 

use AdventureWorks2014;
Select 
	soh.CustomerID,
	YEAR(soh.OrderDate) as YearTime,
	Month(soh.OrderDate) as MonthTime,
    Count (distinct sod.ProductID) as Count_ProductID
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4) and soh.CustomerID = 19076
group by CustomerID,YEAR(soh.OrderDate),Month(soh.OrderDate)             



	
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
select soh.CustomerID,
	YEAR(soh.OrderDate) as YearTime,
	Month(soh.OrderDate) as MonthTime,
	day(soh.OrderDate) as DayTime,
	sod.ProductID 
from Sales.SalesOrderHeader soh
	join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4) and CustomerID = 13096;    

select  t.Customer_ID, t.Count_ProductCategories_Month1, t.Count_ProductCategories_Month2, t.Count_CategoryIncreased, t.OrderDate_ID
from DW3.dbo.tmp2FactOrder t
Where t.Customer_ID in (select  
	soh.CustomerID
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
where YEAR(soh.OrderDate) = 2014 and Month(soh.OrderDate) in (3,4) --and CustomerID = 15911
) and t.Count_CategoryIncreased = 1   and t.Customer_ID = 13096         

use DW3;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     