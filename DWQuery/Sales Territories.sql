USE [DataWareHouseLastFinal]
GO
/****** Object:  StoredProcedure [dbo].[LoadSalesTerritories]    Script Date: 7/25/2018 10:37:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LoadSalesTerritories] @LastDate datetime
AS
BEGIN

IF NOT EXISTS (select 1 from SalesTerritory)
		BEGIN

		--adding source new records to dimention table
		INSERT INTO SalesTerritory(AdventureID,SalesTerritoryName,Regiongroup,TerritoryGroup)
		--  AdventureID - TerritoryID
		--  SalesTerritoryName - Name
		--  Regiongroup - CountryRegionCode
		--  TerritoryGroup - [Group]
		--  WaterMark - ModifiedDate
			SELECT TerritoryID,iif(A.Name is not null,A.Name,'Not Yet Confirmed'),iif(A.CountryRegionCode is not null,A.CountryRegionCode,'Not Yet Confirmed'),iif(A.[Group] is not null,A.[Group],'Not Yet Confirmed')
			FROM AdventureWorks2014.Sales.SalesTerritory AS A
		--check the new records exists	 
			--where @LastDate< a.modifiedDate
			--WHERE TerritoryID NOT IN (SELECT AdventureID FROM SalesTerritory) 


			END
		ELSE
			BEGIN

			INSERT INTO SalesTerritory(AdventureID,SalesTerritoryName,Regiongroup,TerritoryGroup)
		--  AdventureID - TerritoryID
		--  SalesTerritoryName - Name
		--  Regiongroup - CountryRegionCode
		--  TerritoryGroup - [Group]
		--  WaterMark - ModifiedDate
			SELECT TerritoryID,iif(A.Name is not null,A.Name,'Not Yet Confirmed'),iif(A.CountryRegionCode is not null,A.CountryRegionCode,'Not Yet Confirmed'),iif(A.[Group] is not null,A.[Group],'Not Yet Confirmed')
			FROM AdventureWorks2014.Sales.SalesTerritory AS A
		--check the new records exists	 
			where @LastDate< a.modifiedDate

		--Update dimetion table acording to update source records
			Update SalesTerritory
			Set SalesTerritory.AdventureID = A.TerritoryID,
				SalesTerritory.SalesTerritoryName =iif(A.Name is not null,A.Name,'Not Yet Confirmed'),
				SalesTerritory.Regiongroup =iif(A.CountryRegionCode is not null,A.CountryRegionCode,'Not Yet Confirmed'),
				SalesTerritory.TerritoryGroup =iif(A.[Group] is not null,A.[Group],'Not Yet Confirmed')
		
    	
		--creating connection 	
				from SalesTerritory as c
				inner join AdventureWorks2014.Sales.SalesTerritory AS A
				on c.AdventureID = a.TerritoryID
		--check for updates
				where @LastDate< a.modifiedDate
   END
		update Watermark
			set lastModifiedDate = @LastDate
			where 
				Tablename like 'SALESTERRITORY'
	
END