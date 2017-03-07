@echo off
echo.
more +5 %0 | PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
exit /b
 
Function Get-Test {
  param()
  Begin{
    <# 
    Kommentarblock
    #>
    Clear-Host
    Write-Host -fore green "Starte PowerShell" 
    #--------------------------------------------------------------------
    # Add Veeam snap-in if required
    If ((Get-PSSnapin -Name VeeamPSSnapin -ErrorAction SilentlyContinue) -eq $null) {
      Add-PSSnapin VeeamPSSnapin
      }
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
    #--------------------------------------------------------------------
    }
  Process{
    gps power*,cmd*
    #--------------------------------------------------------------------
    # Main Procedures
    Write-Host "********************************************************************************"
    write-host "Starting Veeam Script" $myInvocation.MyCommand.Name
    Write-Host "********************************************************************************`n"
    #--------------------------------------------------------------------

    #--------------------------------------------------------------------
    # Check Veeam Version (If VEEAM 9)
    If ((Get-PSSnapin VeeamPSSnapin).Version.Major -eq 9) {

      write-host "Tape Library einlesen ..."
      $library = Get-VBRTapeLibrary
      write-host "VBRTapeLibrary = $library"

      write-host "Drive identifizieren ..."
      $drive = Get-VBRTapeDrive
      write-host "VBRTapeDrive = $drive"

      write-host "Inventarisierung starten und auf Abschluss warten ..."
      Start-VBRTapeInventory -Library $library -wait

      write-host "aktuelles Tape identifizieren ..."
      $tape = Get-VBRTapeMedium -Drive $drive
      write-host "VBRTapeMedium = $tape"

      write-host "Katalog des aktuellen Bandes einlesen und auf Abschluss warten ..."
      Start-VBRTapeCatalog -Medium $tape -wait
      write-host "Fertig"

      write-host "aktuelles Medium in den Pool 'FREE' schieben ..."
      Move-VBRTapeMedium -Medium $tape -MediaPool "Free" -Confirm:$false
      write-host "Fertig"

      write-host "aktuelles Medium loeschen und auf Abschluss warten ..."
      Erase-VBRTapeMedium -Medium $tape -wait -Confirm:$false
      write-host "Fertig"
      write-host "Script beendet"
      }
  }
  End{
   Write-Host -fore green  "`nBeende PowerShell"
  }
}
Get-Test
 
exit
