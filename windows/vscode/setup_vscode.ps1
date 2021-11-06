. $PSScriptRoot\..\utils.ps1

LogHeader "Starting Vscode Config"

$vscode_config_src_dir = "$linux_userland_dir/vscode"
$vscode_config_dest_dir = "$env:APPDATA/Code/User"

Start-Process -FilePath "$(GetProgramInstallPathUsingHKLM 'Git')\git-bash.exe" -ArgumentList "$vscode_config_src_dir/vscode_extension.sh" -Wait

$null = TryToMakeSymlink `
    "$vscode_config_src_dir/settings.json" `
    "$vscode_config_dest_dir/settings.json"
$null = TryToMakeSymlink `
    "$vscode_config_src_dir/keybindings.json"`
    "$vscode_config_dest_dir/keybindings.json" 

LogHeader "Finished Vscode Config"