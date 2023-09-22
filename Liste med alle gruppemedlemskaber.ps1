Import-Module ActiveDirectory
$Groups = Get-Content C:\Groups.txt -Encoding UTF8
$output = foreach ($Group in $Groups)
# {
# if(Get-ADGroup "$Group" -Properties Members | where {-not $_.members})
# {
# Write-Output "The '$Group' has no Members."
# Write-Output "n"
# }
# else
{
Write-Output "The members in the '$Group' are:"
Get-ADGroupMember (Get-ADGroup -Filter * | Where-Object {$_.Name -eq $Group}) | select Name
Write-Output "n"
}
#}
$output | Out-File c:\GroupDetails.csv