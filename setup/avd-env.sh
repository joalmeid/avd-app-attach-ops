#!/bin/bash

# Generic Environment variables
export SUBSCRIPTION=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  # The Azure subscription ID.
export LOCATION=westeurope 
export PROJ_NAME=avdops                                   # A project name to be used in Azure resource names.

# AVD related Environment variables
export DEV_RG=dev-$PROJ_NAME-rg                           # The Resource Group name hosting the AVD host pool resource.
export VM_VNET=dev-$PROJ_NAME-vnet                        # Azure VNET to hold AADDS DNS Zone, storage account, Azure NetApp subnet
export DEV_DOMAIN_NAME=xxxxxxx.onmicrosoft.com            # Azure ADDS domain (FQDN).
export DOMAIN_ADMIN=aadadmin@xxxxxxx.onmicrosoft.com      # SPN for a Azure ADDS Domain administrator. 
export DOMAIN_ADMIN_PASSWD=xxxxxxx                        # Password for the Domain administrator of Azure ADDS Domain.

# Azure NetApp Files (ANF) related Environment variables
export ANF_ACCOUNT_NAME=$PROJ_NAME-anf                    # Azure NetApp Files account name.
export AND_SMB_SHARE_NAME=anfshare                        # Azure NetApp Files Prefix SMB Share name. 
export ANF_POOL_NAME=$PROJ_NAME-anf-pool                  # Azure NetApp Files Capacity Pool name.
export ANF_POOL_SIZE=4                                    # Azure NetApp Files capacity pool size (minimum 4 TiB).
export ANF_SERVICE_LEVEL=Standard                         # Azure NetApp Files service level (Standard, Premium or Ultra)
export ANF_VOLUME_NAME=$PROJ_NAME-anf-vol                 # Azure NetApp Files Volume resource name.
export ANF_VNET_SUBNET=netapp-subnet                      # Azure VNET subnet name to hold Azure NetApp Files resources.
export ANF_VNET_SUBNET_CIDR "xxx.xxx.xxx.xxx/24"          # Azure VNET subnet CIDR to hold Azure NetApp Files resources.
export ANF_VOLUME_SIZE=100                                # Azure NetApp Files volume size (GiB). 
export ANF_UNIQUE_FILE_PATH=avdmsix                       # Azure NetApp Files volume file path (creation token). Needs to be unique within subscription and region.
