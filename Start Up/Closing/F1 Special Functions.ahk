	F1::
		actions =
		(ltrim comments
			Switch Monitors:SwitchScreens,300
			Maximize / Restore:MaximizeToggle
			QuickMacro...:QuickMacroShow
			Press F1={F1}
			Switch Monitors (under mouse):SwitchScreensUnderMouse
			(Nevermind):,0
		)
		PressAndHold("F1", actions)
	Return
