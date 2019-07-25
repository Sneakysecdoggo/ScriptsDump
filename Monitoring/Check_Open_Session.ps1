#monitor if specific user is connect to a computer
$sessiontomonitor = "DOMAIN\Miaou"
#Iniatilisation des variables
$global:Warning = 0
$global:Critical = 0
$global:Unknown = 0
$global:ToSend = ""
$nomordinateur = $env:computername


$Var = GWMI -Comp $nomordinateur -CL Win32_ComputerSystem 

$user = $Var.UserName
if ( $user -ne "$sessiontomonitor") {
    $global:Critical = 1
    $global:ToSend = 'CRITICAL - ' + 'Session $sessiontomonitor non ouverte sur le poste $nomordinateur'
 
 
}
 
if ($global:Critical -ne 0) {
    Write-Host $global:ToSend
    exit 2
}
elseif ($global:Warning -ne 0) {
    Write-Host $global:ToSend
    exit 1
}
elseif ($global:Unknown -ne 0) {
    Write-Host $global:ToSend
    exit 3
}
else {
    $global:ToSend = "Session $sessiontomonitor ouverte sur le poste $nomordinateur"
    Write-Host $global:ToSend
    exit 0
}
	