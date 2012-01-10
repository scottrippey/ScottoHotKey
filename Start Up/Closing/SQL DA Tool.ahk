;Auto-Execute:
	
	DASprocText =
	(
		Sample Procedure:
		
		CREATE PROCEDURE [dbo].[usp_TableA_GetById]
			@Param1	uniqueidentifier,
			@Param2	int = null
		AS BEGIN
			SELECT
				[Column1],
				[Column2],
				[Column3]
		END
	)
	;GoSub ShowSQLDATool

	RegisterTool("ShowSQLDATool", "&SQL DA Tool", "Generates a C# DA method for a stored procedure")

Return

ShowSQLDATool:
	; Create a GUI for creating DA methods:
	GuiUniqueDestroy("SQLDATool")
	GuiUniqueDefault("SQLDATool")
	
	Gui, Add, Button, vB1 gSQLDATool_ImportClipboard							, Import from Clipboard
	Gui, Add, Button, vB2 gSQLDATool_ImportFile						x+10 yp		, Import from File...
	Gui, Add, Button, vB3 gCopyDAResult_Click						x320 yp		, Copy to Clipboard
	Gui, Add, Edit, vDASprocText gSQLDATool_Changed		-Wrap	Section x10 r31 w300, %DASprocText%
	;Gui, Add, Edit, vSprocHeader gSQLDATool_Changed	-Wrap	Section	x10	r15 w300, %SprocHeader%
	;Gui, Add, Edit, vSprocReturn gSQLDATool_Changed	-Wrap				r15 w300, %SprocReturn%
	GoSub GenerateDAResult
	Gui, Add, Edit, vDAResult		ReadOnly 		-Wrap			x+10 ys r31 w500, %DAResult%
	
	Gui, Show, , SQL DA Tool
Return
SQLDATool_Close:
SQLDATool_Escape:
	GuiUniqueDestroy("SQLDATool")
Return

SQLDATool_Changed:
	Gui, Submit, NoHide
	
	GoSub GenerateDAResult

	GuiControl, , DAResult, %DAResult%
Return
CopyDAResult_Click:
	clipboard := DAResult
Return
	
SQLDATool_ImportClipboard:
    DASprocText := clipboard

	GuiControl, , DASprocText, %DASprocText%
	GoTo SQLDATool_Changed
SQLDATool_ImportFile:
	Gui +OwnDialogs
    FileSelectFile, SprocFilename, 1, , , *.sql
    If SprocFilename =
        Return
    FileRead DASprocText, %SprocFilename%

	GuiControl, , DASprocText, %DASprocText%
	GoTo SQLDATool_Changed





	
GenerateDAResult:
    ; Normalize whitespace:
    sprocText := RegexReplace(DASprocText, "\s+", " ")
	
	; Extract the procedure name:
	RegexMatch(sprocText, "i)\bCREATE PROCEDURE (?<Name>[\[\]\.\w_]+)\s*(?<Params>.*?)\s*AS\b", sproc)
	
	If (sproc = ""){
		DAResult := "Couldn't find the CREATE PROCEDURE statement."
		Return
	}

    ; Extract the MethodName and ReturnType, based on our naming conventions:
    If (RegexMatch(sprocName, "ix) (\[?dbo\]?\.|\[?smartgfe\]?\.|) (\[?usp_|) (?<Table>[^_]+) [_] (?<Action>GET|FIND|UPDATE|INSERT|CREATE|SET|DELETE|) (?<ActionInfo>\w*) ", sprocNameInfo)) {
	
        StringUpper sprocNameInfoAction, sprocNameInfoAction, T
        MethodName := sprocNameInfoAction . sprocNameInfoTable . sprocNameInfoActionInfo
        ReturnType := sprocNameInfoTable
    } Else {
		; Defaults:
		MethodName := "GetReturnTypes"
		ReturnType := "ReturnType"
	}

	
	; Extract all parameters:
	; HACK: Don't CSV a decimal(#,#) value:
	sprocParams := RegexReplace(sprocParams, "i)\bdecimal\s*\(\s*d+\s*,\s*\d+\s*\)", "decimal")
	param0 := 0
	Loop, Parse, sprocParams, CSV
	{
		If (!RegexMatch(A_LoopField, "i)@(?<Name>\w+) (?<Type>[\w\(\)]+)\s*(?:= (?<Default>\w+))?", param%A_Index%))
			Continue
		param0 := A_Index
	}
	
	
	; Extract the Return results:
	; Find the LAST "SELECT ... FROM" statement:
	sReturn =
	lastFound = 1
	Loop
	{
		lastFound := RegexMatch(sprocText, "i)\bSELECT (.+?) (FROM|END)\b", lastSelect, lastFound)
		If (!lastFound)
			Break
			
		lastFound += StrLen(lastSelect)
		sReturn := lastSelect1
	}
	
	; Extract all Columns from the SELECT statement:
	Loop, Parse, sReturn, CSV
	{
		columnName := A_LoopField
		
		; See if this column is more complicated than just a column name:
		If (RegexMatch(columnName, "i)\bAS\b(.*)", col)) { ; eg: Column AS 'Alias'
			columnName := col1
		} Else If (RegexMatch(columnName, "i)\.(.+)", col)) { ; eg: Table.Column
			columnName := col1
		}
		
		; Remove brackets and quotes:
		columnName := RegexReplace(columnName, "[\[\]']", "")
		
		columnName%A_Index% = %columnName%
		columnName0 := A_Index
	}
	
	
	
	; Generate the result:
	
	; Create the parameters:
	methodParameters =
	addParameters =
	Loop, %param0%
	{
		csType := TranslateType(param%A_Index%Type, param%A_Index%Default)
		csName := TranslateName(param%A_Index%Name)

		if (methodParameters != "")
			methodParameters .= ", "
		methodParameters = 
		(ltrim join
			%methodParameters%
			%csType% %csName%
		)
		
		paramName := param%A_Index%Name
		csDefault := param%A_Index%Default
		csDefault := (csDefault = "") ? "" : " // Defaults to '" . csDefault . "'"
		if (addParameters != "")
			addParameters .= "`n"
		addParameters = 
		(join
			%addParameters%
			command.Parameters.AddWithValue("@%paramName%", %csName%); %csDefault%
		)
	}
	
	; Create the reader:
	If (columnName0 = 0) {
		MethodType := "void"
		reader =
		(
			command.ConnectAndExecute();
		)
	} Else {
		MethodType := "List<" . ReturnType . ">"
		readResults =
		Loop, %columnName0%
		{
			columnName := columnName%A_Index%
			If (readResults != "")
				readResults .= "`n"
			readResults =
			(join
				%readResults%
				%columnName% = reader.Get<string>("%columnName%"),
			)
		}
		reader =
		(
			return command.ConnectAndExecute(reader => new %ReturnType%() {
				%readResults%
			});
		)
	}
	
	; Combine it all together:
	DAResult =
	(
		
		public %MethodType% %MethodName%(%methodParameters%)
		{
			var command = new SqlCommand("%sprocName%") { CommandType = CommandType.StoredProcedure };
			%addParameters%
			
			%reader%
		}
	)	
Return

TranslateName(paramName){
	; change first char to lowercase
	RegexMatch(paramName, "(.)(.*)", paramName)
	StringLower paramName1, paramName1
	Return paramName1 . paramName2
}
TranslateType(paramType, paramDefault){
	StringLower paramType, paramType
	If (RegexMatch(paramType, "varchar"))
		Return "string"
	If (paramType = "uniqueidentifier")
		Return "Guid" . (paramDefault = "" ? "" : "?")
	If (paramType = "tinyint")
		Return "byte" . (paramDefault = "" ? "" : "?")
	If (paramType = "bigint")
		Return "long" . (paramDefault = "" ? "" : "?")
	If (paramType = "datetime")
		Return "DateTime" . (paramDefault = "" ? "" : "?")
	If (paramType = "int")
		Return "int" . (paramDefault = "" ? "" : "?")
	If (paramType = "bit")
		Return "bool" . (paramDefault = "" ? "" : "?")
	Return paramType . (paramDefault = "" ? "" : "?")
}
