Set-Variable -Name "windows_conf_root_dir" -Value ($PSScriptRoot) -Scope global -Description "Root dir of windows config"

Set-Variable -Name "linux_conf_root_dir" -Value ("$PSScriptRoot/../linux") -Scope global -Description "Root dir of linux config"
Set-Variable -Name "linux_userland_dir" -Value ("$linux_conf_root_dir/userland") -Scope global -Description "Root dir of linux config"

function LogHeader {
    param (
        [string]$LogContent
    )

    # have to write a special character at end of line for this issue:
    # https://stackoverflow.com/questions/66123718/write-host-with-background-colour-fills-the-entire-line-with-background-colour-w
    Write-Host "$LogContent" -ForegroundColor black -BackgroundColor white -NoNewline
    Write-Host ([char]0xA0)
}
function LogError {
    param (
        [string]$LogContent
    )
    Write-Host "$LogContent" -ForegroundColor red -BackgroundColor white -NoNewline
    Write-Host ([char]0xA0)
}

# Input string can be gotten from DisplayName of
# Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
function ProgramIsInstalledUsingHKLM {
    param (
        [string]$DisplayNameSearchString
    )
    return $null -ne (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*$DisplayNameSearchString*" })
}
# used for UWP apps like Windows Terminal
function ProgramIsInstalledUsingAppX {
    param (
        [string]$AppXNameSearchString
    )
    # powershell 7 has problems importing this module
    # so use windows powershell mode
    import-module appx -usewindowspowershell

    return $null -ne (Get-AppxPackage | Where-Object { $_.Name -like "*$AppXNameSearchString*" })
}
function ProgramIsInstalledUsingWMI {
    param (
        [string]$AppName
    )

    return $null -ne (Get-WMIObject -Query "SELECT * FROM Win32_Product Where Name Like '%$AppName%'")
}
function ProgramIsInstalledUsingCommandName {
    param (
        [string]$CommandName
    )
    return $null -ne (Get-Command $CommandName -errorAction SilentlyContinue)
}

function DownloadAndInstallAppXPackage { 
    param (
        [string]$InstallerDownloadURL,
        [string]$AppName
    )
    if (-Not (ProgramIsInstalledUsingAppX "$AppName")) {
        LogHeader "Installing $AppName"
    
        $InstallWorkDir = "$env:TEMP/${AppName}_install_tmp"
        $MsixDestDir = "$InstallWorkDir/${AppName}"
    
        $null = New-Item -ItemType Directory -Force -Path $InstallWorkDir
    
        Invoke-WebRequest -Uri "$InstallerDownloadURL" -OutFile $MsixDestDir
        Add-AppxPackage -Path $MsixDestDir
    
        Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore

        LogHeader "Finished Installing $AppName"
    }
    else {
        LogHeader "$AppName has been already installed"
    }
}
function DownloadAndInstallGenericExe { 
    param (
        [string]$AppName,
        [string]$InstallerDownloadURL,
        [string]$InstallerDownloadFile = "installer.exe",
        [string[]]$ArgList
    )
    LogHeader "Installing $AppName"
    
    $InstallWorkDir = "$env:TEMP/${AppName}_install_tmp"
    $ExeDestDir = "$InstallWorkDir/$InstallerDownloadFile"
    
    $null = New-Item -ItemType Directory -Force -Path $InstallWorkDir
    
    Invoke-WebRequest -Uri "$InstallerDownloadURL" -OutFile $ExeDestDir

    Start-Process `
        -FilePath "$ExeDestDir" `
        -ArgumentList $ArgList `
        -NoNewWindow `
        -Wait
    
    # Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore

    LogHeader "Finished Installing $AppName"
}
function RemoveAppXPackage {
    param (
        [string[]]$AppXNameSearchList
    )
    # powershell 7 has problems importing this module
    # so use windows powershell mode
    import-module appx -usewindowspowershell

    foreach ($AppName in $AppXNameSearchList) {
        Get-AppxPackage | Where-Object { $_.Name -like "*$AppName*" } | Remove-AppxPackage
    }
}

function AddToEnvironmentVariable {
    param (
        [string]$VarName,
        [string]$ValueToAdd
    )

    $currVarValue = [Environment]::GetEnvironmentVariable($VarName, [EnvironmentVariableTarget]::Machine)
    if ($currVarValue.IndexOf($ValueToAdd) -eq -1) {
        Write-Output "Adding $ValueToAdd to $VarName env variable"
        [Environment]::SetEnvironmentVariable(
            $VarName,
            $currVarValue + ";$ValueToAdd",
            [EnvironmentVariableTarget]::Machine)
    }
    else {
        Write-Output "$ValueToAdd already exists in $VarName env variable"
    }
}