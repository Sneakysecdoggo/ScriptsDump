#Script to start Hardening an disable some useless things 
#Use at your own risk
#Remove default package
Get-AppXPackage -Name *bing* | Remove-AppXPackage                                                                                                                                                                                                                        
Get-AppXPackage -Name *xbox* | Remove-AppXPackage                                                                                                                                                                                                              
get-appxpackage -Name Microsoft.XboxGameCallableUI -allusers | remove-appxpackage                                                                                                                                                                                        
Get-AppxPackage *xboxapp* | Remove-AppxPackage                                                                                                                                                                                                                           
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage                                                                                                                                                                                                                   
Get-AppxPackage Microsoft.XboxApp -Allusers | Remove-AppxPackage                                                                                                                                                                                                         
Get-AppxPackage -name Microsoft.MicrosoftSolitaireCollection -Allusers | Remove-AppxPackage                                                                                                                                                                              
Get-AppxPackage *alarms* -Allusers | Remove-AppxPackage                                                                                                                                                                                                                  
Get-AppxPackage *camera* -Allusers | Remove-AppxPackage                                                                                                                                                                                                                  
Get-AppxPackage *phone* -Allusers | Remove-AppxPackage                                                                                                                                                                                                                   
Get-AppxPackage *maps* -Allusers | Remove-AppxPackage                                                                                                                                                                                                                    
Get-AppxPackage -Name Microsoft.People -Allusers | Remove-AppxPackage   
Get-AppxPackage -Name Windows.MiracastView -Allusers | Remove-AppxPackage 
Get-AppxPackage -Name Microsoft.Advertising.Xaml -Allusers | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.3DBuilder -Allusers | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.GetStarted -Allusers | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.Appconnector -Allusers | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.ConnectivityStore -Allusers | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.StorePurchaseApp -Allusers | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.Oneconnect -Allusers | Remove-AppxPackage
Get-AppxPackage -Name Microsoft.WindowsFeedbackHub -Allusers | Remove-AppxPackage
Get-AppxPackage -Name microsoft.windowscommunicationsapps -Allusers | Remove-AppxPackage
#Disable service
#Xbox live authentification
Set-Service XblAuthManager -StartupType disable
#G�re les paiements et les �l�ments s�curis�s bas�s sur la communication en champ proche (NFC).
Set-Service SEMgrSvc -StartupType disable
#D�sactive trap snmp
Set-Service SNMPTRAP -StartupType disable
#D�sactivation du service Jeu sauvegard� sur Xbox Live XblGameSave
Set-Service XblGameSave -StartupType disable
#D�sactivation service capteur inutile si non convertible 
Set-Service SensorService -StartupType disable
#D�sactivation de la localisation 
Set-Service lfsvc -StartupType disable
#D�sactivation Service de gestion radio et de mode Avion
Set-Service RmSvc -StartupType disable
#D�sactivation Service de mise en r�seau Xbox Live
Set-Service XboxNetApiSvc -StartupType disable
#Service du clavier tactile et du volet d��criture manuscrite
Set-Service TabletInputService -StartupType disable
#SErvice Service Moniteur infrarouge
Set-Service irmon -StartupType disable
#Service t�l�phonique
Set-Service PhoneSvc -StartupType disable
#Service Service Windows Insider
Set-Service wisvc -StartupType disable
#Service telimetrie 
Set-Service dmwappushservice -StartupType disable
#Manages profiles and accounts on a SharedPC configured 
Set-Service shpamsvc -StartupType disable
#Xbox Accessory Management Service
Set-Service XboxGipSvc -StartupType disable
#Xbox Game Monitoring
Set-Service xbgm -StartupType disable 
#Exp�riences des utilisateurs connect�s et t�l�m�trie
Set-Service DiagTrack -StartupType disable
#D�sactivation Active la perception spatiale, les entr�es spatiales et le rendu holographique.
Set-Service spectrum -StartupType disable
#Active les fonctionnalit�s de stylet et d�entr�e manuscrite du clavier tactile et du volet d��criture 
Set-Service TabletInputService -StartupType disable
#D�sactivation Service Partage r�seau du Lecteur Windows Media
Set-Service WMPNetworkSvc -StartupType disable
#Service Point d'acc�s sans fil mobile Windows c'est pas un t�l�phone 
Set-Service icssvc -StartupType disable

#Service Routeur SMS Microsoft Windows pas un t�lephone on d�sactive 
Set-Service SmsRouter  -StartupType disable

#T�l�phonie T�l�phonie
Set-Service TapiSrv  -StartupType disable
#Service de d�mo du magasin
Set-Service RetailDemo  -StartupType disable
#D�sactivation des publication de ressouces Publication des ressources de d�couverte de fonctions c'est pas un serveur donc pas de share sur un poste client
Set-Service FDResPub  -StartupType disable
#Localisateur d�appels de proc�dure distante (RPC) 
Set-Service RpcLocator  -StartupType disable
#D�sactivation upnphost H�te de p�riph�rique UPnP
Set-Service upnphost  -StartupType disable

#D�sactivation Gestionnaire des cartes t�l�charg�es
Set-Service MapsBroker  -StartupType disable
#D�couverte D�couverte SSDP
Set-Service SSDPSRV  -StartupType disable
# Assistant Connexion avec un compte Microsoft
Set-Service wlidsvc -StartupType disable
#Pc pas en workgroup donc on desactive Fournisseur du Groupement r�sidentiel
Set-Service HomeGroupProvider -StartupType disable
#Authentification naturelle
Set-Service NaturalAuthentication -StartupType disable

#Pas de biometrie sur les postes pro Service de biom�trie Windows
Set-Service WbioSrvc -StartupType disable
#Service mail libre bluetooth Service mains libres Bluetooth sert � rien sauf si casque mais bon rare
Set-Service BthHFSrv -StartupType disable
#Service de prise en charge Bluetooth pas de bluetoot vecteur d'extraction de donn�e
Set-Service bthserv -StartupType disable



#D�sactivation des taches planifi�e
#D�sactivation taches planifi�e Xboxlive 
Unregister-ScheduledTask XblGameSaveTask
#Suppresion telemetrie Office 
Unregister-ScheduledTask OfficeTelemetryAgentFallBack2016
Unregister-ScheduledTask OfficeTelemetryAgentLogOn2016
#Suppresion application programme experience 
Unregister-ScheduledTask "Microsoft Compatibility Appraiser"
Unregister-ScheduledTask ProgramDataUpdater
#Customer experience improvment 
Unregister-ScheduledTask Consolidator
Unregister-ScheduledTask KernelCeipTask
Unregister-ScheduledTask UsbCeip
#D�sactivation des taches de localisation 
Unregister-ScheduledTask Notifications
Unregister-ScheduledTask WindowsActionDialog

#D�sactivation t�lemetrie 
New-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection\ -Name AllowTelemetry -PropertyType Dword -Value 0
#D�sactivation features optionel 
#Reader XPS
Disable-WindowsOptionalFeature -online -FeatureName Xps-Foundation-Xps-Viewer
#Impression internet 
Disable-WindowsOptionalFeature -online -FeatureName Printing-Foundation-InternetPrinting-Client
#D�sactivation du smb1 
Disable-WindowsOptionalFeature -online -FeatureName SMB1Protocol
#D�sactivation Windows media player , preferer un vlc qui a moins d'acces de base 
Disable-WindowsOptionalFeature -online -FeatureName WindowsMediaPlayer
#Desactivation recepetion fax 
Disable-WindowsOptionalFeature -online -FeatureName FaxServicesClientPackage
#Desactivation gestion des media natif
Disable-WindowsOptionalFeature -online -FeatureName MediaPlayback
#Desactivation impression interneet
Disable-WindowsOptionalFeature -online -FeatureName Printing-Foundation-Features
#D�sactivation de l'ipv6 risque de tunneling donc pypass des routeur possible
New-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\tcpip6\Parameters\ -Name DisabledComponents -PropertyType Dword -Value 255
#Desactivation IGMP
netsh interface ipv4 set global mldlevel=none
#D�sactivation Upnp
New-ItemProperty HKLM:\SOFTWARE\Microsoft\DirectPlayNATHelp\DPNHUPnP -Name UPnPmode -PropertyType Dword -Value 2

