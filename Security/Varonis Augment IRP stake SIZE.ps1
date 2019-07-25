fltmc
New-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters  -Name IRPStackSize -PropertyType  Dword -Value 30