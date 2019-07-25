#Check deleted account between to date
Import-Module ActiveDirectory
[datetime]$StartTime = "6/10/2016"
[datetime]$EndTime = "6/27/2016"
Get-ADObject -Filter {(isdeleted -eq $true) -and (name -ne "Deleted Objects")} -includeDeletedObjects -property whenChanged | Where-Object {$_.whenChanged -ge $StartTime -and $_.whenChanged -le $EndTime} | ft DistinguishedName,Name,WhereDeleted,WhenChanged