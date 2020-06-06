CLS12
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Get-Credentials
$Path = (Get-ItemProperty Registry::HKCU\SOFTWARE\CRED)."(Default)"
$Cred = Get-Content -Path $Path
$UserName = $Cred[0]
$Password = $Cred[1] | ConvertTo-SecureString -asPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($UserName, $Password)
$PSSession = New-PSSession -ComputerName "dc02" -Credential $Credentials

Write-Host **** FSMO ****
netdom query fsmo

Write-Host **** Replication ****
(Get-ADDomain).ReplicaDirectoryServers

Write-Host
Write-Host **** Services ****
$Services = @("ADWS","DNS","KDC","NETLOGON")
Invoke-Command -ComputerName dc02 -ScriptBlock { Get-Service ADWS } -Credential $Credentials
Invoke-Command -ComputerName dc02 -ScriptBlock { Get-Service DNS } -Credential $Credentials
Invoke-Command -ComputerName dc02 -ScriptBlock { Get-Service KDC } -Credential $Credentials
Invoke-Command -ComputerName dc02 -ScriptBlock { Get-Service NETLOGON } -Credential $Credentials



#https://www.petri.com/check-domain-controller-services-powershell
