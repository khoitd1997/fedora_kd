# got from https://chocolatey.org/install

LogHeader "Installing Chocolatey Software"

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

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
foreach ($choco_app in $choco_app_list) {
    choco install -y $choco_app
}

# create tasks to automatically update choco
$action = New-ScheduledTaskAction -Execute 'choco' -Argument 'upgrade all -Y'
$trigger = New-ScheduledTaskTrigger -AtLogon
$Stset = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "choco automatic upgrade" -Description "Automatically upgrade choco app" -RunLevel Highest -Settings $Stset