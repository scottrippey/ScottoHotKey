; Auto-Execute:

	TimeToHibernate = 060000 ; 6:00 am
	Menu, Hibernate, Add, daily at 6:00 am, ToggleAutoHibernate
	
	; Turn it on:
	AutoHibernateEnabled = 0
	GoSub ToggleAutoHibernate
Return

ToggleAutoHibernate:
	AutoHibernateEnabled := 1 - AutoHibernateEnabled
	If (AutoHibernateEnabled) {
		Menu, Hibernate, Check, daily at 6:00 am
		SetTimer, CheckForAutoHibernate, -1000
	} Else {
		Menu, Hibernate, UnCheck, daily at 6:00 am
		SetTimer, CheckForAutoHibernate, Off
	}
Return


CheckForAutoHibernate:
	; Find today's hibernate time:
	FormatTime, nextHibernate, %A_Now%, yyyyMMdd
	nextHibernate .= TimeToHibernate

	; Calculate how much time until then:
	delay := nextHibernate
	EnvSub, delay, %A_Now%, seconds

	; See if we should Hibernate right now (within 30 seconds)
	If (Abs(delay) < 30)
	{	; Start the Hibernate sequence!
		ShutdownAction := 5 ; (Hibernate)
		ShutdownForce := true
		ShutdownMinutes := 3
		GoSub DoDelayedShutdown
		
		; If the user presses cancel:
		SetTimer, CheckForAutoHibernate, -60000
		return
	}
	
	; Find the next Hibernate time:
	If (delay < 0)
		delay += 1 * 24 * 60 * 60 ; add a day


	
	
	delay *= 1000 ; ms
	; Reduce the delay, so that the timer will fire 
	; sooner than expected.  That way, it will re-target
	; the correct time, and our accuracy will be
	; greatly improved:
	;delay *= (2/3)
	
	; Set the timer with the appropriate duration:
	SetTimer, CheckForAutoHibernate, -%delay%
Return
