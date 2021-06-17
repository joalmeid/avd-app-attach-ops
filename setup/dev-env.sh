#!/bin/bash

<env>-<proj>-<res>

# Environment variables
export SUBSCRIPTION=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
export LOCATION=westeurope 
export PROJ_NAME=avdops
export DEV_RG=dev-$PROJ_NAME-rg 
export DEV_VM_RG=dev-$PROJ_NAME-shpool-rg 
export VM_VNET=dev-$PROJ_NAME-vnet 
export VM_VNET_SUBNET=avd-subnet 
export SHARE_VNET_SUBNET=unc-subnet 
export DEV_KV_NAME=dev-$PROJ_NAME-kv
export DEV_AG_NAME=dev-$PROJ_NAME-ag 
export DEV_WORSPACE_NAME=dev-$PROJ_NAME-wks 
export DEV_HPOOL_NAME=dev-$PROJ_NAME-avd 
export DEV_HPOOL_VM_PREFIX=avdops-host 
export DEV_HPOOL_VM_AS=avdops-vm-dev-as 
export DEV_DOMAIN_NAME=xxxxx.onmicrosoft.com 
export DOMAIN_VNET_SUBNET=aadds-subnet 
export VM_ADMIN=avdops 
export VM_ADMIN_PASSWD=xxxxxxxx
export DOMAIN_ADMIN=vmjoiner@xxxxx.onmicrosoft.com 
export DOMAIN_ADMIN_PASSWD=xxxxxxxx 
export VM_SIZE=Standard_D2_v4 
export RDBrokerURL=https://rdbroker.wvd.microsoft.com 
export VM_TENANT_NAME= 
export AVD_STRG_NAME=avdsdevstrg 
export AVD_FILE_SHARE_NAME=avd-unc 
export AAD_WVG_GRP=avd-user-group
export ADO_ORGANIZATION=https://dev.azure.com/xxxxx/
export ADO_PROJECT=xxxxx
export ADO_SC_NAME=xxxxx
export ADO_PIPELINE_NAME=env-CICD-AVD-msix-app-attach
