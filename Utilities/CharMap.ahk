;Auto-Execute:
	; Display a ASCII table:
	;SetTimer CharMap, -1000
	charmapIndex = -1
	fontNames = Wingdings,WebDings,Wingdings 2,Wingdings 3
	StringSplit fontNames, fontNames, `,
Return
#a::
	GuiUniqueDefault("Anim")
	Gui, Font, s40, Wingdings
	c := Chr(183)
	Gui, Add, Text, w300 vAnim, %c%
	Gui, Show, , Animation...
	SetTimer DoAnim, 10
	animIndex = 183
Return
DoAnim:
	GuiUniqueDefault("Anim")
	animIndex++
	If (animIndex > 194)
		animIndex = 183
	c := Chr(animIndex)

	GuiControl, , Anim, %c%
Return

#c::
	charmapIndex++
	Goto CharMap
#d::
	charmapIndex--
	GoTo CharMap
	
CharMap:
	GuiUniqueDestroy("CharMap")

	count := 32
	wrap := 8
	index := charmapIndex * count
	fontIndex := 1
	fontName := fontNames%fontIndex%
	While (Index >= 256) {
		index -= 256
		fontIndex++
		fontName := fontNames%fontIndex%
	}
	
	first := index
	last := index + count
	numbers := index
	allChars := ""

	GuiUniqueDefault("CharMap")
	Gui, Add, Text, , %fontName% (%first% to %last%)
	Gui, Font, s40, %fontName%


	Loop %count%
	{
		index++
		c := Chr(index)
		;             whitesp not displayed
		If index IN 9,10,13,28,29,30,31,32
			continue
		
		allChars .= c
		If (index < last AND Mod(index, wrap) = 1)
		{
			allChars .= "`n"
			numbers .= "`n" . index 
			opt = section x0
		}
		Else
		{
			allChars .= " " ;"`t"
			opt = ys
		}
		Gui, Add, Text, %opt% gCharClick vChar%index%, %c%
		Char%index%_TT = %fontName% %c% (%index%)
	}
		
	;Gui, Add, Text, xs, %allChars%
	;Gui, Font, s40, Verdana
	;Gui, Add, Text, ys, %numbers%
	Gui, Show
	GoSub ActivateGuiTooltips
Return
CharMap_Escape:
	GuiUniqueDestroy("CharMap")
Return 
CharClick:
	Gui +OwnDialogs
	c := A_GuiControl
	a := Asc(c)
	copyText = %fontName% %c% (%a%)
	InputBox copyText, Copy %copyText%..., Please enter the text you would like to copy:, , , , , , , , %copyText%
	If (ErrorLevel)
		Return
	clipboard := copyText
Return


ActivateGuiTooltips:
	OnMessage(0x200, "WM_MOUSEMOVE")
return
WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := A_GuiControl
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip  ; Turn off any previous tooltip.
        SetTimer, Display_TT, 5
        PrevControl := CurrControl
    }
    return

    Display_TT:
    SetTimer, Display_TT, Off
    ToolTip % %CurrControl%_TT  ;%;% The leading percent sign tell it to use an expression.
    SetTimer, Remove_TT, 10000
    return

    Remove_TT:
    SetTimer, Remove_TT, Off
    ToolTip
    return
}


