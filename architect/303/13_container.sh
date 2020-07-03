az group create --name az303rg --location australiaeast
DNS_NAME_LABEL=az303rg-acidemodns 
az container create --resource-group az303rg --name az303rg-container --image microsoft/aci-helloworld --ports 80 --dns-name-label az303rg-acidemodns --location australiaeast
az container show --resource-group  az303rg --name az303rg-container --query FQDN:ipAddress.fqdn --out table az container show --resource-group  az303rg --name az303rg-container --query ProvisioningState:provisioningState --out table
