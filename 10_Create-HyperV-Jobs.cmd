:: 10_Create-HyperV-Jobs.cmd

:: https://gist.github.com/smasterson/9136468

:: Create a backup job:
$hvserver = Find-VBRHvEntity -Name "$env:computername"
$repository = Get-VBRBackupRepository -Name Wochenrepository
Add-VBRHvBackupJob -Name "1 - Wochenrepository" -Entity $crm -BackupRepository $repository

:: Add another VM to the job:
$backupjob = Get-VBRJob -Name "1 - Wochenrepository"
Find-VBRHvEntity -Name "$env:computername" | Add-VBRHvJobObject -Job $backupjob

:: Configure job schedule and enable it
Get-VBRJob -Name "1 - Wochenrepository" | Set-VBRJobSchedule -Daily -At "19:00" -DailyKind Weekdays | Enable-VBRJobSchedule

:: Set synthetic full and active full schedule
Get-VBRJob -Name "1 - Wochenrepository" | Set-VBRJobAdvancedBackupOptions -Algorithm ReverseIncremental -EnableFullBackup:$true -TransformFullToSyntethic -FullBackupScheduleKind Monthly -DayNumberInMonth First -FullBackupDays Saturday
