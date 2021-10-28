LogHeader "Installing Powershell Modules"

$ps_module_list = 
$(
    "PowerShellGet"
    "PSReadLine"
    "PSFzf"
    "posh-git"
)

foreach ($ps_module in $ps_module_list) {
    Install-Module $ps_module -Confirm:$False
}