# Purge Log file
$dossierlog = gci "D:\Exchange\LOGS"|Select fullname
foreach ( $logiis in $dossierlog){
$logiis = $logiis.fullname
$logiis = Convert-Path  $logiis
set-location $logiis
foreach ($File in get-childitem) {
   if ($File.LastWriteTime -lt (Get-Date).AddDays(-120)) {
      Remove-Item $File
   }
}
}