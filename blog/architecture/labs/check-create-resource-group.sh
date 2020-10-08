#!/bin/bash 

echo "DECLARING VARIABLES...."
ResourceGroup=$(date +"%Y%m%d")
ResourceGroup="rg$ResourceGroup"
location=southeastasia 

if [[ ($1 == "clean") && ($(az group exists --name $ResourceGroup) == true) ]]
then 
    echo "DELETING RESOURCE GROUP AS CLEANUP"
    az group delete --name $ResourceGroup --yes 
fi 

if [ $(az group exists --name $ResourceGroup) == false ]
then 
    echo "CREATING RESOURCE GROUP"
    az group create --name $ResourceGroup --location $location 
fi 
