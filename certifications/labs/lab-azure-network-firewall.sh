# NOTE: NOT COMPLETED YET - NEED AZ FIREWALL SETTINGS, JUMP BOX IP. 
# REF https://docs.microsoft.com/en-us/azure/firewall/scripts/sample-create-firewall-test


resourcegroup=$(date +"%Y%m%d")
resourcegroup="rg$resourcegroup"
location=southeastasia 
resourcetype="vnet"

echo "CREATING RESOURCE GROUP $resourcegroup"
az group delete --name $resourcegroup --yes 
az group create --name $resourcegroup --location $location

echo "CREATING VNET, SUBNETS"
INSTANCE=1  
vnetname=$resourcegroup$resourcetype$INSTANCE
addressprefix="10."$INSTANCE".0.0/16"
subnetname="vnet"$INSTANCE"subnet1"
subnetprefix="10."$INSTANCE".1.0/24"
az network vnet create --name $vnetname --resource-group $resourcegroup --address-prefix $addressprefix --subnet-name $subnetname --subnet-prefix $subnetprefix
    
#creating additionl subnets 
subnetname="vnet"$INSTANCE"subnet2"
subnetprefix="10."$INSTANCE".2.0/24"
az network vnet subnet create --resource-group $resourcegroup --vnet-name $vnetname --name $subnetname --address-prefixes $subnetprefix

#creating additionl subnets 
subnetname="vnet"$INSTANCE"subnet3"
subnetprefix="10."$INSTANCE".3.0/24"
az network vnet subnet create --resource-group $resourcegroup --vnet-name $vnetname --name $subnetname --address-prefixes $subnetprefix

for INSTANCE in 1 2 3
do 
    vnetname=$resourcegroup$resourcetype$INSTANCE
    addressprefix="10."$INSTANCE".0.0/16"
    subnetname="vnet"$INSTANCE"subnet"$INSTANCE
    subnetprefix="10."$INSTANCE"."$INSTANCE".0/24"

    # Create vnet with base subnet1, and then add subnet2, subnet3
    if [ $INSTANCE == 1 ]
    then         
        az network vnet create --name $vnetname --resource-group $resourcegroup --address-prefix $addressprefix --subnet-name $subnetname --subnet-prefix $subnetprefix
    else 
        az network vnet subnet create --resource-group $resourcegroup --vnet-name $vnetname --name $subnetname --address-prefixes $subnetprefix
    fi 

    vmname="VM"$INSTANCE
    az vm create --name $vmname --resource-group $resourcegroup --image win2016datacenter --admin-user vmadmin --admin-password "VM@dm1n12345" --vnet-name $vnetname --subnet $subnetname & 
do 