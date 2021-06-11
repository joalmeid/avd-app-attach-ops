## MSIXMGR: Expand MSIX into VHDX requires Hyper-V

#region variables
$appWorkingFolder="C:\temp\avd-msix-appattach\"
$appMsixFileName="<msix_package_file_name>"
$appImageSize="1GB"
$appImageFilePath="$appMsixFileName.vhdx"
$msixRootFolder="PackageRootFolder"
$wvdMsixFileSharePath="<UNC_file_share_path>"

#region create volume
Set-Location $appWorkingFolder
& New-VHD -SizeBytes $appImageSize -Path ".\$appImageFilePath" -Dynamic -Confirm:$false
$vhdObject = Mount-VHD $appImageFilePath -Passthru
$disk = Initialize-Disk -Passthru -Number $vhdObject.Number
# Avoids Exporer/GUI prompt due to AutoPlay hardware events
Stop-Service -Name ShellHWDetection
$partition = New-Partition -AssignDriveLetter -UseMaximumSize -DiskNumber $disk.Number
Start-Service -Name ShellHWDetection
& Format-Volume -FileSystem NTFS -Confirm:$false -DriveLetter $partition.DriveLetter -Force
& New-Item -Path "$($partition.DriveLetter):\$msixRootFolder" -ItemType Directory

#region unpack and dismount
& .\msixmgr\x64\msixmgr.exe -Unpack -packagePath "$appMsixFileName.msix" -destination "$($partition.DriveLetter):\$msixRootFolder" -applyacls
# Fix for Windows Server 2019
# .\msixmgr\x64\msixmgr.exe -UnmountImage -fileType VHDX -imagePath $appImageFilePath
& Dismount-DiskImage -imagePath "$appWorkingFolder$appImageFilePath"

#Copy to WVD fileshare
Copy-Item -Path "$appWorkingFolder$appImageFilePath" -Destination $wvdMsixFileSharePath
Write-Host "$wvdMsixFileSharePath\$appImageFilePath"
