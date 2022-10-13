---
layout: page
title: Power BI - Report  Writer / End User
---

Lab notes and instructions targeted to Power BI Report Writer or End User role. 


# Introduction / Context 

## End outcome
At the end of this exercise, you should be able to produce a report looking like this: 

1. [Overview Tab]

    ![Reference](/resources/PBIRptDev/Page1_Overview.png "Overview Report")
    - [Reference](/resources/PBIRptDev/Page1_Overview.png "Overview Report")
    
2. [Profit Tab]

    ![Reference](/resources/PBIRptDev/Page2_Profit.png "Profit Report") 
    - [Reference](/resources/PBIRptDev/Page2_Profit.png "Profit Report") 

3. (Hidden) [Product Details Tab]

    ![Reference](/resources/PBIRptDev/Page3_ProductDetails.png "Product Details")
    - [Reference](/resources/PBIRptDev/Page3_ProductDetails.png "Product Details")

4. (Bonus) [Performance Tab]

    ![Reference](/resources/PBIRptDev/Page4_Performance.png "Performance Report")
    - [Reference](/resources/PBIRptDev/Page4_Performance.png "Performance Report")

Support files (for info): 
* [AdventureWorksDW Extract]({% link resources/PBIRptDev/AdventureWorksDW2020AdventworksDW_Extract.xls %}) 

<br><br>

# Stage 1: Connect with Data Source 
1. Open Power BI (PBI) Desktop application 
2. Click on **Get Data**
3. Select **Excel Workbook**, browse the location of DW Extract file marked above (adventureworksdw extract), select the file and client **Open**.
4. Check the checkbox against following entities. 
    - **DW DimDate**
    - **DW DimProduct** 
    - **DW DimReseller**
    - **DW DimSalesPerson** 
    - **DW FactSales**
    - **DW FactSaleQuota**

    NOTE: In this exercise all the aforementioned entities are in ready-to-consume state. In some real world scenarios, you might need to source the data and then cleanse/ transform it for your or business specific consumption. 

5. Click on **Load** button. 

At end of this stage, you must be on **Report** view (left bar). This is where you can start creating your visuals, report pages etc. Please take a note of other options on this bar (**Data** and **Model** views).

<br><br>

# Stage 2: Establish Wireframe or Report Outlook 
0. <i>Discuss or explore the need for a report wireframe.</i> 

<br><br>

# Stage 3: Create Report Pages and Visuals

## Establish Hierarchy and Measures

1. Establish following Hierarchies
    - **[DW DimDate].[Date Hierarchy]** as **Year, Quarter, Month** (in that order)
    - **[DW DimProduct].[Product Hierarchy]** as **Category, Subcategory, Product**
    - **[DW DimSalesPerso].[Country Hierarchy]** as **Group, Region, Country**

2. Establish following measures under **[DW FactSales]** 
    - `Profit = SUM('DW FactSales'[Sales]) - SUM('DW FactSales'[Cost])`
    - `Profit Margin = DIVIDE([Profit], SUM('DW FactSales'[Sales]))`
    - `SalesLY = CALCULATE(SUM('DW FactSales'[Sales]), SAMEPERIODLASTYEAR('DW DimDate'[Date]))`
    - Set **Profit** as Currency with 0 precision 
    - Set **Profit Margin** as Percentage with 2 precision 
    - Set **SalesLY** as Currency with 0 precision


## Report 1 / 3: Overview
1. Add Logo 

    Download the Adventureworks Logo file locally from [this URL]({% link resources/PBIRptDev/AdventureWorksLogo.jpg %}). 

    a. Click on **Insert** -> **Add an image to your report** menu options

    b.  Provide the downloaded file's path in Filename textbox, and click **Open**.

    c. Logo / Visual should be visual on left-top corner of your report. Ensure its selected, and then go to **Format Image** -> **General**. Change Width and Height to **120**. Also, add **AdventureWorks Logo. Black semi circle, with yellow start in the middle, and connected green mountains at bottom** as **Alt Text**.

    d. Click anywhere in the empty report screen area. 

2. Fiscal Year Slicer (Drop down) 

    a. Under **Fields** (right side), check the checkbox in front of **DW DimDate : FiscalYear**. Under **Visualization**, select **Slicer** (visual).

    b. Change the visual to use Dropdown (hover onto slicer visual -> select **down-arrow sign** (top right corner) -> select **Dropdown**).

3. Country Slicer (List)

    a. Under **Fields** (right side), check the checkbox in front of **DW DimSalesPerson : Country**. Under **Visualization**, select **Slicer** (visual). 

4. Add **Line and Stacked Column Chart** visual for **Sales and Profit Margin by Year** (name of visual will populate automatically)

    a. Under **Visualization**, select **Line and Stacked Column Chart**

    b. Bring in attributes
    
    - Drag and drop attributes from under Fields to specific placeholders under **Visualizations**: 
        - **DW FactSales : Sales** to **Column values** 
        - **DW FactSales : Profit Margin** to **Line values**
        - **DW DimDate : Date Hierarchy** to **Shared axis**

    c. Format the visual

    - With visual selected, select **Format** under **Visualizations**. Select a darker tone (e.g. dark blue) for **Profit Margin** and lighter hue (e.g. light Blue) for **Sales** or **Default color**.
    - Toggle **On** for **Data Labels**

    Notice the options like drill down, next level etc. on the top-right corner of the visual. Its because we are using an Hierarchy (**Date**). This allows you to explore data at Year - Quarter - Month - Day levels, cumulatively or for selected value. 

5. Add **Line Chart** Visual for **Sales and SalesLY by Week** (name of visual will populate automatically)

    a. Under **Visualization**, select **Line Chart**

    b. Bring in attributes
    - Drag and drop attributes from under Fields to specific placeholders under **Visualizations**: 
        - **DW FactSales : SalesLY** to **Values** 
        - **DW FactSales : Sales** to **Secondary values**
        - **DW DimDate : Week** to **Axis**

    c. Format the visual

    - With visual selected, select **Format** under **Visualizations**, match the color tone to previous visual. Select a light tone (e.g. light blue) for **Sales** and darker hue (e.g. Dark Blue) for **SalesLY**.

6. Add **Clustered Bar** Visual for **Sales by Category**

    a. Under **Visualization**, select **Clustered Bar**

    b. Bring in attributes
    - **DW FactSales : Sales** to **Values** 
    - **DW DimProduct : Product Category** to **Axis**

7. Rename this report page to **Overview** (double click on page tab, and key in Overview)

You now should have the report ready. Explore the report, use filters, cross filtering

## Report 2/3 : Profit Matrix

Add a new report page, and rename it to **Profit**.

1. Add **Country** filter 

    a. Click anywhwere on empty screen (on Profit page) and select **DW DimSalesPerson : Country** 

    b. Select **Slicer** as visual type

2. **Matrix** Visual for Quantity, Sales, Cost, Profit, Profit Margin

    a. Click anywhere on empty screen and select **Matrix** visual type

    b. Bring in attributes
    - Drag and drop attributes from under Fields to values under **Visualizations**: 
        - **DW DimDate : Date Hierarchy**  
        - **DW FactSales : Quantity** 
        - **DW FactSales : Sales** 
        - **DW FactSales : Cost**
        - **DW FactSales : Profit**  
        - **DW FactSales : Profit Margin**

3. Select **View**, then **Slicers**
    - Ensure **Country** filter transitions between **Overview** and **Profit** reports

## Report 3/3 : Product Details 
Add a new report page, and rename it to **Product Details**. 
Make this report page hidden by right-clicking on tab name, and select **Hide Page**. 

1. Add Category Page filter 

    a. Drag and drop **DW DimProduct : Category** to **Drill through** section with **Visualization** screen

    Notice it would have added a Back arrow link. 

2. Add **Card** visual for Product Category

    a. Select anywhere on empty screen, select **Card** visual, expand it to match the page width next to Arrow. 

    b. Drag and drop **DW DimProduct : Category** to the card visual. 

    c. Format the visual to 
    - Switch off **Title**

    - Change **Background** color to light blue or grey. 

3. Add Product Details **Table** visual with **Conditional Formatting** 

    a. Bring in attributes
    - Drag and drop attributes from under Fields to values under **Visualizations**: 
        - **DW DimProduct : Subcategory** 
        - **DW DimProduct : Color**
        - **DW FactSales : Quantity** 
        - **DW FactSales : Sales** 
        - **DW FactSales : Profit Margin**

    b. Add conditional formating 
    - Under **Visualizations** -> **Values**, click on down arrow next to **Profit Margin**, select **Conditional Formatting**, select **Icons**.

    - Make the selection match with [this screen]({% link resources/PBIRptDev/ConditionalFormatting.png %}) and click OK.

Explore the Drill Through option from **Overview** tab to **Product Details** page for different category options.  

## Bonus Report : Salesperson Performance 
Add a new report page, rename it to **Performance**.

1. Add FiscalYear Filter 

    a. Select **Filter** visual, drag and drop **DimDate : FiscalYear** to **Field**, convert the filter to **Dropdown**.

2. Add **Multi-row card** visual for **Sales, Target**

    a. Select **multi-card** visual, drag and drop **DW FactSales : Sales, DW FactSalesQuota : Target** to **Fields**. 

    b. Format the visual to change **Card** -> **Bar Color** to black and **Background** to gray.

3. Add overlapping **Bar** and **Column** charts for **Sales and Target by Month**

    a. Add **Clustered Bar chart** visual, drag and drop **DW DimDate : Month** to Axis and **DW FactSales : Sales, DW FactSalesQuota : Target** to Values 

    Note: If the Target value is coming across same value for all years, its because relationship is not setup correctly. To correct this, go to Model view and Link **DW FactSalesQuota : DateKey** to **DW DimDate : OrderDateKey**

    b. Copy paste the visual (a) on the same page, and change visual to **Clustered Column chart**. As well, add two buttons named Column and Bar. 

    c. Enable **Selection, Bookmarks** from within **View**. Under Selection, hide **Clustered Column chart** and add **BarBookmark** under **Bookmarks**. Similarly, under selection, now hide the other  **Clustered Bar chart** (unhiding the other one) and add **ColumnBookmark** under **Bookmarks**. 

    d. Select **Column** button, and link it with **ColumnBookmark** (selection **Action**, **Type: Bookmark**, **Bookmark: Column**). Repeat the action for other button. Select **Bar** button, and link it with **BarBookmark** (selection **Action**, **Type: Bookmark**, **Bookmark: Bar**). 

Go to **Overview** report, enable **Edit Interactions** (under **Format** menu) and disable interactivity with, say **Sales by Category**. 
