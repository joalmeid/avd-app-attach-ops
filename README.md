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
Recommended IaC : [ARM Template to Create and provision new Windows Virtual Desktop hostpool](https://github.com/Azure/RDS-Templates/tree/master/ARM-wvd-templates)
## Getting Started
## Configure the Environments
## Configure the Variable Group
## Configure and run the CI pipeline
## Configure and run the CD pipeline


## References

* [Enterprise-scale support for the Windows Virtual Desktop construction set](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone)