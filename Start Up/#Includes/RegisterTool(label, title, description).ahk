;Auto-Execute:

	RegisteredTools = 
	; Example:	
		; RegisterTool("DoTest1", "Test 1", "Does the test #1")
		; RegisterTool("DoTest2", "Test 2", "Performs test #2")
Return

#IfWinActive AutoHotKey Tool Kit
	#t::GoSub ToolKit_Close
#IfWinActive

#t::
ShowRegisteredTools:
	If (GuiUniqueDestroy("ToolKit"))
		GuiShowTooltips(false)
	GuiUniqueDefault("ToolKit")
	GuiShowTooltips()
	
	Loop, Parse, RegisteredTools, `n
	{
		StringSplit, ToolInfo, A_LoopField, |
		Gui, Add, Button, g%ToolInfo1% vToolInfoButton%A_Index% w120 h40, %ToolInfo2%
		ToolInfoButton%A_Index%_TT := ToolInfo3
	}
	
	Gui, Show, , AutoHotKey Tool Kit

Return
ToolKit_Close:
ToolKit_Escape:
	GuiUniqueDestroy("ToolKit")
	GuiShowTooltips(false)
Return


RegisterTool(gotoLabel, title, description, includeInMenu = true) {
	Global
	
	If (RegisteredTools != "")
		RegisteredTools .= "`n"
	RegisteredTools =
	(join ltrim
		%RegisteredTools%
		%gotoLabel%|%title%|%description%
	)
	If (includeInMenu){
		Menu, ToolKitMenu, Add, %title%, %gotoLabel%
		Menu, TRAY, Add, Tool Kit (Win+T), :ToolKitMenu
	}
}