# Azure Virtual Desktop MSIX App Attach delivery

![Azure Virtual Desktop MSIX App Attach delivery](doc/images/AVD_MSIX_App_Attach_delivery.gif)

[Fast forward -  jump directly to the *Getting started* section](#getting-started)

Azure Virtual Desktop (AVD) introduced lately the [MSIX App Attach](https://docs.microsoft.com/en-us/azure/virtual-desktop/what-is-app-attach) feature, which allows Ops teams to deploy MSIX packages to the AVD infrastructure. The AVD MSIX App Attach starter ADO pipeline has the goal to provide an workflow automation to upgrade a MSIX Package to a new version using MSIX App Attach. Using ADO pipelines will provide Ops teams traceability and operational reliability to manage MSIX packages in AVD. We intentionally kept the process simple so that you can adopt it easily to your specific needs.

**Create an MSIX package with no access to source code and there is no installer**

The pipeline will support the scenario where the team is getting App binaries for the Application, which needs to to be packaged as MSIX package and deployed to AVD. App binaries is a folder structure containing the App itself - not an installer of the App.

**Create an MSIX package from an existing installer - customization needed**

If the Team is getting an installer of the App the CI stage of the automation needs to be customized. There is the [MSIX Packaging Tool](https://docs.microsoft.com/en-us/windows/msix/packaging-tool/create-app-package) which is supporting this conversation.

**Build an MSIX package from source code - customization needed**

If the Team is owning the code, building the Application and packaging the MSIX in an automated way before deploying to AVD. The pipeline could be adopted for this scenario by adopting the CI stage of the pipeline to integrate with your existing automation.

The following graphic is showing an overview of the key components involved by our scenario. Please note that we are using an Azure VM as MSIX_AppAttach_File_share. For high performance and reliability we recommend to use Azure NetApp Files, which the pipeline is supporting as well.

The pipeline implements a CI and CD stage. The CI stage is getting the App binaries from a Azure Blob. The CD stage deploys the image to the MSIX _AppAttach_File_share (1) and deploys it to the AVD infrastructure (2):

![Pipeline overview](doc/images/pipeline_overview.jpg)

### Pipeline process

**CI Stage** will
1. create a new MSIX package from a zipped Application File structure, which the pipeline takes as input from Azure Blob
2. create an VHDX image containing the MSIX package
3. store the image as an ADO Artifact and makes it available to the **CD stage**

**CD Stage** will
1. copy the VHDX image to the Azure VM, which act as the MSIX_AppAttach_File_share
2. register the new MSIX package in AVD and set it as inactive
3. triggers a manual Approval Gate workflow which allows to set the package active, which triggers the rollout to AVD.

The following graphic is showing the pipeline process structured by the CI stage process steps and the CD stage process steps.

![CI-CD process steps](doc/images/ci_cd_process.jpg)

### YAML template structure

The pipeline is using yaml templates to structure the workflow. The following overview is showing templates being used. The main entry point ```ENV-CICD-avd-msix-app-attach.yml``` is considered to be environment specific and so takes all environment specific variables. The sub templates could be easily mapped to the CI/CD stages and are presenting the workflow for each logical set of steps.

![YAML tempalte structure](doc/images/yaml_template_structure.jpg)

Learn more about the details and how to customize for specific scenarios :

Pipeline workflow
- [Understand the concept Image_Artifact_Location](doc/image-artifact-location.md) : Image_Artifact_Location is a storage location used by the pipeline for the images. Learn how to customize the behavior.
- [Rollout Orchestration multiple environments](doc/multiple-environments.md) : Many enterprises require rollouts to be orchestrated trough several environments before reaching production. Learn how the pipeline is supporting this requirement.
- [Parallel Beta testing in a single AVD environment](doc/beta-test-env.md) : How to support Beta App Users in parallel within a single AVD environment.

MSIX packaging, Image creation and MSIX App Attach
- [MSIX App Attach Automation](doc/msix-appattach-automation.md) : Learn about the MSIX packaging, image creation and publishing process by the pipline and where to customize if needed.
- [Azure NetApp Files for performance and reliability](doc/netapp.md) : Learn about Azure NetApp Files as MSIX_AppAttach_File_share to support your performance and reliability requirements.
- [Package Support Framework](doc/psf.md) : Your legacy App is not MSIX compatible and you do not have access to code? Learn about the Package Support Framework and how it could be used in the pipeline to overcome legacy limitations by using PSF configuration.

## Prerequirements

As this project fosters a full MSIX Appattach CI/CD pipeline to Azure Virtual Desktop, there is a set of requirements which are out of scope. However, we present a list of requirements and specific notes are provided:

* **Azure Subscription** : An Azure subscription, parented to one Azure AD tenant, that will contain a virtual network that either contains or is connected to the Azure AD DS (AADDS) instance;
* **Azure DevOps project** : An Azure DevOps project is required using Azure Repos and Azure Pipelines
* **Azure DevOps tasks** : MSIX Packaging task, which can be installed from the [Marketplace](https://marketplace.visualstudio.com/items?itemName=MSIX.msix-ci-automation-task) 
* **Azure Virtual Desktop environment** :
  * There are a set of [Requirements](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview#requirements) for the AVD environment
  * Session Host Pool : There is [tutorial](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-azure-marketplace) in AVD documentation.
    * Alternatively, you can also recur to the [AVD ARM based Infrastructure as Code](https://github.com/Azure/RDS-Templates/tree/master/ARM-wvd-templates)
  * Application Group: There is [tutorial](https://docs.microsoft.com/en-us/azure/virtual-desktop/manage-app-groups) in AVD documentation.
* **Azure Active Directory** : Azure Active Directory Domain Services (AADDS) instance in the same Azure AD tenant.
* **Azure Storage Account Gen2** :
  * Create Blob container to place application input file (zip). Documentation is available [here](https://docs.microsoft.com/en-us/azure/storage/blobs/.storage-quickstart-blobs-portal)
* **Azure Virtual Machine (MSIX_AppAttach_File_share)** : For using the MSIX App Attach feature, a UNC file share is required. In this setup, a common Virtual Machine is set up. Documentation is available [here](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-portal).
* **Remote Desktop clients** : Several clients are supported for different OSs and devices. Download the one that suits you, by checking the options [here](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview#supported-remote-desktop-clients).
* **Bash shell** : Having a bash shell (ex:WSL2) in order to run provided `.sh` scripts. The Azure CLI is requried to be installed.

## Getting Started

Once you have all the requirements checked, there will be a an Azure Virtual Desktop infrastructure already setup. This infrastructure also includes some additional Azure resources, hence being a full cloud native setup.

1. If you're familiar with Azure Devops you may prefer to do some of the steps manually. The following tasks are required in order to run this pipeline:

    - Create an Azure Devops project pointing to the repo;
    - Create azure Service connection;
    - Create Azure Devops pipeline pointing to yaml
    - Create Application Variable Group (**review and update Variables including secrets**)
    - Create Environment Variable Group (**review and update Variables including secrets**)
    - Create Secure File (certificate)
  
  <img src="doc/images/variable_groups_schematic.jpg" alt="Pipeline used Libraries">

2. We've also automated part of the initial setup. In order to quickly start, let's configure the Azure DevOps project to run the pipline and deploy the sample application to your AVD infrastructure.

    - Create Azure Devops project pointing to the repo (manual)
    - Review and update bash variables in `/setup/devops-env.sh` (manual)
    - Run the `/setup/setup-azure-devops.sh`
    - Update secrets in Variable Groups (manual)
    - Create Secure File (certificate) (manual)

Let us help you with a complete walkthrough:

### Setup Azure Devops

**1. Open a bash with `az cli` installed;**

**2. Review/change all the variables in `/setup/devops-env.sh`;**

**3. execute `/setup/setup-azure-devops.sh`.**

  >  This script will execute the following tasks:
  >
  >  - Create the `Variable Groups` used by the pipelines;
  >  - Create `Service Connection(s)` to your Azure Subscription(s);
  >  - Create a `pipeline` in Azure Pipelines (pointing to yaml in `./pipelines/env-CICD-avd-msix-app-attach.yml`);

### Configure the Variable Groups

In your Azure Devops project, go to **Azure Pipelines > Library**. You should have a total of 2 variable groups already created:

- `APP-msix-appattach-vg` : This is an application specific variable group. It should contain information to be used during the MSIX packaging steps.
- `DEV-msix-appattach-vg` : This is an environment (DEV) specific variable group. Contains information about the environment, namelly azure service connection, AVD Session pool name and others. Should be simillar to other environment variable groups.

> **NOTE:** For more information about parameters, variable groups or secure files, check the [Library Management](/doc/images/library-management.md) document.

**4. Review variable values in `APP-msix-appattach-vg`;**

**5. Review variable values in `DEV-msix-appattach-vg`.**

### Configure the Secure file

**6. Create a new secure file in the Azure Devops project;**

  > Add the sample self-signed certificate available in `/msix-appattach/msix_certs/sscert.pfx` as a secure file;
  > You can read how to do it in [Use secure files](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/secure-files?view=azure-devops).

**7. Install the self-signed certificate in the AVD Session hosts**
  
  > Copy the sample self-signed certificate available in `/msix-appattach/msix_certs/sscert.pfx` to the session hosts. Install the certificate in the `Local Machine` store using the password `Q1w2e3r4t5y6.` Select the `Trusted Root Certification Authorities` store:

  <img src="doc/images/cert_wizard_trusted_root.jpg" alt="Certificate Wizard" width="400" height="400">

### Configure and run the CI/CD pipeline

The pipeline is expecting an app zip file in a Blob Storage.

**8. Copy the `/application/appbin.zip` to a reachable blob container in the Blob storage account.** 

> **Please note** that the blob container needs to be a trusted location. Instead of anoymous read access we recommend to configure SAS token to access the blob. You can read how to do it [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-sas-overview). Customize the first step in `CI-appConfig-steps.yaml` to use the SAS token.

Now you're aready to run the pipeline using a Windows based Hosted Agent. The pipeline accepts parameters that must match your environment.

**9. Run the created pipeline (default name shoud be `env-CICD-AVD-msix-app-attach`)**

**10. Fill all the parameters accordingly to your environment;**

<img src="doc/images/pipeline_parameters.jpg" alt="Pipeline parameters" width="300" height="600">

  > **NOTE:** you can directly change and commit the main YAML pipeline `/.pipelines/env-CICD-avd-msix-app-attach.yaml` and change the parameters default values.

**11. Once the pipeline has been started it will pause in the CD stage for manual validation to activate the package.** After approval the pipeline looks like this:

<img src="doc/images/pipeline_run.jpg" alt="Pipeline Run" width="700" height="270">

  >  Check your MSIX Pachages in the AVD host pool resource. There should be an active package for `SimpleApp`:

  <img src="doc/images/msix_packages.jpg" alt="MSIX packages" width="600" height="150">

**12. Add the new app in an existing Application Group with respective assingments**

  > Go to your AVD Host pool resource and open `Application Groups` and select a application group;
  > Click in `Applications (manage)` and add a new Application.
  > Specify recently deployed `MSIX Package` and optionally fulfill the `Display Name` and `Description`
  > Documentation is available in article [Manage app groups with the Azure portal](https://docs.microsoft.com/en-us/azure/virtual-desktop/manage-app-groups)

 <img src="doc/images/avd_app_group.jpg" alt="AVD Application Group" width="500" height="200">

In this image we see an example with the `SimpleApp` app registered in an application group.

**13. Sign-in into one of the session hosts and run the deployed application**

**14. Re-run the pipline with new Version 0.0.2.0.** After AVD registration of the new package. Wait some time after the RD-agent finished polling. Sign-out in the remote session and sign-in again. Run the new version of the SimpleApp 0.0.2.0

<img src="doc/images/remote_desktop_app.jpg" alt="Remote Desktop" width="600" height="400">

## References

* [What are the top methods to deploy a Windows Virtual Desktop Host Pool](https://cloudblogs.microsoft.com/industry-blog/en-gb/cross-industry/2020/03/17/what-are-the-top-methods-to-deploy-a-windows-virtual-desktop-host-pool/)
* [Enterprise-scale support for the Windows Virtual Desktop construction set](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone)
* [Azure Virtual Desktop QuickStart](https://techcommunity.microsoft.com/t5/azure-virtual-desktop/introducing-the-windows-virtual-desktop-quickstart/m-p/1589347)
* [Building a Windows 10 Enterprise Multi Session Master Image with the Azure Image Builder DevOps Task](https://techcommunity.microsoft.com/t5/azure-virtual-desktop/building-a-windows-10-enterprise-multi-session-master-image-with/m-p/1503913)
* [Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/faq)
* [MSIX app attach FAQ](https://docs.microsoft.com/en-us/azure/virtual-desktop/app-attach-faq)
