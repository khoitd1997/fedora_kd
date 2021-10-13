# used for first time set up of ssh key on the server

ssh-keygen.exe

type $env:USERPROFILE\.ssh\id_rsa.pub | ssh kd@"kd-server" "cat >> .ssh/authorized_keys"

$From = Get-Content -Path $PSScriptRoot\ssh_config
Add-Content -Path $env:USERPROFILE\.ssh\config -Value $From