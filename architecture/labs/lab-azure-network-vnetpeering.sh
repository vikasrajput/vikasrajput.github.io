#!/bin/bash 

echo "CREATING RG1-VNET1(VM1), RG1-VNET2(VM2), RG-2-VNET3(VM3, VM4)"
echo "ALL Three VNETs Peered. VM1, VM2, VM3 allow pings. VM4 wont allow access."

resourcegroup=$(date +"%Y%m%d")
resourcegroup="rg$resourcegroup"
location=southeastasia 
resourcetype="vnet"

echo "CREATING RESOURCE GROUP $resourcegroup"
az group delete --name $resourcegroup --yes 
az group create --name $resourcegroup --location $location

                                                
echo "CREATING THREE VNETs"
for INSTANCE in 1 2 3
do 
    #INSTANCE=1
    vnetname=$resourcegroup$resourcetype$INSTANCE
    addressprefix="10."$INSTANCE".0.0/16"
    subnetname="vnet"$INSTANCE"subnet"
    subnetprefix="10."$INSTANCE".0.0/24"
    az network vnet create --name $vnetname --resource-group $resourcegroup --address-prefix $addressprefix --subnet-name $subnetname --subnet-prefix $subnetprefix
    
    vmname="VM"$INSTANCE
    az vm create --name $vmname --resource-group $resourcegroup --image win2016datacenter --admin-user vmadmin --admin-password "VM@dm1n12345" --vnet-name $vnetname --subnet $subnetname & 
    if [ $INSTANCE == 3 ]
    then         
        az vm create --name $vmname"2" --resource-group $resourcegroup --image win2016datacenter --admin-user vmadmin --admin-password "VM@dm1n12345" --vnet-name $vnetname --subnet $subnetname & 

        # Forward traffic vnet peering. VNET3 can ping VNET1. VNET3 cant ping VNET2. 
        az network vnet peering create --resource-group $resourcegroup --name "vnet3vnet1peer" --vnet-name $vnetname --remote-vnet  $resourcegroup$resourcetype"1" --allow-forwarded-traffic
        az network vnet peering create --resource-group $resourcegroup --name "vnet3vnet2peer" --vnet-name $vnetname --remote-vnet  $resourcegroup$resourcetype"2" --allow-forwarded-traffic --allow-vnet-access --allow-gateway-transit
        # gateway-transit or transitivity ref: https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-peering-gateway-transit
        
        # Backward traffic vnet peering. VNET1 can ping VNET3. VNET2 cant ping VNET3
        az network vnet peering create --resource-group $resourcegroup --name "vnet1vnet3peer" --vnet-name $resourcegroup$resourcetype"1" --remote-vnet $vnetname  --allow-vnet-access
        az network vnet peering create --resource-group $resourcegroup --name "vnet2vnet3peer" --vnet-name $resourcegroup$resourcetype"2" --remote-vnet  $vnetname --allow-forwarded-traffic --allow-vnet-access
    fi 

# command to be run on each VM 
# New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4

done 
