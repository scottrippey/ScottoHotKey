; Auto-Execute:
	; Add a menu item for delayed hibernate:
	Menu, Hibernate, Add, in a few minutes..., #F4
	Menu, Hibernate, Add, in 22 minutes, HibernateIn22
	Menu, Hibernate, Add, in 45 minutes, HibernateIn44
	Menu, Tray, Add, Hibernate, :Hibernate
	
	ShutdownAction := 5 ; (Hibernate)
	ShutdownForce := true
	ShutdownMinutes := 0
Return

HibernateIn22:
	ShutdownAction := 5 ; (Hibernate)
	ShutdownForce := true
	ShutdownMinutes := 22
	GoTo DoDelayedShutdown
HibernateIn44:
	ShutdownAction := 5 ; (Hibernate)
	ShutdownForce := true
	ShutdownMinutes = 44
	GoTo DoDelayedShutdown
Return
SleepIn22:
	ShutdownAction := 4 ; (Sleep)
	ShutdownForce := true
	ShutdownMinutes := 22
	GoTo DoDelayedShutdown
SleepIn44:
	ShutdownAction := 4 ; (Sleep)
	ShutdownForce := true
	ShutdownMinutes = 44
	GoTo DoDelayedShutdown
Return

;-----------------------------------------------
; Delayed Shutdown
;-----------------------------------------------
#F4::
ShowDelayedShutdown:
	GuiUniqueDestroy("DelayedShutdown")
	GuiUniqueDefault("DelayedShutdown")
	GuiShowTooltips(true)

	; -- Actions --
	Gui, Add, Text, x10 w90, &Action:
	Gui, Add, Radio, x+10 vShutdownAction gDelayedShutdown_Changed, &Shut Down
	Gui, Add, Radio, x+10 wp gDelayedShutdown_Changed, &Restart
	Gui, Add, Radio, x+10 wp gDelayedShutdown_Changed, &Log Off
	Gui, Add, Radio, x+10 wp gDelayedShutdown_Changed, Slee&p
	Gui, Add, Radio, x+10 wp Checked gDelayedShutdown_Changed, &Hibernate
	Gui, Add, Checkbox, x+10 vShutdownForce Checked gDelayedShutdown_Changed, &Force *
	ShutdownForce_TT := "* Forcing shutdown, restart, or log off does not wait long `nfor applications to save data, and might result in data loss"
	
	; -- Delay --
	Gui, Add, Text, x10 w90, &Delay: (minutes)
	Gui, Add, Edit, x+10 w100 vShutdownMinutesText, ;%ShutdownMinutes%
	Gui, Add, UpDown, vShutdownMinutes gDelayedShutdown_Changed Range0-1440, 0
	
	; -- Buttons --
	ShutdownSeconds := floor(ShutdownMinutes * 60)
	GoSub GetShutdownActionText
	Gui, Add, Button, x+10 w300 Default vOKButtonText gDelayedShutdown_Start, %ShutdownActionText%
	Gui, Add, Button, x+10 gDelayedShutdown_Close, &Cancel
	
	; -- Show --
	Gui +AlwaysOnTop
	Gui, Show, , Delayed Shutdown...
	GuiControl, Focus, ShutdownMinutes
Return
DelayedShutdown_Close:
DelayedShutdown_Escape:
	GuiUniqueDestroy("DelayedShutdown")
	GuiShowTooltips(false)
Return
DelayedShutdown_Changed:
	GuiUniqueDefault("DelayedShutdown")
	Gui Submit, NoHide
	ShutdownSeconds := floor(ShutdownMinutes * 60)
	GoSub GetShutdownActionText
	GuiControl, , OKButtonText, %ShutdownActionText%...
Return
GetShutdownActionText:
	; Map the ShutdownAction to the right name:
	If (ShutdownAction = 1)
		ShutdownActionName = Shut Down
	Else If (ShutdownAction = 2)
		ShutdownActionName = Restart
	Else If (ShutdownAction = 3)
		ShutdownActionName = Log Off
	Else If (ShutdownAction = 4)
		ShutdownActionName = Sleep
	Else If (ShutdownAction = 5)
		ShutdownActionName = Hibernate

	Time := TimeFromSeconds(ShutdownSeconds,false,false)

	ShutdownActionText := SmartFormat("{ShutdownForce:Force|} {ShutdownActionName} {ShutdownSeconds:now|in 1 second|in {Time}}")
Return

DelayedShutdown_Start:
	Gui Submit
	GuiUniqueDestroy("DelayedShutdown")
	GuiShowTooltips(false)
	
	; Fall-through:
DoDelayedShutdown:
	ShutdownSeconds := floor(ShutdownMinutes * 60)
	GoSub GetShutdownActionText
	If ShutdownSeconds <= 1
		ShutdownSeconds = 1

	if CustomMessageBox(ShutdownActionText, SmartFormat("{ShutdownActionName} is delayed ... {ShutdownActionName} NOW or cancel?"), " Focus2 B1W+90X-40 B2X+50 ", "&{ShutdownActionName} Now {Time}...", "&Cancel", "", ShutdownSeconds) = 2
		return
		
	ShutdownSeconds = 30
	GoSub GetShutdownActionText
	if CustomMessageBox(ShutdownActionText, SmartFormat("About to {ShutdownActionName} ... {ShutdownActionName} NOW or cancel?"), " Focus2 B1W+90X-40 B2X+50 ", "&{ShutdownActionName} Now {Time}...", "&Cancel", "", ShutdownSeconds) = 2
		return
	
	ShutdownSeconds = 7
	GoSub GetShutdownActionText
	if CustomMessageBox(ShutdownActionText, SmartFormat("About to {ShutdownActionName}! {ShutdownActionName} NOW or cancel?"), " Focus2 B1W+90X-40 B2X+50 ", "&{ShutdownActionName} Now {Time}", "&Cancel", "", ShutdownSeconds) = 2
		return


	; Time to shut down!
	If ShutdownAction IN 1,2,3 ; Shut Down, Restart, Log Off:
	{
		If (ShutdownAction = 1)
			code := 1 ; Shutdown
		Else If (ShutdownAction = 2)
			code := 2 ; Reboot
		Else If (ShutdownAction = 3)
			code := 0 ; Logoff
		If (ShutdownForce)
			code += 4 ; Force
		Shutdown, %code%
	} Else {
		; Sleep or hibernate:
		If (ShutdownAction = 4)
			hibernate := 0 ; Suspend
		Else If (ShutdownAction = 5)
			hibernate := 1 ; hibernate
		If (ShutdownForce)
			force := 1 ; Force
		Else
			force := 0
		disableWake := 0
		
		; Call the Windows API function "SetSuspendState" to have the system suspend or hibernate.
		; Windows 95/NT4: Since this function does not exist, the following call would have no effect.
		; Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
		; Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
		; Parameter #3: Pass 1 instead of 0 to disable all wake events.
		DllCall("PowrProf\SetSuspendState", "int", hibernate, "int", force, "int", disableWake)	
	}
return





