; Auto-Execute:
	RegisterTool("ShowXMLFormatter", "&XML Formatter", "Inserts whitespace into an XML document")
Return

ShowXMLFormatter:
	GuiUniqueDestroy("XMLFormatter")
	GuiUniqueDefault("XMLFormatter")
	XMLText := clipboard
	GoSub FormatXML
	Gui, Font, S10, Consolas
	Gui, Add, Edit, vXMLText -Wrap ReadOnly w600 r50, %XMLText%
	
	Gui, Show, , XML Formatter
Return

XMLFormatter_Close:
XMLFormatter_Escape:
	GuiUniqueDestroy("XMLFormatter")
Return

FormatXML:
	indent := 0
	output =
	Loop, parse, XMLText, <, %A_Space%%A_Tab%
	{
		value = %A_LoopField% ; (trim)
		;If (value = "")
		;	continue
		If (output != "")
			output .= "`n"

		isOpen := (SubStr(value, 1, 1) != "/") ? true : false
		If (!isOpen)
			indent--
		Loop, %indent%
		{
			output .= "  "
		}

		If (isOpen)
			indent++

		If (output != "")
			output .= "<"
		output .= value
	}
	XMLText := output
Return
