: Start-Tape-Job.cmd
@start "Start-Tape-Job" cmd /c PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {(Add-PSSnapin VeeamPSSnapin); (Get-VBRTapeJob | Start-VBRJob -FullBackup)}"
