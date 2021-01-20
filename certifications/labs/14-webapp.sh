RESOURCE_GROUP=az303-14-rg1
LOCATION=southeastasia
APPSERVICE=azappservice-$RANDOM
APPSKU=P1V2
WEBAPP=azwebapp-$RANDOM


az group create --name $RESOURCE_GROUP --location $LOCATION

#DEMO 1: Create app service and webapp 
az appservice plan create --name $APPSERVICE --resource-group $RESOURCE_GROUP --location $LOCATION --sku $APPSKU --is-linux
# az webapp list-runtimes
az webapp create --name $WEBAPP --plan $APPSERVICE --resource-group $RESOURCE_GROUP --runtime "DOTNETCORE|3.1" 

#az extension add --name application-insights
az monitor app-insights component create --app $WEBAPP --location $LOCATION --resource-group $RESOURCE_GROUP


#DEMO 2: Webapp for Containers 
#ACRNAME=azregistry-$RANDOM 
#az acr create --name $ACRNAME --resource-group $RESOURCE_GROUP --sku standard --admin-enabled true 
#az acr build --file Dockerfile or 

az group delete --name $RESOURCE_GROUP --yes 