USE [DataWareHouseLastFinal]
GO
/****** Object:  StoredProcedure [dbo].[LoadProducts]    Script Date: 7/25/2018 10:36:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LoadProducts] @LastDate datetime
AS
BEGIN

IF NOT EXISTS (select 1 from Product)
		BEGIN

		--adding source new records to dimention table 
		INSERT INTO Product(AdventureID,SubCategoryID,ProductName,ProductColour,ProductSize)
		--AdventureID - Sourcetable primary ProductID
		--SubCategoryID - Sourcetable ProductSubCategoryID
		--ProductName - Name
		--ProductColour - Color
		--ProductSize - Size
		--Watermark - ModifiedDate 
			SELECT ProductID,iif( A.ProductSubcategoryID is not null,A.ProductSubcategoryID,-1),iif(A.Name is not null,A.Name,'Not Yet Confirmed'),iif(A.Color is not null,A.Color,'Not yet confirmed'),iif(A.Size is not null,A.Size,'Not yet confirmed')
			FROM AdventureWorks2014.Production.Product AS A
		--check the new records exists
			--where @LastDate< a.modifiedDate
			--WHERE ProductID NOT IN (SELECT AdventureID FROM Product)	
	
		END
		ELSE
			BEGIN

			INSERT INTO Product(AdventureID,SubCategoryID,ProductName,ProductColour,ProductSize)
		--AdventureID - Sourcetable primary ProductID
		--SubCategoryID - Sourcetable ProductSubCategoryID
		--ProductName - Name
		--ProductColour - Color
		--ProductSize - Size
		--Watermark - ModifiedDate 
			SELECT ProductID,iif( A.ProductSubcategoryID is not null,A.ProductSubcategoryID,-1),iif(A.Name is not null,A.Name,'Not Yet Confirmed'),iif(A.Color is not null,A.Color,'Not yet confirmed'),iif(A.Size is not null,A.Size,'Not yet confirmed')
			FROM AdventureWorks2014.Production.Product AS A
		--check the new records exists
			where @LastDate< a.modifiedDate

--Update dimetion table acording to update source records
	Update Product
	Set Product.AdventureID = A.ProductID,
		Product.SubCategoryID =iif( A.ProductSubcategoryID is not null,A.ProductSubcategoryID,-1),
		Product.ProductName= iif(A.Name is not null,A.Name,'Not Yet Confirmed'),
        Product.ProductColour=iif(A.Color is not null,A.Color,'Not yet confirmed'),
		Product.ProductSize=iif(A.Size is not null,A.Size,'Not yet confirmed')
		
--creating connection 
		from Product as c
		inner join AdventureWorks2014.Production.Product AS A
		on c.AdventureID = a.ProductID
		where @LastDate< a.modifiedDate
	END
		update Watermark
			set lastModifiedDate = @LastDate
			where 
				Tablename like 'PRODUCT'

END