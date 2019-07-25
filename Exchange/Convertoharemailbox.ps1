#Convert a mailbox to sharemailbox
#A sharemailbox is mailbox with a disable account & can only be access with delegated right
Import-Module ActiveDirectory
$mailboxcible = Read-host "Entrez le login du compte à passer en mailboxpartagé "
Set-Mailbox $mailboxcible -Type shared
$description = "Sharemailbox ne pas supprimer "
Set-ADUser $mailboxcible -Description $description