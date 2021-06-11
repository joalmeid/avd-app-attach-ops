# Create MSIX
$appWorkingFolder="C:\temp\avd-msix-appattach\"
Set-Location $appWorkingFolder
$appMsixSourceFolderName="app"
$appMsixFileName="$(Get-Date -Format "ddMMyyHHmm")-$appMsixSourceFolderName"
$appMsixCertificateFileName="sscert-msix.pfx"
$appMsixCertificatePassword="<Certification Password>"

## MakePri: Generate Config for Resources package 
& "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\makepri.exe" createconfig /cf ".\$appMsixSourceFolderName\priconfig.xml" /dq en-US /o
## MakePri: Create the resources.pri file(s)
& "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\makepri.exe" new /pr ".\$appMsixSourceFolderName" /cf ".\$appMsixSourceFolderName\priconfig.xml" /of ".\$appMsixSourceFolderName\resources.pri" /mn ".\$appMsixSourceFolderName\AppxManifest.xml" /o
## Makeappx: Create MSIX package
& "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\makeappx.exe" pack /d ".\$appMsixSourceFolderName" /p "$appMsixFileName" /o /v
## Signtool: Sign MSIX package
& "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\Signtool.exe" sign /v /debug /fd SHA256 /f $appMsixCertificateFileName /p $appMsixCertificatePassword "$appMsixFileName.msix"

