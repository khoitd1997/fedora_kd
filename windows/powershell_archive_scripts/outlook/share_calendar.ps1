Add-Type -assembly "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Shared\Visual Studio Tools for Office\PIA\Office15\Microsoft.Office.Interop.Outlook.dll"

$OutlookApplication = $(New-Object -comobject Outlook.Application)
$OutlookNamespace = $OutlookApplication.GetNameSpace("MAPI")

$CalendarFolder = $OutlookNamespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderCalendar)

$CalendarSharingObject = $CalendarFolder.GetCalendarExporter()
$CalendarSharingObject.CalendarDetail = [Microsoft.Office.Interop.Outlook.OlCalendarDetail]::olFullDetails 
$CalendarSharingObject.IncludeAttachments = $true 
$CalendarSharingObject.IncludePrivateDetails = $true 
$CalendarSharingObject.IncludeWholeCalendar = $true 

$Timestamp = Get-Date -Format 'dddd MM/dd/yyyy HH:mm K'

$Email = $OutlookApplication.CreateItem([Microsoft.Office.Interop.Outlook.OlItemType]::olMailItem)

$Email.Subject = "Calendar Sharing Subject $Timestamp"

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

$Email.Body = "Calendar Sharing Body $Timestamp"
$Email.BodyFormat = [Microsoft.Office.Interop.Outlook.OlBodyFormat]::olFormatPlain

$null = $Email.Attachments.Add("$PSScriptRoot/mail_test_attachment.txt")

$null = $Email.Display()

# $null = $Email.Send()