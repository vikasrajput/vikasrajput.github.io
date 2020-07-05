
#creating a base container app 
RESOURCE_GROUP=az303rg
az group create --name $RESOURCE_GROUP --location australiaeast
DNS_NAME_LABEL=$RESOURCE_GROUP-acidemodns 
az container create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-container --image microsoft/aci-helloworld --ports 80 --dns-name-label $RESOURCE_GROUP-acidemodns --location australiaeast
az container show --resource-group  $RESOURCE_GROUP --name $RESOURCE_GROUP-container --query "{FQDN:ipAddress.fqdn.ProvisioningState:provisioningState}" --out table 

# creating container with CNI
az network vnet create --resource-group $RESOURCE_GROUP --location australiaeast --name $RESOURCE_GROUP-aks-vnet --address-prefixes 10.0.0.0/8 --subnet-name $RESOURCE_GROUP-aks-subnet --subnet-prefixes 10.240.0.0/16
SUBNET_ID=$(az network vnet subnet show --vnet-name $RESOURCE_GROUP-aks-vnet --name $RESOURCE_GROUP-aks-subnet --resource-group $RESOURCE_GROUP --query id -o tsv)

az aks create --resource-group  $RESOURCE_GROUP  --name $RESOURCE_GROUP-akscluster --vm-set-type VirtualMachineScaleSets --load-balancer-sku standard --network-plugin azure --vnet-subnet-id $SUBNET_ID --generate-ssh-keys
az aks get-credentials --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-akscluster

kubectl get nodes
kubectl get namespace
kubectl create namespace ratingsapp
