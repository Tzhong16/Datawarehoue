/*For each customer, display & sort based on the average/total number of SalesOrderDetail.OrderQty 
and total number of (unique) product/product categories they bought at discount/original price 
in a specific/all territory at a specific month/year */


--1.1 For each customer display & sort average/total number of OrderQty 
--and total number of (unique) product/product categories they bought at discount/original price 
--in all territory in 2013
--
USE DW4;
SELECT DISTINCT f.Customer_ID
		,dd.Year AS 'Year'
		,dt.TerritoryName AS 'Region'
		,dt.CountryRegionCode AS 'Country'
		,f.AvgOrderQuantity_nodiscount AS 'AvgOrderQty with no Discount'
		,f.AvgOrderQuantity_discount AS 'AvgOrderQty with Discount'
		,(f.AvgOrderQuantity_discount - f.AvgOrderQuantity_nodiscount) AS 'AvgOrderQty Increased with Discount'
		,f.TotalOrderQuantity_nodiscount AS 'TotalOrderQty with  no Discount'
		,f.TotalOrderQuantity_discount AS 'TotalOrderQty with Discount'
		,(f.TotalOrderQuantity_discount - f.TotalOrderQuantity_nodiscount) AS 'TotalOrderQty Increased with Discount' 
		,f.PurchaseGreaterWhenDiscount AS 'Purchase Increased with Discount'
		,f.Count_ProductCategories_nodiscount AS 'Total Product Categories with Discount'
		,f.Count_ProductCategories_discount AS 'Total Product Categories with Discount'
		,(f.Count_ProductCategories_discount - f.Count_ProductCategories_nodiscount) AS 'Total Product Categories Increased with Discount'
		,f.Count_ProductID_discount AS 'Total Unique Product with Discount'
		,f.Count_ProductID_nodiscount AS 'Total Unique Product with no Discount'
		,(f.Count_ProductID_discount - f.Count_ProductID_nodiscount) AS 'Total Unique Product Increased with Discount'
FROM FactOrder f
JOIN dimDate dd on dd.OrderDate = f.OrderDate
JOIN dimTerritory dt on dt.TerritoryID = f.Territory_ID 
WHERE dd.Year = 2013
	  AND AvgOrderQuantity_discount > 0
	  AND TotalOrderQuantity_discount > 0
	  AND PurchaseGreaterWhenDiscount = 1
ORDER BY TotalOrderQuantity_discount DESC
GO
--1.2 For each customer display & sort average/total number of OrderQty 
--and total number of (unique) product/product categories they bought at discount/original price 
--in USA in 2014
USE DW4;
SELECT DISTINCT f.Customer_ID
		,dd.Year AS 'Year'
		,dt.TerritoryName AS 'Region'
		,f.AvgOrderQuantity_nodiscount AS 'AvgOrderQty with no Discount'
		,f.AvgOrderQuantity_discount AS 'AvgOrderQty with Discount'
		,(f.AvgOrderQuantity_discount - f.AvgOrderQuantity_nodiscount) AS 'AvgOrderQty Increased with Discount'
		,f.TotalOrderQuantity_nodiscount AS 'TotalOrderQty with  no Discount'
		,f.TotalOrderQuantity_discount AS 'TotalOrderQty with Discount'
		,(f.TotalOrderQuantity_discount - f.TotalOrderQuantity_nodiscount) AS 'TotalOrderQty Increased with Discount' 
		,f.PurchaseGreaterWhenDiscount AS 'Purchase Increased with Discount'
		,f.Count_ProductCategories_nodiscount AS 'Total Product Categories with Discount'
		,f.Count_ProductCategories_discount AS 'Total Product Categories with Discount'
		,(f.Count_ProductCategories_discount - f.Count_ProductCategories_nodiscount) AS 'Total Product Categories Increased with Discount'
		,f.Count_ProductID_discount AS 'Total Unique Product with Discount'
		,f.Count_ProductID_nodiscount AS 'Total Unique Product with no Discount'
		,(f.Count_ProductID_discount - f.Count_ProductID_nodiscount) AS 'Total Unique Product Increased with Discount'
FROM FactOrder f
JOIN dimDate dd on dd.OrderDate = f.OrderDate
JOIN dimTerritory dt on dt.TerritoryID = f.Territory_ID 
WHERE dt.TerritoryID in (1,2,3) 
	  AND dd.Year = 2014 
	  AND AvgOrderQuantity_discount > 0
	  AND TotalOrderQuantity_discount > 0
	  AND PurchaseGreaterWhenDiscount = 1
ORDER BY TotalOrderQuantity_discount DESC
