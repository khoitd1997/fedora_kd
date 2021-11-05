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