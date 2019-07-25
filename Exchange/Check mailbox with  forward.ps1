#List all mailbox with forward configured
$pathtoexport = "C:\MailForward.csv"
Get-Mailbox -ResultSize unlimited | where {$_.forwardingSMTPAddress -ne $NULL} | select-object UserPrincipalName,ForwardingSmtpAddress,DeliverToMailboxAndForward | export-csv $pathtoexport -Encoding UTF8