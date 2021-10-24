function CreateAdminTerminalShortcut() {
    $DesktopFolderPath = [Environment]::GetFolderPath("Desktop")
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$DesktopFolderPath\Windows Terminal Admin.lnk")
    $Shortcut.TargetPath = "pwsh.exe"
    
    # got it from https://github.com/microsoft/terminal/tree/main/res
    $Shortcut.IconLocation = "$PSScriptRoot\pics\terminal.ico"

    $Shortcut.Arguments = '-Command Start-Process -FilePath "wt" -Verb RunAs'
    $Shortcut.Save()
}

AddToEnvironmentVariable "Path" "C:\Xilinx\Vitis\2020.1\bin"
AddToEnvironmentVariable "Path" "C:\Xilinx\Vivado\2020.1\bin"

CreateAdminTerminalShortcut