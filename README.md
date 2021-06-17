# Azure Virtual Desktop MSIX App Attach operations

## Introduction

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

## Configure and run the CI pipeline

## Configure and run the CD pipeline

## References

* [Enterprise-scale support for the Windows Virtual Desktop construction set](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone)