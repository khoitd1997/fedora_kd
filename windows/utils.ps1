. "$PSScriptRoot/powershell_utils/utils_vars.ps1"

. "$PSScriptRoot/powershell_utils/utils_log.ps1"
. "$PSScriptRoot/powershell_utils/utils_app_install.ps1"
. "$PSScriptRoot/powershell_utils/utils_file_ops.ps1"

function IsUsingWindowPowershell {
    return -not($PSVersionTable.PSVersion.Major -gt 5)
}

function AddToMachineLevelEnvironmentVariable {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$VarName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
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
        [ValidateNotNullOrEmpty()]
        [string]$VarName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
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
        [ValidateNotNullOrEmpty()]
        [string]$VarName,

        [Parameter(Mandatory = $true)]
        [string]$ValueToSet
    )

    [Environment]::SetEnvironmentVariable($VarName, $ValueToSet, [EnvironmentVariableTarget]::User)
}

function RunAsAnotherUser {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Scriptblock] $ScriptBlock,

        [Object[]]$ArgList = @(),

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
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