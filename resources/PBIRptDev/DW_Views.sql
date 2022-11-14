CREATE SCHEMA DW; 
GO 

CREATE OR ALTER VIEW [DW].[DimDate] AS 
SELECT [DateKey] AS [OrderDateKey]
      ,[FullDateAlternateKey] AS [Date]
      --,[SpanishDayNameOfWeek]
      --,[FrenchDayNameOfWeek]
      --,[SpanishMonthName]
      --,[FrenchMonthName]
	  ,[EnglishMonthName] AS [MonthName]
      ,[EnglishDayNameOfWeek] AS [WeekName]
      --,CAST( [DayNumberOfWeek]   AS VARCHAR(5) ) AS [DayNumberOfWeek]
      --,CAST( [DayNumberOfMonth]  AS VARCHAR(5) ) AS [DayNumberOfMonth]
      --,CAST( [DayNumberOfYear]   AS VARCHAR(5) ) AS [DayNumberOfYear]
      ,[WeekNumberOfYear]  AS [Week]
      ,[MonthNumberOfYear]  AS [Month]
      ,[CalendarQuarter]   AS [Quarter]
      ,[CalendarYear]      AS [Year]
      --,CAST( [CalendarSemester]  AS VARCHAR(5) ) AS [CalendarSemester]
      ,[FiscalQuarter] AS [FiscalQuarter]
      ,'FY'+CAST( [FiscalYear]        AS VARCHAR(5) ) AS [FiscalYear]
      --,CAST( [FiscalSemester]    AS VARCHAR(5) ) AS [FiscalSemester]
  FROM [dbo].[DimDate]
GO

CREATE OR ALTER VIEW [DW].[DimProduct] AS 
SELECT dp.[ProductKey]
      ,dp.[EnglishProductName] AS [Product]
	  ,ds.EnglishProductSubcategoryName AS [Subcategory]
	  ,dc.EnglishProductCategoryName AS [Category]
      ,dp.[StandardCost]
      ,dp.[Color]
  FROM [dbo].[DimProduct] dp 
  INNER JOIN dbo.DimProductSubcategory ds ON dp.ProductSubcategoryKey = ds.ProductSubcategoryKey
  INNER JOIN dbo.DimProductCategory dc ON dc.ProductCategoryKey = ds.ProductCategoryKey
  WHERE dp.[FinishedGoodsFlag] = 1 
GO

CREATE OR ALTER VIEW [DW].[DimReseller] AS 
SELECT dr.[ResellerKey]
      --,[GeographyKey]
      --,[ResellerAlternateKey]
      --,[Phone]
      ,dr.[BusinessType]
      ,dr.[ResellerName]
      --,[NumberEmployees]
      --,[OrderFrequency]
      --,[OrderMonth]
      --,[FirstOrderYear]
      --,[LastOrderYear]
      --,[ProductLine]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[AnnualSales]
      --,[BankName]
      --,[MinPaymentType]
      --,[MinPaymentAmount]
      --,[AnnualRevenue]
      --,[YearOpened]
	  ,dg.City
	  ,dg.StateProvinceName AS [State]
	  ,dg.EnglishCountryRegionName AS [Country] 
  FROM [dbo].[DimReseller] dr 
  INNER JOIN dbo.[DimGeography] dg on dr.GeographyKey = dg.GeographyKey
GO

CREATE OR ALTER VIEW [DW].[DimSalesPerson] AS 
SELECT de.[EmployeeKey]
      --,[ParentEmployeeKey]
      ,de.[EmployeeNationalIDAlternateKey]
      --,[ParentEmployeeNationalIDAlternateKey]
      --,[SalesTerritoryKey]
      ,de.[FirstName] + ' ' + de.[MiddleName] + ' ' + de.[LastName] AS [SalesPerson]
	  --,[NameStyle]
      ,de.[Title]
      --,[HireDate]
      --,[BirthDate]
      --,[LoginID]
      --,[EmailAddress]
      --,[Phone]
      --,[MaritalStatus]
      --,[EmergencyContactName]
      --,[EmergencyContactPhone]
      --,[SalariedFlag]
      --,[Gender]
      --,[PayFrequency]
      --,[BaseRate]
      --,[VacationHours]
      --,[SickLeaveHours]
      --,[CurrentFlag]
      --,[SalesPersonFlag]
      --,[DepartmentName]
      --,[StartDate]
      --,[EndDate]
      --,[Status]
      --,[EmployeePhoto]
	  ,ds.SalesTerritoryCountry  AS [Country]
	  ,ds.SalesTerritoryRegion AS [Region]
	  ,ds.SalesTerritoryGroup AS [Group]
  FROM [dbo].[DimEmployee] de 
  INNER JOIN dbo.DimSalesTerritory ds ON ds.SalesTerritoryKey = de.SalesTerritoryKey
WHERE de.[SalesPersonFlag] = 1
GO

CREATE OR ALTER VIEW [DW].[FactSales] AS 
SELECT [ProductKey]
      ,[OrderDateKey]
      --,[DueDateKey]
      --,[ShipDateKey]
      ,[ResellerKey]
      ,[EmployeeKey]
      --,[PromotionKey]
      --,[CurrencyKey]
      ,[SalesTerritoryKey]
      ,[SalesOrderNumber]
      ,[SalesOrderLineNumber]
      --,[RevisionNumber]
      ,[OrderQuantity] AS [Quantity]
      --,[UnitPrice]
      --,[ExtendedAmount]
      --,[UnitPriceDiscountPct]
      --,[DiscountAmount]
      --,[ProductStandardCost]
      ,[TotalProductCost] AS [Cost]
      ,[SalesAmount] AS [Sales]
      ,[TaxAmt] AS [Tax]
      --,[Freight] 
      --,[CarrierTrackingNumber]
      --,[CustomerPONumber]
      ,CAST([OrderDate] AS DATE) AS [OrderDate]
      --,CAST([DueDate] AS DATE) AS [DueDate]
      --,CAST([ShipDate] AS DATE) AS [ShipDate]
  FROM [dbo].[FactResellerSales]
GO

CREATE OR ALTER VIEW [DW].[FactSalesQuota] AS 
SELECT [SalesQuotaKey]
      ,[EmployeeKey]
      ,[DateKey]
      --,[CalendarYear]
      --,[CalendarQuarter]
      ,[SalesAmountQuota] AS [Target]
      --,[Date]
  FROM [dbo].[FactSalesQuota]
GO
