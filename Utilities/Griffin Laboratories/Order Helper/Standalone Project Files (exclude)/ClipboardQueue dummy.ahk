; This is a dummy file, because the stand-alone version of Order Helper doesn't need the ClipboardQueue functionality.
BackupClipboard:
	clipboardBackup := ClipboardAll
Return
RestoreClipboard:
	Clipboard := clipboardBackup
Return
