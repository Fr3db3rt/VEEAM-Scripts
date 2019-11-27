PowerShell -ExecutionPolicy Bypass -Command "& {(get-service | tee-object -filepath .\services.txt)}"
