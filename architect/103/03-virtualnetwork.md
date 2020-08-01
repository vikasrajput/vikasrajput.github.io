RESOURCEGROUP=az303rg
LOCATION=australiaeast 

az group create --name $RESOURCEGROUP --location $LOCATION

## VIRTUAL NETWORK 
az network vnet create --resource-group $RESOURCEGROUP --name $RESOURCEGROUP-vnet --address-prefix 10.0.0.0/16
az network vnet show --resource-group $RESOURCEGROUP --name $RESOURCEGROUP-vnet 

az network vnet subnet create --resource-group $RESOURCEGROUP --vnet-name $RESOURCEGROUP-vnet --name $RESOURCEGROUP-subnet --address-prefix 10.0.0.0/24

## IP ADDRESSING
# Dynamic. Static. SKU (Basic, Standard)

## NSG 
# Allow rule at all leveles (NSG-Subnet, NSG-IP)

## ASG 

## FIREWALL 

## DNS 