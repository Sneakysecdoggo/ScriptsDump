#list all inactive computer
Import-Module ActiveDirectory
$outputfile = "C:\NonConnectPc.csv"
$JourInactivite = 90
$Date = (Get-Date).Adddays(-($JourInactivite))
Get-ADComputer -Filter {LastLogonTimeStamp -lt $Date -and enabled -eq $true} -Properties LastLogonTimeStamp |SELECT name,LastLogonTimeStamp  |Export-Csv $outputfile -NoTypeInformation
