#SingleInstance Force
#Include ..\Start Up\#Includes\ShowToolTip.ahk

;This script will loop through the clipboard text, line by line, and do whatever you want with it.
;It will wait for you to press "Pause Break"
; To cancel, press Shift+PauseBreak
; To re-do the last line, press ALT+PauseBreak


^q:: 
sleep 100
Send ^s
sleep 100 
ShowToolTip("Debug Reloading")
sleep 1000
Reload
return

Pause::
AllLines := Clipboard
StringReplace AllLines, AllLines, `r`n, `n, All

msgbox, 
(
Press PauseBreak to insert the next line.
Press ALT+PauseBreak to insert the previous line.
Press SHIFT+PauseBreak to cancel.
Clipboard:
%AllLines%
)

CurrentLine =   
Loop Parse, AllLines, `n
{
WaitForKey:
	KeyWait Pause, D
	GetKeyState keystate, Shift
	if keystate = D
	{
		ShowToolTip("Cancel")
		break
	}
	GetKeyState keystate, Alt
	if keystate = D 
	{
		ShowToolTip("Repeating last line")
		gosub SendCurrentLine
		Goto WaitForKey
	}
	
	ShowToolTip("Sending " + A_LoopField)
	CurrentLine := A_LoopField
	GoSub SendCurrentLine
}

ShowToolTip("Line-By-Line typer has finished.")
return

SendCurrentLine:
;Put any custom-code here, such as parsing and sending extra characters
Goto DashTabEnter
Send %CurrentLine%


DashTabEnter:
Loop Parse, CurrentLine, -
{
	Send %A_LoopField%
	Send {Tab}
}
Send {Enter}
Return




