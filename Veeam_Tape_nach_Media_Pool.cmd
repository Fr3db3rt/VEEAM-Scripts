@echo offecho %0 PowerShell -NoProfile -ExecutionPolicy Bypass -Command -more +6 %0 | PowerShell -NoProfile -ExecutionPolicy Bypass -Command -exit /b# Clear-HostWrite-Host -fore green "Starte PowerShell..." #--------------------------------------------------------------------# Add Veeam snap-in if requiredIf ((Get-PSSnapin -Name VeeamPSSnapin -ErrorAction SilentlyContinue) -eq $null) {   Add-PSSnapin VeeamPSSnapin   }#--------------------------------------------------------------------# Check presence if VEEAM PowerShell plugin is installed or notIf ((Get-PSSnapin -Name VeeamPSSnapin -ErrorAction SilentlyContinue) -eq $null) {   [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")   $nl = [System.Environment]::NewLine + [System.Environment]::NewLine   $msg = ""   $msg = $msg + "*** Achtung: ***" + $nl   $msg = $msg + "Das VEEAM PowerShell Snapin ist nicht vorhanden!" + $nl   $msg = $msg + "Zuerst muß die VEEAM PowerShell installiert werden." + $nl   $msg = $msg + "Das Script wird nun beendet." + $nl   [System.Windows.Forms.MessageBox]::Show($msg,"?error. " + $myInvocation.MyCommand.Name,"OK","Error")   exit   }#--------------------------------------------------------------------# Check Veeam Version (If VEEAM 9)If ((Get-PSSnapin VeeamPSSnapin).Version.Major -ne 9) {   exit   }#--------------------------------------------------------------------# Main ProceduresWrite-Host "********************************************************************************"write-host "Starting Veeam Script" $myInvocation.MyCommand.NameWrite-Host "********************************************************************************`n"#--------------------------------------------------------------------write-host "`nTape Sever identifizieren ..."Get-VBRLocalhost | Get-VBRTapeServer    write-host "`nTape Library einlesen ..."Get-VBRTapeServer | Get-VBRTapeLibrarywrite-host "`n...inventarisieren und auf Abschluss warten ..."Get-VBRTapeLibrary | Start-VBRTapeInventory -waitwrite-host "`nAktuelles Tape Drive identifizieren ..."$drive = Get-VBRTapeDrivewrite-host "`n...und Katalog des aktuellen Bandes einlesen und auf Abschluss warten."Get-VBRTapeMedium -Drive $drive | Start-VBRTapeCatalog -Waitwrite-host "`nAktuelles Medium in den Pool 'FREE' schieben ..."Get-VBRTapeMedium -Drive $drive | Move-VBRTapeMedium -MediaPool "Free" -Confirm:$falsewrite-host "`n... und loeschen und auf Abschluss warten ..."Get-VBRTapeMedium -Drive $drive | Erase-VBRTapeMedium -wait -Confirm:$falseexit
