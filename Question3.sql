--Question 3 
/*Display & sort customers, whose average/total number of SalesOrderDetail.OrderQty, 
total number of (unique) product/product categories sold at discount is 
greater than when it is sold at original price in a specific/all territory at a specific month/year,
 and it has increased the number of products/OrderQty through 2 times  period*/

--3.1
USE DW4;
SELECT f.Customer_ID
		,dd.Year AS 'Year'
		,dd.Month AS 'Month'
		,dt.CountryRegionCode AS 'Region'
		,f.AvgOrderQuantity_nodiscount AS 'AvgOrderQty with No Discount'
		,f.AvgOrderQuantity_discount AS 'AvgOrderQty with Discount'
		,(f.AvgOrderQuantity_discount - f.AvgOrderQuantity_nodiscount) 
										AS 'AvgQrderQty Increased with Discount'
		,f.TotalOrderQuantity_nodiscount AS 'TotalOrderQty with No Discount'
		,f.TotalOrderQuantity_discount AS 'TotalOrderQty with Discount'
		,(f.TotalOrderQuantity_discount - f.TotalOrderQuantity_nodiscount) 
										AS 'TotalOrderQty Increased with Discount'
		,f.Count_ProductID_nodiscount  AS 'Total Num Unique Product with Discount'
		,f.Count_ProductID_discount    AS 'Total Num Unique Product with no Discount' 
		--,(f.Count_ProductID_discount - f.Count_ProductID_nodiscount) 
			--							AS 'Unique Product Increased with Discount'	
FROM FactOrder f
JOIN dimDate dd on dd.OrderDate = f.OrderDate
JOIN dimTerritory dt on dt.TerritoryID = f.Territory_ID
WHERE   AvgOrderQuantity_nodiscount > 0
		AND AvgOrderQuantity_discount > 0
		AND TotalOrderQuantity_nodiscount >0 
		AND TotalOrderQuantity_discount > 0
		AND Count_ProductCategories_nodiscount >0 
		AND Count_ProductCategories_discount > 0
		AND dd.Year = 2013		
		--AND (f.Count_ProductCategories_discount - f.Count_ProductCategories_nodiscount)  > 0
		AND f.PurchaseGreaterWhenDiscount = 1 
GROUP BY Customer_ID, Year, Month,CountryRegionCode, AvgOrderQuantity_nodiscount, AvgOrderQuantity_discount, (AvgOrderQuantity_discount - f.AvgOrderQuantity_nodiscount)
		,TotalOrderQuantity_nodiscount, TotalOrderQuantity_discount, TotalOrderQuantity_discount - f.TotalOrderQuantity_nodiscount, Count_ProductID_nodiscount
		,Count_ProductID_discount
ORDER BY 'TotalOrderQty Increased with Discount' DESC
--ORDER BY 'AvgQrderQty Increased with Discount' DESC
--ORDER BY 'Unique Product Increased with Discount' DESC
select f.Count_ProductID_discount from  FactOrder f

--3.2

SELECT f.Customer_ID
		,dd.Month AS 'Month'
		,dt.TerritoryName AS 'Region'
		,f.AvgOrderQuantity_nodiscount AS 'AvgOrderQty with No Discount'
		,f.AvgOrderQuantity_discount AS 'AvgOrderQty with Discount'
		,(f.AvgOrderQuantity_discount - f.AvgOrderQuantity_nodiscount) 
										AS 'AvgQrderQty Increased with Discount'
		--,f.TotalOrderQuantity_nodiscount AS 'TotalOrderQty with No Discount'
		--,f.TotalOrderQuantity_discount AS 'TotalOrderQty with Discount'
		--,(f.TotalOrderQuantity_discount - f.TotalOrderQuantity_nodiscount) 
		--								AS 'TotalOrderQty Increased with Discount'
		--,f.Count_ProductCategories_nodiscount AS 'Total Num Unique Product with no Discount' 
		--,f.Count_ProductCategories_discount AS 'Total Num Unique Product with Discount'
		--,(f.Count_ProductCategories_discount - f.Count_ProductCategories_nodiscount) 
		--								AS 'Unique Product Increased with Discount'
FROM FactOrder f
JOIN dimDate dd on dd.OrderDate = f.OrderDate
JOIN dimTerritory dt on dt.TerritoryID = f.Territory_ID
WHERE   --AvgOrderQuantity_nodiscount > 0
		--AND AvgOrderQuantity_discount > 0
		--AND TotalOrderQuantity_nodiscount >0 
		--AND TotalOrderQuantity_discount > 0
		--AND Count_ProductCategories_nodiscount >0 
		--AND Count_ProductCategories_discount > 0 
	     dd.Year = 2014
		AND dd.Month IN (3, 4)
		--AND dt.TerritoryName = 'United Kingdom'
GROUP BY Customer_ID, dd.Month , TerritoryName, AvgOrderQuantity_nodiscount, AvgOrderQuantity_discount, (f.AvgOrderQuantity_discount - f.AvgOrderQuantity_nodiscount)
ORDER BY 'AvgQrderQty Increased with Discount' DESC
