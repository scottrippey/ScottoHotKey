; auto-execute:
	buildStatus := -1
Return


#IfWinActive Microsoft Visual Studio 		;Region " Visual Studio "

	;Region " Attach-To-Process "
	
		F5:: ; Attach to process:
			; Figure out if we're already Running/Debugging:
			IfWinActive Debugging
			{	; We're already debugging
				Send {F5} 
				return
			} Else IfWinActive Running
			{	; We're already running
				return
			} 		
			
			
			; Search for processes that are available for attachment:
			processes = 
			(ltrim comments
				nunit.exe
				iexplore.exe
				ietester.exe
				aspnet_wp.exe
				firefox.exe
			)
			existingProcessCount = 0
			existingProcesses =
			Loop, parse, processes, `n
			{	; Does the process exist?
				Process, Exist, %A_LoopField%
				If ErrorLevel = 0 ; ErrorLevel returns the PID; 0 = doesn't exist
					continue
				
				; Add this process to our list of existing ones:
				If existingProcesses <>
					existingProcesses .= "`n"
				existingProcesses .= A_LoopField
				existingProcessCount++
			}
			
			; If existingProcessCount = 0
			; {	MsgBox Could not find any processes to attach to!
			; }
			; Else If existingProcessCount = 1
			; {	
				; selectedProcess := existingProcesses
				; GoTo AttachToProcess
			; }
			; Else
			; {	; There are multiple processes; let's ask which one to attach to:
				GuiUniqueDefault("AttachToProcess")
				Gui, Add, Text, , Which process would you like to attach to?
				Gui, Add, Radio, vWhichChecked Checked, None - Start regular debugging {F5}
				; firstChecked = 1
				Loop, parse, existingProcesses, `n
				{
					; If firstChecked = 1
						; Gui, Add, Radio, vWhichChecked Checked, %A_LoopField%
					; Else
						Gui, Add, Radio, , %A_LoopField%
					; firstChecked = 0
				}
				Gui, Add, Button, gAttachToProcess_Submit Default Section, Attach
				Gui, Add, Button, gAttachToProcess_Close yS, Cancel
				
				Gui, +AlwaysOnTop -SysMenu
				
				Gui, Show, , Attach to Process...
			; }
			
		Return
		#IfWinActive Attach to Process...
			F5::Enter ; This allows you to press F5 twice for the default action
		#IfWinActive ahk_class Microsoft Visual Studio ; Visual Studio
		
		AttachToProcess_Escape:
		AttachToProcess_Close:
			GuiUniqueDestroy("AttachToProcess")
		Return
		AttachToProcess_Submit:
			Gui Submit
			GuiUniqueDestroy("AttachToProcess")
			If (WhichChecked = 1) {
				Send {F5}
				Return
			} else {
				WhichChecked--
				StringSplit existingProcesses, existingProcesses, `n
				selectedProcess := existingProcesses%WhichChecked%
			}
			; Fall-through:
		AttachToProcess:
			ShowToolTip("Attaching to " . selectedProcess . "...")
			WinActivate ahk_class wndclass_desked_gsk ; Visual Studio
			Send ^!p
			Send %selectedProcess% ; Attach to the process
			Send {Enter}
		Return

	;EndRegion " Attach-To-Process "
	
	;Region " Auto-Refresh "
		F7::
			If (buildStatus = -1) {
				GoTo WatchBuild
			} Else {
				buildStatus := -1
				SetTimer _WatchBuild, Off
				ToolTip
			}
		Return
		WatchBuild:
			buildStatus := 0
			WinGet buildPID, PID, A
			CurrentWindow = ahk_pid %buildPID%
			
			SetTimer _WatchBuild, -50
			ToolTip Waiting for build to start... (press F7 to stop watching)
		Return
		_WatchBuild:
			; Watch the build progress and do something when building is complete:
			statusText = 
			(ltrim
				Build started...
				Build Progress
				Build succeeded
				Ready
				Build failed
				Item(s) Saved
			)
			SetTitleMatchMode Slow
			WinGetText OutputVar, %CurrentWindow%
			Loop, parse, statusText, `n
			{
				IfInString OutputVar, %A_LoopField%
				{
					buildStatus := A_Index
					Break
				}
			}
			
			If (buildStatus = 0) {
				; Not yet started
			} Else If (buildStatus = 1) {
				; Build started...
				ToolTip Build started... (press F6 to stop watching)
			} Else If (buildStatus = 2) {
				; Build Progress
				ToolTip Build Progress (press F6 to stop watching)
			} Else If (buildStatus = 3 OR buildStatus = 4) {
				; Build succeeded
				; OR Ready (= succeeded)
				buildStatus := -1
				ToolTip
				GoSub AutoRefreshWeb
				Return
			} Else If (buildStatus = 5) {
				; Build failed
				buildStatus := -1
				ToolTip
				MsgBox, 0, Build Failed, The build failed!, 5
				Return
			} Else If (buildStatus = 6) {
				; Item(s) Saved
				buildStatus := -1
				ToolTip
				GoSub AutoRefreshWeb
				Return
			}
			SetTimer _WatchBuild, -2000
		Return

	;EndRegion

#IfWinActive ;EndRegion
