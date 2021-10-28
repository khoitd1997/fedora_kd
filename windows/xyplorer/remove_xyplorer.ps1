. $PSScriptRoot\xyplorer_common.ps1

Write-Host "Removing XYPlorer" -ForegroundColor black -BackgroundColor white

Remove-Item `
    -Path "$XYPlorerInstallDestDir", `
    "$XYPlorerAppDataDir", "$XYPlorerShortcutPath" `
    -Recurse -ErrorAction Ignore