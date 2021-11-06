. $PSScriptRoot\utils.ps1

function CreateWtAdminTerminalShortcut() {
    $DesktopFolderPath = [Environment]::GetFolderPath("Desktop")
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$DesktopFolderPath\Windows Terminal Admin.lnk")
    $Shortcut.TargetPath = "powershell.exe"
    
    # got it from https://github.com/microsoft/terminal/tree/main/res
    $Shortcut.IconLocation = "$PSScriptRoot\pics\terminal.ico"

    $Shortcut.Arguments = '-NonInteractive -NoProfile -Command Start-Process -FilePath "wt" -Verb RunAs'
    $Shortcut.Save()
}
function CreateClassicAdminTerminalShortcut() {
    $DesktopFolderPath = [Environment]::GetFolderPath("Desktop")
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$DesktopFolderPath\Classic Powershell Admin.lnk")
    $Shortcut.TargetPath = "powershell.exe"
    
    $Shortcut.Arguments = '-NonInteractive -NoProfile -Command Start-Process -FilePath "powershell.exe" -Verb RunAs'
    $Shortcut.Save()
}

if (IsUsingHomeConfig) {
    AddToUserLevelEnvironmentVariable "Path" "C:\Xilinx\Vitis\2020.1\bin"
    AddToUserLevelEnvironmentVariable "Path" "C:\Xilinx\Vivado\2020.1\bin"
}

# exposes git vim and nano
AddToUserLevelEnvironmentVariable "Path" "$(GetProgramInstallPathUsingHKLM 'Git')/usr/bin"

# expose convenient script
AddToUserLevelEnvironmentVariable "Path" "$PSScriptRoot/powershell_scripts/user_level"

SetUserLevelEnvironmentVariable "KD_SCRIPT_DIR" "$PSScriptRoot/powershell_scripts"

CreateWtAdminTerminalShortcut
CreateClassicAdminTerminalShortcut