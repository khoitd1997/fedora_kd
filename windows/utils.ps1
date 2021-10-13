Set-Variable -Name "windows_conf_root_dir" -Value ($PSScriptRoot) -Option constant -Scope global -Description "Root dir of windows config"

Set-Variable -Name "linux_conf_root_dir" -Value ("$PSScriptRoot/../linux") -Option constant -Scope global -Description "Root dir of linux config"
Set-Variable -Name "linux_userland_dir" -Value ("$linux_conf_root_dir/userland") -Option constant -Scope global -Description "Root dir of linux config"

function LogHeader {
    param (
        [string]$LogContent
    )
    Write-Host "$LogContent" -ForegroundColor black -BackgroundColor white
}

function LogError {
    param (
        [string]$LogContent
    )
    Write-Host "$LogContent" -ForegroundColor red -BackgroundColor white
}