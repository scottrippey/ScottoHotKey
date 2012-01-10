; Auto-execute:
	RenameIndex := 1
	RenamePrefix := "Sort{Index:000}.{Original}"
	RenameCopy := false
	
	RegisterTool("ShowDragAndDropRenamer", "&Drag and Drop Renamer", "Allows you to drag and drop files in order to rename them in a specific order")
	RegisterTool("ShowScannerAutomater", "S&canner Automater", "Makes scanning easier by controlling it with just the spacebar")
Return

;Region " Drag and Drop Renamer "

;#!e::
ShowDragAndDropRenamer:
	GuiUniqueDestroy("DropAndRename")
	GuiUniqueDefault("DropAndRename")
	
	Gui, Add, Text, , Drag and drop files here, and they will be `nrenamed in the order they were dropped.
	
	Gui, Add, Text, y+8, Filename:
	Gui, Add, Edit, vRenamePrefix x+10 yp-3 w160, %RenamePrefix%
	
	Gui, Add, Edit, x+10 yp w60
	Gui, Add, UpDown, vRenameIndex Range0-9999, %RenameIndex%
	
	Gui, Add, CheckBox, vRenameCopy Checked%RenameCopy% x+10 yp+3, Copy Files
	
	Gui, +AlwaysOnTop
	Gui, Show
Return
DropAndRename_Close:
DropAndRename_Escape:
DropAndRename_Cancel:
	GuiUniqueDestroy("DropAndRename")
Return
DropAndRename_DropFiles:
	GuiControlGet, RenamePrefix
	GuiControlGet, RenameIndex
	GuiControlGet, RenameCopy
	
	errors =
	files := A_GuiEvent
	Loop, Parse, files, `n, `r
	{
		RegexMatch(A_LoopField, "(.+\\)(.+)(\.[^.]+)", filename)
		folder := filename1
		ext := filename3
		filename := filename2

		; If you're double-sorting, find the original name:
		If RegexMatch(filename, "([.])(.+)", orig)
			filename := orig1
		
		Index := RenameIndex
		Original := filename
		outFile := folder . SmartFormat(RenamePrefix) . ext
		RegexMatch(outFile, ".+\\", outFolder)
		FileCreateDir %outFolder%

		If (RenameCopy)
			FileCopy %A_LoopField%, %outFile%
		Else
			FileMove %A_LoopField%, %outFile%
		
		If (ErrorLevel)
			errors .= "Couldn't " . ((RenameCopy) ? "copy " : "move ") . A_LoopField . "`n"
		
		RenameIndex++
	}
	
	If (errors != "") {
		Gui, +OwnDialogs
		MsgBox %errors%
	}
	
	GuiControl, , RenameIndex, %RenameIndex%
Return

;EndRegion

;Region " Scanner Helper "

ShowScannerAutomater:
	MsgBox, 0x1000,Scan Helper, Press Space to begin preview & scanning...
Return

#IfWinActive Scan Helper
Space::
	WinWait EPSON Scan
	; ControlSend, ahk_parent, !p
	WinActivate
	Send !p
	
	ToolTip Waiting for Preview to start...
	WinWait Progress
	ToolTip Waiting for Preview to finish...
	Loop
	{
		IfWinNotExist Scan Helper
			Return
		IfWinExist Progress
			Continue
		Sleep 250
		Break
	}
	Sleep 1000
	
	WinWait EPSON Scan
	; ControlSend, ahk_parent, !s
	WinActivate
	Send !s
	
	WinWait File Save Settings
	; ControlSend, ahk_parent, {Enter}
	WinActivate
	Send {Enter}
	
	
	ToolTip Waiting for Scan to start...
	WinWait Progress
	ToolTip Waiting for Scan to finish...
	Loop
	{
		IfWinNotExist Scan Helper
			Return
		IfWinExist Progress
			Continue
		Sleep 250
		Break
	}
	
	ToolTip Press Space to scan another.
	SoundBeep
	WinActivate Scan Helper
Return

#IfWinActive

;EndRegion
