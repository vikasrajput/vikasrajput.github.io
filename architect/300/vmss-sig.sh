#!/bin/bash
datestr=`date +%Y%m%d`
ResourceGroup="RG$datestr"

az group create --name $ResourceGroup --location eastus

az vm create \
  --resource-group $ResourceGroup \
  --name myVM \
  --image ubuntults \
  --admin-username azureuser \
  --generate-ssh-keys

#az vm list-ip-addresses --ids $(az vm list -g $ResourceGroup --query "[].id" -o tsv)
myVMPublicIp=$(az vm list -g $ResourceGroup -d --query "[].publicIps" -o tsv)

echo azureuser@$myVMPublicIp
ssh -o "StrictHostKeyChecking=no" azureuser@$myVMPublicIp << CLOSE 
sudo apt-get install -y nginx
CLOSE



#myGallery="myGallery$ResourceGroup"

#az group create --name $myResourceGroup --location eastus
az sig create --resource-group $ResourceGroup --gallery-name myGallery

az sig image-definition create \
   --resource-group $ResourceGroup \
   --gallery-name myGallery \
   --gallery-image-definition myImageDefinition \
   --publisher myPublisher \
   --offer myOffer \
   --sku mySKU \
   --os-type Linux \
   --os-state specialized

subscriptionId=$(echo $(az account show --query id) | xargs)

# works within *nix bash only 
managedImage="/subscriptions/$subscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Compute/virtualMachines/myVM"
az sig image-version create \
   --resource-group $ResourceGroup \
   --gallery-name myGallery \
   --gallery-image-definition myImageDefinition \
   --gallery-image-version 2.0.0 \
   --target-regions "southcentralus=1" "eastus=1" \
   --managed-image $managedImage

#create the vmss from image 
imageName="/subscriptions/$subscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Compute/galleries/myGallery/images/myImageDefinition"
az vmss create --resource-group $ResourceGroup --name myScaleSet --image $imageName --specialized

#creae alb rules for vmss
az network lb rule create \
  --resource-group $ResourceGroup \
  --name myLoadBalancerRuleWeb \
  --lb-name myScaleSetLB \
  --backend-pool-name myScaleSetLBBEPool \
  --backend-port 80 \
  --frontend-ip-name loadBalancerFrontEnd \
  --frontend-port 80 \
  --protocol tcp

az network public-ip show \
  --resource-group $ResourceGroup \
  --name myScaleSetLBPublicIP \
  --query [ipAddress] \
  --output tsv