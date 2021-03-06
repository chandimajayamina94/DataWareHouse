USE [DataWareHouseLastFinal]
GO
/****** Object:  StoredProcedure [dbo].[LoadCatergories]    Script Date: 7/25/2018 10:36:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LoadCatergories] @LastDate datetime
AS
BEGIN

IF NOT EXISTS (select 1 from Category)
		BEGIN

			--adding source new records to dimention table 
			INSERT INTO Category(AdventureID,CategoryName)

			--AdventureID - Sourcetable primary keys
			--CategoryName - Sourcetable Categoryname
			--Watermark - ModifiedDate  
				SELECT ProductCategoryID,iif( A.Name is not null,A.Name,'Not Yet Confirmed')
				FROM AdventureWorks2014.Production.ProductCategory AS A

			--check the new records exists	
				--where @LastDate< a.modifiedDate
				--WHERE ProductCategoryID NOT IN (SELECT AdventureID FROM Category) 
	
	
	

	END
		ELSE
			BEGIN

			INSERT INTO Category(AdventureID,CategoryName)

			--AdventureID - Sourcetable primary keys
			--CategoryName - Sourcetable Categoryname
			--Watermark - ModifiedDate  
				SELECT ProductCategoryID,iif( A.Name is not null,A.Name,'Not Yet Confirmed')
				FROM AdventureWorks2014.Production.ProductCategory AS A

			--check the new records exists	
				where @LastDate< a.modifiedDate


			--Update dimetion table acording to update source records
				Update Category
				Set Category.adventureID = A.productCategoryID,
					Category.categoryName =iif( A.Name is not null,A.Name,'Not Yet Confirmed')
		
		
			--creating connection 		
					from Category as c
					inner join AdventureWorks2014.Production.ProductCategory AS A
					on c.AdventureID = a.ProductCategoryID
			--check for updates
					where @LastDate< a.modifiedDate
      END

		update Watermark
			set lastModifiedDate = @LastDate
			where 
				Tablename like 'CATEGORY'

END	
