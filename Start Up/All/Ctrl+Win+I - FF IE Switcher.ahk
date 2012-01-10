;Shortcut for FF that copies the IE address
^#f::
	Copied := false
	;If IE is active, let's copy the address
	IfWinActive, ahk_class IEFrame
	{
		GoSub BackupClipboard
		Copied := true
		
		Sleep 50 ;allows time to release the hot key
		Send !d ;activate address bar
		Sleep 10
		Send ^a ;select all
		Sleep 10
		Send ^c ;copy
		ClipWait 1
	}

	;check for FF
	IfWinExist ahk_class MozillaUIWindowClass
	{
		WinActivate
	} 
	else 
	{
		Run firefox.exe
		
	}
	WinWait ahk_class MozillaUIWindowClass
	WinActivate

	If Copied {
		Sleep 10
		Send !d ;activate address bar
		Sleep 10
		Send ^v ;paste
		Sleep 10
		Send {Enter}
		
		GoSub RestoreClipboard
	}
return

;Shortcut for IE that copies the Firefox address
^#i::
	Copied := false
	;If firefox is active, let's copy the address
	IfWinActive, ahk_class MozillaUIWindowClass
	{
		GoSub BackupClipboard
		Copied := true
		
		Sleep 50 ;allows time to release the hot key
		Send !d ;activate address bar
		Sleep 10
		Send ^a ;select all
		Sleep 10
		Send ^c ;copy
		ClipWait 1
	}

	;check for IE
	IfWinExist ahk_class IEFrame 
	{
		WinActivate
	} 
	else 
	{
		Run iexplore.exe
		
	}
	WinWait ahk_class IEFrame
	WinActivate
	
	If Copied {
		Sleep 10
		Send !d ;activate address bar
		Sleep 10
		Send ^v ;paste
		Sleep 10
		Send {Enter}
		
		GoSub RestoreClipboard
	}

return
