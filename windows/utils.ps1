Set-Variable -Name "windows_conf_root_dir" -Value ($PSScriptRoot) -Scope global -Description "Root dir of windows config"

Set-Variable -Name "linux_conf_root_dir" -Value ("$PSScriptRoot/../linux") -Scope global -Description "Root dir of linux config"
Set-Variable -Name "linux_userland_dir" -Value ("$linux_conf_root_dir/userland") -Scope global -Description "Root dir of linux config"

function LogHeader {
    param (
        [Parameter(Mandatory = $true)]
        [string]$LogContent
    )

    # have to write a special character at end of line for this issue:
    # https://stackoverflow.com/questions/66123718/write-host-with-background-colour-fills-the-entire-line-with-background-colour-w
    Write-Host "$LogContent" -ForegroundColor black -BackgroundColor white -NoNewline
    Write-Host ([char]0xA0)
}
function LogError {
    param (
        [Parameter(Mandatory = $true)]
        [string]$LogContent
    )
    Write-Host "$LogContent" -ForegroundColor red -BackgroundColor white -NoNewline
    Write-Host ([char]0xA0)
}

# Input string can be gotten from DisplayName of
# Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
function ProgramIsInstalledUsingHKLM {
    param (
        [Parameter(Mandatory = $true)]
        [string]$DisplayNameSearchString
    )
    return $null -ne (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*$DisplayNameSearchString*" })
}
# used for UWP apps like Windows Terminal
function ProgramIsInstalledUsingAppX {
    param (
        [Parameter(Mandatory = $true)]
        [string]$AppXNameSearchString
    )
    # powershell 7 has problems importing this module
    # so use windows powershell mode
    if ($PSVersionTable.PSVersion.Major -ne 5) {
        import-module appx -usewindowspowershell
    }

    return $null -ne (Get-AppxPackage | Where-Object { $_.Name -like "*$AppXNameSearchString*" })
}
function ProgramIsInstalledUsingWMI {
    param (
        [Parameter(Mandatory = $true)]
        [string]$AppName
    )

    return $null -ne (Get-WMIObject -Query "SELECT * FROM Win32_Product Where Name Like '%$AppName%'")
}
function ProgramIsInstalledUsingCommandName {
    param (
        [Parameter(Mandatory = $true)]
        [string]$CommandName
    )
    return $null -ne (Get-Command $CommandName -errorAction SilentlyContinue)
}

function DownloadAndInstallAppXPackage { 
    param (
        [Parameter(Mandatory = $true)]
        [string]$InstallerDownloadURL,

        [Parameter(Mandatory = $true)]
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
        [Parameter(Mandatory = $true)]
        [string]$AppName,

        [Parameter(Mandatory = $true)]
        [string]$InstallerDownloadURL,

        [string]$InstallerDownloadFile = "installer.exe",

        [Parameter(Mandatory = $true)]
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
        [Parameter(Mandatory = $true)]
        [string[]]$AppXNameSearchList
    )
    # powershell 7 has problems importing this module
    # so use windows powershell mode
    if ($PSVersionTable.PSVersion.Major -ne 5) {
        import-module appx -usewindowspowershell
    }

    foreach ($AppName in $AppXNameSearchList) {
        Get-AppxPackage | Where-Object { $_.Name -like "*$AppName*" } | Remove-AppxPackage
    }
}

function GetProgramInstallPathUsingHKLM {
    param (
        [Parameter(Mandatory = $true)]
        [string]$DisplayNameSearchString
    )

    return Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | ForEach-Object { Get-ItemProperty $_.PsPath } | Where-Object { $_.DisplayName -eq "$DisplayNameSearchString" } | Select-Object -First 1 | ForEach-Object { $_.InstallLocation }
}

function AddToMachineLevelEnvironmentVariable {
    param (
        [Parameter(Mandatory = $true)]
        [string]$VarName,

        [Parameter(Mandatory = $true)]
        [string]$ValueToAdd
    )

    $currVarValue = [Environment]::GetEnvironmentVariable($VarName, [EnvironmentVariableTarget]::Machine)
    if ($currVarValue.IndexOf($ValueToAdd) -eq -1) {
        Write-Output "Adding $ValueToAdd to $VarName Machine Env Variable"
        [Environment]::SetEnvironmentVariable(
            $VarName,
            $currVarValue + ";$ValueToAdd",
            [EnvironmentVariableTarget]::Machine)
    }
    else {
        Write-Output "$ValueToAdd already exists in $VarName Machine Env Variable"
    }
}

function AddToUserLevelEnvironmentVariable {
    param (
        [Parameter(Mandatory = $true)]
        [string]$VarName,

        [Parameter(Mandatory = $true)]
        [string]$ValueToAdd
    )

    $currVarValue = [Environment]::GetEnvironmentVariable($VarName, [EnvironmentVariableTarget]::User)
    if ($currVarValue.IndexOf($ValueToAdd) -eq -1) {
        Write-Output "Adding $ValueToAdd to $VarName User Env Variable"
        [Environment]::SetEnvironmentVariable(
            $VarName,
            $currVarValue + ";$ValueToAdd",
            [EnvironmentVariableTarget]::User)
    }
    else {
        Write-Output "$ValueToAdd already exists in $VarName User Env Variable"
    }
}
function SetUserLevelEnvironmentVariable {
    param (
        [Parameter(Mandatory = $true)]
        [string]$VarName,

        [Parameter(Mandatory = $true)]
        [string]$ValueToSet
    )

    [Environment]::SetEnvironmentVariable($VarName, $ValueToSet, [EnvironmentVariableTarget]::User)
}

function RunAsAnotherUser {
    param (
        [Parameter(Mandatory = $true)]
        [Scriptblock] $ScriptBlock,

        [Parameter(Mandatory = $true)]
        [Object[]]$ArgList,

        [Parameter(Mandatory = $true)]
        [String]$PromptMessage
    )

    $Cred = Get-Credential -Message $PromptMessage

    $job = Start-Job -scriptblock $ScriptBlock -ArgumentList $ArgList -Credential $Cred
    Receive-Job -Job $job -Wait

    Write-Host "Job Output: $($job.Output)"
    Write-Host "Job Warning: $($job.Warning)"
    Write-Host "Job Verbose: $($job.Verbose)"

    if ($job.State -eq "Failed") {
        Write-Host "Job Error: $($job.Error)"
        return $false
    }
    return $true
}


function MakeSymlinkIfAllowed {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SrcPath,

        [Parameter(Mandatory = $true)]
        [string]$DestPath
    )
    <#
        .SYNOPSIS
        Symlink requires admin access so it's not possible to do sometimes,
        in that case, copy the file instead
    #>

    try {
        $null = New-Item -Path "$DestPath" `
            -ItemType SymbolicLink `
            -Value "$SrcPath" `
            -Force -Erroraction stop
    }
    catch [System.UnauthorizedAccessException] {
        Write-Host "Permission denied to create symlink for file $SrcPath, trying to copy instead"
        $null = Copy-Item "$SrcPath" -Destination "$DestPath"
    }
}

function MakeSymlinkUsingMkLink {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SrcPath,

        [Parameter(Mandatory = $true)]
        [string]$DestPath
    )
    <#
        .SYNOPSIS
        Symlink using New-Item require admin access but bat mklink doesn't seem to
        so use it instead
    #>

    if (Test-Path $DestPath) {
        $null = Remove-Item -Recurse $DestPath
    }
    cmd.exe /c "mklink `"$DestPath`" `"$SrcPath`""
}