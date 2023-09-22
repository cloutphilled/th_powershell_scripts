# Henter data fra CSV fil (skal genereres, se Oprettelse af CSV fil fra XLSX.ps1). 
$udstyr=Import-Csv -Path V:\Intern it\Udstyr\Udstyrslog.csv -Delimiter ";" -Encoding UTF8 
#Henter liste over alle PCer i domænet. 
Get-ADComputer -SearchBase "OU=Testhuset PC,DC=testhuset,DC=local" -Filter * | ForEach-Object{
    $groupName = ([string]::Format(“Local-Admin_{0}”,$_.name))
    $computerName = $_.name
    $UserInitials = ($udstyr | Where-Object {$_.PCNavn -like $computerName}).Initialer
    Write-Output ([string]::Format(“Updating {0} with {1}”,$computerName, $UserInitials)) | Out-File -FilePath c:\PSLOG\localadminupdate.txt -Append 
    Set-ADComputer -Identity $computerName -Description $UserInitials
    } 