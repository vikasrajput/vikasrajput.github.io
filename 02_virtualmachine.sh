# create ubuntu vm with web server 
RESOURCE_GROUP=az303rg 
#az group create --name $RESOURCE_GROUP --location australiaeast 
az vm create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-ubuntuvm --image UbuntuLTS --admin-username $RESOURCE_GROUP-vmadmin --generate-ssh-keys 
az vm open-port --port 80 --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-ubuntuvm
