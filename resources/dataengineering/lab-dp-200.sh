# This lab will deploy following resources: 
# 1. Storage Account 
# 2. Azure SQL DB 
# 3. Azure SQL DW / Synapse Analytics 
# 4. Events Hub Namespace and Events Hub 
# 5. Azure Stream Analytics 
# 6. Azure DataBricks 
# 7. Azure CosmosDB
# 8. Azure Data Factory
# 9. Azure Monitor 
# 10.Azure Security Center 

#!/bin/bash

. ./../architecture/check-create-resource-group.sh clean 

if [[ ($1 == "storage" ) || ($1 == "all" ) ]]
then
    echo "CREATING STORAGE ACCOUNT AND CONTAINER"
    ResourceType="storage"
    ResourceName=$ResourceGroup$ResourceType

    az storage account create                \
        --name $ResourceName                \
        --resource-group $ResourceGroup     \
        --location $location                \
        --sku Standard_LRS                  
    #kind: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2
    #enable-hierarchical-namespace: true, false
    #access-tier: Cool, Hot
    #minimal-tls-version 1.0,1.1,1.2
    #sku: Premium_[LRS,ZRS], Standard_[GRS,GZRS,LRS,RAGRS,RAGZRS,ZRS]

    az storage container create             \
        --name "data"                       \
        --account-name $ResourceName        \
        --resource-group $ResourceGroup     \
        --public-access blob 
fi 


if [[ ($1 == "sqldb" ) || ($1 == "all" ) ]]
then
    echo "CREATING SQL DB"
    ResourceType="sqldb"
    StartIP=0.0.0.0
    EndIP=0.0.0.0
    ResourceName=$ResourceGroup$ResourceType
    ResourceServer=$ResourceName"srv"

    #ref: https://docs.microsoft.com/en-us/cli/azure/sql/server?view=azure-cli-latest
    az sql server create --name $ResourceServer     \
        --resource-group $ResourceGroup             \
        --admin-user $ResourceType"admin"           \
        --admin-password $ResourceType"@dm1n910"

    az sql server firewall-rule create              \
        --server $ResourceServer                    \
        --resource-group $ResourceGroup             \
        --name AllowSome                            \
        --start-ip-address $StartIP                 \
        --end-ip-address $EndIP     

    #ref: https://docs.microsoft.com/en-us/cli/azure/sql/db?view=azure-cli-latest
    az sql db create --name $ResourceName --resource-group $ResourceGroup --server $ResourceServer                    \
        --sample-name AdventureWorksLT --edition GeneralPurpose --zone-redundant false 
    #compute-model Provisioned, Serverless 
    #min-capacity, max-size, capacity
fi 


if [[ ($1 == "synapse" ) || ($1 == "all" ) ]]
then 
    echo "CREATING SYNAPSE ANALYTICS"
    echo "Ref Azure Template - path in comments"
    #https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-deployment-template-workspaces
    
fi 

echo "CREATING EVENT HUB"
echo "CREATING STREAM ANALYTICS"
echo "CREATING DATABRICKS"
echo "CREATING COSMOSDB"

echo "CREATING AZURE DATA FACTORY "
if [[ ($1 == "adf" ) || ($1 = "all") ]]
then 
    ResourceType="adf"
    ResourceName=$ResourceGroup$ResourceType
    az extension add --name datafactory 
    az datafactory factory create --name $ResourceName --resource-group $ResourceGroup
fi 

echo "CREATING AZURE MONITOR"
# https://squaredup.com/blog/mastering-azure-monitor-with-richard-benwell/
echo "CREATING AZURE SECURITY CENTER"
