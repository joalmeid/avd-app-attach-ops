#!/bin/bash
set -x

. ./devops-env.sh

# Setup Azure DevOps project with Variable Groups, Service Connection(s)/Endpoint and Creating Pipeline (pointing to yaml)

# Azure Devops Service Connection
sed -i -e "s/\[subscriptionId\]/$SUBSCRIPTION_ID/g" ./azure-devops-service-endpoint-template.json
sed -i -e "s/\[subscriptionName\]/$SUBSCRIPTION_NAME/g" ./azure-devops-service-endpoint-template.json
sed -i -e "s/\[sc-name\]/$ADO_SC_NAME/g" ./azure-devops-service-endpoint-template.json
sed -i -e "s/\[tenantId\]/$TENANT_ID/g" ./azure-devops-service-endpoint-template.json
az devops service-endpoint create \
  --service-endpoint-configuration ./azure-devops-service-endpoint-template.json \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

# Azure Devops Pipeline
az pipelines create \
  --name $ADO_PIPELINE_NAME \
  --branch Main \
  --description 'MSIX App Attach CI/CD pipeline'\
  --repository $ADO_PROJECT \
  --repository-type tfsgit \
  --skip-first-run true \
  --yaml-path '/.pipelines/env-CICD-avd-msix-app-attach.yml' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

# Application specific variable group
## Create APP variable group
az pipelines variable-group create \
  --name 'APP-msix-appattach-vg' \
  --variables applicationDescription=SimpleApp applicationDisplayName='Simple App' applicationExecutable=simple-app.exe applicationName=SimpleApp CertificateName=$CERTIFICATE_NAME CertificatePasswordVariable=CertificatePassword msixImageSize=100 publisher=CN=Contoso publisherDisplayName=Contoso \
  --authorize true \
  --description 'Application specific variable group for AVD and MSIX Appattach automation' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

## get APP variable group ID
AppVariableGroupID=$(az pipelines variable-group list \
  --detect true \
  --group-name 'APP*' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT \
  --query '[].id'\
  -o tsv)
## Create secrets in APP variable group
az pipelines variable-group variable create \
  --group-id $AppVariableGroupID \
  --name CertificatePassword \
  --secret true \
  --value $CERTIFICATE_PASSWD \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

# Environment specific variable group
## Create DEV variable group
az pipelines variable-group create \
  --name 'DEV-msix-appattach-vg' \
  --variables azureSubscription=$ADO_SC_NAME hostPoolName=$DEV_HPOOL_NAME resourceGroup=$DEV_RG storageAccount=$AVD_STRG_NAME msixAppAttachUNCLocalPath='c:\avdmsix' msixAppAttachUNCServer=fileshare.domain.onmicrosoft.com msixApplicationUNCShareName=avdmsix \
  --authorize true \
  --description 'MSIX Appattach Package specific environment variables' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

## Get DEV variable group ID
DEVVariableGroupID=$(az pipelines variable-group list \
  --detect true \
  --group-name 'DEV*' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT \
  --query '[].id'\
  -o tsv)
## Create secrets in DEV variable group
az pipelines variable-group variable create \
  --group-id $DEVVariableGroupID \
  --name UserUsername \
  --secret true \
  --value $VM_ADMIN \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

az pipelines variable-group variable create \
  --group-id $DEVVariableGroupID \
  --name UserPassword \
  --secret true \
  --value $VM_ADMIN_PASSWD \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT
