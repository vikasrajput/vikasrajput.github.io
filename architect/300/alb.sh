datestr=`date +%Y%m%d`
myResourceGroupLB="RG$datestr"

#Create a resource group
az group create \
    --name $myResourceGroupLB \
    --location eastus

#create public IP 
az network public-ip create \
    --resource-group $myResourceGroupLB \
    --name myPublicIP \
    --sku Standard

#create standard ALB 
#create alb resource 
az network lb create \
    --resource-group $myResourceGroupLB \
    --name myLoadBalancer \
    --sku Standard \
    --public-ip-address myPublicIP \
    --frontend-ip-name myFrontEnd \
    --backend-pool-name myBackEndPool
#create health probe 
az network lb probe create \
    --resource-group $myResourceGroupLB \
    --lb-name myLoadBalancer \
    --name myHealthProbe \
    --protocol tcp \
    --port 80
#create alb rule 
az network lb rule create \
    --resource-group $myResourceGroupLB \
    --lb-name myLoadBalancer \
    --name myHTTPRule \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name myFrontEnd \
    --backend-pool-name myBackEndPool \
    --probe-name myHealthProbe \
    --disable-outbound-snat true

#configure virtual network 
#create vnet
az network vnet create \
    --resource-group $myResourceGroupLB \
    --location eastus \
    --name myVNet \
    --subnet-name myBackendSubnet
#create nsg 
az network nsg create \
    --resource-group $myResourceGroupLB \
    --name myNSG
#create nsg rule 
az network nsg rule create \
    --resource-group $myResourceGroupLB \
    --nsg-name myNSG \
    --name myNSGRuleHTTP \
    --protocol tcp \
    --direction inbound \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 80 \
    --access allow \
    --priority 200
#create 3 nic's for 3 vm's 
az network nic create \
    --resource-group $myResourceGroupLB \
    --name myNicVM1 \
    --vnet-name myVNet \
    --subnet myBackEndSubnet \
    --network-security-group myNSG \
    --lb-name myLoadBalancer \
    --lb-address-pools myBackEndPool
az network nic create \
    --resource-group $myResourceGroupLB \
    --name myNicVM2 \
    --vnet-name myVnet \
    --subnet myBackEndSubnet \
    --network-security-group myNSG \
    --lb-name myLoadBalancer \
    --lb-address-pools myBackEndPool
az network nic create \
    --resource-group $myResourceGroupLB \
    --name myNicVM3 \
    --vnet-name myVnet \
    --subnet myBackEndSubnet \
    --network-security-group myNSG \
    --lb-name myLoadBalancer \
    --lb-address-pools myBackEndPool

#create VMs
az vm create \
    --resource-group $myResourceGroupLB \
    --name myVM1 \
    --nics myNicVM1 \
    --image UbuntuLTS \
    --generate-ssh-keys \
    --custom-data cloud-init.yaml \
    --zone 1 \
    --no-wait
az vm create \
    --resource-group $myResourceGroupLB \
    --name myVM2 \
    --nics myNicVM2 \
    --image UbuntuLTS \
    --generate-ssh-keys \
    --custom-data cloud-init.yaml \
    --zone 1 \
    --no-wait
az vm create \
    --resource-group $myResourceGroupLB \
    --name myVM3 \
    --nics myNicVM3 \
    --image UbuntuLTS \
    --generate-ssh-keys \
    --custom-data cloud-init.yaml \
    --zone 1 \
    --no-wait

#create outbound rule config 
#create outbound public IP  
az network public-ip create \
    --resource-group $myResourceGroupLB \
    --name myPublicIPOutbound \
    --sku Standard
#create public ip prefix 
az network public-ip prefix create \
    --resource-group $myResourceGroupLB \
    --name myPublicIPPrefixOutbound \
    --length 28
#create outbound frontend IP  
az network lb frontend-ip create \
    --resource-group $myResourceGroupLB \
    --name myFrontEndOutbound \
    --lb-name myLoadBalancer \
    --public-ip-address myPublicIPOutbound
#create public IP prefix 
az network lb frontend-ip create \
    --resource-group $myResourceGroupLB \
    --name myFrontEndOutbound \
    --lb-name myLoadBalancer \
    --public-ip-prefix myPublicIPPrefixOutbound
#create outbound pool
az network lb address-pool create \
    --resource-group $myResourceGroupLB \
    --lb-name myLoadBalancer \
    --name myBackendPoolOutbound
#create outbound rule 
az network lb outbound-rule create \
    --resource-group $myResourceGroupLB \
    --lb-name myLoadBalancer \
    --name myOutboundRule \
    --frontend-ip-configs myFrontEndOutbound \
    --protocol All \
    --idle-timeout 15 \
    --outbound-ports 10000 \
    --address-pool myBackEndPoolOutbound

#add Vms to outbound pool 
az network nic ip-config address-pool add \
   --address-pool myBackendPoolOutbound \
   --ip-config-name ipconfig1 \
   --nic-name myNicVM1 \
   --resource-group $myResourceGroupLB \
   --lb-name myLoadBalancer
az network nic ip-config address-pool add \
   --address-pool myBackendPoolOutbound \
   --ip-config-name ipconfig1 \
   --nic-name myNicVM2 \
   --resource-group $myResourceGroupLB \
   --lb-name myLoadBalancer
az network nic ip-config address-pool add \
   --address-pool myBackendPoolOutbound \
   --ip-config-name ipconfig1 \
   --nic-name myNicVM3 \
   --resource-group $myResourceGroupLB \
   --lb-name myLoadBalancer