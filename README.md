# Azure Virtual Desktop MSIX App Attach operations

## Introduction

Azure Virtual Desktop introduced lately the MSIX App Attach feature, which allows Ops teams effiently to deploy MSIX packages to the AVD infrastructure. The AVD MSIX App Attach starter ADO pipeline has the goal to provide a workflow automation to upgrade an MSIX Package to a new version using MSIX App Attach. Using ADO piplines will provide Ops teams traceability and operational relaibility to manage MSIX packages in AVD. We intentialy keept the process simple so that you can adopt it easily to your specific needs.

From a process perspective there are two main scenarios:
1. The Team is owning the code and is building the Application as well as packaging the MSIX in an automated way before deploying to AVD.
2. The Team is getting App binaries and will need to create the MSIX package before deploying to AVD.

The starter pipeline implements the second scenario. The pipeline could be easly adopted for the first scenario as well by changing the CI stage of the pipeline to work with your existing automation.

The following graphic is showing an overview of the key components involved by the second scenario. The pipeline implemets a CI and CD stage. The CI stage is getting the App binaries from a Azure Blob. The CD stage deploys the image to the MSIX _AppAttach_File_share (1) and depolys it to the AVD infrastructure (2):

![Pipeline overview](doc/images/pipeline_overview.jpg)

### Pipeline process

**CI Stage** will
1. create a new MSIX package from a ziped Application File structure, which the pipeline takes as input from Azure Blob
2. create an VHDX image containing the MSIX package
3. store the image as an ADO Artifact and makes it available to the **CD stage**

**CD Stage** will
1. copy the VHDX image to the Azure VM, which act as the MSIX _AppAttach_File_share
2. register the new MSIX package in AVD and set it as inactive
3. triggers a manual Approval Gate workflow which allows to set the package active, which triggers the rollout to AVD.

The following graphic is showing the pipeline process structured by the CI stage process steps and the CD stage process steps. 

![CI-CD process steps](doc/images/ci_cd_process.jpg)

### YAML template structure

todo > chris

- Image_Artifact_Location > link > Chris
- Rollout Orchestration multiple environments > link > Joao

## Prerequirements

* Azure Subscription
* Azure DevOps project
* Azure Virtual Desktop environment
  * Session Host Pool
  * Workspace
  * Application Group
* Azure Storage Account Gen2
  * Create Blob container to place application input file (zip)
* Azure Virtual Machine (fileshare)

Recommended IaC : [ARM Template to Create and provision new Windows Virtual Desktop hostpool](https://github.com/Azure/RDS-Templates/tree/master/ARM-wvd-templates)

## Getting Started

Once you have all the requirements checked, there will be a an Azure Virtual Desktop infrastructure already setup. This infrastructure also includes some additional Azure resources, hence being a full cloud native setup.

This section helps getting started with the automation, focusing on the devops tasks you need to run in order to deploy a demo enterprise scale application using [MSIX App Attach](https://docs.microsoft.com/en-us/azure/virtual-desktop/what-is-app-attach) feature.

As a generic set of steps you must:

>**NOTE:** All the steps are scripted in bash, using `az cli`. <ins>You can review/change all the variables in `/setup/dev-env.sh` and execute `/setup/setup-azure-devops.sh`.</ins>

* In your recently created Azure DevOps project
  * Create the `Variable Groups` used by the pipelines;
  * Create `Service Connection(s)` to your Azure Subscription(s);
  * Create a `pipeline` in Azure Pipelines (pointing to yaml in `./pipelines/env-CICD-avd-msix-app-attach.yml`);


* The pipeline is expecting an app zip file in a Blob Storage;
  * Copy the `/application/appbin.zip` to a reachable blob container in the Blob storage account.

## Configure the Environments

For simplicity purpose, this pipeline does not leverage leverage [Multi-stage pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/multi-stage-pipelines-experience?view=azure-devops). This could be easilly extended and/or maintaing seperate pipelines per environment (ex: **DEV**, **QA**, **PROD**).

This initial pipeline can be considered a **DEV** environment pipeline, where we already have specific variable groups created.

## Configure the Variable Group

In your Azure Devops project, go to **Azure Pipelines > Library**. You should have a total of 4 variable groups already created:

* `APP-msix-appattach-vg` : This is an application specific variable group. It should contain information to be used during the MSIX packaging steps.
* `DEV-msix-appattach-vg` : This is an environment (DEV) specific variable group. Contains information about the environment, namelly azure service connection, AVD Session pool name and others. Should be simillar to other environment variable groups.
* `QA-msix-appattach-vg` : This is an environment (QA) specific variable group.
* `PROD-msix-appattach-vg` : This is an environment (PROD) specific variable group.

Currently we're only referencing `APP-msix-appattach-vg` and `DEV-msix-appattach-vg` in our pipeline. It is necessary to review the variable values according to you application and Azure Virtual Desktop infrastructure.

* Review variable values in `APP-msix-appattach-vg`;
* Review variable values in `DEV-msix-appattach-vg`.

## Configure and run the CI/CD pipeline

## References

* [What are the top methods to deploy a Windows Virtual Desktop Host Pool](https://cloudblogs.microsoft.com/industry-blog/en-gb/cross-industry/2020/03/17/what-are-the-top-methods-to-deploy-a-windows-virtual-desktop-host-pool/)
* [Enterprise-scale support for the Windows Virtual Desktop construction set](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone)
* [Azure Virtual Desktop QuickStart](https://techcommunity.microsoft.com/t5/azure-virtual-desktop/introducing-the-windows-virtual-desktop-quickstart/m-p/1589347)
* [Building a Windows 10 Enterprise Multi Session Master Image with the Azure Image Builder DevOps Task](https://techcommunity.microsoft.com/t5/azure-virtual-desktop/building-a-windows-10-enterprise-multi-session-master-image-with/m-p/1503913)