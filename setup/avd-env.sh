#!/bin/bash

# AVD related Environment variables
export SUBSCRIPTION=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  # The Azure subscription ID.
export LOCATION=westeurope 
export PROJ_NAME=avdops                                   # A project name to be used in Azure resource names.
export DEV_RG=dev-$PROJ_NAME-rg                           # The Resource Group name hosting the AVD host pool resource.
export DEV_HPOOL_NAME=dev-$PROJ_NAME-avd                  # The session host pool resource name in the AVD infrastructure.

export DEV_VM_RG=dev-$PROJ_NAME-vmpool-rg                 # AVD hostpool resource group name to hold all session host vms.
export VM_VNET=dev-$PROJ_NAME-vnet                        # Azure VNET to hold AADDS DNS Zone, storage account, Azure NetApp subnet
export VM_VNET_SUBNET=avd-subnet                          # Azure VNET subnet name to hold AVD Session host pool vms.
export SHARE_VNET_SUBNET=unc-subnet                       # Azure VNET subnet name to hold UNC Shares.
export DEV_AG_NAME=dev-$PROJ_NAME-ag                      # AVD Application Group resource name.
export DEV_WORSPACE_NAME=dev-$PROJ_NAME-wks               # AVD Workspace resource name.
export DEV_HPOOL_NAME=dev-$PROJ_NAME-avd                  # AVD Host pool resource name.
export DEV_HPOOL_VM_PREFIX=$PROJ_NAME-host                # AVD session host VM name prefix.
export DEV_HPOOL_VM_AS=dev-$PROJ_NAME-vm-as 
export DEV_DOMAIN_NAME=xxxxxxx.onmicrosoft.com            # Azure ADDS domain (FQDN).
export DOMAIN_VNET_SUBNET=aadds-subnet                    # Azure VNET subnet name to hold Azure ADDS.
export VM_SIZE=Standard_D2_v4                             # Size for the Virtual Machine to be used as UNC file share. 
export VM_ADMIN=avdadmin                                  # Username for the Virtual Machine to be used as UNC file share. 
export VM_ADMIN_PASSWD=xxxxxxx                            # Password for the Virtual Machine to be used as UNC file share. 
export DOMAIN_ADMIN=aadadmin@xxxxxxx.onmicrosoft.com      # SPN for a Azure ADDS Domain administrator. 
export DOMAIN_ADMIN_PASSWD=xxxxxxx                        # Password for the Domain administrator of Azure ADDS Domain.
export WVD_STRG_NAME=devavdsstrg                          # Storage account name to be used in the AVD infrastructure and pipeline execution.
export AAD_WVG_GRP=avd-user-group                         # User Group in the Azure ADDS domain to provide AVD access.
export ANF_ACCOUNT_NAME=$PROJ_NAME-anf                    # Azure NetApp Files account name.
export ANF_POOL_NAME=$PROJ_NAME-anf-pool                  # Azure NetApp Files Capacity Pool name.
export ANF_POOL_SIZE=4                                    # Azure NetApp Files capacity pool size (minimum 4 TiB).
export ANF_SERVICE_LEVEL=Standard                         # Azure NetApp Files service level (Standard, Premium or Ultra)
export ANF_VOLUME_NAME=$PROJ_NAME-anf-vol                 # Azure NetApp Files Volume resource name.
export ANF_VNET_SUBNET=netapp-subnet                      # Azure VNET subnet name to hold Azure NetApp Files resources.
export ANF_VNET_SUBNET_CIDR "xxx.xxx.xxx.xxx/24"          # Azure VNET subnet CIDR to hold Azure NetApp Files resources.
export ANF_VOLUME_SIZE=100                                # Azure NetApp Files volume size (GiB). 
export ANF_UNIQUE_FILE_PATH=avdmsix                       # Azure NetApp Files volume file path (creation token). Needs to be unique within subscription and region.
export AND_SMB_SHARE_NAME=anfshare                        # Azure NetApp Files SMB Share name. 
