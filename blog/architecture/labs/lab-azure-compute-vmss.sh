# Ref https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/quick-create-cli

echo "DECLARING VARIABLES...."
resourcegroup=$(date +"%Y%m%d")
resourcegroup="rg$resourcegroup"
location=southeastasia 
resourcetype="vmss"

echo "CREATING RESOURCE GROUP $resourcegroup"
#az group create --name $resourcegroup --location $location

echo "---CREATING A VMSS---"
resourcename=$resourcetype$resourcegroup
az vmss create --resource-group $resourcegroup --name $resourcename --image UbuntuLTS --upgrade-policy-mode automatic --admin-username azureuser --generate-ssh-keys

az vmss extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --resource-group $resourcegroup \
  --vmss-name $resourcename \
  --settings '{"fileUris":["https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate_nginx.sh"],"commandToExecute":"./automate_nginx.sh"}'

## dont change the values - determined from uri above
az network lb rule create \
  --resource-group $resourcegroup \
  --name "lbrule"$resourcename \
  --lb-name $resourcename"LB" \
  --backend-pool-name $resourcename"LBBEPool" \
  --backend-port 80 \
  --frontend-ip-name loadbalancerfrontend \
  --frontend-port 80 \
  --protocol tcp

vmip=$(az network public-ip show \
  --resource-group $resourcegroup \
  --name $resourcename"LBPublicIP" \
  --query '[ipAddress]' \
  --output tsv) 
echo "BROWSE $vmip"


echo "DONT FORGET TO CLEAN AFTER YOURSELF!!"
echo "az group delete --name $resourcegroup --yes"
