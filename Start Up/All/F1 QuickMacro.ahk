	;Region " Auto-Execute "
		MacroText = 
		MacroRecording := false
		MacroRecordMouse := false
		MacroPatternDetect := false
		MacroIndex := 0
		MacroPartialLength := 0
		; MacroPosX := -1500
		; MacroPosY := -100
		; GoSub QuickMacroShowTiny
		; MacroPosY := 200
		; GoSub QuickMacroShowSmall
		; MacroPosY := 500
		; GoSub QuickMacroShowFull
		MacroPosX := 0
		MacroPosY := 0
		
		MacroSpecialCommands =
		(ltrim %
			Sleep:QuickMacroSleep 		: {Sleep 500}
			Pause:QuickMacroPause 		: {Pause TOOLTIP}
			Choose:QuickMacroChoose		: {Choose Choice1|Choice2|Choice3}
			ToolTip:ShowToolTip			: {ToolTip TOOLTIP}
			CQNext:NextClip				: {CQNext}
			CQPrev:PrevClip				: {CQPrev}
			CQPasteNext:ClipQueuePasteNext : {CQPasteNext}
			CQPaste:QuickMacroClipQueuePaste		: {CQPaste}
			CQSupress:CQSuspendMonitor	: {CQSupress}
			CQShow:ShowClipQueueWindow	: {CQShow}
		) ;%
		MacroShortcuts =
		(ltrim %
			Keyboard Shortcuts:
			Ctrl+F1		Open QuickMacro (Small) and record
			 +Shift		(Tiny)
			 +Alt		(Capture Mouse and Patterns)
			
			Ctrl+F1		Toggle Recording
			
			F1		Execute the QuickMacro
			
			Ctrl+0		Reset [Index]
			Ctrl+1		Reset the QuickMacro
			Ctrl+2		Toggle Pattern Detection
			Ctrl+3		Reset Partial Length
		) ;%
		
		RegisterTool("QuickMacroShowFull", "&Quick Macro", "")
	Return ;EndRegion

	;Region " Shortcuts "
	^F1:: ; Show small, record
		MacroText =
		MacroPatternDetect := false
		MacroRecordMouse := false
		GoSub QuickMacroShowSmall
		GoSub QuickMacroRecordStart
	Return
	^+F1:: ; Show tiny, record
		MacroText =
		MacroPatternDetect := false
		MacroRecordMouse := false
		GoSub QuickMacroShowTiny
		GoSub QuickMacroRecordStart
	Return
	^!F1:: ;Show small, record, patterns & mouse on
		MacroText =
		MacroPatternDetect := true
		MacroRecordMouse := true
		GoSub QuickMacroShowSmall
		GoSub QuickMacroRecordStart
	Return
	^+!F1:: ;Show full
		GoSub QuickMacroShowFull
	Return
	
	#IfWinExist Quick Macro...
		^Esc::
			If (MacroRecording) {
				; Stop Recording
				GoSub QuickMacroRecordEnd
			} Else {
				; Close QuickMacro
				GoSub QuickMacroClose
			}
		Return
		^0::
		^NumPad0:: 
		QuickMacroResetIndex: ; Reset Index
			GuiUniqueDefault("QuickMacro")
			GoSub QuickMacroIndexReset_Click
		Return
		^1::
		^NumPad1:: ; Reset Macro
		QuickMacroResetMacro:
			GuiUniqueDefault("QuickMacro")
			GoSub QuickMacroClear_Click
		Return
		^2::
		^NumPad2::
		QuickMacroPatternToggle: ; Toggle Detect Patterns
			GuiUniqueDefault("QuickMacro")
			GuiControlGet MacroPatternDetect
			MacroPatternDetect := !MacroPatternDetect
			GuiControl, , MacroPatternDetect, %MacroPatternDetect%
			GoSub QuickMacroPatternDetect_Click
		Return
		^3::
		^NumPad3::
		QuickMacroResetPartial:
			GuiUniqueDefault("QuickMacro")
			GoSub QuickMacroPartialLengthReset_Click			
		Return
		^F1:: ; Toggle Recording mode
			GuiUniqueDefault("QuickMacro")
			GoSub QuickMacroRecordToggle
			If (!MacroRecording) {
				WinActivate
				GuiControl, Focus, MacroText
			}
		Return
		F1::
			If (MacroRecord)
				GoTo QuickMacroRecordEnd
			
			GoTo QuickMacroRun
		Return
		QuickMacroRun:
			GuiUniqueDefault("QuickMacro")
			GoSub RunQuickMacro
		Return
		QuickMacroClose:
			GuiUniqueDefault("QuickMacro")
			GoSub QuickMacro_Close
		Return
	#IfWinExist
	;EndRegion

	;Region " GUI "
	
	QuickMacroShowTiny:
		Tiny := true
		Small := true
		GoTo _QuickMacroShow
	QuickMacroShowSmall:
		Tiny := false
		Small := true
		GoTo _QuickMacroShow
	QuickMacroShowFull:
		Tiny := false
		Small := false
		GoTo _QuickMacroShow
	_QuickMacroShow:
		QuickMacroPreviousWindow := WinExist("A") ; Take note of the Active window
		
		GuiUniqueDestroy("QuickMacro")
		GuiUniqueDefault("QuickMacro")
		GuiShowTooltips(true)

		y := 10
		w := (Tiny) ? 150 : (Small) ? 270 : 400
		h := (Small) ? 37 : 70
		
		If (!Tiny) {
			; Recording:
			Gui, Add, GroupBox, x10 y%y% w%w% h43, % "Record a sequence:" ;%
			y += 43 +5
			Gui, Add, Text, xp+3 yp+16 wp-6 hp-19 Section ; Create a new section inside the GroupBox
				Gui, Add, Button, vMacroRecord gQuickMacroRecord_Click xs ys h25, % "Start Recording" ;%		; (Ctrl+F1)
					MacroRecord_TT := " Captures all input and adds it to the current sequence.`n Press and hold Backspace to undo the last typed key."
				Gui, Add, CheckBox, vMacroRecordMouse Checked%MacroRecordMouse% xs+110 yp hp, % "Capture Mouse Clicks" ;%
					MacroRecordMouse_TT := "When enabled, all mouse clicks will be captured. `nIf disabled, you can still press and hold a mouse button to capture it.`nCoordinates are relative to the active window."
				;Gui, Add, Button, gQuickMacroPlay_Click xs y+5 wp, Play this Macro (F1)
		}
		
		; MacroText:
		; Gui, Add, Text, vMacroTextLabel gDoNothing w320, Type a series of keystrokes:
		
		groupText := (Tiny) ? "Enter a sequence:" : "or manually enter the sequence:"
		Gui, Add, GroupBox, x10 y%y% w%w% h%h%, %groupText%
		y += h +5
		Gui, Add, Text, xp+3 yp+16 wp-6 hp-19 Section ; Create a new section inside the GroupBox
			Gui, Add, Edit, vMacroText gQuickMacroText_Changed xp yp wp hp, %MacroText%
				MacroText_TT = 
				(ltrim %
					Enter a sequence of keystrokes here, and press F1 to send the sequence.
					You can send special keys by surrounding them with {Curly Braces}, such as: 
					`t {Home} 
					`t {F4} 
					`t {NumPadMult} 
					Linefeeds are ignored.  Use {Enter} instead.
					There are also some special commands: 
					`t {Sleep 500}	- waits for a short duration 
					`t {Pause}   	- sends part of the sequence, and waits for you to press F1 again to send the rest
					`t [Index]   	- inserts an auto-incrementing value into the text
					`t [Index + 5 * 2]	- supports equations!
					`t [Index:Zero|One|Two|Three]	- supports conditional formatting!
					`t
					`t {CQNext} {CQPrev} {CQPaste} {CQPasteNext} {CQSupress} {CQShow} 	- Clipboard Queue Integration
				) ;%
			If (!Tiny) {
				; x := w -60 -5 -60 -5 -60 -6
				; Gui, Add, Button, vMacroClear gQuickMacroClear_Click xs+%x% ys-16 w60 h16, % "Reset" ;% ;(Ctrl+1)
					; MacroClear_TT := "Clear the sequence"
				; Gui, Add, Button, vMacroCopy gQuickMacroCopy_Click x+5 ys-16 w60 h16, % "Copy" ;%
					; MacroCopy_TT := "Copy the sequence to the clipboard"
				x := w -60 -6
				Gui, Add, Button, vMacroFunc gQuickMacroFunc_Click xs+%x% ys-16 w60 h16, % "Edit »" ;%
					MacroFunc_TT := "Special functions, such as Copy, Paste, Clear, and Save » "
			}
	
		If (!Tiny) {
			; Pattern Guessing:
			ph := h +3 +16 
			Gui, Add, GroupBox, x10 y%y% w%w% h%ph%, % "Pattern Detection:" ;%
			y += ph +5
			Gui, Add, Text, xp+3 yp+16 wp-6 hp-19 Section ; Create a new section inside the GroupBox
				ph := h -19
				Gui, Add, Edit, vMacroPattern ReadOnly xp yp wp h%ph%,
				Gui, Add, CheckBox, vMacroPatternDetect gQuickMacroPatternDetect_Click Checked%MacroPatternDetect% xs+110 ys-16 h16, % "Enabled" ;%
					MacroPatternDetect_TT := " Automatically detects patterns in the sequence, `n and generates a sequence that repeats the pattern. `n Patterns can consist of either numbers or recognized phrases, `n such as months or days of the week. `n (Shortcut: Ctrl+2)"
					MacroPatternDetect0 := 1-MacroPatternDetect
				x := w -60 -6
				Gui, Add, Button, vMacroPatternEdit gQuickMacroPatternEdit_Click Disabled%MacroPatternDetect0% xs+%x% ys-16 w60 h16, % "Edit" ;%
					MacroPatternEdit_TT := "Replaces the sequence with this pattern, allowing editing"
				
				; Index:
				py := ph +3
				Gui, Add, Text, vMacroIndexLabel gDoNothing xs ys+%py% h16, % "[Index]:" ;%
					MacroIndexLabel_TT := " If [Index] is present in your sequence, it will be replaced with this value. `n Equations can also be inserted, such as [Index+1], [Index*5], [Index*5+1], etc. `n Supported operators are: + (add), - (subtract), * (multiply), / (divide), ^ (power), % (modulus)"
					Gui, Add, Edit, x+5 yp w50 hp, %MacroIndex%
					Gui, Add, UpDown, vMacroIndex gQuickMacroIndex_Changed Range0-2147483647, %MacroIndex%
					Gui, Add, Button, vMacroIndexReset gQuickMacroIndexReset_Click x+5 yp w40 hp, % "Reset" ;%
						MacroIndexReset_TT := "Reset the [Index] to 0 (Ctrl+0)"
		}

		
		If (!Tiny) {
			; Preview Text:
			Gui, Add, GroupBox, x10 y%y% w%w% h%h%, % (Small) ? "Press F1 to send:" : "Press F1 to send the following sequence:" ;%
			y += h +5
			Gui, Add, Text, xp+3 yp+16 wp-6 hp-19 Section ; Create a new section inside the GroupBox
				Gui, Add, Edit, ReadOnly vMacroPreview xp yp wp hp,
				x := w -90 -5 -60 -6
				Gui, Add, Text, vMacroPartialLength gDoNothing xs+%x% ys-16 w90 h16,
					MacroPartialLength_TT = "The Partial Length indicates how much of the sequence has already been sent."
				Gui, Add, Button, vMacroPartialLengthReset gQuickMacroPartialLengthReset_Click Enabled%MacroPartialLength% x+5 ys-16 w60 h16, % "Reset" ;%
					MacroPartialLengthReset_TT := "Resets the Partial Length so that the entire sequence will be sent."
				
				If (MacroPatternDetect)
					GoSub AnalyzeMacroPatterns
				GoSub CreateMacroPreview
		}
		
		; "Resizing" Buttons:
		x := 10 + ((Tiny) ? 150 -16 : 270 -16 -2 -16)
		If (!Tiny)
			Gui, Add, Button, vQuickMacroTiny gQuickMacroTiny_Click x%x% y0 w16 h16, % "^" ;%
		If (Tiny)
			Gui, Add, Button, vQuickMacroExpand gQuickMacroCollapse_Click x%x% y0 w16 h16, % "»" ;%
		Else If (Small)
			Gui, Add, Button, vQuickMacroExpand gQuickMacroExpand_Click x+2 y0 w16 h16, % "»" ;%
		Else
			Gui, Add, Button, vQuickMacroCollapse gQuickMacroCollapse_Click x+2 y0 w16 h16, % "«" ;%
		QuickMacroExpand_TT := "Make this window larger »"
		QuickMacroCollapse_TT := "« Make this window smaller"
		QuickMacroTiny_TT := "^ Make this window tiny"
		



		If (!Small) {
			; Shortcut help:
			x := w+10
			Gui, Add, Text, x%x% y0, %MacroShortcuts%
		}
		
		; Display the window:
		Gui +LastFound
		WinSet Transparent, 230
		Gui +AlwaysOnTop
		Gui, Show, NoActivate x%MacroPosX% y%MacroPosY%, % "Quick Macro..." ;%
	Return
	
	
	
	
	
	
	
	
	
	QuickMacro_Close:
	QuickMacro_Escape:
		GoSub QuickMacroRecordEnd
		GuiShowTooltips(false)
		GuiUniqueDestroy("QuickMacro")
	Return
	
	
	
	QuickMacroFunc_Click:
		GoSub QuickMacroRecordEnd
		
		; Show the Func menu:
		
		; Reset Menus:
		Menu, QuickMacroFunc, Add
		Menu, QuickMacroFunc, Delete
		
		
		; ; Save Menu, Load Menu:
		; Menu, QuickMacroFuncSave, Add
		; Menu, QuickMacroFuncSave, Delete
		; Menu, QuickMacroFuncLoad, Add
		; Menu, QuickMacroFuncLoad, Delete
		; Menu, QuickMacroFuncDelete, Add
		; Menu, QuickMacroFuncDelete, Delete
		; hasFiles := false
		; Menu, QuickMacroFuncSave, Add, Save As..., QuickMacroSaveAs_Click
		; Loop, %A_AppData%\AutoHotKey\QuickMacro\*.txt
		; {	
			; If (!hasFiles) {
				; Menu, QuickMacroFuncSave, Add
				; hasFiles := true
			; }
		
			; RegexMatch(A_LoopFileName, "(.+)[.]txt", filename)
			; ; Add this to the Save, Load, and Delete menus:
			; Menu, QuickMacroFuncSave, Add, %filename1%, QuickMacroSave_Click
			; Menu, QuickMacroFuncLoad, Add, %filename1%, QuickMacroLoad_Click
			; Menu, QuickMacroFuncDelete, Add, %filename1%, QuickMacroDelete_Click
		; }
		; If (!hasFiles) {
			; Menu, QuickMacroFuncLoad, Add, (no saved files), DoNothing
			; Menu, QuickMacroFuncLoad, Disable, (no saved files)
			; Menu, QuickMacroFuncDelete, Add, (no saved files), DoNothing
			; Menu, QuickMacroFuncDelete, Disable, (no saved files)
		; }
		; Menu, QuickMacroFunc, Add, Save, :QuickMacroFuncSave
		; Menu, QuickMacroFunc, Add, Load, :QuickMacroFuncLoad
		; Menu, QuickMacroFunc, Add, Delete, :QuickMacroFuncDelete
		
		; Save Menu, Load Menu:
		; Menu, QuickMacroFuncItemCommands, Add
		; Menu, QuickMacroFuncItemCommands, Delete
		; Menu, QuickMacroFuncItemCommands, Add, Load, QuickMacroLoad_Click
		; Menu, QuickMacroFuncItemCommands, Add, Overwrite, QuickMacroSave_Click
		; Menu, QuickMacroFuncItemCommands, Add, Delete, QuickMacroDelete_Click
		hasFiles := false
		Loop, %A_AppData%\AutoHotKey\QuickMacro\*.txt
		{	
			If (!hasFiles) {
				hasFiles := true
			}
		
			RegexMatch(A_LoopFileName, "(.+)[.]txt", filename)
			
			; Create commands:
			; Add this to the Save, Load, and Delete menus:
			; Reset:
			Menu, QuickMacroFuncItem%filename1%, Add 
			Menu, QuickMacroFuncItem%filename1%, Delete
			
			; Item > Load
			Menu, QuickMacroFuncItem%filename1%, Add, Load, QuickMacroLoad_Click
			; Item > -----
			Menu, QuickMacroFuncItem%filename1%, Add
			; Item > Overwrite > Confirm
			Menu, QuickMacroFuncItemSave%filename1%, Add, Confirm, QuickMacroSave_Click
			Menu, QuickMacroFuncItem%filename1%, Add, Overwrite, :QuickMacroFuncItemSave%filename1% ;QuickMacroLoad_Click
			; Item > Delete > Confirm
			Menu, QuickMacroFuncItemDelete%filename1%, Add, Confirm, QuickMacroDelete_Click
			Menu, QuickMacroFuncItem%filename1%, Add, Delete, :QuickMacroFuncItemDelete%filename1% ;QuickMacroDelete_Click
			; Item
			Menu, QuickMacroFunc, Add, %filename1%, :QuickMacroFuncItem%filename1%
		}
		If (!hasFiles) {
			Menu, QuickMacroFunc, Add, (no saved files), DoNothing
			Menu, QuickMacroFunc, Disable, (no saved files)
		}
		

		
		
		; Create the Insert menu:
		Menu, QuickMacroFuncInsert, Add ; Reset this menu
		Menu, QuickMacroFuncInsert, Delete
		; Create a list of recognized special commands:
		SpecialCommands =
		Loop, parse, MacroSpecialCommands, `n, `r%A_Space%
		{
			StringSplit, cmd, A_LoopField, :, %A_Space%%A_Tab%
			Menu, QuickMacroFuncInsert, Add, %cmd3%, QuickMacroFuncInsert_Click
		}
		
		
		; Other Funcs:
		Menu, QuickMacroFunc, Add, Save As..., QuickMacroSaveAs_Click
		Menu, QuickMacroFunc, Add ; Separator
		Menu, QuickMacroFunc, Add, Insert, :QuickMacroFuncInsert
		Menu, QuickMacroFunc, Add, Copy to Clipboard, QuickMacroCopy_Click
		Menu, QuickMacroFunc, Add, Reset, QuickMacroClear_Click
		
		; Show the Menu to the right of the button:
		GuiControlGet, MacroFunc, Pos
		x := MacroFuncX + MacroFuncW
		y := MacroFuncY + 20
		Menu, QuickMacroFunc, Show, %x%, %y%
	Return
	QuickMacroSaveAs_Click:
	QuickMacroSave_Click:
		GuiUniqueDefault("QuickMacro")
		If (A_ThisMenuItem = "Save As...") {
			Gui, +OwnDialogs
			InputBox, filename, Save QuickMacro..., Please enter a name for this QuickMacro:,,,,,,,,%QuickMacroFile%
			filename := RegexReplace(filename, "[\\/:*?""<>|]", "")
			If (ErrorLevel OR filename = "")
				Return

			QuickMacroFile := filename
		} Else {
			; QuickMacroFile := A_ThisMenuItem
			QuickMacroFile := SubStr(A_ThisMenu, StrLen("QuickMacroFuncItemSave") + 1)
		}
		
		GuiControlGet, MacroText
		
		FileCreateDir %A_AppData%\AutoHotKey\QuickMacro
		filename = %A_AppData%\AutoHotKey\QuickMacro\%QuickMacroFile%.txt
		IfExist %filename%
			FileDelete %filename%
		FileAppend, %MacroText%, %filename%
	Return
	QuickMacroLoad_Click:
		; QuickMacroFile := A_ThisMenuItem
		QuickMacroFile := SubStr(A_ThisMenu, StrLen("QuickMacroFuncItem") + 1)
		filename = %A_AppData%\AutoHotKey\QuickMacro\%QuickMacroFile%.txt
		FileRead, MacroText, %filename%

		GuiUniqueDefault("QuickMacro")
		GuiControl, , MacroText, %MacroText%
	Return
	QuickMacroDelete_Click:
		; QuickMacroFile := A_ThisMenuItem
		QuickMacroFile := SubStr(A_ThisMenu, StrLen("QuickMacroFuncItemDelete") + 1)
		filename = %A_AppData%\AutoHotKey\QuickMacro\%QuickMacroFile%.txt
		IfExist %filename%
			FileDelete %filename%
	Return
	QuickMacroFuncInsert_Click:
		GuiUniqueDefault("QuickMacro")
		GuiControlGet MacroText
		MacroText .= A_ThisMenuItem
		GuiControl, , MacroText, %MacroText%
	Return
	QuickMacroCopy_Click:
		GuiUniqueDefault("QuickMacro")
		GuiControlGet MacroText
		clipboard := MacroText
	Return
	QuickMacroClear_Click:
		GuiUniqueDefault("QuickMacro")
		GuiControl, , MacroText,
		GuiControl, , MacroIndex, 0
		GoSub QuickMacroText_Changed
	Return
	
	
	
	QuickMacroPatternEdit_Click:
		GuiControlGet MacroPattern
		MacroText := MacroPattern
		GuiControl, , MacroText, %MacroPattern%
		GuiControl, , MacroPattern, 
		GuiControl, , MacroPatternDetect, 0
		GuiControl, Disabled, MacroPatternEdit
		
		GuiControl, Focus, MacroText
		Send ^a ; Wish I knew a better way!
	Return
	
	QuickMacroRecord_Click:
		GoSub QuickMacroRecordToggle
	Return
	; QuickMacroPlay_Click:
		; GoSub RunQuickMacro
	; Return
	QuickMacroIndexReset_Click:
		GuiControl, , MacroIndex, 0
		GoSub QuickMacroIndex_Changed
	Return

	QuickMacroPatternDetect_Click:
		GuiControlGet, MacroPatternDetect
		GuiControl, Enabled%MacroPatternDetect%, MacroPatternEdit
		GuiControl, , MacroPattern,
		; Fall-through:
	QuickMacroText_Changed:
		MacroPartialLength := 0
		If (MacroPatternDetect)
			GoSub AnalyzeMacroPatterns
		; Fall-through:
	QuickMacroIndex_Changed:
		GoSub CreateMacroPreview
	Return

	QuickMacroTiny_Click:
		GoSub _QuickMacro_GetPosition
		GoTo QuickMacroShowTiny
	QuickMacroExpand_Click:
		GoSub _QuickMacro_GetPosition
		GoTo QuickMacroShowFull
	QuickMacroCollapse_Click:
		GoSub _QuickMacro_GetPosition
		GoTo QuickMacroShowSmall
	_QuickMacro_GetPosition:
		GoSub QuickMacroRecordEnd
		Gui Submit
		; Get the location of the window:
		Gui +LastFound
		WinGetPos, MacroPosX, MacroPosY
	Return
	
	QuickMacroPartialLengthReset_Click:
		MacroPartialLength := 0
		GoSub CreateMacroPreview
	Return

	CreateMacroPreview:
		GoSub GetMacroPreview
		
		; Update the preview:
		GuiControl, , MacroPreview, %MacroPreview%
		GuiControl, , MacroPartialLength, % "Partial Length: " . MacroPartialLength ;%
		GuiControl, Enable%MacroPartialLength%, MacroPartialLengthReset
	Return
	
	GetMacroPreview:
		; First, determine if we're creating a preview
		; from the MacroText or MacroPattern:
		GuiControlGet, MacroPatternDetect
		If (MacroPatternDetect) {
			GuiControlGet, MacroPattern
			MacroPreview := MacroPattern
		} Else {
			; Get the MacroText
			GuiControlGet, MacroText
			MacroPreview := MacroText
		}
		; Ignore line feeds:
		StringReplace, MacroPreview, MacroPreview, `r`n, , All
		StringReplace, MacroPreview, MacroPreview, `n, , All
		

		; Create the preview by running MacroText through SmartFormat:
		GuiControlGet, MacroIndex
		Index := MacroIndex
		; Apply SmartFormat:
		MacroPreview := SmartFormat(MacroPreview, "[:]")


		; Trim to the partial length:
		If (MacroPartialLength != 0 AND MacroPartialLength < StrLen(MacroPreview))
			MacroPreview := SubStr(MacroPreview, MacroPartialLength+1)
	Return
	
	;EndRegion

	;Region " GUI Capturing "
	
	#IFWinActive Quick Macro...
		Pause::
			If (HasFocus("MacroText", "QuickMacro"))
				SendInput {RAW}{Pause}
			Else
				SendInput {Pause}
		Return
		NumPadEnter::
		Enter::
			If (HasFocus("MacroText", "QuickMacro"))
				SendInput {RAW}{Enter}
			Else
				SendInput {Enter}
		Return
		^Backspace::
			If (HasFocus("MacroText", "QuickMacro"))
				SendInput ^{Left}+^{Right}{BS}
			Else
				SendInput ^{BS}
		Return
		^Delete::
			If (HasFocus("MacroText", "QuickMacro"))
				SendInput ^{Right}+^{Left}{BS}
			Else
				SendInput ^{Delete}
		Return
		HasFocus(varName, guiKey = ""){
			If (guiKey != "")
				GuiUniqueDefault(guiKey)
			GuiControlGet, focused, FocusV
			Return (focused = varName)
		}
	#IfWinActive
	
	;EndRegion
	
	;Region " Recording "

	QuickMacroRecordToggle:
		If (!MacroRecording) {
			GoSub QuickMacroRecordStart
		} Else {
			GoSub QuickMacroRecordEnd
		}
	Return
	QuickMacroRecordStart:
		GuiUniqueDefault("QuickMacro")
		GuiControlGet, MacroRecordMouse
		

		If (QuickMacroPreviousWindow)
			WinActivate ahk_id %QuickMacroPreviousWindow%
	
		MacroRecording := true
		SetTimer CaptureInput, -1

		; Gui +LastFound
		; WinSet Transparent, 128
		GuiControl, , MacroRecord, % "Stop Recording" ;%
		GuiControl, Disable, MacroRecordMouse
		GuiControl, +ReadOnly, MacroText
		; ; Deactivate the window:
		; Gui, Show, Hide, Quick Macro...
		; Gui, Show, NoActivate, Quick Macro...
	Return
	QuickMacroRecordEnd:
		GuiUniqueDefault("QuickMacro")

		MacroRecording := false
		SetTimer CaptureInput, Off

		; Gui +LastFound
		; WinSet Transparent, 230
		GuiControl, , MacroRecord, % "Start Recording" ;%
		GuiControl, Enable, MacroRecordMouse
		GuiControl, -ReadOnly, MacroText
		; Activate the window:
		;Gui, Show, , Quick Macro...
	Return
	
	#IfWinExist Quick Macro...
		Pause::
			PressAndHold("Pause", "Insert a {Pause}:QuickMacroCapturePause|Insert a {Sleep 250}:QuickMacroCaptureSleep250|Insert a {Sleep 1000}:QuickMacroCaptureSleep1000|(Nevermind):,0")
		Return
		QuickMacroCapturePause:
			MacroHotkey := "{Pause}"
			GuiUniqueDefault("QuickMacro")
			GoSub AppendToMacro
		Return
		QuickMacroCaptureSleep250:
			MacroHotkey := "{Sleep 250}"
			GuiUniqueDefault("QuickMacro")
			GoSub AppendToMacro
		Return
		QuickMacroCaptureSleep1000:
			MacroHotkey := "{Sleep 1000}"
			GuiUniqueDefault("QuickMacro")
			GoSub AppendToMacro
		Return
		Backspace::
			If (!MacroRecording) {
				Send {Backspace}
				Return
			}
			PressAndHold("Backspace", ":QuickMacroCaptureBS,1000|Remove last typed key:QuickMacroCaptureRemoveLast|(Nevermind):,0")
		Return
		QuickMacroCaptureRemoveLast:
			; Remove the last key:
			MacroHotkey := "{RemoveLast}"
			GuiUniqueDefault("QuickMacro")
			GoSub AppendToMacro
		Return
		QuickMacroCaptureBS:
			ShowToolTip("(press and hold Backspace to remove the last typed key)")

			Send {Backspace}
			
			; ; Append to the macro:
			; MacroHotkey := "{Backspace}"
			; GuiUniqueDefault("QuickMacro")
			; GoSub AppendToMacro
		Return
		
		~*LButton::
		~*RButton::
		~*MButton::
		~*XButton1::
		~*XButton2::
			If (!MacroRecording)
				Return

			Key := SubStr(A_ThisHotKey, 3) ; Trim the ~*

			If (MacroRecordMouse)
				GoTo QuickMacroCaptureClick
			Else
				PressAndHold(Key, ":QuickMacroCaptureClickTip|Capture " . Key . ":QuickMacroCaptureClick,2000|(Nevermind):,0")
		Return
		QuickMacroCaptureClickTip:
			ShowToolTip("(press and hold the click button to capture the click)")
		Return
		QuickMacroCaptureClick:	
			; Get the coordinates:
			MouseGetPos, x, y
			If (Key = "LButton") {
				Key = {Click %x%,%y%}
			} Else If (Key = "RButton") {
				Key = {Click R %x%,%y%}
			} Else If (Key = "MButton") {
				Key = {Click M %x%,%y%}
			} Else If (Key = "XButton1") {
				Key = {Click X1 %x%,%y%}
			} Else If (Key = "XButton2") {
				Key = {Click X2 %x%,%y%}
			}

			Key := INCLUDESTATE(Key, "Shift")
			Key := INCLUDESTATE(Key, "Control")
			Key := INCLUDESTATE(Key, "Alt")
			Key := INCLUDESTATE(Key, "LWin")

			; Append to the macro:
			GuiUniqueDefault("QuickMacro")
			MacroHotkey := Key
			GoSub AppendToMacro
		Return
	#IfWinExist

	
	CaptureInput:
		If (!MacroRecording)
			Return
	
		; Capture the input:
		; Input, Key, M V L1 T1, {Enter}{Escape}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
		keys =
		(ltrim comments
			{NumPadAdd}{NumPadSub}{NumPadMult}{NumPadDiv}{NumPadEnter}
			;{NumPad0}{NumPad1}{NumPad2}{NumPad3}{NumPad4}{NumPad5}{NumPad6}{NumPad7}{NumPad8}{NumPad9}
			{Enter}{Escape}{BS}{Space}{Tab}
			{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}
			{Left}{Right}{Up}{Down}
			{Home}{End}{PgUp}{PgDn}{Del}{Ins}
			{AppsKey}{Capslock}{Numlock}{PrintScreen}{ScrollLock}
		)
		Input, Key, M V L1 T1, %keys%
		
		If (!MacroRecording) 
			Return

		; Determine what key the user pressed:
		If (ErrorLevel = "Timeout" OR ErrorLevel = "NewInput") 
		{
			SetTimer CaptureInput, -1 ; Try again
			Return
		}
		Else If (ErrorLevel = "Max")
		{
			; The user pressed a normal key:
			
			if Key IN {,},^,+,#,! ; See if this key needs to be escaped
				Key := "{" . Key . "}"
			
			If (GetKeyState("Control")) {
				; Ctrl+key special character conversions:
				; (this is because of the "M" switch)
				if (1 <= Asc(Key) AND Asc(Key) <= 26) {
					Key := Chr(96 + Asc(Key))
				}
			}
			If (1 <= Asc(Key) AND Asc(Key) <= 26) {
				Key := Chr(96 + Asc(Key))
				If (NOT GetKeyState("Control")) {
					Key := "^" . Key ; This fixes ^v compatibility with ClipQueue
				}
			}

		} 
		Else If (InStr(ErrorLevel, "EndKey:"))
		{
			; The user pressed an EndKey
			; Figure out which EndKey:
			StringTrimLeft, Key, ErrorLevel, 7 ; Trim the "EndKey:" text
			Key := "{" . Key . "}"
			
			; Only include Shift when it's an EndKey (in other words, don't include shift with letters and stuff)
			Key := INCLUDESTATE(Key, "Shift")
		}

		Key := INCLUDESTATE(Key, "Control")
		Key := INCLUDESTATE(Key, "Alt")
		Key := INCLUDESTATE(Key, "LWin")
		
		If Key IN ^v
			Key = {CQPaste %cqIndex%}
			
		
		; Append to the macro:
		GuiUniqueDefault("QuickMacro")
		MacroHotkey := Key
		GoSub AppendToMacro

		SetTimer CaptureInput, -1
	Return
	
	
	
	;this method adds {control down}d{control up} to if the user pressed control+d.
	INCLUDESTATE(Key, modifier)
	{
		GetKeyState, state, %modifier%
		if (state = "d")
		{
			;Key = {%modifier% down}%key%{%modifier% up}
			If (modifier = "Shift")
				Key := "+" . Key
			If (modifier = "Control")
				Key := "^" . Key
			If (modifier = "Alt")
				Key := "!" . Key
			If (modifier = "LWin")
				Key := "#" . Key
		}
		return key
	}
	
	AppendToMacro:
		GuiControlGet MacroText

		; If (MacroHotkey = A_Space)
			; MacroHotkey := "{Space}"
		; Else If (MacroHotkey = A_Tab)
			; MacroHotkey := "{Tab}"
		If MacroHotkey = {Space}
			MacroHotkey := A_Space
		; Else If MacroHotkey = {Tab}
			; MacroHotkey := A_Tab
		
		; Append the hotkey to the MacroText:
		; See if we're trying to remove the last key:
		If (MacroHotkey = "{RemoveLast}") {
			If (RegexMatch(MacroText, "([+!^]*){(\w+)( \d+)?}$", LastKey)) {
				; Remove *{LastKey}:
				MacroText := SubStr(MacroText, 1, StrLen(MacroText) - StrLen(LastKey))
				If (LastKey3 != "") {
					; Subtract 1 from *{LastKey #}:
					LastKey3--
					MacroText .= LastKey1 . "{" . LastKey2 . (LastKey3 = 1 ? "" : " " . LastKey3) . "}"
				}
			} Else {
				; Remove *LastKey
				MacroText := RegexReplace(MacroText, "([+!^]*).$", "")
			}
		; See if the last key is the same as this one, so we can combine "{Tab}{Tab}" into "{Tab 2}"
		} Else If (RegexMatch(MacroText, "([+!^]*){(\w+)( \d+)?}$", LastKey) AND RegexMatch(MacroHotkey, "([+!^]*){(\w+)}", ThisKey) AND LastKey1 = ThisKey1 AND LastKey2 = ThisKey2) {
			MacroText := RegexReplace(MacroText, "{(\w+)( \d+)?}$", "{$1 " . (LastKey3 = "" ? 2 : LastKey3 + 1) . "}")
		} Else {
			MacroText .= MacroHotkey
		}
		
		GuiControl, , MacroText, %MacroText%
		GuiControl, Focus, MacroHotkey
		
		GoSub QuickMacroText_Changed
	Return
	
	;EndRegion

	;Region " Pattern Analysis "
	
	AnalyzeMacroPatterns:
		; Get the MacroText:
		GuiControlGet MacroText
		
		; Split the pattern at every un-nested word break:
		; RegexSplit:
		lastPos = 1
		pattern0 = 0
		Loop
		{
			lastPos := RegexMatch(MacroText, "\w+|{[^}]*}|[^{]", pattern%A_Index%, lastPos)
			If (!lastPos)
				Break
			pattern0++
			lastPos += StrLen(pattern%A_Index%)
		}
		If (pattern0 = 0) {
			GuiControl, , MacroPattern, 
			Return
		}
		
		
		
		
		
		
		; Search for patterns:

		
		; Determine which items are sequential:
		Loop, %pattern0%
		{
			pi := A_Index
			p := pattern%pi%
			
			patternType%pi% := "L" ; Literal text
			patternValue%pi% =
			patternFormat%pi% =
		
			If p IS NUMBER
			{
				patternType%pi% := "N"
				patternValue%pi% := p
			} Else {
				; Search for a matching sequence:
				GoSub LoadSequences
				Loop, parse, Sequences, `n, `r%A_Tab%%A_Space%
				{
					Sequence := A_LoopField
					si := A_Index
					Loop, parse, Sequence, |
					{
						If (p = A_LoopField) {
							patternType%pi% := "S" . si
							patternValue%pi% := A_Index - 1
							patternFormat%pi% := Sequence
							Sequence =
							Break
						}
					}
					If Sequence =
						Break
				}
			}
		}


		; Find the modulus (the shortest part of the pattern that starts repeating)
		modulus := 1
		Loop
		{
			Success := true
			
			Loop %pattern0%
			{
				If (A_Index <= modulus) ; Skip to the modulus
					continue
					
				pi := A_Index
				mi := mod(A_Index-1, modulus)+1
				
				; Determine if the items at pi and mi match:
				If (patternType%pi% != patternType%mi%) {
					Success := false
					break
				} Else If (patternType%pi% = "L") {
					; See if the literal text matches:
					If (pattern%pi% = pattern%mi%)
						continue ; Literal text matches!
					Success := false
					break
				}
				; So far so good
			}
			
			If (Success) {
				break
			}
			modulus++
			If (modulus = pattern0) {
				Success := true ; This will recognize EVERY input as a pattern.
				break
			}
		}
		
		If (!Success) ; Could not find a repeating pattern
		{
			GuiControl, , MacroPattern, %MacroText%
			GoTo AnalyzeMacroPatterns_CleanUp
		}





		; Now that we have a repeating pattern, 
		; let's simplify it to the minimum,
		; and join together all analyzed items:
		
		MacroPartialLength := 0
		MacroPattern =
		Loop, %modulus%
		{
			pi := A_Index
			; Determine how to "output" this item:
			If (patternType%pi% = "L") {
				; Literal:
				output := pattern%pi%
			} Else {
				; See if there's a patternFormat for this pattern:
				format =
				max =
				If InStr(patternType%pi%, "S") {
					; Sequence:
					format := ":" . patternFormat%pi%
					; Count the number of items:
					StringSplit max, format, |
					max := max0
				}

					
				; Create an equation using polynomial interpolation:

				; First, get all values from this sequence:
				val0 = 0
				Loop
				{
					mi := pi + (modulus * (A_Index-1))
					If (mi > pattern0)
						Break
					val0++
					val%A_Index% := patternValue%mi%
				}
				
				; Figure out the coefficients for our polynomial equation:
				If (IKnewHowToDoPolynomialInterpolation) {
					; ToDo: Implement polynomial interpolation:
				} Else {
					; For now, I'll just support simple binomial interpolation of the form "y = Ax + B"
					c1 := 1
					If (val0 >= 2)
						c1 := val2-val1
					c0 := val1
					cN := 2 ; (number of coefficients)
					
					; ToDo: I should make sure that the rest 
					; of the pattern matches this equation.
				}

				; Construct the equation from the polynomial coefficients:
				eq =
				Loop %cN%
				{
					pwr := cN - A_Index
					c := c%pwr%
					If (c != 0) {
						If eq !=
							eq .= "+"
							
						If (pwr > 1)
							eq .= "Index^" . pwr . (c!=1 ? "*" . c : "")
						Else If (pwr = 1)
							eq .= "Index"        . (c!=1 ? "*" . c : "")
						Else
							eq .= c
						
					}
				}
				
				
				; See if there's a max, so that a Sequence will loop:
				If (max > 0)
					eq .= "%" . max
				
				
				; Append this equation to the MacroPattern:
				output := "[" . eq . format . "]"
			}
			; Append the output to the pattern:
			MacroPattern .= output
			
			; Keep track of the length of the partially completed portion of the pattern:
			If (A_Index <= mod(pattern0, modulus))
				MacroPartialLength += StrLen(output)
		}






		

		; Output the MacroPattern:
		GuiControl, , MacroPattern, %MacroPattern%
		; Set an appropriate MacroIndex so that completion will continue
		; from where we left off:
		MacroIndex := pattern0 // modulus
		GuiControl, , MacroIndex, %MacroIndex%
		
		
		
		
		
		
		; Clean Up all our temporary variables:
		AnalyzeMacroPatterns_CleanUp:		
		Sequence =
		Sequences =
		Loop, %pattern0%
		{
			pattern%A_Index% =
			patternType%A_Index% =
			patternValue%A_Index% =
			patternFormat%A_Index% =
		}		
	Return

	LoadSequences:
		Sequences =
		(ltrim comments
			Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec
			January|Febuary|March|April|May|June|July|August|September|October|November|December
			Sun|Mon|Tue|Wed|Thu|Fri|Sat
			Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday
			One|Two|Three|Four|Five|Six|Seven|Eight|Nine|Ten ;|Eleven|Twelve|Thirteen|Fourteen|Fifteen|Sixteen|Seventeen|Eighteen|Nineteen|Twenty
		)
	Return
	
	
	
	;EndRegion

	;Region " Playback "
	RunQuickMacro:
		If (MacroRecording) {
			GoSub QuickMacroRecordEnd ; Just in case we're recording, stop.
		}
		
		GoSub GetMacroPreview

		; Create a list of recognized special commands:
		SpecialCommands =
		Loop, parse, MacroSpecialCommands, `n, `r%A_Space%
		{
			StringSplit, cmd, A_LoopField, :, %A_Space%%A_Tab%
			If (SpecialCommands != "")
				SpecialCommands .= "|"
			SpecialCommands .= cmd1
		}
		
		; Send the text, while searching for {Special} commands:
		MacroPreviewLength := StrLen(MacroPreview)
		lastPos := 1
		Loop
		{
			; Split the text between commands:
			specialPos := RegexMatch(MacroPreview, "{(" . SpecialCommands . ")\s*([^}]*)}", specialCmd, lastPos)
			If (specialPos = 0)
				specialPos := MacroPreviewLength + 1
			
			; Send the text:
			If (specialPos != lastPos)
				SendInput % SubStr(MacroPreview, lastPos, specialPos - lastPos) ;%;%
				
			; Update the lastPos:
			lastPos := specialPos + StrLen(specialCmd)
			
			; Determine what to do with the special text:
			Loop, Parse, MacroSpecialCommands, `n, `r%A_Space%
			{
				; Search for the matching command:
				StringSplit, cmd, A_LoopField, :, %A_Space%%A_Tab%
				If (cmd1 = specialCmd1) {
					; See if the special command is a func or a sub:
					If (IsLabel(cmd2)) {
						; Execute the sub:
						GoSub %cmd2%
					} Else If IsFunc(cmd2) {
						; Execute the function:
						returnValue := false
						; Determine the number of parameters:
						; # of params needed:
						paramCount := IsFunc(cmd2) - 1
						; # of params supplied:
						StringSplit, params, specialCmd2, `,, %A_Space%%A_Tab%
						If (paramCount < params0) 
							paramCount := params0
						
						If (paramCount = 0)
							returnValue := %cmd2%()
						Else If (paramCount = 1)
							returnValue := %cmd2%(params1)
						Else If (paramCount = 2)
							returnValue := %cmd2%(params1, params2)
						Else If (paramCount = 3)
							returnValue := %cmd2%(params1, params2, params3)
						Else
							MsgBox Too Many params!

						If (returnValue = true) { ; Return True to "Pause" the sequence
							MacroPartialLength += lastPos-1
							GoSub CreateMacroPreview
							Return
						}
					} Else {
						MsgBox % "Invalid Special Command!`n'" . cmd2 . "' is not a recognized function." ;%
					}
				}
			}
			
			
			; See if we're done:
			If (lastPos > MacroPreviewLength)
				break
		}


		; Reset the partial length:
		MacroPartialLength := 0
		; Increment the Index:
		MacroIndex++
		GuiControl, , MacroIndex, %MacroIndex%
		GoSub QuickMacroIndex_Changed
	Return
	;EndRegion

	;Region " Special Commands "

	QuickMacroSleep(duration = 250, message = "") {
		If (message != "")
			ToolTip %message%
		Sleep %duration%
		ToolTip
	}
	QuickMacroPause(message = "", duration = 5000) {
		If message != 
			ShowToolTip(message, duration)
			
		Return true ; Signals to pause
	}
	QuickMacroChoose(choices) {
		; Present the user with a list of choices:
		
		; Clear menu:
		Menu, QuickMacroChoose, Add, Empty, FolderClicked
		Menu, QuickMacroChoose, Delete
		
		Menu, QuickMacroChoose,     Add, Select an item to insert it:, DoNothing
		Menu, QuickMacroChoose, Disable, Select an item to insert it:
		Menu, QuickMacroChoose, Add, 

		Loop, parse, choices, |
		{
			Menu, QuickMacroChoose, Add, &%A_Index%: %A_LoopField%, QuickMacroChoose_Click
		}

		Sleep 100
		
		menuCancelled := true
		Menu, QuickMacroChoose, Show, %A_CaretX%, %A_CaretY%
		If (menuCancelled)
			Return true ; "Pause" the sequence if no choice was made
	
		Return
		;Return true ; Acts just like pause
		QuickMacroChoose_Click:
		
		Sleep 100
		StringSplit choices, choices, |
		choice := A_ThisMenuItemPos - 2
		choice := choices%choice%
		;MsgBox You chose to send: %choice%
		SendInput %choice%
		menuCancelled := false
	Return
	}
	QuickMacroClipQueuePaste(index = -1) {
		Global
		If (index != -1) {
			cqIndex := index
		}
		GoSub ClipQueuePaste
		Sleep 50
	}

	;EndRegion
	