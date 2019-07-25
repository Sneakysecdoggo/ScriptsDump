#List all mailbox with a larger size than define
#Site in MB
$sizecriteria = 1000
$outputfile = "sup1go.csv"
Get-MailboxStatistics | WHere { $_.TotalItemSize.Value.ToMB() -gt "1000"}   | Sort-Object TotalItemSize -Descending | ft DisplayName,@{label="TotalItemSize(MB)";expression={$_.TotalItemSize.Value.ToMB()}},ItemCount |Export-Csv $outputfile -NoTypeInformation