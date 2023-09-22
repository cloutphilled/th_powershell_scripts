Import-Module ActiveDirectory
# Henter alle grupper i Local Admins folderen
foreach ($Group in (Get-ADGroup -SearchBase "OU=Local Admins,OU=Domain Local Groups,DC=testhuset,DC=local" -Filter *))
{
    $description = ""
# Henter medlemmer af gruppen
    Get-ADGroupMember -Identity $Group | % { 
# Skriver medlemmet til $description
        if($description -eq "")
        {
            $description += $_.sAMAccountName    
        }
# Hvis der er flere medlemmer appenderes medlem2 efter medlem1, adskilt med komma
        else
        {
            $description += ", " + $_.sAMAccountName
        }
    }
    Write-Host $Group.name.Substring(12) $description
# Sætter brugere som beskrivelsen på computerobjektet
    Set-ADComputer -Identity $Group.name.Substring(12) -Description $description
    $description = ""
}
