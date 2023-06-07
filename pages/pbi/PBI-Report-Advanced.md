---
layout: page
title: Power BI - Advanced Reporting Capabilities
---
Lab instructions on exploring and using additional / advanced PBI reporting capabilities.

**Advanced Visualization Capabilities**
- [Explainable Analytics](#explainable-analytics-smart-narrative)
- [Forecasting](#forecasting-line-chart)
- [Top Down Analysis](#top-down-analysis-decomposition-tree)
- [Key Influencers](#causation-key-influencers)
- [Working with Themes](https://learn.microsoft.com/en-us/training/modules/understand-advanced-data-visualization-concepts/2-create-import-custom-report-theme?ns-enrollment-type=learningpath&ns-enrollment-id=learn.wwl.implement-advanced-data-visualization-techniques){:target="_blank" rel="noopener"}
- [Working with Accessibility](https://learn.microsoft.com/en-us/training/modules/understand-advanced-data-visualization-concepts/4-design-configure-power-bi-reports-for-accessibility?ns-enrollment-type=learningpath&ns-enrollment-id=learn.wwl.implement-advanced-data-visualization-techniques){:target="_blank" rel="noopener"}
- [Real time analytics](https://learn.microsoft.com/en-us/training/modules/monitor-data-real-time-power-bi/2-describe-power-bi-real-time?ns-enrollment-type=learningpath&ns-enrollment-id=learn.wwl.implement-advanced-data-visualization-techniques){:target="_blank" rel="noopener"}
- [Paginated Reports](#working-with-paginated-reports)
- [PBI Application Lifecycle](https://learn.microsoft.com/en-us/training/modules/design-power-bi-application-lifecycle-management-strategy/2-define?ns-enrollment-type=learningpath&ns-enrollment-id=learn.wwl.manage-analytics-development-lifecycle){:target="_blank" rel="noopener"} and [Deployment Strategy](https://learn.microsoft.com/en-us/training/modules/design-power-bi-application-lifecycle-management-strategy/4-design-deployment-strategy?ns-enrollment-type=learningpath&ns-enrollment-id=learn.wwl.manage-analytics-development-lifecycle){:target="_blank" rel="noopener"}

# Advanced Visualization Capabilities 

## Explainable Analytics (Smart Narrative)

Open the PBI Desktop file for previously uploaded reports pack. On **Overview** tab, reduce the width of last two visuals to make some space on bottom left corner, and click on **Smart Narrative** button (under **Insert** menu). Explore the findings in narration box by filtering on other visuals and slicers. Here's a [sample screenshot]({% link resources/PBIRptDev/PBIAdvanced_SmartNarrative.png %}).

## Forecasting (Line Chart)

1. Add a new tab to the report and rename it to **Forecast**

2. Select **Line Chart** visual from within **Visualizations** screen. Expand this visual to take the whole screen. 

3. Add **DimDate** : **Date** (hierarchy) to **Axis** drop box

4. Add **FactSales** : **Sales** to **Values** drop box. Click on 3rd icon under Visualization to add more analysis to visual (see [this example]({% link resources/PBIRptDev/PBIAdvanced_Forecast.png %})). 

5. Toggle on **Forecast** and set following parameters
    - Units: Points 

    - Forecast Lenght: 1 

    - Confidence level: 95% 

    Also, for some added fun, toggle on **Trendline** as well. Your resulted screen would look something like [this]({% link resources/PBIRptDev/PBIAdvanced_ForecastAdded.png %}).


## Top Down Analysis (Decomposition Tree)

1. Add a new tab to the report and rename it to **Decomposition**

2. Select **Decomposition Tree** visual from within **Visualizations** screen. Expand this visual to take the whole screen. 

3. Add **FactSales : Sales** to **Analyze**, and following columns to **Explain by** drop box
    - **DimReseller** : **Country** 

    - **DimReseller** : **Business Type** 

    - **DimProduct** : **Category** 

    - **DimProduct** : **Subcategory** 

    - **DimProduct** : **Color** 


4. Click on **+** sign at the end of Sales visual (as shown [here]({% link resources/PBIRptDev/PBIAdvanced_DecompositionTree.png %})) and add the elements (some or all) in your order of choice. A sample view is [here]({% link resources/PBIRptDev/PBIAdvanced_DecompositionTreeFull.png %}). 

5. Explore this visual by clicking on values in any order. 

6. Change the order of analysis by removing some elements by clicking on **X** against the elements and add more options as you like. 


## Causation (Key Influencers)

1. Add a new tab to the report and rename it to **Influencers**

2. Select **Key Influencers** visual from within **Visualizations** screen. Expand this visual to take the whole screen. 

3. Add following attributes to drop box
    - **FactSales** : **Sales** to **Analyze**, and 
    
    - **DimProduct** : **Color** to **Explain by**

    Evaluate the findings along with the Trainer. Understand the **Increase** and **Decrease** influencers, and explore **Top Segments** data.

4. Reset the previous setting by removing previous value and add following to **Explain by** drop box
    -  **DimProduct** : **SubCategory**

    Evaluate the findings along with the Trainer. Understand the **Increase** and **Decrease** influencers, and explore **Top Segments** data.

    Please note that we can add multiple columns to **Explain by**. We are focussing on one attribute at a time to be able to explore it better. 
    
5. Reset the previous setting by removing previous value and add following to **Explain by** drop box
    - **DimProduct** : **SubCategory**

    Evaluate the findings along with the Trainer. Understand the **Increase** and **Decrease** influencers, and explore **Top Segments** data.
    
6. Reset the previous setting by removing previous value and add following to **Explain by** drop box  
    - **DimProduct** : **StandardCost**

    Evaluate the findings along with the Trainer. Understand the **Increase** and **Decrease** influencers, and explore **Top Segments** data.

7. Reset the previous setting by removing previous value and add following to **Explain by** drop box  
    - **DimReseller** : **BusinessType**

    Notice that system confirms for there being no influence (for given metrics).

8. Reset the previous setting by removing previous value and add following to **Explain by** drop box  
    - **FactSales** : **Quantity**

    Evaluate the findings along with the Trainer. Understand the **Increase** and **Decrease** influencers, and explore **Top Segments** data.
        

## Get more Visuals 

Explore the Gallery, and see if you can find Visual options for some of the tools / technology solutions you have already in your environment. 



## Working with Accessibility 


# Working with Paginated Reports 

1. Create a paginated report with Data Source as **SalesAnalysis** PBI Dataset 

2. Create data set with following attributes: 
    - **Profit**, **ProfitMargin**

    - **Year**, **Category**, **Subcategory**, **Product** 

3. Create the paginated report with Year as a **filter**/ parameter, and add rest of attributes to **Matrix** visualiation. 

4. Add Built-in Fields **PageNumber** to the page footer

5. Run the report, providing **Year** values as 2010, 2011

6. If you have PBI Premium Account, **publish** the report back to PBI Service 
You can access the final Paginated report [here]({% link resources/PBIRptDev/SalesAnalysis_Paginated.rdl %}).