# Ref https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli
# 1. Simple VM 
# 2. VM using Cert / Cloud init yaml 
# 3. Custom image 


echo "DECLARING VARIABLES...."
resourcegroup=$(date +"%Y%m%d")
resourcegroup="rg$resourcegroup"
location=southeastasia 
resourcetype="vm"

echo "CREATING RESOURCE GROUP $resourcegroup"
az group create --name $resourcegroup --location $location

resourcename=$resourcetype$resourcegroup
echo "---CREATING A SIMPLE VM $resourcename, OPENING PORT 80, AND DEPLOYING WEBSERVER---"
az vm create --resource-group $resourcegroup --name $resourcename --image UbuntuLTS --admin-username azureuser --generate-ssh-keys
az vm open-port --resource-group $resourcegroup --name $resourcename --port 80 > /dev/null 

resourcepublicip=$(az vm show -d -g $resourcegroup -n $resourcename --query publicIps -o tsv)

echo "SSH INTO REMOTE Ubuntu VM AND DEPLOY WEB SERVER"
ssh -o StrictHostKeyChecking=accept-new azureuser@$resourcepublicip<<EOF 
sudo apt-get -y update > /dev/null
sudo apt-get -y install nginx > /dev/null 
EOF 

echo "BROWSE http://$resourcepublicip"
echo "DONT FORGET TO CLEAN AFTER YOURSELF!!"
echo "az group delete --name $resourcegroup --yes"



echo "---CREATING ANOTHER VM WITH CLOUD INIT---"
echo "CREATE AZ KEY VAULT, CERT, SECRET AND VM SECRET"
keyvault="keyvault"$resourcegroup
certificate="cert"$resourcegroup

az keyvault create --name $keyvault --resource-group $resourcegroup --enabled-for-deployment 
az keyvault certificate create --vault-name $keyvault --name $certificate --policy "$(az keyvault certificate get-default-policy --output json)"

secret=$(az keyvault secret list-versions --vault-name $keyvault --name $certificate --query "[?attributes.enabled].id" --output tsv)
vmsecret=$(az vm secret format --secret "$secret" --output json)

resourcename="secure"$resourcetype$resourcegroup
az vm create --resource-group $resourcegroup --name $resourcename --image UbuntuLTS --admin-username azureuser --generate-ssh-keys --custom-data cloud-init-securevm.txt --secrets "$vmsecret"
az vm open-port --resource-group $resourcegroup --name $resourcename --port 443 > /dev/null
resourcepublicip=$(az vm show -d -g $resourcegroup -n $resourcename --query publicIps -o tsv)
echo "BROWSE https://$resourcepublicip"