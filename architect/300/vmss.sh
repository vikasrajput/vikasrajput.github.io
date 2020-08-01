#!/bin/bash
datestr=`date +%Y%m%d`
myResourceGroup="RG2$datestr"

#create rg
az group create --name $myResourceGroup --location eastus
#create vmss 
az vmss create \
  --resource-group $myResourceGroup \
  --name myScaleSet \
  --image UbuntuLTS \
  --vm-sku Standard_F1 \
  --instance-count 3 \
  --upgrade-policy-mode automatic \
  --admin-username azureuser \
  --generate-ssh-keys
#optional - custom app deploy:apply a vmss extension spec'ed in customVmssConfig.json
az vmss extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --resource-group $myResourceGroup \
  --vmss-name myScaleSet \
  --settings @customVmssConfig.json
#optional - custom app deploy:create alb rule for webtraffic 
az network lb rule create \
  --resource-group $myResourceGroup \
  --name myLoadBalancerRuleWeb \
  --lb-name myScaleSetLB \
  --backend-pool-name myScaleSetLBBEPool \
  --backend-port 80 \
  --frontend-ip-name loadBalancerFrontEnd \
  --frontend-port 80 \
  --protocol tcp  

#list instance in vmss 
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
#optional - custom app deploy test 
az network public-ip show \
  --resource-group $myResourceGroup \
  --name myScaleSetLBPublicIP \
  --query [ipAddress] \
  --output tsv
  #check this ip in the browser 

##managing instances at vmss level 
#az vmss stop --resource-group $myResourceGroup --name myScaleSet --instance-ids 1
#az vmss deallocate --resource-group $myResourceGroup --name myScaleSet --instance-ids 1
#az vmss start --resource-group $myResourceGroup --name myScaleSet --instance-ids 1
#az vmss restart --resource-group myResourceGroup --name myScaleSet --instance-ids 1


#optional - custom app deploy:apply another vmss extension spec'ed in customVmssConfigv2.json
az vmss extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --resource-group $myResourceGroup \
  --vmss-name myScaleSet \
  --settings @customVmssConfigv2.json