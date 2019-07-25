#give access right to another mailbot & send as 
$domain = "domain"
$mailboxcible = Read-Host "Entrez la maibox sur laquelle les droits doivent etre donne"
DO{
$personne = Read-Host "Entrez l'identifiant de la personne a qui les droits doivent etre donne"
Add-MailboxPermission $mailboxcible -User "$domain\$personne" -AccessRights FullAccess
get-user -identity $mailboxcible |Add-ADPermission -User "$domain\$personne" -ExtendedRights Send-As

Start-ManagedFolderAssistant $personne 
$reponse= Read-Host "voulez vous ajouter les droits à un autre utilisateur O/N ?"
}While ( $reponse -ne "N")
Set-MailboxSentItemsConfiguration $mailboxcible -SendAsItemsCopiedTo SenderAndFrom
