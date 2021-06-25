# Azure NetApp Files (ANF)

In the context of MSIX App Attach feature in Azure Virtual Desktop (AVD), the location for the MSIX images requires a UNC Share. Specially for enterprise-grade organizations, aiming for higher performance, [Azure NetApp Files (ANF)](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction) is a great option. This integrates seamleslly with AVD MSIX App Attach, while leveraging ANF beneficies.

Azure NetApp Files is a high-performance, metered file storage service from Azure. It supports several workload types and is highly available by default. It also offers service and performance levels as well as snapshot capabilities. Specifically for Azure Virtual Desktop, it is recommended for extremely large scale deployments, providing up to 450,000 IOPS and sub-millisecond latency.

![MSIX_App_Attach_File_share](doc/images/../../images/msix_app_attach_file_share.jpg)

> [FSLogix](https://docs.microsoft.com/en-us/fslogix/overview), another roaming profile technology can also beneficiate from Azure NetApp Files. You can check additional documentation in the article [Create a profile container with Azure NetApp Files and AD DS](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-fslogix-profile-container).

# Setting up Azure NetApp Files for MSIX App Attach

Here, the main goal is to add MSIX Packages on a AVD host pool relying on Azure NetApp Files, an enterprise-grade SMB volumes. We will guide you through the steps to set up Azure NetApp Files for MSIX App Attach.

> At the time of writing, Azure NetApp Files usage required submiting a waitlist request. You can refer to [Register for Azure NetApp Files](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-register).

## Prerequirements

We enumerate the ANF prerequisites accordingly to our scenario. Check additional initial [prerequisites](../README.md#prerequirements)

- Azure account with contributor or administrator privileges on the subscription
- Ensure the VNet or subnet where AADDS is deployed is in the same Azure region as the Azure NetApp Files deployment.
- It will be required to delegate a subnet to Azure NetApp Files.

## Walkthrough the Azure NetApp Files for AVD MSIX App Attach

> First things first: Confirm Azure NetApp Files is available in the region of your session hosts.

### Process overview


We've automated the Azure NetApp Files setup. By using Azure CLI and the `netappfiles` module In order to quickly start, let's configure the Azure DevOps project to run the pipline and deploy the sample application to your AVD infrastructure.

**1. Open a bash with `az cli` installed;**

**2. Review/change all the variables in `/setup/avd-env.sh`;**

**3. Execute `/setup/create-netapp.sh`.**

  >  This script will execute the following tasks:
  > 
  >  - Register the NetApp Resource Provider
  >  - Set up an Azure NetApp Files account
  >  - Create a capacity pool
  >  - Join an Active Directory Connection
  >  - Create a delegated subnet
  >  - Create a new volume
  >  - Verify connection to Azure NetApp Files Share

**4. Upload MSIX Image to Azure NetApp Files Share**

**5. Configure the Azure Devops pipeline to publish to the Azure NetApp Files Share**

## References

- [Setting up Azure NetApp Files for MSIX App Attach | TechCommunity Step-by-Step Guide](https://techcommunity.microsoft.com/t5/azure-virtual-desktop/setting-up-azure-netapp-files-for-msix-app-attach-step-by-step/m-p/1990021)
- [Guidelines for Azure NetApp Files network planning](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-network-topologies)
https://docs.microsoft.com/en-us/azure/azure-netapp-files/create-active-directory-connections#decide-which-domain-services-to-use
- [Solution architectures using Azure NetApp Files](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-solution-architectures#virtual-desktop-infrastructure-solutions)
- [Create and manage Active Directory connections for Azure NetApp Files](https://docs.microsoft.com/en-us/azure/azure-netapp-files/create-active-directory-connections#decide-which-domain-services-to-use)
- [FAQs About Azure NetApp Files](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-faqs)