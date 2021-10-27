# got from https://chocolatey.org/install

. $PSScriptRoot\..\utils.ps1

LogHeader "Installing Chocolatey Software"

if (-Not (Get-Command "choco" -errorAction SilentlyContinue)) {
    Write-Output "Installing Chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
else {
    Write-Output "Chocolatey already installed"
}

choco install -y microsoft-windows-terminal --pre
$choco_app_list = @(
    "googlechrome"
    "autohotkey" 
    "dropbox" 
    "spotify"
    "crystaldiskinfo"
    "treesizefree"
    "firefox"
    "powertoys"
    "everything"
    "xyplorer"
    # dev apps
    "sourcecodepro"
    "nerdfont-hack"
    "powershell-core"
    "vcredist140"
    "python"
    "vscode"
    "github-desktop"
    "git.install"
    "putty.install" 
    "mobaxterm"
    "rufus"
    "etcher"
    # command line tools
    "fzf"
    "bat"
    "wget"
    "curl"
)
foreach ($choco_app in $choco_app_list) {
    choco install -y $choco_app
}

choco install -y neovim --params "/NeovimOnPathForAll"

$chocoUpgradeTaskName = "choco automatic upgrade"
$taskExists = Get-ScheduledTask | Where-Object { $_.TaskName -like $chocoUpgradeTaskName }

if (-Not $taskExists) {
    $action = New-ScheduledTaskAction -Execute 'choco' -Argument 'upgrade all -Y'
    $trigger = New-ScheduledTaskTrigger -AtLogon

    $Stset = `
        New-ScheduledTaskSettingsSet `
        -RunOnlyIfNetworkAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    Register-ScheduledTask `
        -Action $action -Trigger $trigger -TaskName $chocoUpgradeTaskName `
        -Description "Automatically upgrade choco app" -RunLevel Highest -Settings $Stset  
}
else {
    Write-Output "Choco upgrade task is already created"
}
