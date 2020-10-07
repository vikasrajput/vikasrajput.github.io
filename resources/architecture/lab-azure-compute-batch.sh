# Ref https://docs.microsoft.com/en-us/azure/batch/quick-create-cli

echo "DECLARING VARIABLES...."
resourcegroup=$(date +"%Y%m%d")
resourcegroup="rg$resourcegroup"
location=southeastasia 
resourcetype="batch"

echo "CREATING RESOURCE GROUP $resourcegroup"
az group delete --name $resourcegroup --yes 
az group create --name $resourcegroup --location $location

echo "---CREATING A BATCH ACCOUNT---"
resourcename=$resourcetype$resourcegroup
batchaccount=$resourcename"account"
storageaccount="sa"$resourcename 
az storage account create --resource-group $resourcegroup --name $storageaccount --location $location --sku Standard_LRS 
az batch account create --name $batchaccount --storage-account $storageaccount --resource-group $resourcegroup --location $location 
az batch account login --name $batchaccount --resource-group $resourcegroup --shared-key-auth 

echo "---CREATE BATCH POOL---"
poolid=$resourcename"pool"

az batch pool create \
    --id $poolid --vm-size Standard_A1_v2 \
    --target-dedicated-nodes 2 \
    --image canonical:ubuntuserver:16.04-LTS \
    --node-agent-sku-id "batch.node.ubuntu 16.04"
az batch pool show --pool-id $poolid \
    --query "allocationState"

echo "---JOB AND TASK TIME---"    
jobid=$poolid"jobid"
az batch job create --id $jobid --pool-id $poolid
for i in {1..4}
do
   az batch task create \
    --task-id mytask$i \
    --job-id $jobid \
    --command-line "/bin/bash -c 'printenv | grep AZ_BATCH; sleep 90s'"
done

az batch task show --job-id $jobid --task-id mytask1

az batch task file list --job-id $jobid --task-id mytask1 --output table 
#az batch task file download --job-id $jobid --task-id task1 --file-path <fileName> --destination ./<fileName>

az batch pool delete --pool-id $poolid


echo "DONT FORGET TO CLEAN AFTER YOURSELF!!"
echo "az group delete --name $resourcegroup --yes"
