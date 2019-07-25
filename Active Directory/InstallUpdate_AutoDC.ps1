#Install Auto Update for dc , check if all definy dc are UP and Ready
#Liste of dc 
$dcs = @("9.9.9.9",".8.8.8.8",) 


$UpdateSession = New-Object -Com Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
 
Write-Host("Searching for applicable updates...") -Fore Green
 
$SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Software'")
 
Write-Host("")
Write-Host("List of applicable items on the machine:") -Fore Green
For ($X = 0; $X -lt $SearchResult.Updates.Count; $X++){
    $Update = $SearchResult.Updates.Item($X)
    Write-Host( ($X + 1).ToString() + "&gt; " + $Update.Title)
}
 
If ($SearchResult.Updates.Count -eq 0) {
    Write-Host("There are no applicable updates.")
    Exit
}
 
#Write-Host("")
#Write-Host("Creating collection of updates to download:") -Fore Green
 
$UpdatesToDownload = New-Object -Com Microsoft.Update.UpdateColl
 
For ($X = 0; $X -lt $SearchResult.Updates.Count; $X++){
    $Update = $SearchResult.Updates.Item($X)
    #Write-Host( ($X + 1).ToString() + "&gt; Adding: " + $Update.Title)
    $Null = $UpdatesToDownload.Add($Update)
}
 
Write-Host("")
Write-Host("Downloading Updates...")  -Fore Green
 
$Downloader = $UpdateSession.CreateUpdateDownloader()
$Downloader.Updates = $UpdatesToDownload
$Null = $Downloader.Download()
 
#Write-Host("")
#Write-Host("List of Downloaded Updates...") -Fore Green
 
$UpdatesToInstall = New-Object -Com Microsoft.Update.UpdateColl

For ($X = 0; $X -lt $SearchResult.Updates.Count; $X++){
    $Update = $SearchResult.Updates.Item($X)
    If ($Update.IsDownloaded) {
        #Write-Host( ($X + 1).ToString() + $Update.Title)
        $Null = $UpdatesToInstall.Add($Update)        
    }
}
 

Write-Host $dc -ForegroundColor Green

$ping = new-object System.Net.NetworkInformation.Ping
#balise de bon fonctionnement 
$continue=$true
foreach ( $dc in $dcs){

$replyexch = $ping.send("$dc")

if( $replyexch.status -eq "Success"){ 
Write-Host("$dc   est disponible") -Fore Green
$test =Test-Path "\\$dc\sysvol"
if ($test -eq $true){
Write-Host ("le sysvol de $dc est disponible") -Fore Green
$checkservice = get-service NTDS -ComputerName $dc 
if ($checkservice.status -eq "Running"){

Write-Host ("le service Active Directory  de $dc est disponible") -Fore Green


}else {

Write-Host("le service Active Directory de $dc est indisponible") -Fore Red
$continue = $false 



}
}else{

Write-Host("le sysvol de $dc est indisponible") -Fore Red
$continue = $false 

}


}else{
Write-Host("$dc  est indisponible") -Fore Red
$continue = $false 
}

}

 
if( $continue -eq $true ){
 

    Write-Host("")
    Write-Host("Installing Updates...") -Fore Green
 
    $Installer = $UpdateSession.CreateUpdateInstaller()
    $Installer.Updates = $UpdatesToInstall
 
    $InstallationResult = $Installer.Install()
 
    Write-Host("")
    Write-Host("List of Updates Installed with Results:") -Fore Green
 
    For ($X = 0; $X -lt $UpdatesToInstall.Count; $X++){
        Write-Host($UpdatesToInstall.Item($X).Title + ": " + $InstallationResult.GetUpdateResult($X).ResultCode)
    }
 
    Write-Host("")
    Write-Host("Installation Result: " + $InstallationResult.ResultCode)
    Write-Host("    Reboot Required: " + $InstallationResult.RebootRequired)
  Restart-Computer -Force
			Read-host "Test1"
    If ($InstallationResult.RebootRequire -eq $True){
       
           
            Write-Host("")
            Write-Host("Rebooting...") -Fore Green
			start-sleep 30
            Restart-Computer -Force
			
        }
    }
