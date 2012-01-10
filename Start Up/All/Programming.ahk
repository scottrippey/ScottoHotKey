;Sending Mouse Clicks:
; Commands: Click X, y ; MouseMove x,y ; MouseClickDrag
; Click [up|down|U|D] [relative|rel] [left|right|middle|l|r|m|x1|x2|wheelUp|WheelDown|WU|WD] [x,y|%varX%,%varY%][count]
; x, y are relative to the active window


#IfWinActive ahk_class SciTEWindow 							;Region " SciTE "
	^s::
;EndRegion

#IfWinActive ahk_class Notepad++ 							;Region " Notepad++ "
	^s::
		Send ^s
		WinGetActiveTitle OpenFile
		If RegexMatch(OpenFile, "i)\\Start Up\\.*\.ahk ")
		{	;If we're in Notepad++ editing an AHK file and we press Ctrl+S to save, we should automatically reload AHK!
			ToolTip Reloading...
			Sleep 500
			Reload
		}
	Return
	^x::
		actions =
		(ltrim comments
			=^x,500
			Cut Line={Up}{End}{Right}+{Down}^x,1000
			Cancel:,0
		)
		PressAndHold("x", actions)
	Return
	^c::
		actions =
		(ltrim comments
			=^c,500
			Copy Line={Up}{End}{Right}+{Down}^c,1000
			Cancel:,0
		)
		PressAndHold("c", actions)
	Return

	^=::^NumPadAdd
	^-::^NumPadSub

	^g:: ; (Go To Definition)
		Send {Left}{Right 2}^{Left}^+{Right}
		Send ^f
		Send {End}:
		Send {Enter}
		
		WinWait Find, Can't find the text, .2
		If ErrorLevel = 0
		{	WinActivate
			Send {Enter}
			WinActivate Find
			Send {End}{Backspace}{Home}Dim{Space}
			Send {Enter}
		}
		WinWait Find, Can't find the text, .2
		If ErrorLevel = 0
		{	WinActivate
			Send {Enter}
			WinActivate Find
			Send {Home}{Delete 3}Symbol
			Send {Enter}
		}
		WinWait Find, Can't find the text, .2
		If ErrorLevel = 0
		{	WinActivate
			Send {Enter}
			WinActivate Find
			Send {Home}{Delete 6}Define
			Send {Enter}
		}
		WinWait Find, Can't find the text, .2
		If ErrorLevel = 0
		{	Send {Enter}
			WinActivate Find
			ShowToolTip("Couldn't find the definition.")
		}

		Send {Esc}
	Return

	+F8::Send !vmm{Enter} ; Move to new window

;EndRegion

#IfWinActive Toad for SQL Server 							;Region " Toad "
	
	^w::Send ^{F4}
	^'::Send ^k^c
	^+'::Send ^k^u
	
;EndRegion

#IfWinActive Microsoft SQL Server Management Studio 		;Region " SQL Server (SSMS) "
	F5::Send {F5} ; (Overrides the Visual Studio F5 enhancement below)
	
	
;EndRegion

#IfWinActive Microsoft Visual Studio 						;Region " Visual Studio "

	;Region " Keyboard Normalization "
	
	^f:: ;Region
		Send ^f
		Send !l{Home} ; Choose "Current Document" always
		Send !n ; re-Focus the find textbox
	Return ;EndRegion
	^+f:: ;Region
		Send ^f
		Send !l{End} ; Choose "Entire Solution"
		Send !n ; re-Focus the find textbox
	Return ;EndRegion
	
	
	;^w::^F4
	
	;-----Keyboard Remaps-----
	;!right::Send {F11}       ; changes the "forward" button into Step-Into
	;!left::Send {F10}		 ; changes the "back" button to Step-Over

	;EndRegion

	;Region " Special Quotes "	
	
	;---------HotKeys---------
	#+s:: ;Region
		ToInsert := "Smart.Format("
		GoTo InsertBeforeQuote ;EndRegion
	#s:: ;Region
		ToInsert := "string.Format("

		InsertBeforeQuote:
		GoSub BackupClipboard
		;When you press this hotkey, String.Format will be inserted before the string that you just started typing!
		ShowToolTip("Inserting " . ToInsert . "...")
		SendInput +{Home}
		ClipBoard =
		SendInput ^c
		ClipWait 1
		;Find the previous "
		
		qPos := StrLen(Clipboard) - Instr(Clipboard, """", false, 0) + 1 ;search in reverse
		SendInput {Right}
		SendInput {Left %qPos%}

		SendInput {Raw}%ToInsert%
		SendInput {Right %qPos%}
		
		GoSub RestoreClipboard
	Return ;EndRegion
	#q:: ;Region
		GoSub BackupClipboard
		
		; When you press this hotkey, the string will be selected from quote to quote
		ShowToolTip("Selecting from Quote to Quote...")
		SendInput +{Home}
		ClipBoard =
		SendInput ^c
		ClipWait 1
		; Find previous "
		clip := ClipBoard
		qPos := StrLen(clip) - Instr(clip, """", false, 0) ;search in reverse
		
		SendInput {Right}
		SendInput {Left %qPos%}

		SendInput +{End}
		ClipBoard =
		SendInput ^c
		ClipWait 1
		; Find next "
		clip := ClipBoard
		qPos2 := StrLen(clip) - Instr(clip, """", false, 1) + 1 
		
		SendInput +{Left %qPos2%}

		GoSub RestoreClipboard
	Return ;EndRegion
	
	;EndRegion

	;Region " Snippets "

	; :b0:/// <s::summary>`n/// `n/// </summary>`n/// <param name="param1" type="Number"> _ </param>`n/// <returns type="Number" />{Up 3}
	; :b0:/// <p::param name="param2" type="Number" integer="true"> _ </param>^{Left 12}^+{Left}
	; :b0:/// <f::field name="field1" type="String"> _ </field>^{Left 12}^+{Left}
	; :b0:/// <r::returns type="Number"> _ </returns>^{Left 7}^+{Left}
	
	; :b0:<script :: type="text/javascript" src">{Left 2}="	;";"
	
	; :b0:<% if :: () {{}{Delete}{End}{Enter}<% {}}^z{Up}{Right 2}
	; :b0:<% foreach :: () {{}{Delete}{End}{Enter}<% {}}^z{Up}{Right 7}
	:b0:<% }::{}}^z			;%;%;%
	:b0?:>`n::{Enter}{Up}{End}{Enter}{Tab}

	;:b0:#end#::region`n`n{#}region:  :{Left 2}
	
	
	;%;%;%
	;EndRegion
	
	;Region " Misc Shortcuts "
	
		CapsLock & 3::
		; ^Up::
			SendInput ^{Up 3}
		Return
		CapsLock & c::
		; ^Down::
			SendInput ^{Down 3}
		Return
		; ^!NumPadSub::Send ^{F2}^{NumPadSub}{F2}^{F2}
		; =::
			; actions =
			; (ltrim comments
				; ={=},500
				; Ctrl++=^{=},1000
				; Cancel:,0
			; )
			; PressAndHold("=", actions)
		; Return
		; -::
			; actions =
			; (ltrim comments
				; ={-},500
				; Ctrl+-=^{-},1000
				; Cancel:,0
			; )
			; PressAndHold("-", actions)
		; Return
		
	
	;EndRegion

	;Region " Resharper Unit-Tests "
	
		!F5::
			Send !ruc ; Resharper > Unit Tests > Run Current
			ShowToolTip("Running Current Session Unit Tests...")
		Return
		!F10:: ; Run Selected Tests
			dx := 55
			dy := 15
			GoTo ClickUnitTestSession
		!F11:: ; Debug Selected Tests
			dx := 80
			dy := 15
			GoTo ClickUnitTestSession
		ClickUnitTestSession:
			; Get the position of the Unit Tests window (docked or undocked)
			If (WinExist("Unit Test Sessions - Session #"))
				WinActivate
			
			; Get the position of the Unit Tests toolbar
			unitTestsToolbar := "WindowsForms10.Window.8.app.0.179a6ef17"
			ControlGetPos, x, y, , , %unitTestsToolbar%, A
			If (x = "" OR y = "")
			{
				; There are no unit tests
				Send ^!t ; Show "Unit Test Sessions" tool window
				Return
			}
			
			x += dx ; Locate the correct button
			y += dy
			Click, %x%, %y%
		Return
	
	;EndRegion

	
;EndRegion

#IfWinActive ahk_class FrontPageExplorerWindow40 			;Region " Expression Web "
	^1::Send ^+s{Home}{Down 2}{Enter} ; H1
	^2::Send ^+s{Home}{Down 3}{Enter} ; H2
	^3::Send ^+s{Home}{Down 4}{Enter} ; H3
	^4::Send ^+s{Home}{Down 5}{Enter}
	^5::Send ^+s{Home}{Down 6}{Enter}
	^6::Send ^+s{Home}{Down 7}{Enter}


;EndRegion






#IFWinActive 
