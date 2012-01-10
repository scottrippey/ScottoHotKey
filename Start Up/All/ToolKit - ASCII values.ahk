; Auto-Execute:
	RegisterTool("ShowAsciiValues", "&ASCII values", "Converts strings to and from ASCII")
Return

ShowAsciiValues:
	GuiUniqueDestroy("AsciiValues")
	GuiUniqueDefault("AsciiValues")
	AsciiText := clipboard
	Gui, Font, S10, Consolas
	Gui, Add, Edit, vAsciiText gAsciiText_Changed		w150 r5, %asciiText%
	GoSub GetAsciiValues
	Gui, Add, Edit, vAsciiValues gAsciiValues_Changed	w600 r5 x+12 yp, %asciiValues%
	Gui, Font
	Gui, Add, Text, vAsciiTextLength					x12 y+10 w500,
	GoSub UpdateAsciiTextLength
	
	Gui, Show, , Ascii Values
Return

AsciiValues_Close:
AsciiValues_Escape:
	GuiUniqueDestroy("AsciiValues")
Return


AsciiText_Changed:
	Gui, Submit, NoHide
	GoSub GetAsciiValues
	GuiControl, , AsciiValues, %AsciiValues%
	GoSub UpdateAsciiTextLength
Return
AsciiValues_Changed:
	Gui, Submit, NoHide
	GoSub GetAsciiText
	GuiControl, , AsciiText, %AsciiText%
	GoSub UpdateAsciiTextLength
Return
UpdateAsciiTextLength:
	GoSub GetAsciiTextLength
	GuiControl, , AsciiTextLength, %AsciiTextLength% chars
Return


GetAsciiValues:
	AsciiValues =
	Loop, parse, AsciiText
	{
		Ascii := Asc(A_LoopField)
		while (StrLen(Ascii) < 3)
			Ascii := " " . Ascii
		AsciiValues .= Ascii . " "
	}
Return

GetAsciiText:
	AsciiText =
	Loop, parse, AsciiValues, %A_Space%
	{
		AsciiText .= Chr(A_LoopField)
	}
Return

GetAsciiTextLength:
	AsciiTextLength := StrLen(AsciiText)
Return
