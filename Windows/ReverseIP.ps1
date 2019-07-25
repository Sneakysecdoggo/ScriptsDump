#reverse name from list of IP address
$sourcefile =  "C:\Nagios.csv"
$outputfile = "Output.txt"

function Get-HostToIP($hostname) {     
    $result = [system.Net.Dns]::GetHostByName($hostname)     
    $result.AddressList | ForEach-Object {$_.IPAddressToString } 
} 
 
Get-Content $sourcefile  | ForEach-Object {($_)>> $outputfile ;Get-HostToIP($_) >> $outputfile }