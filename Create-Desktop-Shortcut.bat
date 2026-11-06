@echo off
TITLE Create Desktop Shortcut for Windows Optimizer
cd /d "%~dp0"

echo Creating Windows Optimizer shortcut on your Desktop...

powershell -NoProfile -ExecutionPolicy Bypass -Command "& {
    $desktop = [Environment]::GetFolderPath('Desktop')
    $shortcutPath = Join-Path $desktop 'Windows Speed Optimizer.lnk'
    $targetPath = Join-Path '%~dp0' 'Launch-Optimizer.bat'
    
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $targetPath
    $Shortcut.WorkingDirectory = '%~dp0'
    $Shortcut.Description = 'Windows Speed & Performance Master Optimizer'
    $Shortcut.Save()
    Write-Host 'Shortcut created successfully at:' $shortcutPath -ForegroundColor Green
}"

echo.
pause

