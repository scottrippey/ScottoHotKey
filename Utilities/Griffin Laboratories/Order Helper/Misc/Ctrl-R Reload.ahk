
CheckForUpdates:
	src = Y:\Scott Rippey Temp\Order Helper\Order Helper.ahk
	dest = %A_ScriptFullPath% ; %A_Desktop%\Order Helper.ahk
	
	FileGetTime srcTime, %src%, M
	FileGetTime destTime, %dest%, M
	If (srcTime != destTime) {
		ToolTip Loading Update...

		IfExist %dest%
			FileDelete %dest%
		FileCopy %src%, %dest%, 1
		
		Sleep 500
		ToolTip Update Loaded.
	}
	Sleep 500
	ToolTip
Return

^r::
	If Not CloseOrder()
		Return
	
	ToolTip Reloading Script...

	IfNotInString A_UserName, Scott
		GoSub CheckForUpdates

	ToolTip
	Reload
Return
