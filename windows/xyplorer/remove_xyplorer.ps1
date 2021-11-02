. $PSScriptRoot\xyplorer_common.ps1
. $PSScriptRoot\..\utils.ps1

LogHeader "Removing XYPlorer"

Remove-Item `
    -Path "$XYPlorerInstallDestDir", `
    "$XYPlorerAppDataDir", "$XYPlorerShortcutPath" `
    -Recurse -ErrorAction Ignore