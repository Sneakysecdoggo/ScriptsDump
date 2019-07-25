#List all account with SPN Configured
Import-Module ActiveDirectory 
Get-ADUser -Filter * -Properties servicePrincipalName | where {$_.servicePrincipalName -ne $NULL} | Select-Object Name,servicePrincipalName