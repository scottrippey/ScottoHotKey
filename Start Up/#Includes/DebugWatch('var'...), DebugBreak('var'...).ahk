; auto-execute

	; SetTimer Debug_Test, -500
; Return
; Debug_Test:
	; variableA = WOAH!
	; DebugBreak("First = Scott", "Middle = William", "Last = Rippey", "variableA")
	; MsgBox Break Done
	DebugWriteMessage = Script Initialized`n
Return

;;; Syntax:
;;;   DebugWrite("Title", "variableA", "variableB", ...)
;;;   OR
;;;   DebugWrite("Title", "Value of A = " . variableA, "Value of B = " . variableB, ...)
;;;   (the second method allows you to perform calculations)
DebugWrite(message, varName1 = "", varName2 = "", varName3 = "", varName4 = "", varName5 = "") {
	Global
	
	If message =
		DebugWriteMessage =
	DebugWriteMessage .= message
	Loop, 5
	{	
		If (varName%A_Index% = "")
			break
		varName := varName%A_Index%
		If (InStr(varName, "="))
			varValue := SubStr(varName, InStr(varName, "=") + 1)
		Else
			varValue := %varName%
			
		DebugWriteMessage .= ",`t" . varName . ": " . varValue
	}
	DebugWriteMessage .= "`n"
	
	windowGUIKey := "Debug Write Window"
	DebugWatch(DebugWriteMessage, varName1, varName2, varName3, varName4, varName5, windowGUIKey, false)
}


;;; Syntax:
;;;   DebugBreak("Title", "variableA", "variableB", ...)
;;;   OR
;;;   DebugBreak("Title", "Value of A = " . variableA, "Value of B = " . variableB, ...)
;;;   (the second method allows you to perform calculations)
DebugBreak(message, varName1 = "", varName2 = "", varName3 = "", varName4 = "", varName5 = "") {
	If GetKeyState("ScrollLock", "T") {
		windowGUIKey := "AHK Debug Break Window"
		DebugWatch(message, varName1, varName2, varName3, varName4, varName5, windowGUIKey, false)
		WinWaitClose %windowGUIKey%
		GuiUniqueDestroy(windowGUIKey)
		; MsgBox,
		; (ltrim
			; Breakpoint hit in "%A_ThisLabel%".
			; Deactivate Scroll Lock to disable breakpoints.
		; )

	} Else {
		msg =
		(ltrim
			Activate ScrollLock to enable the breakpoint at %A_ThisLabel%.
			%varName1%
			%varName2%
			%varName3%
			%varName4%
			%varName5%
		)
		ShowToolTip(msg, 5000)
	}
}
;;; Syntax:
;;;   DebugWatch("Title", "variableA", "variableB", ...)
;;;   OR
;;;   DebugWatch("Title", "Value of A = " . variableA, "Value of B = " . variableB, ...)
;;;   (the second method allows you to perform calculations)
DebugWatch(message, varName1 = "", varName2 = "", varName3 = "", varName4 = "", varName5 = "", windowGUIKey = "Debug Window", autoUpdate = true) {
	Global
	; Global lblDebugVarName1, lblDebugVarName2, lblDebugVarName3, lblDebugVarName4, lblDebugVarName5
	; Global lblDebugVarValue1, lblDebugVarValue2, lblDebugVarValue3, lblDebugVarValue4, lblDebugVarValue5
	GuiUniqueDestroy(windowGUIKey)
	GuiUniqueDefault(windowGUIKey)
	
	Gui, Add, Text, , %message%
	
	Loop, 5
	{	
		varName := varName%A_Index%
		If varName =
			break
		If varName Contains =
		{	StringSplit s, varName, =, %A_Space%%A_Tab%
			varName := s1
			varValue := s2
		} Else
			varValue := %varName%
		
		; Put the values into the GUI:
		If A_Index = 1
			options = section
		Else
			options = ys

		Gui, Add, Text, %options% vlblDebugVarName%A_Index%, %varName%
		Gui, Add, Text,          vlblDebugVarValue%A_Index%, %varValue%
	}

	If (autoUpdate)
		SetTimer DebugWindow_Refresh, 100
	Else
	{	;Gui, Add, Button, section gDebugWindow_Refresh, Refresh
		Gui, Add, Button, ys default gDebugWindow_Close, &OK
	}

	Gui +AlwaysOnTop
	Gui, Show, NA, %windowGUIKey%
	

	Static swindowGUIKey
	swindowGUIKey := windowGUIKey
	
	Return
	DebugWindow_Refresh:
		GuiUniqueDefault(swindowGUIKey) ;"Debug Window")
		Loop, 5
		{
			GuiControlGet lblDebugVarName%A_Index%
			varName := lblDebugVarName%A_Index%

			If varName =
				break
			varValue := %varName%

			; Put the values into the GUI:
			GuiControl, , lblDebugVarValue%A_Index%, %varValue%
		}
	Return
}


DebugWindow_Escape:
DebugWindow_Close:
	;GuiUniqueDestroy("Debug Window")
	GuiUniqueDestroy() ;"Debug Window")
	SetTimer DebugWindow_Refresh, Off
	DebugWriteMessage =
Return





