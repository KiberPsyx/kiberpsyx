# Get-Credentials
$Path = (Get-ItemProperty Registry::HKCU\SOFTWARE\CRED)."(Default)"
$Cred = Get-Content -Path $Path
$UserName = $Cred[0]
$Password = $Cred[1] | ConvertTo-SecureString -asPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($UserName, $Password)



#Copy-Item "C:\Users\aheiev.a\Desktop\наташа-болото-1.png" -Destination \\fs01\fs-users\_TEMP\!Scripts



#$Session = New-PSSession -ComputerName "fs01" -Credential "forpost\adm_pobyrokhin.k"
#Copy-Item "C:\Users\pobyrokhin.k\Desktop\WAC.txt" -Destination "\\fs01\fs-users\_TEMP\!Scripts" -Credential "forpost\adm_pobyrokhin.k"


#$a = New-PSSession -ComputerName "ws0751" -Credential "forpost\adm_pobyrokhin.k"
$b = New-PSSession -ComputerName "fs01" -Credential $Credentials

Copy-Item "C:\Users\pobyrokhin.k\Desktop\WAC.txt" -Destination "E:\" -ToSession $b