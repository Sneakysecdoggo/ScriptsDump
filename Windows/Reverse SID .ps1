#Reverse SID
$objSID = New-Object System.Security.Principal.SecurityIdentifier ("*Sidtoreverse")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value