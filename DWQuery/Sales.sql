USE [DataWareHouseLastFinal]
GO
/****** Object:  StoredProcedure [dbo].[LoadSales]    Script Date: 7/25/2018 10:36:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LoadSales] @LastDate datetime
AS
BEGIN
	
	IF NOT EXISTS (select 1 from Sales)
		BEGIN

			--adding source new records to dimention table
			INSERT INTO Sales(SalesAmount,SalesQuantity,ProductID,DateKey,CustomerID,SalesTerritoryID)
			-- SalesAmount - AdventureWorks2014.Sales.SalesOrderDetail.LineTotal
			-- SalesQuantity - AdventureWorks2014.Sales.SalesOrderDetail.OrderQty
			-- ProductID - Product.ProductID
			-- DateKey - Date.DateKey
			-- CustomerID - Customer.CustomerID
			-- SalesTerritoryID - SalesTerritory.SalesTerritoryID
			-- watermark - AdventureWorks2014.Sales.SalesOrderHeader.ModifiedDate
				SELECT  t1.LineTotal, t1.OrderQty, t2.ProductID,t4.DateKey,t5.CustomerID,t6.SalesTerritoryID
				 FROM AdventureWorks2014.Sales.SalesOrderDetail as t1
				 Inner JOIN Product as t2 
				 ON t1.ProductID = t2.AdventureID
				 Inner Join AdventureWorks2014.Sales.SalesOrderHeader as t3
				 ON t1.SalesOrderID=t3.SalesOrderID
				 Inner Join Date as t4
				 ON t3.OrderDate=t4.Date
				 Inner Join Customer as t5
				 ON  t3.CustomerID=t5.AdventureID
				 Inner Join SalesTerritory as t6
				 ON t3.TerritoryID=t6.AdventureID
			--check the new records exists	 
				  
				END
		ELSE
			BEGIN
				--adding source new records to dimention table
			INSERT INTO Sales(SalesAmount,SalesQuantity,ProductID,DateKey,CustomerID,SalesTerritoryID)
			-- SalesAmount - AdventureWorks2014.Sales.SalesOrderDetail.LineTotal
			-- SalesQuantity - AdventureWorks2014.Sales.SalesOrderDetail.OrderQty
			-- ProductID - Product.ProductID
			-- DateKey - Date.DateKey
			-- CustomerID - Customer.CustomerID
			-- SalesTerritoryID - SalesTerritory.SalesTerritoryID
			-- watermark - AdventureWorks2014.Sales.SalesOrderHeader.ModifiedDate
				SELECT  t1.LineTotal, t1.OrderQty, t2.ProductID,t4.DateKey,t5.CustomerID,t6.SalesTerritoryID
				 FROM AdventureWorks2014.Sales.SalesOrderDetail as t1
				 Inner JOIN Product as t2 
				 ON t1.ProductID = t2.AdventureID
				 Inner Join AdventureWorks2014.Sales.SalesOrderHeader as t3
				 ON t1.SalesOrderID=t3.SalesOrderID
				 Inner Join Date as t4
				 ON t3.OrderDate=t4.Date
				 Inner Join Customer as t5
				 ON  t3.CustomerID=t5.AdventureID
				 Inner Join SalesTerritory as t6
				 ON t3.TerritoryID=t6.AdventureID

				 where @LastDate< t3.modifiedDate --AND t1.LineTotal is not null AND t1.OrderQty is not null AND t2.ProductID is not null AND t4.DateKey is not null AND t5.CustomerID is not null AND t6.SalesTerritoryID is not null
			END			 
				 
		 
	
    update Watermark
			set lastModifiedDate = @LastDate
			where 
				Tablename like 'CATEGORY'
	 

END
	
