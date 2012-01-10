;-----------------------------------------------
;Auto Shutdown:
;We will prompt the user for a delay, and then hibernate after that delay!
;-----------------------------------------------
;#F4::

	ShutDownSeconds = 20
	msg = Your system's battery is critically low!  Your system will suspend in %ShutDownSeconds% seconds!
	title = Critical Battery!  Suspend imminent!
	;Sleep %ShutDownMinutes%
	SetTimer ChangeHibernateButtonNames, 50
	MsgBox 1, %title%, %msg%, %ShutDownSeconds%
	SetTimer ChangeHibernateButtonNames, off
	IfMsgBox Cancel	
		Return

	; Call the Windows API function "SetSuspendState" to have the system suspend or hibernate.
	; Windows 95/NT4: Since this function does not exist, the following call would have no effect.
	; Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
	; Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
	; Parameter #3: Pass 1 instead of 0 to disable all wake events.
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 0)	
return
ChangeHibernateButtonNames: 
	IfWinNotExist %title%
	    return  ; Keep waiting another 50 ms
	SetTimer ChangeHibernateButtonNames, 1000
	WinActivate 
	ShutDownMinutes := floor(ShutDownSeconds / 60)
	If (ShutDownMinutes >= 1) {
		TrimShutDownSeconds := floor(mod(ShutDownSeconds, 60))
		TimeRemaining = &Now (%ShutDownMinutes%m %TrimShutDownSeconds%s)
	} else {
		TimeRemaining = &Now (%ShutDownSeconds%s)
	}
	ControlSetText Button1, %TimeRemaining%
	ControlSetText Button2, &Cancel
	ShutDownSeconds := ShutDownSeconds - 1
	If (ShutDownSeconds <= 0) {
		SetTimer ChangeHibernateButtonNames, off
	}
return