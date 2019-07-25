#copie all member of one group to another
Import-Module ActiveDirectory
$groupapcopier = (Get-ADgroupMember "SourceGroup")
$groupeCible ="TargetGroup"

foreach($user in $groupapcopier){
$username = $user.sAMAccountName
Add-ADGroupMember -identity "$groupeCible"  -Members $username



}