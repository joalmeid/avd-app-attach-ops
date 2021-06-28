#!/bin/bash
set -x

. ./avd-env.sh

# Prepare your environment for the Azure CLI.
az account set --subscription $SUBSCRIPTION

# Register the NetApp Resource Provider
az provider register --namespace Microsoft.NetApp --wait 

# Set up an Azure NetApp Files account
az netappfiles account create \
    --resource-group $DEV_RG \
    --location $LOCATION \
    --account-name $ANF_ACCOUNT_NAME
	
# Create a capacity pool
az netappfiles pool create \
    --resource-group $DEV_RG \
    --location $LOCATION \
    --account-name $ANF_ACCOUNT_NAME \
    --pool-name $ANF_POOL_NAME \
    --size $ANF_POOL_SIZE \
    --service-level $ANF_SERVICE_LEVEL

# Join an Active Directory Connection
# Supports Active Directory DOmain Services and Azure AD Domain Services
AAD_DNS=$(az ad ds show -n $DOMAIN_ADMIN -g $DEV_RG --query "replicaSets[0].domainControllerIpAddress[0]" -o tsv)
az netappfiles account ad add \
  -g $DEV_RG \
  --dns $AAD_DNS \
  --domain $DEV_DOMAIN_NAME \
  --smb-server-name $AND_SMB_SHARE_NAME \
  --username $DOMAIN_ADMIN \
  --password $DOMAIN_ADMIN_PASSWD \
  --account-name $ANF_ACCOUNT_NAME \
  --organizational-unit "OU=AADDC Computers" 

# Create a SMB volume for Azure NetApp Files
# Create a delegated subnet
az network vnet subnet create \
    --resource-group $DEV_RG \
    --vnet-name $VM_VNET \
    --name $ANF_VNET_SUBNET \
    --address-prefixes $ANF_VNET_SUBNET_CIDR \
    --delegations "Microsoft.NetApp/volumes"

# Create a new volume
ANF_VNET_ID=$(az network vnet show --resource-group $DEV_RG --name $VM_VNET --query "id" -o tsv)
ANF_SUBNET_ID=$(az network vnet subnet show --resource-group $DEV_RG --vnet-name $VM_VNET --name $ANF_VNET_SUBNET --query "id" -o tsv)
az netappfiles volume create \
  -g $DEV_RG \
  --location $LOCATION \
  --account-name $ANF_ACCOUNT_NAME \
  --file-path $ANF_UNIQUE_FILE_PATH \
  --name $ANF_VOLUME_NAME \
  --pool-name $ANF_POOL_NAME \
  --usage-threshold $ANF_VOLUME_SIZE \
  --vnet $ANF_VNET_ID \
  --subnet $ANF_SUBNET_ID \
  --protocol-types "CIFS" \
  --snapshot-dir-visible false \
  --kerberos-enabled false \
  --smb-continuously-avl false \
  --ldap-enabled false \
  --encryption-key-source Microsoft.NetApp

# Verify connection to Azure NetApp Files Share
ANF_VOL_ID=$(az netappfiles volume show -g $DEV_RG --account-name $ANF_ACCOUNT_NAME --pool-name $ANF_POOL_NAME --volume-name $ANF_VOLUME_NAME --query "id" -o tsv)
#ANF_SMB_SERVER_FQDN=$(az netappfiles mount-target list -g $DEV_RG --account-name $ANF_ACCOUNT_NAME --pool-name $ANF_POOL_NAME --volume-name $ANF_VOLUME_NAME --query "[].smbServerFqdn" -o tsv)
ANF_SMB_SERVER_FQDN=$(az resource show --ids $ANF_VOL_ID --query "properties.mountTargets[0].smbServerFQDN" -o tsv)
ANF_SMB_SHARE_NAME=$(az resource show --ids $ANF_VOL_ID --query "properties.creationToken" -o tsv)

ANF_MOUNT_PATH="\\\\\\\\${ANF_SMB_SERVER_FQDN}\\\\${ANF_SMB_SHARE_NAME}"
echo $ANF_MOUNT_PATH
