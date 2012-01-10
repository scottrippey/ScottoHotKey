;Actions Syntax:
;DelayMS, Action Title, ActionLabel

XButton2::
	XB2Actions =
(
Switch Screens:SwitchScreens,500
Maximize / Restore:MaximizeToggle,750
Alt-Tab:PressAltTab,1000
Forward:PressForward
)
	PressAndHold("XButton2", XB2Actions, False)
Return

PressAltTab:
	Send !{Tab}
Return

PressForward:
	Send {XButton2}
return
