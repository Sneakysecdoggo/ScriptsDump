#Export Member of specific Distribution Group
$DGnName = Read-Host "Please entry the Distribution Group name."
$outputfile = "c:\$DGnName.csv"
Get-DistributionGroupMember "$DGnName" | Select Name, PrimarySMTPAddress | Export-CSV $outputfile -Encoding UTF8 -NoTypeInformation