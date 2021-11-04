. $PSScriptRoot\..\utils.ps1

LogHeader "Starting Vscode Config"

Start-Process -FilePath '"C:\Program Files\Git\git-bash.exe"' -ArgumentList "$PSScriptRoot\setup_vscode.sh"

$vscode_config_src_dir = "$linux_userland_dir/vscode"
$vscode_config_dest_dir = "$env:APPDATA/Code/User"

$null = MakeSymlinkUsingMkLink `
    "$vscode_config_src_dir/settings.json" `
    "$vscode_config_dest_dir/settings.json"
$null = MakeSymlinkUsingMkLink `
    "$vscode_config_src_dir/keybindings.json"`
    "$vscode_config_dest_dir/keybindings.json" 

LogHeader "Finished Vscode Config"