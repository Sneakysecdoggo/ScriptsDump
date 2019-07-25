#Script to monitoring certificat 
#Iniatilisation des variables
$global:Warning = 0
$global:Critical = 0
$global:Unknown = 0
$global:ToSend = ''


SET-LOCATION CERT:\LOCALMACHINE\MY
$listcertif = gci
foreach ($certificat in $listcertif ) {
    $dateexpiration = $certificat.NotAfter
    $datewarning = ((Get-Date).AddDays(+60))
    $test = (get-date $datewarning  ) -gt ( get-date $dateexpiration )


    if ($test -eq $true ) {

        $global:ToSend = 'CRITICAL ' + 'Alerte certificat expire dans moins de soixantes jours '
        $global:Critical = 1

    }


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
    $global:ToSend = 'Certificat valide'
    Write-Host $global:ToSend
    exit 0
}
	