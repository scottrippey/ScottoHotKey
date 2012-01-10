; Auto-Execute:
	SetTimer CheckKeyboardStatus, -1000
Return

; On startup, this script checks the status of Numlock, Capslock, and Scrolllock.
; Depending on the unique combination of these 3 variables, 1 of 8 commands will be executed.
; The status is then reset (Numlock on, Capslock off, Scrolllock off)
;
; To use this script, place it in your startup folder.
; Then, every time you power up your computer, toggle the keyboard status 
; to specify which apps you want to run at startup.


NumOffCapsOffScrollOff:	; Looks like:  . . .
	GoSub NumOnCapsOnScrollOff
	GoSub HibernateIn22
Return
NumOnCapsOffScrollOff:	; Looks like:  o . .   (Default)

Return
NumOffCapsOnScrollOff:	; Looks like:  . o .
	
Return
NumOnCapsOnScrollOff:	; Looks like:  o o .
	filesToRun =
	(ltrim comments
		C:\Documents and Settings\srippey\Desktop\Hours.xlsx
		C:\Program Files\Quest Software\Toad for SQL Server Freeware 5.0\Toad.exe
		C:\Projects\SmartOrder_1.0\All Projects.sln
	)
	MsgBox, 0x1104, Run Startup..., You sure you want to run all of the following?`n%filesToRun%, 15
	IfMsgBox No
		Return
	Loop, parse, filesToRun, `n
		Run %A_LoopField%
Return
NumOffCapsOffScrollOn:	; Looks like:  . . o

Return
NumOnCapsOffScrollOn:	; Looks like:  o . o

Return
NumOffCapsOnScrollOn:	; Looks like:  . o o
	
Return
NumOnCapsOnScrollOn:	; Looks like:  o o o

Return
















CheckKeyboardStatus:
	; Read the keyboard status:
	Status = 
	Status .= "Num" . (GetKeyState("Numlock", "T") ? "On" : "Off")
	Status .= "Caps" . (GetKeyState("Capslock", "T") ? "On" : "Off")
	Status .= "Scroll" . (GetKeyState("Scrolllock", "T") ? "On" : "Off")
	; Reset the keyboard status:
	SetNumLockState On
	SetCapsLockState Off
	SetScrollLockState Off

	; Execute the appropriate script:
	If (IsLabel(Status))
		GoTo %Status%
Return
