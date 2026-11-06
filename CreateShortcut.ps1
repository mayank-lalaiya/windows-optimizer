$desktop = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktop "Windows Speed Optimizer.lnk"
$targetPath = Join-Path $PSScriptRoot "Launch-Optimizer.bat"

$wsh = New-Object -ComObject WScript.Shell
$sc = $wsh.CreateShortcut($shortcutPath)
$sc.TargetPath = $targetPath
$sc.WorkingDirectory = $PSScriptRoot
$sc.Description = "Windows Speed & Performance Master Optimizer"
$sc.Save()

Write-Host "Created Desktop Shortcut: $shortcutPath" -ForegroundColor Green

