# Script til at oprette nye brugere i AD.


# Existing-User tjekker indtastede initialer mod allerede eksisterende initialer i AD

Function Existing-User
{
    $Initials = ""
    Do 
    {
        $Initials = Read-Host -Prompt "Initialer til ny bruger"
        $User = Get-ADUser -Filter {sAMAccountName -eq $Initials}
        If ($User -ne $Null) 
        {
            write-host "Brugernavnet eksisterer allerede, vælg et nyt"
        }
    }
    Until ($User -eq $Null)
        write-host "Brugernavnet er ledigt"
        Return $Initials.ToLower()
}
<#

$TemplateArray =  Get-ADUser -SearchBase "OU=User Templates,DC=testhuset,DC=local" -Filter *

function Get-Template
    Write-Host "$TemplateArray.name"
    $Template = Read-Host -Prompt "Vælg skabelonkode"
    
Return $Template


#>

function Get-Address
{
    $AddressReturn = ""
    while ($AddressReturn -notmatch "[A-B]")
    {
        $AddressReturn = Read-Host -Prompt "Kontor: (A)arhus eller (B)allerup"
        Write-Host "Ugyldig adresse. Prøv A eller B"
        
    }
    If ($AddressReturn -match "[B]")
       {
       $AddressReturn = "Ballerup"
       }
    else
    {
        $AddressReturn = "Aarhus"
    }
    Return $AddressReturn
}


# Henter data fra skabeloner i User Templates mappen

$TemplateArray =  Get-ADUser -SearchBase "OU=User Templates,DC=testhuset,DC=local" -Filter * 

function Get-Template
{
    $Result = ""
    for ($i = 1; $i -lt ($TemplateArray.Count+1); $i++)
    {
        Write-Host "$($TemplateArray[$i-1].samaccountname) $i"
        
    }

    $PromptReturn = Read-Host -Prompt "Indtast skabelonkode"
    while ($PromptReturn -notin 1..($TemplateArray.count))
    {
        Write-Host "Invalid value. Try again"
        $PromptReturn = Read-Host -Prompt "Indtast skabelonkode"
    }
    $Result = $TemplateArray[($PromptReturn-1)].samaccountname
    Return $Result
    
}


$Initials = Existing-User
$GivenName = Read-Host -Prompt "Fornavn på ny bruger"
$SurName = Read-Host -Prompt "Efternavn på ny bruger"
$Title = Read-Host -Prompt "Titel på ny bruger"
$Phone = (Read-Host -Prompt "Telefonnummer, format: XXXX XXXX")
$Email = $Initials+"@Testhuset.dk"
$Password = ConvertTo-SecureString "TestHuset2022!" -AsPlainText -Force
$UserPC = Read-Host -Prompt "PC der udleveres til ny bruger, format THXXX" 
$TemplateResult = Get-Template 
$TemplateAddress = Get-Address


# Skriver indtastet information ud. 

Write-Host "
    Du opgav: 
    Navn:`t$($GivenName) $($SurName) 
    Initialer:`t$($Initials)  
    Titel:`t$($Title)
    Tlf:`t$($Phone)
    Mail:`t$($Email) 
    Udl. PC:`t$($UserPC)
    Kopi af:`t$($TemplateResult)
    I mappe:`t$($TemplateAddress)"

New-ADUser -SamAccountName $initials `
            -UserPrincipalName "$($Initials)@testhuset.dk" `
            -name "$($GivenName) $($SurName)" `
            -Office "$($TemplateAddress)" `
            -GivenName $($GivenName) `
            -Surname $($SurName) `
            -Initials $($Initials) `
            -Title $($Title) `
            -OfficePhone "+45 $($Phone)" `
            -EmailAddress $($Email) `
            -AccountPassword $($Password) `
            -ChangePasswordAtLogon $false `
            -DisplayName $($GivenName + " " + $SurName) `
            -PasswordNeverExpires $false `
            -Path "OU=$($TemplateAddress),OU=O365,OU=TestHuset medarbejdere,DC=testhuset,DC=local" `
            -Enabled $true `
            -ErrorAction Stop

Get-ADUser -Identity $TemplateResult `
            -Properties memberof `
            -Verbose `
            | Select-Object -ExpandProperty memberof `
            | Add-ADGroupMember -Members $Initials -PassThru

Add-ADGroupMember -Identity Local-Admin_$UserPC -Members $Initials