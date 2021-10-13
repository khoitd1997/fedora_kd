# got from https://chocolatey.org/install
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

New-Item -Path "$profile" `
         -ItemType SymbolicLink `
         -Value "$PSScriptRoot\powershell_profile.ps1"`
         -Force

New-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json" `
         -ItemType SymbolicLink `
         -Value "$PSScriptRoot\terminal_settings.json"`
         -Force

choco install -y microsoft-windows-terminal --pre
$choco_app_list = @(
    "fzf"
    "sourcecodepro"
    "powershell-core"
    "googlechrome"
    "git.install"
    "putty.install" 
    "autohotkey" 
    "vscode"
    "github-desktop"
    "dropbox" 
    "spotify"
    "python"
    "firefox"
)
foreach ($choco_app in $choco_app_list)
{
    choco install -y $choco_app
}

$ps_module_list = "PowerShellGet","PSReadLine","PSFzf","posh-git","oh-my-posh"
foreach ($ps_module in $ps_module_list)
{
    Install-Module $ps_module -Confirm:$False -Force
}