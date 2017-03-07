@echo off
echo.
more +5 %0 | powershell -command -
exit /b
 
Function Get-Test {
  param()
  Begin{
    Write-Host -fore green "Starte PowerShell" 
  }
  Process{
    gps power*,cmd*  
    <# 
      Kommentarblock
    #>
  }
  End{
   Write-Host -fore green  "`nBeende PowerShell"
  }
}
Get-Test
 
exit
