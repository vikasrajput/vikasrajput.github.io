resourcegroup=$(date +"%Y%m%d")
resourcegroup="rg$resourcegroup"
location=southeastasia 

az group create --name $resourcegroup --location $location

ssh-keygen -t rsa -b 2048
az vm create --resource-group $resourcegroup --name mycentos --admin-username azureuser --image CentOS --generate-ssh-keys --size Standard_B2s

ssh azureuser@<publicIP> 
printenv 
# or ssh azureuser@vmname.region.cloudapp.azure.com





