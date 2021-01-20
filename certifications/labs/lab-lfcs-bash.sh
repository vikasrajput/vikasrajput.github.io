resourcegroup=$(date +"%Y%m%d")
resourcegroup="rg$resourcegroup"
location=southeastasia 

az group create --name $resourcegroup --location $location

vmimage=CentOS
vmname=$resourcegroup$vmimage
azureuser=azureuser 

ssh-keygen -t rsa -b 2048
az vm create --resource-group $resourcegroup --name $vmname --admin-username $azureuser --image $vmimage --generate-ssh-keys --size Standard_B2s

vmip=$(az vm show -d -g $resourcegroup -n $vmname --query publicIps -o tsv) 

ssh $azureuser@$vmip
 
# or ssh azureuser@vmname.region.cloudapp.azure.com





