LogHeader "Starting Vscode Config"

Start-Process -FilePath '"C:\Program Files\Git\git-bash.exe"' -ArgumentList "$PSScriptRoot\setup_vscode.sh"

$vscode_config_src_dir = "$linux_userland_dir/vscode"
$vscode_config_dest_dir = "$env:APPDATA/Code/User"

$null = New-Item -Path "$vscode_config_dest_dir/settings.json" `
    -ItemType SymbolicLink `
    -Value "$vscode_config_src_dir/settings.json"`
    -Force
$null = New-Item -Path "$vscode_config_dest_dir/keybindings.json" `
    -ItemType SymbolicLink `
    -Value "$vscode_config_src_dir/keybindings.json"`
    -Force

LogHeader "Finished Vscode Config"