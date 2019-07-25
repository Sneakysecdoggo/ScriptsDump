#Remove all right to a share for specific user or group 
$listedeshares = Get-SmbShare | Select Name 
$groupetoremove = "DOMAIN\domain admins"

foreach ( $share in $listedeshares) {
    $sharename = $share.name
    Revoke-SmbShareAccess -Name $sharename -AccountName $groupetoremove 

}
