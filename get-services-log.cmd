PowerShell -ExecutionPolicy Bypass -Command "& {(get-service | tee-object -filepath C:\fastviewer\services.txt)}"
