#Get statistic for inative mailbox
$oldDate = get-date 01/01/2013
$outputfile = "C:\deco2013.log"
$alluser = get-mailboxStatistics | where{$_.LastLogonTime -lt $oldDate}
$alluser
$d=New-Object PSObject
$MaVariable=@() 
$d=New-Object PSObject
foreach ($user in $alluser){
$d=New-Object PSObject
$utilisateur = $user.DisplayName
$utilisateurnbelement = (Get-MailboxFolderStatistics $utilisateur | Where {$_.name -like "Top of Information Store"}).ItemsInFolderAndSubfolders
$utilisateursiz =(Get-MailboxFolderStatistics $utilisateur| Where {$_.name -like "Top of Information Store"}).FolderAndSubfolderSize.ToMB()
$utilisateursite = (Get-Mailbox $utilisateur).Office
$d | Add-Member -Name idutilisateur -MemberType NoteProperty -Value $utilisateur
$d | Add-Member -Name nombredelement -MemberType NoteProperty -Value $utilisateurnbelement
$d | Add-Member -Name tailleelementmailbox -MemberType NoteProperty -Value $utilisateursiz
$d | Add-Member -Name bureau -MemberType NoteProperty -Value $utilisateursite
$d >>$outputfile

}

