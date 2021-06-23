# MSIX App Attach

In Azure Virtual Desktop (AVD), the [MSIX app attach](https://docs.microsoft.com/en-us/azure/virtual-desktop/what-is-app-attach) feature allows application delivery. This is done by making an MSIX Package image available to any AVD session host, in other words, to the AVD infrastructure.

The [MSIX](https://docs.microsoft.com/en-us/windows/msix/overview) is the new Windows app package format providing a modern packaging experience for all Windows Apps. MSIX packaged applications will run in a lightweight app container. The MSIX application process and its child processes run inside the container and are isolated using file system and registry virtualization.

For more information, visit [Understanding how MSIX packages run on Windows](https://docs.microsoft.com/en-us/windows/msix/desktop/desktop-to-uwp-behind-the-scenes).

## Packaging process

In order to package MSIX we must consider our scenario and choose the ideal process to package the application. Here we summarize the scenarios:

- You're a developer with access to the source code, there are native ways to package it from Visual Studio. We recommend the article [Package your app as an MSIX in Visual Studio](https://docs.microsoft.com/en-us/windows/msix/desktop/vs-package-overview).
- You do not have access to source code but there is an existing installer. We recommend following the article Create an [MSIX Package from an existing installer](https://docs.microsoft.com/en-us/windows/msix/packaging-tool/create-an-msix-overview).
- **You do not have access to source code and there is no installer**. This is the scenario this pipeline focus on. It's meant specially for the legacy applications we want to make available in any Azure Virtual Desktop environment. For more advanced scenarios with legacy apps, check the [Package Support Framework](./psf.md).

In this repo, we present an automated way to **prepare**, **package**, **create image** and **publish** it in AVD.

In this section we describe additional details about each phase:

### Prepare

If we're targeting an MSIX Package to package our application, we need to prepare the application binaries.

Into a specific file location we name `AppConfigured` we copy all the app binaries and minimum MSIX artifacts. These are copied from  `/msix-appattach/msix_application_artifacts` and include the **Manifest file** and images to be used as icons in Windows.

Each pipeline user should change the contents of this folder according to the end goals.

Still during this phase, the **Manifest file** is fullfilled with parameter data and variable data. This brings flexibility to the pipeline as one can customize the app per environment.

During the next steps, some tools like `MakePri.exe` are executed. This is a command line tool that can be used to create and dump PRI files. It is integrated as part of MSBuild within Microsoft Visual Studio. This tool is available in the *Windows Software Development Kit*.

In our case we're creating packages manually and using a custom build system (not Visual Studio). We included makepri.exe directly in the repo in `/msix-appattach/tools/windowskit` with the respective version identified in [version.txt](https://github.com/joalmeid/avd-app-attach-ops/blob/main/tools/windowskit/version.txt).

The `MakePri.exe` execution is done by providing a set of parameters. We start by generating a config for Resources package specifing the supported application languages. For multilanguage scenarios visit documentation [here](https://docs.microsoft.com/en-us/windows/uwp/app-resources/compile-resources-manually-with-makepri). The last `MakePri.exe` is to create the resources.pri file(s) which will be included in the MSIX package.

### Package

In order to package our application, the pipeline leverages the `MsixPackaging@1` in order to create the msix file based on the existing manifest file.

In the following step we use the `MsixSigning@1` task, in order to sign the MSIX package. As an input we are providing a certificate file (.pfx) stored as a secure file. We also provide the respective certificate password from a variable group secret. The certificate file used is a self-signed certificate and it used as a mere sample.

The sample certificate is located in `/msix-appattach/msix_certs/sscert.pfx`.

> It is recommended to use [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/) to place and manage your certificates.

### Create MSIX Image

From an MSIX Package, we have to transform into a supported image format (VHD, VHDX or CIM). In AVD, any of these formats allows you to dynamically attach apps from an MSIX package to a user session. It becomes an application layering solution, seperate from any master image used in AVD.

In the pipeline we use the task `MsixAppAttach@1` to create a VHDX file for app attach. This task uses native tools like `diskpart` in order to mount a volume and prepare the image. As inputs we specify the package format `MSIX.msix`, the output path but also the size of the image. This size should be big enough to hold the full application file system.

### Publish

For publishing the MSIX image, we use the Powershell Azure CLI, specifically the `Az.DesktopVirtualization` module. By using the `Expand-AzWvdMsixImage` and `New-AzWvdMsixPackage` cmdlets, we are able to add the MSIX Package to the host pool. We provide the UNC path to the MSIX image

At this point, all the session hosts will individually validate the MSIX Image anc confirm the outcome. If successfull, the MSIX Package will be registered in the host pool. Now the MSIX application is available to be added into an Application Group with a given set of assignments. This will determine who will be able to access and use the application during any host pool sessions.

Any MSIX Package will have a determined state (`Active` | `Inactive`). The pipeline publishes the app inactive and only after manual approval the state is changed to active.
