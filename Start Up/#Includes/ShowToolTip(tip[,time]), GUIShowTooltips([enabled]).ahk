ShowToolTip(tip,time = 1500)
{
	ToolTip %tip%
	SetTimer RemoveThisToolTip, -%time% ;specifying a negative time will cause the timer to run only once.
}
RemoveThisToolTip:
	ToolTip ,
return

; Every GUI that wants tooltips should call this show method
; and needs to disable it as well when the gui is destroyed.
GuiShowTooltips(enable = true)
{
	static count
	if (enable)
	{	count++
		If (count = 1)
			OnMessage(0x200, "WM_MOUSEMOVE")
	}
	else
	{	count--
		If (count = 0)
			OnMessage(0x200, "")
		If (count < 0)
			count = 0
		ToolTip
	}
}
; The following code was obtained from http://www.autohotkey.com/docs/commands/Gui.htm#ExToolTip
WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := A_GuiControl
	CurrControl := RegexReplace(CurrControl, "[& ]+")
    If (CurrControl <> PrevControl)
    {
        ToolTip  ; Turn off any previous tooltip.
        SetTimer, Display_TT, 5
        PrevControl := CurrControl
    }
    return

    Display_TT:
    SetTimer, Display_TT, Off
    ToolTip % %CurrControl%_TT  ;%;% The leading percent sign tell it to use an expression.
    ;SetTimer, Remove_TT, 10000
    return

    ; Remove_TT:
    ; SetTimer, Remove_TT, Off
    ; ToolTip
    ; return
}

