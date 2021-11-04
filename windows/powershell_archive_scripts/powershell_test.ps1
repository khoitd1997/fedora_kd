# NOTE: this would need Visual Studio to be installed
Add-Type -assembly "C:\Program Files (x86)\Microsoft Visual Studio\Shared\Visual Studio Tools for Office\PIA\Office15\Microsoft.Office.Interop.Outlook.dll"

$Outlook = New-Object -comobject Outlook.Application
$namespace = $Outlook.GetNameSpace("MAPI")

# basically OlDefaultFolders is a C# enum, that is documented here:
# https://docs.microsoft.com/en-us/dotnet/api/microsoft.office.interop.outlook.oldefaultfolders?view=outlook-pia
# $inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)
# $box = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderSentMail)
# the good ones are:
# olFolderInbox
# olFolderSentMail
# olFolderOutbox
# olFolderTasks
# olFolderToDo

# How To Backup:

$OutlookBackupPath = "$env:TEMP/outlook_backup/backup.pst"
$namespace.AddStore($OutlookBackupPath)
$OutlookBackupFolder = $namespace.Folders.GetLast()
$OutlookBackupFolder.Name = "Outlook Backup Folder Name"

# This actually lists out all the folders like Inbox, Gmail, etc, Outbox, Notes
$namespace.Folders.Item("khoidinhtrinh@gmail.com").Folders.Item("Notes").CopyTo($OutlookBackupFolder)

# $namespace.Folders.Item("khoidinhtrinh@gmail.com").Folders.Count
# $null = $namespace.Folders.Item("khoidinhtrinh@gmail.com").Folders.Item("Outbox").CopyTo($DraftFolder)
# $namespace.Stores.Item(1)

# $namespace.Folders("")

# $inbox

# $namespace.Folders

# $rules = $namespace.DefaultStore.GetRules()
# $rule = $rules.create("My rule1: Receiving Notification", [Microsoft.Office.Interop.Outlook.OlRuleType]::olRuleReceive)

# $rules

# ${namespace.Folders}

# Write-Output "Inbox: $inbox"
# $inbox