; Auto-execute:
	GoSub ShowDefaultGUI
Return


	F12::GoSub ShowDefaultGUI

;Region " MultiTap (Default Layout) "	

#IfWinExist ahk_class #32771 ; This is Window's Alt-Tab menu
	~*Enter::Send {Enter}{Alt up}
	~*Escape::Send {Escape}{Alt up}
#IfWinExist

;#IfWinExist Multi-Tap Enabled (Default) ; Enables toggling
#IfWinNotActive ahk_class eHome Render Window

	F12::GoSub ShowNumberPadGUI

	; The # key is for spaces:
	; Pressing # on the remote sends "Alt+(3,5)" which types "#";
	; We will replace that functionality:
	!NumPad3::Return ; Ignore Alt+3
	!NumPad5::MultiTapProgress("_ Space={Space}|< Backspace={Backspace}|____ Tab={Tab}|x Escape={Esc}|^ SmartCaps:UpdateSmartCapsStatus", 1000)
	; The 0 key is for modifiers:
	Numpad0::MultiTapProgress("Ctrl=^|Alt=!|Shift=+|Win=#|0|" . SmartCapsText . ":ToggleSmartCaps|F1={F1}|F2={F2}|F3={F3}|F4={F4}|F5={F5}|F6={F6}|F7={F7}|F8={F8}|F9={F9}|F10={F10}|F11={F11}|F12={F12}", 1000)

	; The * key is for special shortcuts:
	NumpadMult::
		; Get a list of all the paste actions:
		pasteActions =
		If (cqCount > 0) {
			pasteActions := "`n"
			Loop, %cqCount%
			{	
				If (cqCount > 10) {
					If (cqIndex <= 5) {
						If (A_Index > 10)
							continue
					} Else If (cqIndex > cqCount - 5) {
						If (A_Index <= cqCount - 10)
							continue
					} Else If (-5 >= cqIndex - A_Index OR cqIndex - A_Index > 5)
						continue
				}
				; Remove the special characters that are used by MultiTap:
				currentPaste := RegexReplace(ClipDisplay%A_Index%, "[=:,]+", "")
				pasteActions .= currentPaste . ":ClipQueuePaste" . A_Index . "`n"
			}
			pasteActions .= "(Clear Clipboard Queue):ClipQueueClear`n"
		}

		IfWinActive ahk_class MozillaUIWindowClass ; Firefox
			Actions =
			(ltrim comments
				;FireFox:OpenFF
				Explore "Complete":ExploreComplete
				Explore "TV Shows":ExploreTVShows
				µTorrent:OpenUTorrent
				DVD Shrink:DVDShrink
				
				New Tab +=^t
				Add www. .com=^{Enter}
				Address Bar ^:DeFocusFlash ;=^l
				Switch Tabs >=^{Tab}
				Switch Tabs <=^+{Tab}
				New Window []=^n
				Full Screen={F11}
				kokanut82@hotmail.com=kokanut82@hotmail.com
				%pasteActions%
				
				Max/Restore:MaximizeToggle
				Minimize:MinimizeWindow
				Switch Windows <>=!{Esc}
				Suspend for 30 seconds ...:SuspendFor30
			)
		Else IfWinActive µTorrent
			Actions =
			(ltrim comments
				FireFox:OpenFF
				Explore "Complete":ExploreComplete
				Explore "TV Shows":ExploreTVShows
				;µTorrent:OpenUTorrent
				DVD Shrink:DVDShrink
				
				Select All=^a
				Remove x={Delete}
				
				Previous Tab <:uTorrentPrevTab
				Next Tab >:uTorrentNextTab
				Add a TV Show +:uTorrentRSS ; (requires uTorrentRSS.ahk)
				
				Max/Restore:MaximizeToggle
				Minimize:MinimizeWindow
				Switch Windows <>=!{Esc}
				Suspend for 30 seconds ...:SuspendFor30
			)
		Else IfWinActive ahk_group AllExplorer ; Windows Explorer
		{	
			Actions =
			(ltrim comments
				FireFox:OpenFF
				New Explore "Complete":ExploreComplete
				New Explore "TV Shows":ExploreTVShows
				µTorrent:OpenUTorrent
				DVD Shrink:DVDShrink
				
				Select All=^a
				New Folder=!fwf
				Rename={F2}
				
				Cut x:ClipQueueCut
				Copy c:ClipQueueCopy
				%pasteActions%
				Delete x={Delete}
				
				Move to "TV Shows\New":MoveToNew
				Move to "TV Shows\Done":MoveToDone
				Move to "Movies":MoveToMovies
				Move to...=!ev+{Tab 3}
				
				Max/Restore:MaximizeToggle
				Minimize:MinimizeWindow
				Switch Windows <>=!{Esc}
				Suspend for 30 seconds ...:SuspendFor30
			)
		} Else {
			Actions =
			(ltrim comments
				FireFox:OpenFF
				Explore "Complete":ExploreComplete
				Explore "TV Shows":ExploreTVShows
				µTorrent:OpenUTorrent
				DVD Shrink:DVDShrink
				
				%pasteActions%
				
				Max/Restore:MaximizeToggle
				Minimize:MinimizeWindow
				Switch Windows <>=!{Esc}
				Suspend for 30 seconds ...:SuspendFor30
			)
		}
		MultiTapProgress(actions, 1000, "XR-160 YB Top Left BGWhite A200")
	Return




	; This uses a default numeric layout, where 1,2,3 is at the top.
	; The 1 key is for punctuation:
	Numpad1::MultiTapProgress(".|,|1|\|-|:|'|""", 1000)
	Numpad2::MultiTapProgress("A|B|C|2|@")
	Numpad3::MultiTapProgress("D|E|F|3|#={#}")
	Numpad4::MultiTapProgress("G|H|I|4|$")
	Numpad5::MultiTapProgress("J|K|L|5|%") ;%;%;%;%
	Numpad6::MultiTapProgress("M|N|O|6|^")
	Numpad7::MultiTapProgress("P|Q|R|S|7|&&=&")
	Numpad8::MultiTapProgress("T|U|V|8|*")
	Numpad9::MultiTapProgress("W|X|Y|Z|9|(|)")

	; NumpadEnter::
	; Enter::
		; MultiTapProgress("Enter={Enter}", 0) ; Send it instantly!
	; Return

;EndRegion

;Region " MultiTap (NumberPad Layout) "
; #IfWinExist Multi-Tap Enabled (NumberPad Mode) ; Enables toggling
	; ; If you are using the keyboard's number pad, with 7,8,9 at the top,
	; ; it might be easier to map the keys inverted, so 8 = a,b,c etc...
	; F12::
		; GuiUniqueDestroy("NumpadMultitap")
	; Return
	; ; The 1 key is for punctuation:
	; Numpad7::MultiTapProgress(".|,|@|-|:|'|""|1", 1500)
	; Numpad8::MultiTapProgress("A|B|C|2|@")
	; Numpad9::MultiTapProgress("D|E|F|3|#={#}")
	; Numpad4::MultiTapProgress("G|H|I|4|$")
	; Numpad5::MultiTapProgress("J|K|L|5|%") ;%;%;%;%
	; Numpad6::MultiTapProgress("M|N|O|6|^")
	; Numpad1::MultiTapProgress("P|Q|R|S|7|&&=&")
	; Numpad2::MultiTapProgress("T|U|V|8|*")
	; Numpad3::MultiTapProgress("W|X|Y|Z|9|(|)")
	; ; The 0 key is for modifiers:
	; Numpad0::MultiTapProgress("Ctrl=^|Alt=!|Shift=+|Win=#|0|" . SmartCapsText . ":ToggleSmartCaps", 1000)
	; ; The . key is for spaces:
	; NumpadDot::MultiTapProgress("_ Space={Space}|< Backspace={Backspace}|____ Tab={Tab}|x Escape={Esc}|^ SmartCaps:UpdateSmartCapsStatus", 1000)

	; ; NumpadEnter::
	; ; Enter::
		; ; MultiTapProgress("Enter={Enter}", 30) ; Send it quickly!
	; ; Return

;EndRegion

#IfWinExist

;Region " Special Functions "



MinimizeWindow:
	WinMinimize A
Return
MoveToMovies:
	location := "E:\RippeyMC\Movies"
	SetTimer _MoveTo, -50
Return
MoveToNew:
	location := "E:\RippeyMC\TV Shows\New"
	SetTimer _MoveTo, -50
Return
MoveToDone:
	location := "E:\RippeyMC\TV Shows\Done"
	SetTimer _MoveTo, -50
Return
_MoveTo:
	GoSub BackupClipboard
	
	; Get the list of files:
	Send ^c
	ClipWait 1
	files := clipboard
	
	; Create a pipe-delimited list of files:
	StringReplace files, files, `r`n, |, All

	QueueFileMove(files, location)

	GoSub RestoreClipboard
Return


uTorrentPrevTab:
	Control TabLeft, , SysTabControl321, A
Return
uTorrentNextTab:
	Control TabRight, , SysTabControl321, A
Return

ExploreTVShows:
	If WinExist("ahk_group Explorer") ; Windows Explorer
		IfWinNotActive
		{	WinActivate
			Return
		}
	
	If OpenFolder("E:\RippeyMC\TV Shows") {
		Send {Down}
		Send +{Tab} ; Focus the folders tree
	}
Return
ExploreComplete:
	If WinExist("ahk_group Explorer") ; Windows Explorer
		IfWinNotActive
		{	WinActivate
			Return
		}
	
	If OpenFolder("C:\Users\Rippeys\Downloads\Torrents\Complete") {
		Send {Down}
		Send +{Tab} ; Focus the folders tree
	}
Return


OpenFolder(folder, duration = 3000) {
		RegexMatch(folder, "(?<=\\)[^\\]+$", LastFolder)
		IfNotExist %folder%
		{	MsgBox The following folder does not exist:`n%folder%
			Return
		}
		Run %folder%, , Max
		duration /= 100
		; Wait for explorer to open so we can set the proper focus to the folders tree
		Loop, %duration%
		{
			IfWinExist %LastFolder%
			{	
				WinActivate
				Return true
			}
			Sleep 100
		}
	Return false
}
OpenUTorrent:
	IfWinExist µTorrent
	{	WinActivate
		Return
	}
	; If the window doesn't exist, we need to click the task bar icon
	DetectHiddenWindows On
	Process Exist, utorrent.exe
	If ErrorLevel = 0
	{	Run %A_ProgramFiles%\uTorrent\uTorrent.exe
		Return
	}
	; Get the process ID:
	WinGet W, List, ahk_pid %ErrorLevel%
	; Search the windows to find the hWnd of µTorrent
	Loop %W%
	{
		WinGetClass Class, % "ahk_id" W%A_Index% ;%;%;%;%
		If InStr( Class, "µTorrent" ) {
			hWnd := W%A_Index%
			Break
		}
	}
	 
	PostMessage, 0x8001, 0,0x204,, ahk_id %hWnd% ; Right Click down
	PostMessage, 0x8001, 0,0x205,, ahk_id %hWnd% ; Right Click Up
	WinWait µTorrent
	Send h ;hide/show
	
	DetectHiddenWindows Off
Return
SuspendFor30:
	ToolTip Shortcuts Suspended
	Suspend On
	SetTimer SuspendFor30Resume, -30000
Return
SuspendFor30Resume:
	Suspend Off
Return
OpenFF:
	IfWinExist ahk_class MozillaUIWindowClass
		WinActivate
	Else
		Run FireFox.exe
Return
DoReload:
	Reload
Return

;EndRegion

;Region " GUI "

ShowDefaultGUI:
	GuiUniqueDestroy("NumpadMultitap")
	GuiUniqueDefault("NumpadMultitap")
	
	; Makes an OSD
	GUI +ToolWindow +Owner +LastFound +Disabled
	WinSet Transparent, 100
	WinSet ExStyle, +0x20 ; Prevents the window from ever getting focus
	GUI -Caption
	
	Gui Add, Button, x6 y7 w50 h50 gNumpad1, 1`n. , @ -
	Gui Add, Button, x56 y7 w50 h50 gNumpad2, 2`nABC
	Gui Add, Button, x106 y7 w50 h50 gNumpad3, 3`nDEF
	Gui Add, Button, x6 y57 w50 h50 gNumpad4, 4`nGHI
	Gui Add, Button, x56 y57 w50 h50 gNumpad5, 5`nJKL
	Gui Add, Button, x106 y57 w50 h50 gNumpad6, 6`nMNO
	Gui Add, Button, x6 y107 w50 h50 gNumpad7, 7`nPQRS
	Gui Add, Button, x56 y107 w50 h50 gNumpad8, 8`nTUV
	Gui Add, Button, x106 y107 w50 h50 gNumpad9, 9`nWXYZ
	Gui Add, Button, x6 y157 w50 h50 gNumpadMult, *`nShortcut
	Gui Add, Button, x56 y157 w50 h50 gNumpad0, 0`nCtrl Alt Shift
	Gui Add, Button, x106 y157 w50 h50 g!Numpad5, #`nSpace
	
   ; Move the window to the bottom right:
   GUI Show, Hide
   WinGetPos, ,,width,height
   SysGet monitorNumber, MonitorPrimary
   SysGet M,MonitorWorkArea, monitorNumber
   MR := MRight - width
   MB := MBottom - height
   Gui Show, NoActivate x%MR% y%MB% w%width% h%height% , Multi-Tap Enabled (Default)
Return







ShowNumberPadGUI:
	GuiUniqueDestroy("NumpadMultitap")
	GuiUniqueDefault("NumpadMultitap")

	; Makes an OSD
	GUI +AlwaysOnTop +Owner +LastFound +Disabled
    WinSet Transparent, 192
	WinSet ExStyle, +0x20 ; Prevents the window from ever getting focus
	GUI -Caption
	Gui Add, Button, x6 y7 w50 h50 gNumpad7, 7`n. , @ - : 1
	Gui Add, Button, x56 y7 w50 h50 gNumpad8, 8`nABC 2
	Gui Add, Button, x106 y7 w50 h50 gNumpad9, 9`nDEF 3
	Gui Add, Button, x6 y57 w50 h50 gNumpad4, 4`nGHI 4
	Gui Add, Button, x56 y57 w50 h50 gNumpad5, 5`nJKL 5
	Gui Add, Button, x106 y57 w50 h50 gNumpad6, 6`nMNO 6
	Gui Add, Button, x6 y107 w50 h50 gNumpad1, 1`nPQRS 7
	Gui Add, Button, x56 y107 w50 h50 gNumpad2, 2`nTUV 8
	Gui Add, Button, x106 y107 w50 h50 gNumpad3, 3`nWXYZ 9
	Gui Add, Button, x6 y157 w100 h50 gNumpad0, 0`nCtrl Alt Shift
	Gui Add, Button, x106 y157 w50 h50 gNumpadDot, .`nSpace

	; Move the window to the bottom right:
   GUI Show, Hide
   WinGetPos x, y, width, height
   SysGet monNum, MonitorPrimary
   SysGet M, MonitorWorkArea, monNum
   MR := MRight - width
   MB := MBottom - height
   Gui Show, NoActivate x%MR% y%MB% w%width% h%height% , Multi-Tap Enabled (NumberPad Mode)
Return

;EndRegion
