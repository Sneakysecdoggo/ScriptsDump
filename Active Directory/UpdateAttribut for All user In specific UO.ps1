
#Update a specific attribut for all user in a specific UO with ADSI OLD Style
$dcname = "DomainCOntrollerNameformodification"
$attributtomodify ="company"
$attributtomodifyvalue ="MyDerpAny"
$objDomaine=[ADSI]"LDAP://OU=MIAOU,OU=USER,DC=MIAOUR,DC=LOCAL,DC=DDERP"
$objRecherche = new-object system.DirectoryServices.DirectorySearcher($objDomaine)
$objRecherche.Filter="(&(objectCategory=user)(objectClass=user))"
$objRecherche.PropertiesToload.add("Path")
$objResult = $objRecherche.FindAll()
foreach( $person in $objresult ){
$personne = [ADSI]"$person"
$name = $personne.distinguishedName

$objpers =[ADSI]"LDAP://$dcname/$name"
$objpers.Put($attributtomodify,$attributtomodifyvalue)
$objpers.Setinfo()
}
