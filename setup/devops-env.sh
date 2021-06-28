#!/bin/bash

# Environment variables

## Environment specific variable group
export SUBSCRIPTION=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  # The Azure subscription ID.
export PROJ_NAME=avdops                                   # A project name to be used in Azure resource names.
export DEV_RG=dev-$PROJ_NAME-rg                           # The Resource Group name hosting the AVD host pool resource.
export DEV_HPOOL_NAME=dev-$PROJ_NAME-avd                  # The session host pool resource name in the AVD infrastructure.
export VM_ADMIN=avdops                                    # The Virtual Machine username to allow copying to the fileshare (UNC Share) created in the VM.
export VM_ADMIN_PASSWD=xxxxxxxx                           # The Virtual Machine password. This will be created as a secret in the variable group.
export AVD_STRG_NAME=avdsdevstrg                          # The storage account name to be created as a variable in a variable group and used by the pipeline.

## Application specific variable group
export CERTIFICATE_NAME=sscert.pfx
export CERTIFICATE_PASSWD=xxxxxxxx                        # The sample self-signed certificate password. This will be created as a secret in the variable group.

## Azure Devops 
export ADO_ORGANIZATION=https://dev.azure.com/xxxxx/      # The Azure Devops organization name.
export ADO_PROJECT=xxxxx                                  # The Azure Devops project name.
export ADO_SC_NAME=xxxxx                                  # The name of a Service Connection of type Azure Resource Manager in the Azure Devops organization.
export ADO_PIPELINE_NAME=env-CICD-AVD-msix-app-attach     # The Azure Devops pipeline name.
