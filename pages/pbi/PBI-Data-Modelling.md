---
layout: page
title: Power BI - Data Modelling 
---

Lab instructions on modelling data in Power BI. 
- [Exploring data model](#exploring-data-model)
- [Data model elements](#data-model-elements)
- [DAX](#dax)
- [Implement model changes](#implement-model-changes)


## Exploring Data Model 
- Manage Relationships 
- Manage Roles, View as
- Q&A Setup
    - Field Synonym 
    - Review Questions 
    - Teach Q&A
    - Suggest Questions 
- Field Settings 
    - Hide Tables/ Attributes 
    - Manage Aggregations (covered [later](#model-optimizations))
    - Field Properties 
        - Synonyms, Display Folder, Hiddne, Format, SortBy, DataCategory 
    - Hierarchy

## Data Model Elements 
### Types of Data Model
- Intro, Pros, Cons of 
    - Flat (denormalized)
    - Star
    - Snowflake 
### Relationships 
- Cardinality 
    - noun :) 
    - the number of elements in a set or other grouping, as a property of that grouping
    - 1-1, 1-n, n-1, m-n
    - Solid vs dotted line 
- Filtering 
    - Unidirectional, bi-directional 
- Compression 
    - Value based encoding (base value + value)
    - Dictionary based encoding (dictionary index - occurence)
### Model Optimizations 
- Aggregations 
    - [Automatic Aggregations (preview)]
        - ![Reference](https://docs.microsoft.com/en-us/power-bi/enterprise/media/aggregations-automatic/auto-aggregations.png)
        - [Reference](https://docs.microsoft.com/en-us/power-bi/enterprise/media/aggregations-automatic/auto-aggregations.png)
- Tips 
    - optimize number of columns pulled into model (as model stays in physical memory)
    - key columns arent needed in fact tables 
    - pre-sort columns as pre-design activity outside PBI 
    - increase the number of columns with unique values (e.g. datetime vs date and time)
    - always target star schema 
### Model Enhancers 
- Calculated Columns
    - Per row calculation, extends table 
    - Avoid helper columns (not used in final calc, but still take up memory)
    - Create calculated columns in dimensions over facts 
    - Use Add Column instead of Calculated columns 
- Measures 
    - Table level aggregates 
    - Page specific 

### DAX 
- This can last for next few weeks ! 
#### Introduction to DAX 
- [Key Concepts](https://support.microsoft.com/en-us/office/context-in-dax-formulas-2728fae0-8309-45b6-9d32-1d600440a7ad#:~:text=Query%20context%20refers%20to%20the,filter%20expressions%20within%20the%20formula.){:target="_blank" rel="noopener"} 
    - Row Context 
        - Current row
        - [Profit] = [Sales] - RELATED('ProductionLog'[Cost])
        - EARLIER, EARLIEST (multi-row context)
    - Query Context
        - SUM('Sales'[SalesAmount])
        - Value changes on basis of placement, hierarchy, filters, slicers! 
    - Filter Context
        - Regardless of the Query context due to filters, slicers, column or row values, the Filter context is still applied (or overrides the filter context)
        - E.g. grand total using [ALL](https://docs.microsoft.com/en-us/dax/all-function-dax){:target="_blank" rel="noopener"}, selectively clear and apply filters using [ALLEXCEPT](https://docs.microsoft.com/en-us/dax/allexcept-function-dax){:target="_blank" rel="noopener"}

#### Fundamentals 
- Calculated Columns 
    - e.g. TargetMonth 
- Calculated Measures 
    - Profit, ProfitMargin 

#### DAX Context 
- Filter Context 
    - Filter Context: Set of one or more filters (e.g. CalendarYear value clicked, then Eduction value clicked, and then Brand Contoso is clicked). Filter context is not a condition, but a set of filters. 
    - Experiment
    
            TotalSales = SUM('DW FactSales'[Sales])
        
            TotalSales(Global) = CALCULATE([TotalSales], ALL('DW FactSales'[Sales]))
        
            TotalSales(Globalv2) = IF(ISBLANK([TotalSales]), BLANK(), CALCULATE([TotalSales], REMOVEFILTERS('DW DimSalesPerson'[Country])))
        
            TotalSales(NA) = CALCULATE([TotalSales], 'DW DimSalesPerson'[Country] IN {"United States", "Canada"})
        
            TotalSalesPercentNA = DIVIDE([TotalSales(NA)], [TotalSales])

- Row Context 
- Context Transition 
        MaxOrderdate = MAX('InternetSales'[OrderDate])
        MaxOrderDate = CALCULATE(MAX('InternetSales'[OrderDate]))

#### Timeseries 

        YTDSales = TOTALYTD([TotalSales], 'DW DimDate'[Date])
        YTDSalesJuneEnd = TOTALYTD([TotalSales], 'DW DimDate'[Date], "06/30")
        YTDSalesXmas = TOTALYTD([TotalSales], 'DW DimDate'[Date], 'DW DimDate'[Month] IN {12,1})
        PriorYearSales = CALCULATE([TotalSales], SAMEPERIODLASTYEAR('DW DimDate'[Date]))
        PriorYTDSales = CALCULATE([YTDSales], SAMEPERIODLASTYEAR('DW DimDate'[Date]))

#### Semi Additive Measures 



#### Key DAX Functions 
- Aggregate: COUNT[X], AVERAGE[X], MAX[X], MIN[X], SUM[X], PRODUCT[X]

- Date/Time: CALENDAR, DATE, DATEDIFF, HOUR, MINUTE, NOW, TIME, TODAY, MONTH, YEAR

- Filter: ALL, ALLEXCEPT, CALCULATE, FILTER, EARLIER, KEEPFILTERS

- Financial: PMT, PV, YIELD

- Logical: AND, OR, BITOR, BITAND, IF, IFERROR, NOT, OR, SWITCH

- Relationship: CROSSFILTER, RELATED, RELATEDTABLE, USERELATIONSHIP

- Text: LEFT, RIGHT, TRIM, REPLACE, FORMAT, CONCATENATE

- Time Intelligence: DATESMTD, DATESQTD, DATESYTD, ENDOFMONTH, ENDOFYEAR, FIRST/LASTDATE, NEXT[DAY, MONTH, YEAR], PREVIOUS[DAY, MONTH, YEAR], TOTAL[MTD, QTD, YTD]

## Implement Model Changes 

### Create Relationships 
- Product (ColorFormats/Color)
    - Now reduce snowflake to flat dimension merging Product & ColorFormats (retaining Color attribute as well)
- ResellerSalesFY2020 (SalesPerson, Product, Reseller)

### Hide Tables/Attributes 
- ResellerSalesTarget (mistaken data as Finance never provided EmployeedID!)
- All Key Attributes 

### Reports - Modelled Data in Action
#### Relationships 
- Delete relationship 
- Manage Role + View as 

#### Hierarchies
- Customer and Reseller (repeat for both)
    - Regions: TerritoryGroup (rename to Region), Country, Territory, State 
- Product 
    - Category, Subcategory, Product
- Date 
    - CalendarDate: CalendarYear, CalendarQuarter, EnglishMonthName
    - FiscalDate: FiscalYear, FiscalQuarter, EnglishMonthName
- Visual
    - Use Line & Clustered Column chart, adding 
        - **Customer -> Regions** hierarchy to x-axis 
        - **FactInternetSales -> Total Product Cost, Tax Amount** to column y-axis
        - **FactInternetSales -> Sales Amount** to Line y-axis
    - Notice the hierarchy based options on top right 
#### DAX Calculations 
- FactInternetSales 
    - Sales All Countries = CALCULATE(SUM(FactInternetSales[Sales Amount]), REMOVEFILTERS('Customer'[Country]))
    - Sales % All Countries = DIVIDE(SUM(FactInternetSales[Sales Amount]), CALCULATE(SUM(FactInternetSales[Sales Amount]), REMOVEFILTERS(Customer[Country])))
    - Visual 
        Add Matrix Visual with Rows as **Region, Country** and Values as **Sales, Sales All Countries, Sales % All Countries**
    - Sales YTD = TOTALYTD(SUM(FactInternetSales[Sales Amount]),'Date'[DateValue], "06-30")
    - Visual 
        - Add Sales YTD to matrix and notice the values (no values shown). Add filter on **Date -> CalendarYear**. Make some selections and notice the Sales YTD. Change filter to use **Date -> FiscalYear** and notice the Sales YTD. Adjust Sales YTD formula to use a different EOFY date. 

Resulted file from this lab is available [here]({% link resources/PBIRptDev/SalesAnalysis_DataModel.pbix %}){:target="_blank" rel="noopener"}.