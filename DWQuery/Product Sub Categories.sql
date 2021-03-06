USE [DataWareHouseLastFinal]
GO
/****** Object:  StoredProcedure [dbo].[LoadSubCategories]    Script Date: 7/25/2018 10:37:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LoadSubCategories] @LastDate datetime
AS
BEGIN


IF NOT EXISTS (select 1 from SubCategory)
		BEGIN
			--adding source new records to dimention table 
			INSERT INTO SubCategory(AdventureID,CategoryID,SubCategoryName)
			--AdventureID - Sourcetable primary ProductSubcategoryID
			--CategoryID - Sourcetable ProductCategoryID
			--SubCategoryName - Name
			--Watermark - ModifiedDate  
				SELECT ProductSubcategoryID,iif(A.ProductCategoryID is not null,A.ProductCategoryID,-1),iif(A.Name is not null,A.Name,'Not Yet Confirmed')
				FROM AdventureWorks2014.Production.ProductSubcategory AS A
			--check the new records exists	
				--where @LastDate< a.modifiedDate
				--WHERE ProductSubcategoryID NOT IN (SELECT AdventureID FROM SubCategory) 

				END
		ELSE
			BEGIN

			INSERT INTO SubCategory(AdventureID,CategoryID,SubCategoryName)
			--AdventureID - Sourcetable primary ProductSubcategoryID
			--CategoryID - Sourcetable ProductCategoryID
			--SubCategoryName - Name
			--Watermark - ModifiedDate  
				SELECT ProductSubcategoryID,iif(A.ProductCategoryID is not null,A.ProductCategoryID,-1),iif(A.Name is not null,A.Name,'Not Yet Confirmed')
				FROM AdventureWorks2014.Production.ProductSubcategory AS A
			--check the new records exists	
				where @LastDate< a.modifiedDate


--Update dimetion table acording to update source records
	Update SubCategory
	Set SubCategory.AdventureID = A.productSubCategoryID,
	    SubCategory.CategoryID =iif(A.ProductCategoryID is not null,A.ProductCategoryID,-1),
		SubCategory.SubCategoryName = iif(A.Name is not null,A.Name,'Not Yet Confirmed')
		
		
--creating connection 	
		from SubCategory as c
		inner join AdventureWorks2014.Production.ProductSubcategory AS A
		on c.AdventureID = a.ProductSubCategoryID
--check for updates
		where @LastDate< a.modifiedDate
   END
		update Watermark
			set lastModifiedDate = @LastDate
			where 
				Tablename like 'SUBCATEGORY'
	END