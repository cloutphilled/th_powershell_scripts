$computerName = Read-Host -Prompt "Navn på PC"
$computer = Get-ADComputer -Identity $computerName | ForEach-Object{
    $groupName = ([string]::Format(“Local-Admin_{0}”,$_.name))
    $computerName = $_.name
    Write-Host "Creating " $groupName
    New-ADGroup -Path "OU=Local Admins,OU=Domain Local Groups,DC=testhuset,DC=local" -GroupScope 0 -Name $groupName -GroupCategory Security 
    Add-ADGroupMember -Identity Local_Admin_Authorized -Members $_
    } 
