# windows_config

Repo for configuring a new Windows install

## Instruction

At minimum, need to run the `setup_required.bat`:

```Powershell
# assuming current working directory is this repo
cmd.exe setup_required.ps1
```

After that, individual scripts can be run to only set up certain components or `setup_all.ps1` can be run to setup everything

```PowerShell
# launch powershell in admin mode
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
cd C:\Users\khoid\windows_config\windows

.\setup_all.ps1
```
