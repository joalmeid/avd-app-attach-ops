#!/bin/bash
set -x

. ./dev-env.sh

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
  --name AVD-DEV-ABS-CS \
  --branch Main \
  --description 'AVD-DEV-ABS-CS pipeline'\
  --repository MSIXPipelinePattern \
  --repository-type tfsgit \
  --skip-first-run true \
  --yaml-path '/.pipelines/env-CICD-avd-msix-app-attach.yml' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

az pipelines list \
  --name 'AVD*' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT


# Application specific variable group
## Create APP variable group
az pipelines variable-group create \
  --name 'APP-msix-appattach-vg' \
  --variables applicationDescription=SyncierConfigSuite applicationDisplayName='Syncier Config Suite' applicationExecutable=GGRLSUITE\\bin\\abs_configuration_suite.exe applicationName=SyncierConfigSuite CertificateName=configsuite-sscert-msix.pfx CertificatePasswordVariable=CertificatePassword msixImageSize=1024 publisher=CN=syncier publisherDisplayName=SyncierConfigSuite \
  --authorize true \
  --description 'Application specific variable group for AVD and MSIX Appattach automation' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

## get APP variable group ID
AppVariableGroupID=$(az pipelines variable-group list \
  --detect true \
  --group-name 'APP*' \
  --org https://dev.azure.com/xcbinder/ \
  --project ABSEE \
  --query '[].id'\
  -o tsv)
## Create secrets in APP variable group
az pipelines variable-group variable create \
  --group-id $AppVariableGroupID \
  --name CertificatePassword1 \
  --secret true \
  --value Q1w2e3r4t5y6. \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

# Environment specific variable group
## Create DEV variable group
az pipelines variable-group create \
  --name 'DEV-msix-appattach-vg' \
  --variables applicationGroupName=syncier-absee-ag azureSubscription=WVD-INTERNAL-AZURE hostPoolName=syncier-dev-wvd resourceGroup=absee-dev-rg storageAccount=wvdsdevstrg VMAdminUsername=absee \
  --authorize true \
  --description 'MSIX Appattach Package specific environment variables' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

## Get DEV variable group ID
DEVVariableGroupID=$(az pipelines variable-group list \
  --detect true \
  --group-name 'DEV*' \
  --org https://dev.azure.com/xcbinder/ \
  --project ABSEE \
  --query '[].id'\
  -o tsv)
## Create secrets in DEV variable group
az pipelines variable-group variable create \
  --group-id $DEVVariableGroupID \
  --name VMAdminPassword \
  --secret true \
  --value Q1w2e3r4t5y6. \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

## Create QA variable group
az pipelines variable-group create \
  --name 'QA-msix-appattach-vg' \
  --variables applicationGroupName=syncier-absee-ag azureSubscription=WVD-INTERNAL-AZURE hostPoolName=syncier-dev-wvd resourceGroup=absee-dev-rg storageAccount=wvdsdevstrg VMAdminUsername=absee \
  --authorize true \
  --description 'MSIX Appattach Package specific environment variables' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

## Get QA variable group ID
QAVariableGroupID=$(az pipelines variable-group list \
  --detect true \
  --group-name 'QA*' \
  --org https://dev.azure.com/xcbinder/ \
  --project ABSEE \
  --query '[].id'\
  -o tsv)
## Create secrets in QA variable group
az pipelines variable-group variable create \
  --group-id $QAVariableGroupID \
  --name VMAdminPassword \
  --secret true \
  --value Q1w2e3r4t5y6. \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

## Create PROD variable group
az pipelines variable-group create \
  --name 'PROD-msix-appattach-vg' \
  --variables applicationGroupName=syncier-absee-ag azureSubscription=WVD-INTERNAL-AZURE hostPoolName=syncier-dev-wvd resourceGroup=absee-dev-rg storageAccount=wvdsdevstrg VMAdminUsername=absee \
  --authorize true \
  --description 'MSIX Appattach Package specific environment variables' \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT

## Get PROD variable group ID
PRODVariableGroupID=$(az pipelines variable-group list \
  --detect true \
  --group-name 'PROD*' \
  --org https://dev.azure.com/xcbinder/ \
  --project ABSEE \
  --query '[].id'\
  -o tsv)
## Create secrets in PROD variable group
az pipelines variable-group variable create \
  --group-id $PRODVariableGroupID \
  --name VMAdminPassword \
  --secret true \
  --value Q1w2e3r4t5y6. \
  --org $ADO_ORGANIZATION \
  --project $ADO_PROJECT