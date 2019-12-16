# Datawarehoue

## Adventureworks database diagram:

![adventureworks-database-diagram](/image/adventureworks-database-diagram.png)

## The data warehouse project is mainly built for answering 3 main questions.

1. For each customer, display & sort based on the average/total number of SalesOrderDetail.OrderQty
   and total number of (unique) product/product categories they bought at discount/original price
   in a specific/all territory at a specific month/year

2. For each customer, display & sort based on whether the number of products/OrderQty
   has increased through 2 times period.

3. Display & sort customers, whose average/total number of SalesOrderDetail.OrderQty,
   total number of (unique) product/product categories sold at discount is
   greater than when it is sold at original price in a specific/all territory at a specific month/year,
   and it has increased the number of products/OrderQty through 2 times period

## Over view dimensional modelling in data warehouse

![Over-view-dimensional-modelling-in-data-warehouse](/image/Over-view-dimensional-modelling-in-data-warehouse.png)

## Data-quality-assurance

![Data-quality-assurance](/image/Data-quality-assurance.png)

## Sample query to extract from ADW and load into fact table

![Sample-query-to-extract-from-ADW-and-load-into-fact-table](/image/Sample-query-to-extract-from-ADW-and-load-into-fact-table.png)

## Query performance

![query-performance](/image/query-performance.png)
