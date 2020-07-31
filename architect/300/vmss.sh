#!/bin/bash
datestr=`date +%Y%m%d`
myResourceGroupLB="RG$datestr"

#create rg
az group create --name $myResourceGroup --location eastus
#create vmss 
az vmss create \
  --resource-group $myResourceGroup \
  --name myScaleSet \
  --image UbuntuLTS \
  --vm-sku Standard_F1 \
  --instance-count 3
  --admin-username azureuser \
  --generate-ssh-keys
#create instance in vmss 
az vmss list-instances \
  --resource-group $myResourceGroup \
  --name myScaleSet \
  --output table
#accessing instance details
az vmss list-instance-connection-info \
  --resource-group $myResourceGroup \
  --name myScaleSet
az vmss show \
    --resource-group $myResourceGroup \
    --name myScaleSet \
    --query [sku.capacity] \
    --output table
##managing instances at vmss level 
#az vmss stop --resource-group $myResourceGroup --name myScaleSet --instance-ids 1
#az vmss deallocate --resource-group $myResourceGroup --name myScaleSet --instance-ids 1
#az vmss start --resource-group $myResourceGroup --name myScaleSet --instance-ids 1
#az vmss restart --resource-group myResourceGroup --name myScaleSet --instance-ids 1