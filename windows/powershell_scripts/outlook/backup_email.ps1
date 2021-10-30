# NOTE: this would need Visual Studio to be installed
Add-Type -assembly "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Shared\Visual Studio Tools for Office\PIA\Office15\Microsoft.Office.Interop.Outlook.dll"

$OutlookNamespace = $(New-Object -comobject Outlook.Application).GetNameSpace("MAPI")

# basically OlDefaultFolders is a C# enum, that is documented here:
# https://docs.microsoft.com/en-us/dotnet/api/microsoft.office.interop.outlook.oldefaultfolders?view=outlook-pia
# the good ones are:
# olFolderInbox
# olFolderSentMail
# olFolderOutbox
# olFolderTasks
# olFolderToDo
# $inbox = $OutlookNamespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)

$OutlookBackupRelativePath = "outlook_backup\backup_2.pst"
$OutlookBackupPath = "$env:TEMP\$OutlookBackupRelativePath"
# $EmailAddressToBackup = "khoidinhtrinh@gmail.com"
$EmailAddressToBackup = "khoidinhtrinh@outlook.com"

$OutlookNamespace.AddStore($OutlookBackupPath)
$BackupStoreDisplayName = `
    $OutlookNamespace.Stores | Where-Object { $_.FilePath -like "*${OutlookBackupRelativePath}*" } | Select-Object -First 1 | Select-Object -ExpandProperty "DisplayName"

$OutlookBackupFolder = $OutlookNamespace.Folders.Item($BackupStoreDisplayName)
$OutlookBackupFolder.Name = "Outlook Backup Folder Name 2"

# Adjust to pick which folder to backup
$FolderToBackup = $OutlookNamespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)
# $FolderToBackup = $OutlookNamespace.Folders.Item($EmailAddressToBackup).Folders.Item("Outbox")

$null = $FolderToBackup.CopyTo($OutlookBackupFolder)
