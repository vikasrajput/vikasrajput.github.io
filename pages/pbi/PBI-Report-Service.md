---
layout: page
title: Power BI Service - Report Dev and Collaborate
---
Lab instructions on exploring and using PBI Service online. 
- [Explore PBI Service](#explore-the-service) 
- [PBI Service: Consume](#pbi-service--consume) 
- [PBI Service: Create](#pbi-service--create)
    - [Report](#create-a-report-online) 
    - [Dashboard](#create-a-dashboard)
- [PBI Service: Collaborate](#pbi-service--collaborate)
    - [Workspace and App](#create-a-workspace-and-app)


# Explore the service 

Lets explore the service online before jumping on the triad of Consume - Create - Collaborate. 

1. Sign in to PBI Service (https://app.powerbi.com) using your corporate account or provided demo account (check with instructor). Browse the service alongside Instructor to see all the options. Revisit Apps, Deployment Pipelines later. 

2. Browse to **My Workspace** (unless instructors has called out for a shared workspace to be used) and explore the enlisted [objects]({% link resources/PBIRptDev/PBIService_Comps.png %}).

3. Notice details like file type's (report, dataset), ownership, last refresh and next refresh, endorsement ([ref](https://docs.microsoft.com/en-us/power-bi/collaborate-share/service-endorsement-overview)) and sensitivity ([ref](https://docs.microsoft.com/en-us/power-bi/enterprise/service-security-sensitivity-label-overview))

4. Explore the report across tabs. Consider interactivity, navigation (like links), menu options, filter sync, conditional visuals, Analyze function etc. 


# PBI Service : Consume

1. Explore the [options for reports]({% link resources/PBIRptDev/PBIService_ReportSettings.png %}) , especially 
    - [Share](https://docs.microsoft.com/en-us/power-bi/collaborate-share/service-how-to-collaborate-distribute-dashboards-reports)

    - [Insights](https://docs.microsoft.com/en-us/power-bi/create-reports/service-insights)
    
    - Settings 

    - [Usage Metrics Report (preview)](https://docs.microsoft.com/en-us/power-bi/collaborate-share/service-modern-usage-metrics)

    - [View lineage](https://docs.microsoft.com/en-us/power-bi/collaborate-share/service-data-lineage)

    - [Create Paginated Reports](https://docs.microsoft.com/en-us/power-bi/paginated-reports/paginated-reports-report-builder-power-bi)

    - Manage Permissions 

2. [Explore the options for Dataset]({% link resources/PBIRptDev/PBIService_DatasetSettings.png %}), especially 
    - Schedule Refresh 

        - Description, [Gateway](https://docs.microsoft.com/en-us/power-bi/connect-data/service-gateway-onprem), [Sensitivity label](https://docs.microsoft.com/en-us/power-bi/enterprise/service-security-sensitivity-label-overview)

        - Gateway connection (requires installation), Data source credentials, [scheduled refresh](https://docs.microsoft.com/en-us/power-bi/connect-data/refresh-scheduled-refresh)

        - Endorsement ([ref](https://docs.microsoft.com/en-us/power-bi/collaborate-share/service-endorsement-overview) )
    
    - Analyze in Excel 

    - Quick Insights

    - Settings 

    - Manage Permissions 

    - View Lineage 
<br><br>

# PBI Service : Create 

## Create a Report Online 

1. Select **Homepage**, click on **+ New Report** button

2. Select **Pick a published dataset**, select the dataset you published previously and click on **Create** button

3. Explore the options and layout, and recreate **Overview** tab (from PBI Desktop workshop) for practice

## Create a Dashboard 

1. Open any of the PBI reports as published on PBI Service. 

2. Hover the cursor on any of the visuals you would like to add to your Dashboard, and click on **Pin Visual** link (as shown [here]({% link resources/PBIRptDev/PBIService_DashboardPinVisual.png %})). On subsequent screen, choose to save as new Dashboard and provide a name as preferred ([example]({% link resources/PBIRptDev/PBIService_DashboardPinVisual2.png %})).

3. Repeat the process for couple of visuals (of your choice), only this time add them to an existing Dashboard, i.e. the one you created previously ([example]({% link resources/PBIRptDev/PBIService_DashboardPinVisual3.png %})). 

4. Once you are done, either you can view the Dashboard by clicking on **Go to Dashboard** button on the confirmation pop up, or you can browse to the workspace, and click on the Dashboard from within the list of objects (example of [Dasboard listing]({% link resources/PBIRptDev/PBIService_DashboardList.png %}), and [view of Dashboard]({% link resources/PBIRptDev/PBIService_DashboardView.png %})). 

5. Feel free to explore the options and views more with Dashboards, for example using subscription, [Q&A]({% link resources/PBIRptDev/PBIService_DashboardQnA.png %}) etc. 

<br><br>

# PBI Service : Collaborate 

1. Report level
    - Comments 

    - Bookmarks

    - Teams 

    - Subscribe 

    - Export (PDF, PPT, Excel)

## Create a Workspace and App

1. Create Workspace 
    - Click **Workspace** -> **Create a Workspace**
    
    - Provide a workspace name (e.g. Test_AdvWorks_Initials), Description. Review all other (Advanced) settings. 

2. Upload Content (PBI Report)
    - Open the PBI report you previously created using PBI Desktop 

    - After saving the file (in case there was any change made), click on Publish and point to the Workspace you created in previous steps ([ref]({% link resources/PBIRptDev/PBIService_PublishtoWorkspace.png %}) ) and click on **Select** button

3. Create and Publish App 
    - Click on **Create app** on top right of the page

    - Provide App name, description ([setup page]({% link resources/PBIRptDev/PBIService_AppSetup.png %}))

    - Provide sections, link etc. ([navigation page]({% link resources/PBIRptDev/PBIService_AppNavigation.png %}))

    - Setup permissions for the app - user or group levels ([navigation page]({% link resources/PBIRptDev/PBIService_AppPermissions.png %}))

    - After clicking on create button, confirmation message with links to App would look something link [this]({% link resources/PBIRptDev/PBIService_AppCreate.png %})

    - Explore the App for its contained Reports and Dataset 

    - Go back to App's main page and click on [Access button]({% link resources/PBIRptDev/PBIService_AppAccess.png %}) to [explore/add user/groups with needed permissions]({% link resources/PBIRptDev/PBIService_AppAccess2.png %}) 


