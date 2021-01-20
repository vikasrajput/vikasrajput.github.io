
REGION_NAME=southeastasia 
RESOURCE_GROUP=az303-13-rg1
VNET_NAME=aks-vnet 
SUBNET_NAME=aks-subnet 
AKS_CLUSTER_NAME=aksworkshop-$RANDOM
VERSION=1.18.10

# create Resource Group 
az group create --name $RESOURCE_GROUP --location $REGION_NAME

# DEMO 1: Create AKS 
# networking opions: kubernetes - pods on dhcp, behind node IP. CNI: pods on static and accessed directly 
az network vnet create --resource-group $RESOURCE_GROUP --location $REGION_NAME --name $VNET_NAME --address-prefix 10.0.0.0/8 --subnet-name $SUBNET_NAME --subnet-prefix 10.240.0.0/16

SUBNET_ID=$(az network vnet subnet show \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_NAME \
    --name $SUBNET_NAME \
    --query id -o tsv)

#create aks cluster - create in portal. not working because of subnet_id
# query=$(az aks create \
# --resource-group $RESOURCE_GROUP \
# --name $AKS_CLUSTER_NAME \
# --vm-set-type VirtualMachineScaleSets \
# --load-balancer-sku standard \
# --location $REGION_NAME \
# --kubernetes-version $VERSION \
# --network-plugin azure \
# --vnet-subnet-id $SUBNET_ID \
# --service-cidr 10.2.0.0/24 \
# --dns-service-ip 10.2.0.10 \
# --docker-bridge-address 172.17.0.1/16 \
# --generate-ssh-keys

az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME

kubectl get nodes 

kubectl get namespace 

kubectl create namespace ratingsapp



# DEMO 2: Create ACI 
DNS_NAME_LABEL=aci-demo-$RANDOM 
CONTAINER_NAME=aciworkshop
az container create --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME --image microsoft/aci-helloworld --ports 80 --dns-name-label $DNS_NAME_LABEL
az container show --resource-group $RESOURCE_GROUP --name $CONTAINER_NAME --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table 

az group delete --name $RESOURCE_GROUP --yes 
