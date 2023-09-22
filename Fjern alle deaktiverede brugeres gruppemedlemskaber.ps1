Import-Module ActiveDirectory
#Script that removes all users in folder Deaktiverede Brugere from all AD groups

Get-ADUser -SearchBase "OU=Deaktiverede brugere,OU=TestHuset medarbejdere,DC=testhuset,DC=local" -Filter * -Properties MemberOf | ForEach-Object 
    {
    $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false
    }

#Script that removes all user identifiable data and renames object in folder Deaktiverede Brugere to user initials. 
Get-ADUser -SearchBase "OU=Deaktiverede brugere,OU=TestHuset medarbejdere,DC=testhuset,DC=local" -Filter * | % {
    Set-ADUser -identity $_.ObjectGUID -clear GivenName, sn, Initials, DisplayName, telephoneNumber, mail, description, title
    Rename-ADObject -identity $_.ObjectGUID -NewName $_.sAMAccountName
    }