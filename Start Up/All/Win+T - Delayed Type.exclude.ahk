;Auto-Execute:
	DelayedText = #t
	DelayedTextInterval = 60
Return
; Delayed Type:
; Allows you to send keystrokes after an interval.


#t::
ShowDelayedType:
	GuiUniqueDestroy("DelayedType")
	GuiUniqueDefault("DelayedType")
	
	Gui, Add, Text, Section, Interval:
	Gui, Add, Edit, vDelayedTextInterval wp, %DelayedTextInterval%
	Gui, Add, Text, x+10 ys, Text to send:
	Gui, Add, Edit, vDelayedText w120, %DelayedText%
	Gui, Add, Text, x+10 ys, or press a key combination:
	Gui, Add, HotKey, vDelayedHotkey gDelayedHotkey_Changed w120
	Gui, Add, Button, gSend_Click Default w120, Send after Interval...

	Gui, Show, , Delayed Type...
Return

DelayedHotkey_Changed:
	GuiControlGet DelayedHotkey
	; We need to insert {braces} into key names:
	DelayedHotkey := RegexReplace(DelayedHotkey, "(\w{2,})", "{$1}")
	GuiControl, , DelayedText, %DelayedHotkey%
Return

Send_Click:
	Gui, Submit
	GuiUniqueDestroy("DelayedType")
	
	Time := TimeFromSeconds(DelayedTextInterval)
	;; See if our text is maybe an existing label?
	;DelayedTypeLabel := RegexReplace(DelayedText, "[{}]", "")
	If IsLabel(DelayedText)
		Message := "In " . Time . ", we will execute the following method:`n" . DelayedText
	Else
		Message := "In " . Time . ", we will type the following text:`n" . RegexReplace(DelayedText, "{", "{{")
	If CustomMessageBox("Delayed Type...", Message, " Focus2 B1W+30 B2X+30 ", "Type &Now ({time})", "&Cancel", "", DelayedTextInterval) = 2
		Return
	
	Sleep 100
	If IsLabel(DelayedText)
		GoSub %DelayedText%
	Else
		SendInput %DelayedText%
Return


DelayedType_Escape:
DelayedType_Close:
	GuiUniqueDestroy("DelayedType")
Return
