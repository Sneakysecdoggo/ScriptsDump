#Get Information about Disk from a partition
$Disk = Get-WmiObject -Class Win32_logicaldisk -Filter "DeviceID = 'C:'"
$DiskPartition = $Disk.GetRelated('Win32_DiskPartition')
$DiskDrive = $DiskPartition.getrelated('Win32_DiskDrive')
$DiskDrive | Select-Object -Property Caption,Model,SerialNumber,FirmwareRevision,Size,Status
