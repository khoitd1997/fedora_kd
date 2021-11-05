# Input string can be gotten from DisplayName of
# Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
function ProgramIsInstalledUsingHKLM {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayNameSearchString
    )
    return $null -ne (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "*$DisplayNameSearchString*" })
}
# used for UWP apps like Windows Terminal
function ProgramIsInstalledUsingAppX {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AppXNameSearchString
    )
    # powershell 7 has problems importing this module
    # so use windows powershell mode
    if (-not(IsUsingWindowPowershell)) {
        import-module appx -usewindowspowershell
    }

    return $null -ne (Get-AppxPackage | Where-Object { $_.Name -like "*$AppXNameSearchString*" })
}
function ProgramIsInstalledUsingWMI {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AppName
    )

    return $null -ne (Get-WMIObject -Query "SELECT * FROM Win32_Product Where Name Like '%$AppName%'")
}
function ProgramIsInstalledUsingCommandName {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CommandName
    )
    return $null -ne (Get-Command $CommandName -errorAction SilentlyContinue)
}

function DownloadAndInstallAppXPackage { 
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InstallerDownloadURL,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
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
        [ValidateNotNullOrEmpty()]
        [string]$AppName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InstallerDownloadURL,

        [string]$InstallerDownloadFile = "installer.exe",

        [string[]]$ArgList = @("")
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
        [ValidateNotNullOrEmpty()]
        [string[]]$AppXNameSearchList
    )
    # powershell 7 has problems importing this module
    # so use windows powershell mode
    if (-not(IsUsingWindowPowershell)) {
        import-module appx -usewindowspowershell
    }

    foreach ($AppName in $AppXNameSearchList) {
        Get-AppxPackage | Where-Object { $_.Name -like "*$AppName*" } | Remove-AppxPackage
    }
}

function GetProgramInstallPathUsingHKLM {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayNameSearchString
    )

    return (Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | ForEach-Object { Get-ItemProperty $_.PsPath } | Where-Object { $_.DisplayName -eq "$DisplayNameSearchString" } | Select-Object -First 1).InstallLocation
}