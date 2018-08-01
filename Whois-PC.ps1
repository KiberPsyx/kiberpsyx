Clear-Host
Add-Type –AssemblyName System.Windows.Forms
#$Credentials = Get-Credential

$Path = (Get-ItemProperty Registry::HKCU\SOFTWARE\CRED)."(Default)"
$Cred = Get-Content -Path $Path
$UserName = $Cred[0]
$Password = $Cred[1] | ConvertTo-SecureString -asPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($UserName, $Password)

$PC = Read-Host "Enter Hostname"

$WinRM = Test-WSMan -ComputerName $PC -Credential $Credentials -Authentication Negotiate 2> $null
if (-not $WinRM) {Write-Host "Error: WinRM"}

$IP=Test-Connection $PC -count 1 | Select -ExpandProperty Ipv4Address
if (-not $IP) {Write-Host "Error: Ping"}
  
Invoke-Command -ComputerName $PC -ScriptBlock { 

    #Import-Module GroupPolicy
    #Invoke-GPUpdate -Computer "$env:ComputerName" -Force

    #gpupdate /force
    wuauclt.exe /reportnow
    #wuauclt.exe /resetauthorization /detectnow

    $PC = $env:computername
    $IP=Test-Connection $PC -count 1 | Select -ExpandProperty Ipv4Address
    
    $Name=(Get-CimInstance -Class Win32_OperatingSystem).Caption
    $Build1=(Get-CimInstance -Class Win32_OperatingSystem).BuildNumber  
    $Build2 = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").UBR      
    $ReleaseId = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId


    $Arch=(Get-CimInstance –Query "Select OSArchitecture from Win32_OperatingSystem").OSArchitecture 
    $User=(Get-CimInstance -Class Win32_ComputerSystem).UserName
    $Lang=(Get-CimInstance –Query "Select OSLanguage from Win32_OperatingSystem").OSLanguage 
    if ($Lang -eq "1033") {$Lang = "(EN)"}  
    if ($Lang -eq "1049") {$Lang = "(RU)"} 
    $WUServer = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate").WUServer
    $Branch = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate").BranchReadinessLevel
    $Defer = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate").DeferFeatureUpdates
    $Drivers = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate").DeferFeatureUpdates
    $Boot=(Get-CimInstance –Class CIM_OperatingSystem).LastBootUpTime
    
    Write-Host "--------------------------------------------------"
    Write-Host "Hostname:"$PC [$IP]
    Write-Host "--------------------------------------------------"
    Write-Host "Name:"$Name $Arch $Lang
    Write-Host "Build:"$Build1'.'$Build2 [$ReleaseId]    
    Write-Host "User:"$User
    Write-Host "Boot Time:"$Boot
    Write-Host "WUServer:"$WUServer
    Write-Host "Defer:"$Branch "|" $Defer
    Write-Host

} -Credential $Credentials

Read-Host " "