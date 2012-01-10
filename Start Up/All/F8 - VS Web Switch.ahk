
#IfWinActive ahk_group AnyBrowser	 		;Region " Any Browser "
	F8::
		; Switch back to Visual Studio
		WinActivate Microsoft Visual Studio
	Return
;EndRegion

#IfWinActive Microsoft Visual Studio 		;Region " Visual Studio "
	F8::
		Send ^+s
		Sleep 300
	AutoRefreshWeb:
		autoRefreshDestinations =
		(ltrim comments
			; A list of browser titles that should be refreshed, in this order
			smartgfe.dev
			localhost
			A Blog by Jennie Rippey
			ahk_group AnyBrowser ; No specific window has been found, so just refresh any browser window
		)
		
		; Determine which window to send Refresh:
		SetTitleMatchMode RegEx
		Loop, parse, autoRefreshDestinations, `n
		{
			IfWinExist %A_LoopField%
			{
				WinActivate
				;Sleep 300
				;ControlSend, , ^a^{F5}
				SendInput ^a^{F5}
				Return
			}
		}
		
	Return 

#IfWinActive ;EndRegion
