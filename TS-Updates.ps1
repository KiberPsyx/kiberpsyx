CLS

Write-Host **** Services ****
$Services = @("wuauserv","cryptsvc","bits","msiserver")

ForEach ($Srv in $Services) {
    Stop-Service $Srv 
    Get-Service $Srv 
}

$SD = "C:\Windows\SoftwareDistribution"
$CR = "C:\Windows\System32\catroot2"
$DL = "$env:allusersprofile\Microsoft\Network\downloader"

if (Test-Path $SD) {Rename-Item -Path $SD -NewName "SoftwareDistribution.old"}
if (Test-Path $CR) {Rename-Item -Path $CR -NewName "Catroot2.old"}
if (Test-Path $DL) {Rename-Item -Path $DL -NewName "Downloader.old"}


 
 ForEach ($Srv in $Services) {
    Start-Service $Srv 
    Get-Service $Srv 
}


#https://answers.microsoft.com/en-us/insider/forum/insider_wintp-insider_update-insiderplat_pc/windows-update-database-corruption/7d4a68e8-cad3-422b-a54b-d5c17e397319