@echo off
echo %0 PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
more +10 %0 | PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
exit /b
:********************
:* end of CMD-Batch *
:********************


# Line 10 - Start of Powershell Script from here...

# .........................................
# VEEAM Update Downloader with BITS
# for VeeamBackup&Replication_9.5.0.711.iso
# .........................................

# Definitions for Origin: https://dataspace.livingdata.de/#/public/shares-downloads/51B1v2phMU1Ghl96cXyXuq90TJGyWitF
$source = "https://dataspace.livingdata.de/api/v4/public/shares/downloads/51B1v2phMU1Ghl96cXyXuq90TJGyWitF/LzD68Bj3jbUzSS5Xcpm79rqsQFQtR-lfZ0B92NCxNoZJY6LTiz-oFQ83_mPBTXOI0oNQ_SUWquMbmWI1iILfBnWsnxUQIIZmZyk6_4n485lethOdYeDRikG-ITqk0Cjq4EZBK1vUFmNB6nsow0QMTFj15t1uEQladfb9MnI0k4Pptoob8xH0mjTJ0553efde6fe2c2e1"

write-host $source
$destinationfile = "VeeamBackup&Replication_9.5.0.711.iso"
write-host $destinationfile
$destinationpath = "c:\scripts\updates\"
write-host $destinationpath
$destination = $destinationpath + $destinationfile
write-host $destination
# ...........

write-host ""

# Download ...
Import-Module BitsTransfer
write-host "Import-Module BitsTransfer"
Start-BitsTransfer -Source $source -Destination $destination -Description "Downloading..." -DisplayName "by BitsTransfer" -ProxyUsage SystemDefault -Priority Foreground -RetryInterval 120
write-host "Start-BitsTransfer -Source $source -Destination $destination -Description "Downloading..." -DisplayName "by BitsTransfer" -ProxyUsage SystemDefault -Priority Foreground -RetryInterval 120"
# -Asynchronous
#
Get-BitsTransfer | Resume-BitsTransfer
Get-BitsTransfer | Complete-BitsTransfer
Get-BitsTransfer
Write-Output "Download finished"
# ............
