uname -a 
df -h       --mounted storage account 
apt list 


az group list -o table 
az resource list -o table 

# deploy sql server 
resourcegroup = $(date +"%Y%m%d")
resourcegroup="rg$resourcegroup"
location=southeastasia 

az group create --name $resourcegroup --location $location
az deployment group create --resource-group $resourcegroup --template-uri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-sql-database/azuredeploy.json

ssh-keygen -t rsa -b 2048
az group deployment create --resource-group $resourcegroup --template-uri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-sshkey/azuredeploy.json

az resource list -o table 

az group delete --name $resourcegroup  --yes 

clouddrive unmount 
#select other drive 
mkdir git 
cd git 
git clone https://github.com/vikarajput/vikasrajput.github.io 


