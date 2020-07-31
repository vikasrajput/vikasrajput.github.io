#!/bin/bash
datestr=`date +%Y%m%d`
myResourceGroupLB="RG$datestr"

#create rg
az group create --name myResourceGroup --location eastus
#create vmss 
az vmss create \
  --resource-group myResourceGroup \
  --name myScaleSet \
  --image UbuntuLTS \
  --admin-username azureuser \
  --generate-ssh-keys
#create instance in vmss 
az vmss list-instances \
  --resource-group myResourceGroup \
  --name myScaleSet \
  --output table
az vmss list-instance-connection-info \
  --resource-group myResourceGroup \
  --name myScaleSet
  --instance-id 1