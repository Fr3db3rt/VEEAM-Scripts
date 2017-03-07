@echo off
echo start "VEEAM_PreJob" cmd /c PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
more +5 %0 | PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
exit /b
 
Function Get-Test {
  param()
  
  Begin{
    Clear-Host
    Write-Host -fore green "Starte PowerShell..." 
    <#--------------------------------------------------------------------
    Add Veeam snap-in if required
      #>
    If ((Get-PSSnapin -Name VeeamPSSnapin -ErrorAction SilentlyContinue) -eq $null) {
      Add-PSSnapin VeeamPSSnapin
      }
    <#--------------------------------------------------------------------
    Check presence if VEEAM PowerShell plugin is installed or not
      #>
    If ((Get-PSSnapin -Name VeeamPSSnapin -ErrorAction SilentlyContinue) -eq $null) {
      [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
      $nl = [System.Environment]::NewLine + [System.Environment]::NewLine
      $msg = ""
      $msg = $msg + "*** Achtung: ***" + $nl
      $msg = $msg + "Das VEEAM PowerShell Snapin ist nicht vorhanden!" + $nl
      $msg = $msg + "Zuerst muß die VEEAM PowerShell installiert werden." + $nl
      $msg = $msg + "Das Script wird nun beendet." + $nl
      [System.Windows.Forms.MessageBox]::Show($msg,"?error. " + $myInvocation.MyCommand.Name,"OK","Error")
      exit
      }
    <#--------------------------------------------------------------------
    Check Veeam Version (If VEEAM 9)
      #>
      If ((Get-PSSnapin VeeamPSSnapin).Version.Major -ne 9) {
      exit
      }
    }

  Process{
    #--------------------------------------------------------------------
    # Main Procedures
    Write-Host "********************************************************************************"
    write-host "Starting Veeam Script" $myInvocation.MyCommand.Name
    Write-Host "********************************************************************************`n"
    #--------------------------------------------------------------------

    write-host "`n`n`n`n`n`n`n`n`n`nTape Sever identifizieren ..."
    Get-VBRLocalhost | Get-VBRTapeServer
    
    write-host "`n`n`n`n`n`n`n`n`n`nTape Library einlesen ..."
    Get-VBRTapeServer | Get-VBRTapeLibrary

    write-host "`n`n`n`n`n`n`n`n`n`n...inventarisieren und auf Abschluss warten ..."
    Get-VBRTapeLibrary | Start-VBRTapeInventory -wait

    write-host "`n`n`n`n`n`n`n`n`n`nAktuelles Tape Drive identifizieren ..."
    $drive = Get-VBRTapeDrive

    write-host "`n`n`n`n`n`n`n`n`n`n...und Katalog des aktuellen Bandes einlesen und auf Abschluss warten."
    Get-VBRTapeMedium -Drive $drive | Start-VBRTapeCatalog -Wait

    write-host "`n`n`n`n`n`n`n`n`n`nAktuelles Medium in den Pool 'FREE' schieben ..."
    Get-VBRTapeMedium -Drive $drive | Move-VBRTapeMedium -MediaPool "Free" -Confirm:$false

    write-host "`n`n`n`n`n`n`n`n`n`n... und loeschen und auf Abschluss warten ..."
    Get-VBRTapeMedium -Drive $drive | Erase-VBRTapeMedium -wait -Confirm:$false
    }

  End{
    Write-Host -fore green  "`nBeende PowerShell"
    }
  }

Get-Test
 
exit
