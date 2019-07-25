#Disable administrative share
New-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters  -Name AutoShareServer -PropertyType  Dword -Value 0