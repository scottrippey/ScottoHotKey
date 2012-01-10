
#^d::
DVDShrink:
	IfWinNotExist DVD Shrink
	{
		ToolTip Starting DVD Shrink...
		Run %ProgramFiles%\DVD Shrink\DVD Shrink 3.2.exe
		WinWait DVD Shrink
	}
	WinActivate
	
	; Open disc
	Send !fd
	; Choose the right disc and press OK
	Send {Up}{Up}{Down}{Enter}
	
	; Wait for analysing to finish
	ToolTip Waiting for DVD Shrink start analysing...
	SetTitleMatchMode 2 ; = Anywhere
	WinWait Analysing, , 5 ; wait for the window to open
	ToolTip Waiting for DVD Shrink to finish...
	WinWaitClose Analysing, , 120 ; wait for the window to close
	ToolTip
	If (ErrorLevel)
		Return
	Sleep 100
	IfWinNotExist DVD Shrink
		Return
	WinActivate
	Send ^b
	Send {Enter}
Return
