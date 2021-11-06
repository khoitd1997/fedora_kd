Set-Variable -Name "windows_conf_root_dir" -Value ($PSScriptRoot) -Scope global -Description "Root dir of windows config"

Set-Variable -Name "linux_conf_root_dir" -Value ("$PSScriptRoot/../../linux") -Scope global -Description "Root dir of linux config"
Set-Variable -Name "linux_userland_dir" -Value ("$linux_conf_root_dir/userland") -Scope global -Description "Root dir of linux config"
