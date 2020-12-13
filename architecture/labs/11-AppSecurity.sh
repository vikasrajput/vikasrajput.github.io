RESOURCE_GROUP=az30311-labRG
LOCATION=southeastasia 
KEYVAULTNAME=azkeyvault-$RANDOM 

az group create --name $RESOURCE_GROUP --location $LOCATION

az keyvault create --resource-group $RESOURCE_GROUP --name $KEYVAULTNAME
