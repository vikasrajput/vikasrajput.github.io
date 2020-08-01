#!/bin/bash
datestr=`date +%Y%m%d`
myResourceGroup="RG6$datestr"

az group create --name $myResourceGroup --location eastus

az vm create \
  --resource-group $myResourceGroup \
  --name myVM \
  --image ubuntults \
  --admin-username azureuser \
  --generate-ssh-keys

#az vm list-ip-addresses --ids $(az vm list -g $myResourceGroup --query "[].id" -o tsv)
myVMPublicIp=$(az vm list -g $myResourceGroup -d --query "[].publicIps" -o tsv)

echo azureuser@$myVMPublicIp
ssh -o "StrictHostKeyChecking=no" azureuser@$myVMPublicIp << CLOSE 
sudo apt-get install -y nginx
CLOSE



#yGallery="myGallery$myResourceGroup"

#az group create --name $myResourceGroup --location eastus
az sig create --resource-group $myResourceGroup --gallery-name myGallery

az sig image-definition create \
   --resource-group $myResourceGroup \
   --gallery-name myGallery \
   --gallery-image-definition myImageDefinition \
   --publisher myPublisher \
   --offer myOffer \
   --sku mySKU \
   --os-type Linux \
   --os-state specialized

subscriptionId=$(echo $(az account show --query id) | xargs)

## not working... 
#managedImage=$(echo "/subscriptions/$subscriptionId/resourceGroups/MyResourceGroup/providers/Microsoft.Compute/virtualMachines/myVM")
#az sig image-version create \
#   --resource-group $myResourceGroup \
#   --gallery-name myGallery \
#   --gallery-image-definition myImageDefinition \
#   --gallery-image-version 1.0.0 \
#   --target-regions "southcentralus=1" "eastus=1" \
#   --managed-image $managedImage

#create the vmss from image 
imageName=$(echo "//subscriptions//$subscriptionId//resourceGroups//myGalleryRG//providers//Microsoft.Compute//galleries//myGallery//images//myImageDefinition")
az vmss create --resource-group $myResourceGroup --name myScaleSet --image $imageName --specialized