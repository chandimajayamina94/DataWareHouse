USE [DataWareHouseLastFinal]
GO
/****** Object:  StoredProcedure [dbo].[LoadCustomers]    Script Date: 7/25/2018 10:36:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LoadCustomers]
AS
BEGIN
--adding source new records to dimention table
INSERT INTO Customer(AdventureID,CustomerName, CustomerCity, CustomerCountry)
--  AdventureID - BusinessEntityID
--  CustomerName - CONCAT(FirstName,'',LastName) we have to give both first and last names
--  CustomerCity - City
--  CustomerCountry - CountryRegionName
   SELECT   BusinessEntityID,CONCAT(FirstName,'',LastName),City,CountryRegionName
	 FROM AdventureWorks2014.Sales.vIndividualCustomer
--check the new records exists	   
	 WHERE BusinessEntityID NOT IN (Select AdventureID FROM Customer)

END