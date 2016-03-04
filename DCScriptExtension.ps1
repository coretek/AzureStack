

Continue = "Continue"

#Set all DNS addresses needed.
write-verbose -Verbose "Set all DNS addresses needed."
$local = "127.0.0.1"
$DC = "172.20.2.4"
$Internet = "8.8.8.8" #Google

route add 172.20.2.0 mask 255.255.255.0 10.0.0.5

#Combine addresses
write-verbose -Verbose "Combining DNS addresses."
$dns = "$DC", "$Internet"

#Set network adapter ranges
write-verbose -Verbose "Setting network adapter ranges."

#Get Network adapters
write-Verbose -Verbose "Now checking available network adapters."
$Net = Get-NetAdapter | select ifIndex | ft -a | Out-File -FilePath C:/Netadapter.txt
$Net =  "C:/Netadapter.txt"

#Setting ranges to work with
$Ranges = (Get-Content $Net) -creplace "ifIndex", "" -creplace "-", "" | foreach {$_.Trim()} | Where { $_ } | Sort #| out-file C:/Netadapter.txt

#Execute DNS change
write-Warning -Verbose "Now executing DNS change to all available network adapters."
foreach ($range in $ranges)    {
Set-DnsClientServerAddress -InterfaceIndex $range -ServerAddresses ($DNS)
}

New-Item C:\log\newlog.txt -ItemType file -Force

Add-WindowsFeature AD-Domain-Services -LogPath C:\log\newlog.txt

Get-WindowsFeature | Where installed >> C:\log\newlog.txt

Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012" -DomainName "new.com" -DomainNetbiosName "new" -ForestMode "Win2012" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString "Ironman1979" -AsPlainText -force)
 
