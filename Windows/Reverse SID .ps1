#Reverse SID
$objSID = New-Object System.Security.Principal.SecurityIdentifier ("*SIDtoREVERSE")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value