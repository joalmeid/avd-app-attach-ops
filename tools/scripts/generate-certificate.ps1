$workingFolder="..\..\msix_certs\"
$certSubject="CN=organization"
$certFriendlyName="organization-selfsigned"
$certPassword="<Certification Password>"
$certFilePath=".\sscert.pfx"

Set-Location $workingFolder
$cert = New-SelfSignedCertificate -Type Custom -Subject $certSubject -KeyUsage DigitalSignature -FriendlyName $certFriendlyName -CertStoreLocation "cert:\LocalMachine\My"
$password = ConvertTo-SecureString -String $certPassword -Force -AsPlainText
$certThumbprint = $cert.Thumbprint
Export-PfxCertificate -cert "cert:\LocalMachine\My\$certThumbprint" -FilePath $certFilePath -Password $password 
