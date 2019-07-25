 
# Upload multiple Photos to Active Directory with automatic Logging



#-------------------------------------VARIABLE TO CHECK--------------------------------------------

#If you want to overwrite existing pictures, set this variable to "true"
$overwrite = "true" 
#only path to folder
#Picture should be name with SAMUsername exemple toto.jpg for the user with SAM toto
$pathToPictures = "\\servershare\Photos\TODO" 
$uploadedFolder = "\\servershare\Photos\EXIST"

$errorFolder = "\\servershare\Photos\ERROR"
# in byte
$maxPictureSize = "20000" 
#with name of the file
$pathToLog = "C:\Script\PicUpload.log" 

$maxLogSize = "10000000" #in byte
#---------------------------------------------------------------------------------------------

$log = Get-Item $pathToLog

#Check Log file size
if ($log.length -gt $maxLogSize) {


    Clear-Content $pathToLog
    Write-Host "Log file purged" -ForegroundColor Green
}



#DateStamp
$(Get-Date -format g) | add-content $pathToLog

#Using hashtable for logs.
$errorlist = @{ } #Log file list

$queryPics = Get-ChildItem $pathToPictures -ErrorAction Stop
 
foreach ($pic in $queryPics) {
    $username = $pic.basename
    $dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    $root = $dom.GetDirectoryEntry()
    $search = [System.DirectoryServices.DirectorySearcher]$root
    $search.Filter = "(&(objectclass=user)(objectcategory=person)(samAccountName=$username))"
    $result = $search.FindOne()

    #Check if user exists
    if ($result -ne $null) {
        $user = $result.GetDirectoryEntry()
        $thumbnailPhoto = $user.thumbnailPhoto
        #Check if there is already a Picture
        if ($thumbnailPhoto.Value -eq $null) {
            #Check if picture size is less than maximum
            if ($pic.length -le $maxPictureSize) {
                #Add picture to user property
                [byte[]]$jpg = Get-Content $pic.FullName -encoding byte
                $user.put("thumbnailPhoto", $jpg )
                $user.setinfo()
                Move-Item $pic.FullName -Destination $uploadedFolder
                Write-Host $user.displayname "Uploaded picture successfully and moved to '$uploadedFolder' folder!" -ForegroundColor Green
                $errorlist.Add($username, "Sucess")
            }
            else {
                Write-Host $pic.Name "is too big in size! Max picture size is 10KB for each user. Picture was moved to '$errorFolder' folder!" -ForegroundColor Red
                Move-Item $pic.FullName -Destination $errorFolder
                $errorlist.Add($username, "Size too big")
            }
        }
        else {
            if ($overwrite -eq $true) {
                #Add picture to user property
                [byte[]]$jpg = Get-Content $pic.FullName -encoding byte
                $user.put("thumbnailPhoto", $jpg )
                $user.setinfo()
                Move-Item $pic.FullName -Destination $uploadedFolder
                Write-Host $user.displayname "Picture replaced and moved to '$uploadedFolder' folder!" -ForegroundColor Green
                $errorlist.Add($username, "Replaced")
            }
            else {
                Write-Host $user.displayname "has already stored a Picture in AD. Picture was moved to '$errorFolder' folder!" -ForegroundColor Yellow
                Move-Item $pic.FullName -Destination $errorFolder
                $errorlist.Add($username, "Has already a picture")
            }
        }
    }
    else {
        Write-Host $username " Does not exist! Picture was moved to '$errorFolder' folder!" -ForegroundColor Red
        Move-Item $pic.FullName -Destination $errorFolder
        $errorlist.Add($username, "User not found")
    }
}

#Create thumbnails and update SharePoint Profile Photo Store
#Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
#Update-SPProfilePhotoStore -CreateThumbnailsForImportedPhotos $true -MySiteHostLocation $mySite

#Notification
$maxLogSize = $maxLogSize / 1000000
Write-Host "#Note: Log files can be found in $pathtopictures " 
Write-Host "If thumbmail don't display in outlook, you should remove all files in  C:\Users\%USERNAME%\AppData\Local\Microsoft\Outlook\Offline Address Books" -ForegroundColor Green
#Add Error list to log file
$errorlist | out-string | add-content $pathToLog
 