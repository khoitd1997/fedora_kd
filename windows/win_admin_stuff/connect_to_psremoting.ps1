#Requires -RunAsAdministrator
# needs admin right if local computer is the target computer

. $PSScriptRoot\..\utils.ps1

# use Get-PSSessionConfiguration to get -ConfigurationName
# $SessionConfigurationName = "PowerShell.7"

try {
    # Note: In Windows Vista and later versions of the Windows operating system, to include the local computer in the value of the ComputerName parameter, you must start PowerShell with the Run as administrator option
    # From this: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enter-pssession?view=powershell-7.1
    $session = New-PSSession -ComputerName localhost -Credential $(whoami)


    Copy-Item "$PSScriptRoot/test_file.txt" -Destination "$env:TEMP/test_dir" -ToSession $session
    Invoke-Command -Session $session -FilePath "$PSScriptRoot/test_remote_script.ps1"

    Remove-PSSession -Session $session
}
catch {
    LogError "$PSItem"
}