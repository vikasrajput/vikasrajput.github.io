RESOURCEGROUP=az303rg 
LOCATION=australiaeast 

if [ $1 = 'app-base' ]; then 
az group create --name $RESOURCEGROUP --location $LOCATION
## Create AppService Plan 
az appservice plan create --name $RESOURCEGROUP-appserviceplan --resource-group $RESOURCEGROUP --is-linux --number-of-workers 4 --sku S1 
## Create WebApp 
az webapp create --name $RESOURCEGROUP-base-webapp --plan $RESOURCEGROUP-appserviceplan --resource-group $RESOURCEGROUP --deployment-container-image-name nginx 
fi 

if [ $1 = 'app-container' ]; then 
az group create --name $RESOURCEGROUP --location $LOCATION
## defined Azure Container Registry 
az acr create --resource-group $RESOURCEGROUP --name ${RESOURCEGROUP}acr --sku standard  
## build the local docker image 
    if (./mslearn-deploy-run-container-app-service/); then rm -rf mslearn-deploy-run-container-app-service/ 
    fi 
    git clone https://github.com/MicrosoftDocs/mslearn-deploy-run-container-app-service.git 
    cd mslearn-deploy-run-container-app-service/dotnet 
    az acr build --registry ${RESOURCEGROUP}acr --image $RESOURCEGROUP-webimage . 
    rm -rf mslearn-deploy-run-container-app-service/
    az appservice plan create --name $RESOURCEGROUP-appserviceplan --resource-group $RESOURCEGROUP --number-of-workers 4 --sku S1 
    az webapp create --resource-group $RESOURCEGROUP --name $RESOURCEGROUP-docker-webapp --plan $RESOURCEGROUP-appserviceplan --deployment-container-image-name ${RESOURCEGROUP}acr.azurecr.io/$RESOURCEGROUP-webimage:latest

    ## creating deployment slot 
    az webapp deployment slot create --resource-group $RESOURCEGROUP --name $RESOURCEGROUP-docker-webapp --slot staging --configuration-source $RESOURCEGROUP-docker-webapp
    az webapp deployment slot auto-swap --resource-group $RESOURCEGROUP --name $RESOURCEGROUP-docker-webapp --slot staging
fi 

if [ $1 = 'logicapp' ]; then 
fi 