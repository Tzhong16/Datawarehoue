--Question 2 
/*For each customer, display & sort based on whether the number of products/OrderQty 
has increased through 2 times period. For instance, if Customer A  bought 20 pencils and 5 pens 1 months ago 
and now he bought 30 pencils, Customer A number of products categories has not increased through 2 times period (False),
 but the number of products has (True)*/

USE DW4;
GO
--Total Sub_Questions: 2.1 About 4k people order in March or April
SELECT * FROM vEachCustomerNumberOfProductOn2TimePeriod; 
--2.2 Only 27 people Increased their Number of Products and Qty both on March and April 
SELECT * FROM vEachCustomerNumberOfProductHasIncreasedOn2TimePeriod 
		ORDER BY  'Number of ProductQty Increased' DESC; 

--2.3.1 About 2k people haven't increase their Number of Products or Qty in two time period
SELECT * FROM vEachCustomerNumberOfProductHasDecreasedOn2TimePeriod 
		ORDER BY  'Number of Products Decreased' DESC;
--2.3.2 People who decreased most of their Number of Products/Qty in two time period based on who have ordered in 2 time period 
SELECT * FROM vEachCustomerOrderIN2MonthWithNumberOfProductHasDecreasedOn2TimePeriod 
		ORDER BY 'Number of Products Decreased' DESC;

--2.4 Peope Who haven't increase their number of product but increased their product Qty in 2 time period
SELECT * FROM  vEachCustomerOnlyIncreasedProductQtyOn2TimePeriod
GO

--2.1 For each customer, 
--	display & sort based on the number of products/OrderQty 
--	through 2 times period. 
USE DW4;

DROP VIEW IF EXISTS dbo.vEachCustomerNumberOfProductOn2TimePeriod;

--CREATE VIEW vEachCustomerNumberOfProductOn2TimePeriod
--AS
SELECT DISTINCT 
		f.Customer_ID
		,f.Count_ProductID_March AS 'Product Category of March'
		,f.Count_ProductID_April AS 'Product Category of April'
		,f.Count_CategoryIncreased AS 'Product Categories Increased'
		,f.Count_ProductQty_March AS 'ProductQty of March'
		,f.Count_ProductQty_April AS 'ProductQty of April'
		,f.Count_ProductIncreased AS 'ProductQty Increased'
FROM FactOrder f
WHERE YEAR(f.OrderDate) = 2014 and MONTH(f.OrderDate) in (3, 4) 
ORDER BY Customer_ID;
GO

-- 2.2 For each customer who brought both March and April, 
--	display & sort based on whether the number of products
--	has INCREASED through 2 times period. 
USE DW4;

DROP VIEW IF EXISTS dbo.vEachCustomerNumberOfProductHasIncreasedOn2TimePeriod;

--CREATE VIEW vEachCustomerNumberOfProductHasIncreasedOn2TimePeriod
--AS
SELECT DISTINCT 
		f.Customer_ID
		,f.Count_ProductID_March AS 'Product Category of March'
		,f.Count_ProductID_April AS 'Product Category of April'
		,(f.Count_ProductID_April - f.Count_ProductID_March) AS 'Number of Products Increased' 
		,f.Count_CategoryIncreased AS 'Product Categories Increased'
		,f.Count_ProductQty_March AS 'ProductQty of March'
		,f.Count_ProductQty_April AS 'ProductQty of April'
		,(f.Count_ProductQty_April - f.Count_ProductQty_March) AS 'Number of ProductQty Increased'
		,f.Count_ProductIncreased AS 'ProductQty Increased'
FROM FactOrder f
WHERE YEAR(f.OrderDate) = 2014 
	  AND MONTH(f.OrderDate) in (3, 4)
	  AND f.Count_ProductID_March > 0 
	  AND f.Count_ProductID_April > 0
	  AND f.Count_CategoryIncreased = 1
	  AND f.Count_ProductIncreased =1
ORDER BY (f.Count_ProductQty_April - f.Count_ProductQty_March) DESC;
GO


----2.3 For each customer who brought  March or April, 
--	display & sort based on whether the number of products/Qty
--	has DECREASED through 2 times period. 
USE DW4;
DROP VIEW IF EXISTS dbo.vEachCustomerNumberOfProductHasDecreasedOn2TimePeriod;
DROP VIEW IF EXISTS dbo.vEachCustomerOrderIN2MonthWithNumberOfProductHasDecreasedOn2TimePeriod;
GO

--CREATE VIEW vEachCustomerNumberOfProductHasDecreasedOn2TimePeriod
--AS
--CREATE VIEW vEachCustomerOrderIN2MonthWithNumberOfProductHasDecreasedOn2TimePeriod
--AS
SELECT DISTINCT 
		f.Customer_ID
		,f.Count_ProductID_March AS 'Product Category of March'
		,f.Count_ProductID_April AS 'Product Category of April'
		,(f.Count_ProductID_March - f.Count_ProductID_April) AS 'Number of Products Decreased' 
		,f.Count_CategoryIncreased AS 'Product Categories Increased'
		,f.Count_ProductQty_March AS 'ProductQty of March'
		,f.Count_ProductQty_April AS 'ProductQty of April'
		,(f.Count_ProductQty_March - f.Count_ProductQty_April) AS 'Number of ProductQty Decreased'
		,f.Count_ProductIncreased AS 'ProductQty Increased'
FROM FactOrder f
WHERE YEAR(f.OrderDate) = 2014 
	  AND MONTH(f.OrderDate) in (3, 4) 
	  AND Count_ProductID_April > 0 
	  AND Count_ProductID_March > 0
	  AND f.Count_ProductIncreased =0
ORDER BY 'Number of Products Decreased' DESC;
GO


-- 2.4 Peope Who haven't increased their number of product but increased their product Qty in 2 time period
USE DW4;


DROP VIEW IF EXISTS dbo.vEachCustomerOnlyIncreasedProductQtyOn2TimePeriod;
GO

--CREATE VIEW vEachCustomerOnlyIncreasedProductQtyOn2TimePeriod
--AS
SELECT DISTINCT 
		f.Customer_ID
		,f.Count_ProductID_March AS 'Product Category of March'
		,f.Count_ProductID_April AS 'Product Category of April'
		,f.Count_CategoryIncreased AS 'Product Categories Increased'
		,f.Count_ProductQty_March AS 'ProductQty of March'
		,f.Count_ProductQty_April AS 'ProductQty of April'
		,f.Count_ProductIncreased AS 'ProductQty Increased'
FROM FactOrder f
WHERE YEAR(f.OrderDate) = 2014 
	  AND MONTH(f.OrderDate) in (3, 4) 
	  AND f.Count_CategoryIncreased = 0
	  AND f.Count_ProductIncreased =1



