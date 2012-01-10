;Auto-Execute:
	
	SpreadsheetText =
	(ltrim
		A	B	C	1	2	3
		D	E	F	4	5	6
	)
	SpreadsheetStart := "{Index:          SELECT |UNION ALL SELECT }"
	SpreadsheetJoin := ", "
	SpreadsheetEnd   := "`n"
	
	; SetTimer ShowSQLSpreadsheetTool, -1000

	RegisterTool("ShowSQLSpreadsheetTool", "SQL S&preadsheet Tool", "Converts a Spreadsheet to SQL Insert code")

Return

ShowSQLSpreadsheetTool:
	; Create a GUI
	GuiUniqueDestroy("SQLSpreadsheetTool")
	GuiUniqueDefault("SQLSpreadsheetTool")
	
	Gui, Add, Button, vB1 gSQLSpreadsheetTool_ImportClipboard							, Import from Clipboard
	Gui, Add, Button, vB3 gCopySQLResult_Click						x320 yp		, Copy to Clipboard
	
	Gui, Font, s10, Consolas
	Gui, Add, Edit, vSpreadsheetText gSQLSpreadsheetTool_Changed		-Wrap	Section x10 r31 w300, %SpreadsheetText%
	GoSub GenerateSQLResult
	Gui, Add, Edit, vSQLResult		ReadOnly 		-Wrap			x+10 ys r31 w500, %SQLResult%

	Gui, Add, Edit, vSpreadsheetStart gSQLSpreadsheetTool_Changed	-Wrap	Section	x10	r2 w300, %SpreadsheetStart%
	Gui, Add, Edit, vSpreadsheetJoin gSQLSpreadsheetTool_Changed	-Wrap			x+10 yp r2 w300, %SpreadsheetJoin%
	Gui, Add, Edit, vSpreadsheetEnd gSQLSpreadsheetTool_Changed	-Wrap				x+10 yp r2 w300, %SpreadsheetEnd%
	

	
	Gui, Show, , SQL Spreadsheet Tool
Return
SQLSpreadsheetTool_Close:
SQLSpreadsheetTool_Escape:
	GuiUniqueDestroy("SQLSpreadsheetTool")
	SpreadsheetText =
	SQLResult =
Return

SQLSpreadsheetTool_Changed:
	Gui, Submit, NoHide
	
	GoSub GenerateSQLResult

	GuiControl, , SQLResult, %SQLResult%
Return
CopySQLResult_Click:
	clipboard := SQLResult
Return
	
SQLSpreadsheetTool_ImportClipboard:
    SpreadsheetText := clipboard

	GuiControl, , SpreadsheetText, %SpreadsheetText%
	GoTo SQLSpreadsheetTool_Changed


	
GenerateSQLResult:
	SQLResult =

	; Analyze all columns:
	ColumnCount = 0
	ColumnWidths := ""
	ColumnTypes := ""
	Loop, Parse, SpreadsheetText, `n, `r
	{
		Loop, Parse, A_LoopField, %A_Tab%
		{
			value := A_LoopField

			; Find the number of columns:
			If (ColumnCount < A_Index AND value != "") {
				ColumnCount := A_Index
				ColumnWidths%A_Index% := 0
				ColumnTypes%A_Index% := ""
			}

			; Find the column type:
			IF value =
			{
			} Else If RegexMatch(A_LoopField, "^\d+$") AND (ColumnTypes%A_Index% != "String")
			{
				ColumnTypes%A_Index% := "Number"
			} Else {
				ColumnTypes%A_Index% := "String"
			}

			; Escape the value:
			value := EscapeSQLValue(value, ColumnTypes%A_Index%)
			
			; Find the maximum column width:
			ColumnWidth := StrLen(value)
			If (ColumnWidths%A_Index% < ColumnWidth) {
				ColumnWidths%A_Index% := ColumnWidth
			}
			
		}
	}
	
	; Create the result:
	Loop, Parse, SpreadsheetText, `n, `r
	{
		Index := A_Index
		SQLResult .= SmartFormat(SpreadsheetStart)
		Loop, Parse, A_LoopField, %A_Tab%
		{
			value := A_LoopField

			; Escape the value:
			value := EscapeSQLValue(value, ColumnTypes%A_Index%)
			If (ColumnTypes%A_Index% = "") {
				; No ColumnTypes -- this means the entire column is blank, and should be ignored
				Continue
			}
			
			; Add the comma:
			If (A_Index < ColumnCount)
				value := value . SpreadsheetJoin
			
			; Determine how much padding to use:
			paddingSize := ColumnWidths%A_Index% - StrLen(value) + 4
			If (paddingSize >= 0) {
				Loop %paddingSize%
				{
					value .= " "
				}
			}
			
			; Append the result:
			SQLResult .= value
		}
		SQLResult .= SpreadsheetEnd
	}
			

	
Return
EscapeSQLValue(value, type) {
	If (type = "String") {
		StringReplace value, value, ', '', All
		value := "'" . value . "'"
	} Else If (type = "Number") {
	} Else {
	}
	Return value
}
	


