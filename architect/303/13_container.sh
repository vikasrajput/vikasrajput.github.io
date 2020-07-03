az group create --name az303rg --location australiaeast
DNS_NAME_LABEL=az303rg-acidemodns 
az container create --resource-group az303rg --name az303rg-container --image microsoft/aci-helloworld --ports 80 --dns-name-label az303rg-acidemodns --location australiaeast
az container show --resource-group  az303rg --name az303rg-container --query FQDN:ipAddress.fqdn --out table az container show --resource-group  az303rg --name az303rg-container --query ProvisioningState:provisioningState --out table
# creating container with CNI
az network vnet create --resource-group az303rg --location australiaeast --name az303rg-aks-vnet --address-prefixes 10.0.0.0/8 --subnet-name az303rg-aks-subnet --subnet-prefixes 10.240.0.0/16
subnet_id=$(az network vnet subnet show --vnet-name az303rg-aks-vnet --name az303rg-aks-subnet --resource-group az303rg --query id -o tsv)
az aks create --resource-group  az303rg  --name az303rg-akscluster --vm-set-type VirtualMachineScaleSets --load-balancer-sku standard --network-plugin azure --vnet-subnet-id /subscriptions/f4e9b171-cff4-4f3e-be8c-71b2de84b804/resourceGroups/az303rg/providers/Microsoft.Network/virtualNetworks/az303rg-aks-vnet/subnets/az303rg-aks-subnet --service-cidr 10.2.0.0/24 --dns-service-ip 10.2.0.10 --docker-bridge-address 172.17.0.1/16 --generate-ssh-keys
az aks get-credentials --resource-group az303rg --name az303rg-akscluster
az aks get-credentials --resource-group az303rg --name az303rg-akscluster
az aks get-credentials --resource-group $resource_group --name $resource_group-akscluster
kubectl get nodes
kubectl get namespace
kubectl create namespace ratingsapp
