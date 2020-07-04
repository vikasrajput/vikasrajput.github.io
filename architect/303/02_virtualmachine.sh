#!/bin/bash
##  NOTE: RUN THIS WITH bash -e <script> <parameter>    ## 
RESOURCE_GROUP=az303rg 
REGION=australiaeast

## create image based demo ubuntu VM with webserver ##
if [ $1 = 'simpleVM' ]; then 
az group create --name $RESOURCE_GROUP --location $REGION 
az vm create --name $RESOURCE_GROUP-ubuntuvm --resource-group $RESOURCE_GROUP --image UbuntuLTS --admin-username $RESOURCE_GROUP-vmadmin --generate-ssh-keys
az vm open-port --port 80 --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-ubuntuvm 
## install nginx server ##
PUBLICIP=$(az network public-ip list --resource-group az303rg --query [].ipAddress --output tsv)
ssh $RESOURCE_GROUP-vmadmin@$PUBLICIP << EOF
sudo apt-get -y update 
sudo apt-get -y install nginx
echo 'creating test file..'; touch newfile.log
ls -ltr 
echo 'removing test file...'; rm newfile.log
EOF
fi 

## Detailed VM Creation - with vnet, publicIP, NSG, NSG Rule, virtual nic, availability set, VM ##
if [ $1 = 'detailedVM' ]; then 
#RG 
az group create --resource-group $RESOURCE_GROUP --location $REGION 
#VNET 
az network vnet create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-vnet --address-prefix 192.168.0.0/16 --subnet-name $RESOURCE_GROUP-subnet --subnet-prefix 192.168.1.0/24 
#PUBLICIP 
az network public-ip create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-publicip --dns-name $RESOURCE_GROUP-publicdns 
#NSG 
az network nsg create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-nsg 
#NSGRULE 
az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name $RESOURCE_GROUP-nsg --name $RESOURCE_GROUP-nsgrulessh --protocol tcp --priority 1000 --destination-port-range 22 --access allow 
az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name $RESOURCE_GROUP-nsg --name $RESOURCE_GROUP-nsgruleweb --protocol tcp --priority 1001 --destination-port-range 80 --access allow 
az network nsg show --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-nsg
#NIC 
az network nic create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-nic --vnet-name $RESOURCE_GROUP-vnet --subnet $RESOURCE_GROUP-subnet --public-ip-address $RESOURCE_GROUP-publicip --network-security-group $RESOURCE_GROUP-nsg 
#AVAILABILITYSET 
az vm availability-set create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-availabilityset || exit_on_error "Failed to creae Availability Set"
#VM 
az vm create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-ubuntuvm --availability-set $RESOURCE_GROUP-availabilityset --nics $RESOURCE_GROUP-nic --image UbuntuLTS --admin-username $RESOURCE_GROUP-vmadmin --generate-ssh-keys 
#WEBSERVER 
ssh $RESOURCE_GROUP-vmadin@$RESOURCE_GROUP-publicdns.$REGION.cloudapp.azure.com <<EOF 
sudo apt-get -y update 
sudo apt-get -y install nginx 
EOF
fi 

## Create HA VMs with ALB ## 
if [ $1 = 'HAVM' ]; then 
#RG 
az group create --resource-group $RESOURCE_GROUP --location $REGION 
#VNET 
az network vnet create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-vnet --address-prefix 192.168.0.0/16 --subnet-name $RESOURCE_GROUP-subnet --subnet-prefix 192.168.1.0/24 
#PUBLICIP 
az network public-ip create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-publicip --dns-name $RESOURCE_GROUP-publicdns 
#ALB 
az network lb create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-lb --public-ip-address $RESOURCE_GROUP-publicip --frontend-ip-name $RESOURCE_GROUP-frontendip --backend-pool-name $RESOURCE_GROUP-backendpool
#LBProbe 
az network lb probe create --resource-group $RESOURCE_GROUP --lb-name $RESOURCE_GROUP-lb --name $RESOURCE_GROUP-lbprobe --protocol tcp --port 80
#LBRule
az network lb rule create --resource-group $RESOURCE_GROUP --lb-name $RESOURCE_GROUP-lb --name $RESOURCE_GROUP-lbrule --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name $RESOURCE_GROUP-frontendip --backend-pool-name $RESOURCE_GROUP-backendpool --probe-name $RESOURCE_GROUP-lbprobe
# Create three NAT rules for port 3389.
for i in `seq 1 3`; do
  az network lb inbound-nat-rule create --resource-group $RESOURCE_GROUP --lb-name $RESOURCE_GROUP-lb --name $RESOURCE_GROUP-lbnatrule$i --protocol tcp --frontend-port 422$i --backend-port 3389 --frontend-ip-name $RESOURCE_GROUP-frontendip
done
#NSG 
az network nsg create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-nsg 
#NSGRULE 
az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name $RESOURCE_GROUP-nsg --name $RESOURCE_GROUP-nsgrulessh --protocol tcp --priority 1000 --destination-port-range 3389 --access allow --direction inbound --source-address-prefix "*" --destination-address-prefix "*"
az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name $RESOURCE_GROUP-nsg --name $RESOURCE_GROUP-nsgruleweb --protocol tcp --priority 1001 --destination-port-range 80 --access allow --direction inbound --source-address-prefix "*" --destination-address-prefix "*"
az network nsg show --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-nsg
#NIC 
for i in `seq 1 3`; do
az network nic create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-nic$i --vnet-name $RESOURCE_GROUP-vnet --subnet $RESOURCE_GROUP-subnet --network-security-group $RESOURCE_GROUP-nsg --lb-name $RESOURCE_GROUP-lb --lb-address-pools $RESOURCE_GROUP-backendpool --lb-inbound-nat-rules $RESOURCE_GROUP-lbnatrule$i
done
#AVAILABILITY SET 
az vm availability-set create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-availabilityset 
#VM 
for i in `seq 1 3`; do
az vm create --resource-group $RESOURCE_GROUP --name $RESOURCE_GROUP-w16vm$i --availability-set $RESOURCE_GROUP-availabilityset --nics $RESOURCE_GROUP-nic$i --image win2016datacenter --admin-username $RESOURCE_GROUP-vmadmin --admin-password 'AVm@dmin12345678' 
done
fi