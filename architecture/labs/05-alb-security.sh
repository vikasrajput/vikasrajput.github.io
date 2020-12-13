REGION_NAME=southeastasia 

#Exercise 2
RESOURCE_GROUP=az30305b-labRG
EX3SUBFILE=~/Documents/GitHub/AZ303/AllFiles/Labs/05/azuredeploy30305subb.json
EX3TEMPLATE=~/Documents/GitHub/AZ303/AllFiles/Labs/05/azuredeploy30305rgb.json
EX3PARAMETER=~/Documents/GitHub/AZ303/AllFiles/Labs/05/azuredeploy30305rgb.parameters.json

az deployment sub create --location $REGION_NAME --template-file $EX3SUBFILE --parameters rgName=$RESOURCE_GROUP rgLocation=$REGION_NAME

az deployment group create --resource-group $RESOURCE_GROUP --template-file $EX3TEMPLATE --parameters @$EX3PARAMETER


#Exercise 3
RESOURCE_GROUP=az30305c-labRG
EX3SUBFILE=~/Documents/GitHub/AZ303/AllFiles/Labs/05/azuredeploy30305subc.json
EX3TEMPLATE=~/Documents/GitHub/AZ303/AllFiles/Labs/05/azuredeploy30305rgc.json
EX3PARAMETER=~/Documents/GitHub/AZ303/AllFiles/Labs/05/azuredeploy30305rgc.parameters.json

az deployment sub create --location $REGION_NAME --template-file $EX3SUBFILE --parameters rgName=$RESOURCE_GROUP rgLocation=$REGION_NAME

az deployment group create --resource-group $RESOURCE_GROUP --template-file $EX3TEMPLATE --parameters @$EX3PARAMETER

#Next Step : Add commands to scale and other tasks 