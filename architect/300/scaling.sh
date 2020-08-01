datestr=`date +%Y%m%d`
myResourceGroup="RG$datestr"

#create RG
az group create --name $myResourceGroup --location eastus
#create VMSS
az vmss create \
  --resource-group $myResourceGroup \
  --name myScaleSet \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --instance-count 2 \
  --admin-username azureuser \
  --generate-ssh-keys

#Create autoscale rule for monitor
az monitor autoscale create \
  --resource-group $myResourceGroup \
  --resource myScaleSet \
  --resource-type Microsoft.Compute/virtualMachineScaleSets \
  --name autoscale \
  --min-count 2 \
  --max-count 10 \
  --count 2
#scale out rule
#greater than 70% over a 5-minute period
az monitor autoscale rule create \
  --resource-group $myResourceGroup \
  --autoscale-name autoscale \
  --condition "Percentage CPU > 70 avg 5m" \
  --scale out 3
#scale in rule 
az monitor autoscale rule create \
  --resource-group $myResourceGroup \
  --autoscale-name autoscale \
  --condition "Percentage CPU < 30 avg 5m" \
  --scale in 1

#collect ip information
az vmss list-instance-connection-info \
  --resource-group $myResourceGroup \
  --name myScaleSet

ssh -o "StrictHostKeyChecking=no" azureuser@40.88.2.42 -p 50001 << CLOSE1
sudo apt-get update
sudo apt-get -y install stress
sudo stress --cpu 10 --timeout 420 &
CLOSE1

ssh -o "StrictHostKeyChecking=no" azureuser@40.88.2.42 -p 50002 << CLOSE2
sudo apt-get update
sudo apt-get -y install stress
sudo stress --cpu 10 --timeout 420 &
CLOSE2

az vmss list-instances \
  --resource-group $myResourceGroup \
  --name myScaleSet \
  --output table

