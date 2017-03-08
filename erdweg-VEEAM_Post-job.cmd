@echo off
if not exist c:\scripts\logs\NUL md c:\scripts\logs
echo %date% / %time% >> c:\scripts\logs\tape-load.txt
c:\scripts\mt load >> c:\scripts\logs\tape-load.txt
echo %date% / %time% > c:\scripts\logs\last-drivestatus.txt
c:\scripts\mt drivestatus >> c:\scripts\logs\last-drivestatus.txt
echo %date% / %time% >> c:\scripts\logs\mediastatus.txt
c:\scripts\mt mediastatus >> c:\scripts\logs\mediastatus.txt
echo %date% / %time% >> c:\scripts\logs\tape-rewind.txt
c:\scripts\mt rewind >> c:\scripts\logs\tape-rewind.txt
