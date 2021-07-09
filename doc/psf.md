# Package Support Framework

The [Package Support Framework (PSF)](https://github.com/microsoft/MSIX-PackageSupportFramework) is an open source kit that helps applying fixes to an existing desktop application, specially when there is no  access to the source code. End goal is to run the application in an MSIX container.

Most common use cases to use PSF are:

- Appication can't find some DLLs when launched.
- You may need to set your current working directory.
- Having `ACCESS DENIED` due to appplication writes to the install folder.
- Your app needs to pass arguments to the executable when launched.

To get you started with PSF we have added an app which requires PSF integration in the pipeline. The sample is available in the [PSF-Scenario](https://github.com/joalmeid/avd-app-attach-ops/tree/psf-scenario) branch of the repo. Key additions are:

- we added the `src/psf-simple-app`
- we added `msix-appattach/psf_application_artifacts` which contains the binarires required for PSF
- adpoted the CI stage template  
`.pipelines/templates/CI-appConfig-steps.yaml` to copy PSF binaries
- adpoted the CI stage template  `.pipelines/templates/CI-msixConfig-steps.yaml` to update the PSF configuration required by the App 


If you prefer extending our Main sample yourself here are the basic steps to do so:

PSF can be applied on a existing MSIX package and/or being included in the MSIX package from the beginning.

The process to use PSF while building an MSIX package is:

1. **Identify the runtime fix** that solves the detected issue in the msix package.
   * Find available fixups in [PSF github](https://github.com/Microsoft/MSIX-PackageSupportFramework)
2. Get the Package Support Framework files
   * Run `nuget install Microsoft.PackageSupportFramework` and extract relevant files.
   * All the files you need will be under the /bin folder.
   * Files shoud be:
     * PSFLauncher64.exe / PSFLauncher32.exe
     * PSFRuntime64.dll / PSFRuntime32.dll
     * PSFRunDll64.exe / PSFRunDll32.exe
     * FileRedirectionFixup64.dll / FileRedirectionFixup32.dll (if used)
     * TraceFixup64 / TraceFixup32 (if used)
     * WaitForDebuggerFixup64 / WaitForDebuggerFixup32 (if used)
3. Modify the package manifest so the entrypoint is the `PSFLaucher64.exe` or `PSFLaucher32.exe` depending on app processor architecture.

   ```xml
    <Applications>
      <Application Id="SimpleApp" Executable="PSFLauncher64.exe" EntryPoint="Windows.FullTrustApplication">
      ...
      </Application>
    </Applications>
   ```

4. Create a configuration file name `config.json` in the root folder. Modify the configuration values accordingly. For the sample application the following config was used:

   > PSF allows defining a config in **xml format**.

   ```json
    {
      "applications": [
          {
              "id": "SimpleApp",
              "executable": "simple-app.exe",
              "workingDirectory": "/"
          }
      ],
      "processes": [
          {
              "executable": "simpleapp",
              "fixups": [
                  {
                      "dll": "FileRedirectionFixup.dll",
                      "config": {
                          "redirectedPaths": {
                              "packageRelative": [
                                  {
                                      "base": "/",
                                      "patterns": [
                                          "*.config",
                                          ".*\\.log"
                                      ]
                                  }  
                              ]     
                          }
                      }
                  }
              ]
          }
      ]
    }
   ```

5. Package the MSIX, using the identified process (leveraging `makeappx.exe`) and test the app.

## References

The Package Support Framework (PSF), allows more advanced scenarios and debugging / troubleshooting techniques. The following documentation is recommended:

* **[Apply runtime fixes by using the Package Support Framework](https://docs.microsoft.com/windows/uwp/porting/package-support-framework):** This article provides step-by-step instructions for the main Package Support Framework workflows.
* [File Redirection Fixup](https://github.com/Microsoft/MSIX-PackageSupportFramework/tree/master/fixups/FileRedirectionFixup) redirect attempts to write or read data in a directory that isn't accessible from an application that runs in an MSIX container.
* [Run scripts with the Package Support Framework](https://docs.microsoft.com/windows/msix/psf/run-scripts-with-package-support-framework): This article demonstrates how to run scripts to customize an application dynamically to the user's environment after it is packaged using MSIX.
