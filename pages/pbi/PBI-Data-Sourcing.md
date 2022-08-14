---
layout: page
title: Power BI - Data Sourcing 
---

Lab instructions on sourcing data into PBI Desktop. 

- [PBI Desktop Settings](#pbi-desktop-settings) 
    - [Core](#core-pbi-options) 
    - [Data Source](#data-source-settings)
- [Data Sourcing](#data-sourcing) 
    - [Relational Data](#relational-data) 
    - [Flat File](#flat-file)

## Foundations 
- [PBI on a Page]
    - ![Reference](/resources/PBIRptDev/PBIOnPage.png "PBI on a page")
- [PBI Architecture]
    ![Reference](https://www.stratebi.com/documents/20194/0/power+bi+architecture.png/501000ef-6243-4360-ba59-36e246493d22?t=1534786941141)
    - [Reference](https://www.stratebi.com/documents/20194/0/power+bi+architecture.png/501000ef-6243-4360-ba59-36e246493d22?t=1534786941141){:target="_blank"}
- [Adoption Roadmap](https://docs.microsoft.com/en-us/power-bi/guidance/powerbi-adoption-roadmap-overview){:target="_blank"}
- [Managed Self-service with PBI](https://docs.microsoft.com/en-us/power-bi/guidance/powerbi-implementation-planning-usage-scenario-customizable-managed-self-service-bi){:target="_blank"}

## PBI Desktop Settings
There's a myriad of options that are worth considering and can be set as a Global or current file setting. Options set out here can have a last impact to reports, even when they are finally published (as report or dataset) to PBI Service. 
### (Core PBI) Options
- Global, Current File 
- Data Load 
    - Type Detection 
    - Background Data 
    - Loading Tables Simultaneously 
        - #of evaluations, memory per evaluation 
    - **Time Intelligence**(disable)
    - Data Cache Management Options 
- Diagnostics 
    - **Enable tracing**(leave as is)
    - Crash Dump Collection 
    - Query Diagnostics
        - Aggregated, Detailed, Performance counters
- Preview Features 
    - Sparklines, Mobile layout settings, DirectQuery for PBI Datasets and AS
- Published dataset 
    - Max connections per data source 
- Query Reduction 
    - Cross filtering, Slicers, Filters 
- **Report Settings**(leave as is) 
    - Allow users to change filter types, Cross-report drillthrough , Developer Mode
### Data Source Settings 
- Change Data Source 
- Edit Permissions 
- GLobal Permissions 
## Data Sourcing 
### Relational Data 
- Click on **Get Data** 
- Get the Server details from trainer or as published earlier, Database: AdventureWorksDW 
- Select **Import** as Data Connectivity Mode 
- Select Entities
    - DimCustomer
    - DimDate  
    - DimEmployee
    - DimGeograhpy 
    - DimProduct 
    - DimProductCategory 
    - DimProductSubcategory
    - DimReseller
    - DimSalesTerritory
    - FactResellerSales 
    - FactInternetSales 
    - FactSalesQuota 
    
    After selection, click on **Transform Data**
#### Transform Data 
- Topics worth Exploring 
    - Queries
        - Groups 
            - Usage, (Group) Parameters
        - Create Function, **Enable Load**, **Include in Report Refresh** 
        - Manage parameters 
        - **Advanced Editor** 
        - **Merge / Append** Queries 
        - Columns & Rows
            - Choose Columns, Split Columns, **Data type**, Keep/Remove Rows, **First Rows a Header**, Replace Values
        - AI Insights 
            - Text Analytics, Vision, AML 
    - Transform 
        - Group by, Transpose, Reverse Rows (generally for order)
        - **Pivot, Unpivot** 
        - **Replace Values**, Fill 
        - Number Calculations, Run R/Python script (ELT) 
    - Add Column 
        - From Example, Custom Column, Conditional Column, Index Column 
    - View 
        - **Column Quality**
        - **Column Distribution**
        - **Column Profile** 
        - Query Depdendency 
    - Tools 
        - Diagnose Step, Start/Stop Diagnostics
- Module related transformations
    - Join Product, ProductSubCategory, ProductCategory
        - For **DimProduct**
            - Filter on FinishedGoodsFlag = "TRUE" 
            - Remove all columns except  
                - ProductKey, ProductSubcategoryKey
                - EnglishProductName, ModelName, EnglishDescription, Color 
                - StandardCost, ListPrice, DealerPrice
            - Rename columns as 
                - EnglishProductName -> Product
                - EnglishDescription -> Description
                - StandardCost -> Cost
                - ListPrice -> List Price 
                - DealerPrice -> Dealer Price
        - For **DimProductSubcategory**, 
            - Remove all columns except 
                - ProductSubcategoryKey 
                - EnglishProductSubcategoryName
                - ProductCategoryKey
            - Rename columns as 
                - EnglishProductSubcategoryName -> Subcategory
        - For **DimProductCategory**
            - Remove all columns except 
                - ProductCategoryKey
                - EnglishProductCategoryName
            - Rename columns as 
                - EnglishProductCategoryName -> Category 
        - Merge the three tables together 
            - With DimProduct selected, click on **Merge Queries**, and merge it with **DimProductSubcateogry** with **ProductSubcateogryKey** as joining column
            - Expand DimProductSubcateogry to include all columns except ProductSubcateogryKey without using column name prefix 
            - With DimProduct selected, click on **Merge Queries**, and merge it with **DimProductCateogry** with **ProductCateogryKey** as joining column
            - Expand DimProductCateogry to include all columns except ProductCateogryKey without using column name prefix 
        - Disable loading of DimProductSubcateogry and DimProductCateogry, and rename DimProduct to Product
    - Focussed SalesPerson Data 
        - For **DimEmployee**
            - Filter on SalesPersonFlaog = TRUE 
            - Remove all columns except
                - EmployeeKey, ParentEmployeeKey, SalesTerritoryKey
                - FirstName, LastName, Gender, MaritalStatus, BirthDate 
                - EmailAddress
            - Create a Merged Columne named **SalesPerson**, merging FirstName, LastName with Space as a seperator
        - Rename DimEmployee to **SalesPerson**
    - Customer data with their geography info 
        - For **DimCustomer**
            - Remove all columns except
                - CustomerKey, GeographyKey 
                - FirstName, LastName, BirthDate, MaritalStatus, 
                - EmailAddress, YearlyIncome, EnglishEducation, EnglishOccupation, HouseOwnerFlag, NumberCarsOwned
        - For **DimGeography**
            - Remove all columns except 
                - GeographyKey, SalesTerritoryKey
                - City, StateProvinceName, EnglishCountryRegionName, PostalCode
            - Rename following columns 
                - StateProvinceName -> State
                - EnglishCountryRegionName -> Country 
        - For **DimSalesTerritory**
            - Remove all columns except
                - SalesTerritoryKey
                - SalesTerritoryRegion, SalesTerritoryCountry, SalesTerritoryGroup
            - Rename following columns 
                - SalesTerritoryRegion -> Territory
                - SalesTerritoryCountry -> Country
                - SalesTerritoryGroup -> TerritoryGroup
        - Merge the three tables together 
            - With DimCustomer selected, click on **Merge Queries**, and merge it with **DimGeography** with **GeographyKey** as joining column
            - Expand DimGeography to include all columns except GeographyKey without using column name prefix 
            - With DimCustomer selected, click on **Merge Queries**, and merge it with **DimSalesTerritory** with **SalesTerritoryKey** as joining column
            - Expand DimSalesTerritory to include all columns except SalesTerritoryKey without using column name prefix 
        - Disable loading of DimGeograpy and DimSalesTerritory, and rename DimCustomer to Customer
    - Reseller data with their geography info 
        - For **DimReseller**
            - Remove all columns except
                - Reseller, GeographyKey 
                - BusinessType, ResellerName 
                - AnnualSales, AnnualRevenue
            - Rename DimCustomer to Customer  
        - Note that DimGeograpy and DimSalesTerritory are transformed already in previous step
        - Merge the three tables together 
            - With DimReseller selected, click on **Merge Queries**, and merge it with **DimGeography** with **GeographyKey** as joining column
            - Expand DimGeography to include all columns except GeographyKey without using column name prefix 
            - With DimCustomer selected, click on **Merge Queries**, and merge it with **DimSalesTerritory** with **SalesTerritoryKey** as joining column
            - Expand DimSalesTerritory to include all columns except SalesTerritoryKey without using column name prefix 
        - Rename DimReseller to Reseller
    - Final / Minor Touches 
        - For **DimDate**
            - Remove all columns except 
                - DateKey, FullAlternateDateKey 
                - DayNumberOfWeek, DayNumberOfMonth, DayNumberOfYear, WeekNumberOfYear, MonthNumberOfYear
                - EnglishDayNameOfWeek, EnglishMonthName, CalendarQuarter, CalendarYear, FiscalQuarter, FiscaleYear
            - Rename FullAlternateDateKey to DateValue and table DimDate to Date
        - Rename FactSalesQuota to SalesQuota. Click on **Close & Apply**

### Flat File 
- Within Data Trasformation screen, source flat files: 
    - [ColorFormats]({% link resources/PBIRptDev/ColorFormats.csv %})
    - [ResellerSales_2020]({% link resources/PBIRptDev/ResellerSales_2020.csv %})
    - [ResellerSalesTargets]({% link resources/PBIRptDev/ResellerSalesTargets.csv %})
- **ColorFormats**
    - Alter to use first row as hearders
- **ResellerSalesTargets**
    - Currently its a flat table, with Year, EmployeeIDs monthly targets represented as M01, M02 etc. Target is to reach a by EmployeeID, by Month target sales values. 
    - Unpivot on Year, EmployeeID
    - Replace M from Attribute values, change datatypes to Whole Number.
    - Add column from example with Year, Attribute (for month), input value being [Attribute Value] / 1 / [Year]. Remove columns Year, Attribute. Rename Merged column to **TargetMonth**.
    - Filter out rows with "-" from within Value, convert datatype to wholenumber, and multiply by 1000. Rename the column to **Target**.
    - You should have a table with columns EmployeeID, Target, TargetMonth
- Click on **Close & Apply**

Resulted file from this lab is available [here]({% link resources/PBIRptDev/SalesAnalysis_DataSourcing.pbix %}){:target="_blank" rel="noopener"}. Please note that you will have to alter the data source for relational data store (SQL Server in this case) and respective flat files. Datastore can be referenced [here]({% link resources/PBIRptDev/AdventureWorksDW2020.bak %}){:target="_blank" rel="noopener"}, while flat files are [here](#flat-file)
