Add-Type -assembly "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Shared\Visual Studio Tools for Office\PIA\Office15\Microsoft.Office.Interop.Outlook.dll"

$OutlookApplication = $(New-Object -comobject Outlook.Application)

$Timestamp = Get-Date -Format 'dddd MM/dd/yyyy HH:mm K'

$Email = $OutlookApplication.CreateItem([Microsoft.Office.Interop.Outlook.OlItemType]::olMailItem)

$Email.Subject = "Mail to myself $Timestamp"

$RecipientsList = @(
    "khoidinhtrinh@outlook.com"
    # "khoidinhtrinh@gmail.com"
)
foreach ($Recipient in $RecipientsList) {
    $Email.Recipients.Add($Recipient)
}

$Email.Importance = [Microsoft.Office.Interop.Outlook.OlImportance]::olImportanceHigh

$Email.Sensitivity = [Microsoft.Office.Interop.Outlook.OlSensitivity]::olConfidential

$Email.ReadReceiptRequested = $true

$Email.Body = "Hello I'm the test email $Timestamp"
$Email.BodyFormat = [Microsoft.Office.Interop.Outlook.OlBodyFormat]::olFormatPlain

# The actions stuff may not work if it's not supported
# $EmailAction = $Email.Actions.Add()
# $EmailAction.Name = "Agree"
# $EmailAction.Enabled = $true

$null = $Email.Attachments.Add("$PSScriptRoot/mail_test_attachment.txt")

$null = $Email.Display()

# $null = $Email.Send()