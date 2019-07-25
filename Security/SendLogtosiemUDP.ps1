#PArametrage Connexion SIEM
$IP = "127.0.0.1"
$Facility = "local7"
$Severity = "notice"
switch -regex ($Facility)
 {
 'kern' {$Facility = 0 * 8 ; break } 
 'user' {$Facility = 1 * 8 ; break }
 'mail' {$Facility = 2 * 8 ; break }
 'system' {$Facility = 3 * 8 ; break }
 'auth' {$Facility = 4 * 8 ; break }
 'syslog' {$Facility = 5 * 8 ; break }
 'lpr' {$Facility = 6 * 8 ; break }
 'news' {$Facility = 7 * 8 ; break }
 'uucp' {$Facility = 8 * 8 ; break }
 'cron' {$Facility = 9 * 8 ; break }
 'authpriv' {$Facility = 10 * 8 ; break }
 'ftp' {$Facility = 11 * 8 ; break }
 'ntp' {$Facility = 12 * 8 ; break }
 'logaudit' {$Facility = 13 * 8 ; break }
 'logalert' {$Facility = 14 * 8 ; break }
 'clock' {$Facility = 15 * 8 ; break }
 'local0' {$Facility = 16 * 8 ; break }
 'local1' {$Facility = 17 * 8 ; break }
 'local2' {$Facility = 18 * 8 ; break } 
 'local3' {$Facility = 19 * 8 ; break }
 'local4' {$Facility = 20 * 8 ; break }
 'local5' {$Facility = 21 * 8 ; break }
 'local6' {$Facility = 22 * 8 ; break }
 'local7' {$Facility = 23 * 8 ; break }
 default {$Facility = 23 * 8 } #Default is local7
 }
 switch -regex ($Severity)
 { 
 '^em' {$Severity = 0 ; break } #Emergency 
 '^a' {$Severity = 1 ; break } #Alert
 '^c' {$Severity = 2 ; break } #Critical
 '^er' {$Severity = 3 ; break } #Error
 '^w' {$Severity = 4 ; break } #Warning
 '^n' {$Severity = 5 ; break } #Notice
 '^i' {$Severity = 6 ; break } #Informational
 '^d' {$Severity = 7 ; break } #Debug
 default {$Severity = 5 } #Default is Notice
 }

$pri = "<" + ($Facility + $Severity) + ">"

if ($(get-date).day -lt 10) { $timestamp = $(get-date).tostring("MMM d HH:mm:ss") } else { $timestamp = $(get-date).tostring("MMM dd HH:mm:ss") }
$SourceHostname = $env:computername
$Tag = "PowerShell" 
$Port = 514
#Parametrage Local
$logfile = "C:\Program Files (x86)\Sophos\Reporting Interface\Log Files\DefaultThreats.log"
$readlog = get-content $logfile
foreach ($ligne in $readlog){

$ligne
$msg = $pri + $header + $tag + ": " + $ligne
$bytearray = $([System.Text.Encoding]::ASCII).getbytes($msg)
 $TcpClient = New-Object System.Net.Sockets.UDpClient 
 $TcpClient.Connect($IP,$Port) 
 $TcpClient.Send($ByteArray, $ByteArray.length) | out-null


}