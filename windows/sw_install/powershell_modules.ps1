. $PSScriptRoot\..\utils.ps1

LogHeader "Installing Powershell Modules"

# PSGallery is in list of repository by default but by default it's
# not trusted so we need to change that
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

$ps_module_list = 
$(
    "PowerShellGet"
    "PSReadLine"
    "PSFzf"
    "posh-git"
)

foreach ($ps_module in $ps_module_list) {
    Install-Module $ps_module
}