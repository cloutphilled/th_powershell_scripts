Import-Module activedirectory

#Script til at finde alle tomme grupper i AD
Get-ADGroup -Filter * -Properties Members | where {-not $_.members} | select Name | Export-Csv C:\emptygroups.csv –NoTypeInformation

# Script til at finde alle ikke-tomme grupper i AD
Get-ADGroup -Filter * -Properties Members | where { $_.members} | select Name | Export-Csv C:\groups.csv -NoTypeInformation