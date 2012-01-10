;Auto-execute:
		; Here's what a line copied from USBank looks like:
		; 06/06/11 				  				Purchase With Pin Winco Foods 4043temecula Ca 				  				$162.57 				$640.00  Pending Transaction Help
		; 06/06/11 {TAB}{TAB}{TAB}{TAB}  {TAB}{TAB}{TAB}{TAB}Purchase With Pin Winco Foods 4043temecula Ca {TAB}{TAB}{TAB}{TAB}  {TAB}{TAB}{TAB}{TAB}$162.57 {TAB}{TAB}{TAB}{TAB}$640.00  Pending Transaction Help
		usBankExtract =
		(ltrim comments
			ix)
			0?(?<DateMo>\d+)/0?(?<DateDay>\d+)/\d+ ; Date
			\s+
			(?<Desc>\S[^\t]+)
			\s+
			\$(?<Amt>[0-9.,]+)
		)


		usBankTrimText =
		(ltrim comments join|
			i)(Visa Purchase \(Non-pin\)
			Purchase with Pin
			Web Authorized Pmt
			Electronic Withdrawal
			Check view
			Auto Payment to
			Electronic Deposit
			AAAAA)
		)

		RegisterTool("ShowBudgetTool", "USBank &Budget Tool", "Converts text, copied from USBank's website, into Budget-Spreadsheet format")

Return


#IfWinExist
	ShowBudgetTool:

			; Create a GUI
		GuiUniqueDestroy("BudgetTool")
		GuiUniqueDefault("BudgetTool")
		
		Gui, Add, Button, vB1 gBudgetTool_ImportClipboard							, Import from Clipboard
		Gui, Add, Button, vB3 gCopyBudgetResult_Click						x630 yp		, Copy to Clipboard
		
		Gui, Font, s10, Consolas
		Gui, Add, Edit, vUSBankText gBudgetTool_Changed		-Wrap	Section x10 r31 w300, %USBankText%
		GoSub GenerateBudgetResult
		Gui, Add, Edit, vBudgetResult gBudgetResult_Changed	-Wrap			x+10 ys r31 w300, %BudgetResult%
		GoSub GenerateBudgetResult2
		Gui, Add, Edit, vBudgetResult2				 		-Wrap			x+10 ys r31 w300, %BudgetResult2%

		Gui, Show, , USBank Budget Tool
	Return
	BudgetTool_Close:
	BudgetTool_Escape:
		GuiUniqueDestroy("BudgetTool")
		; USBankText =
		BudgetResult =
	Return

	BudgetTool_Changed:
		Gui, Submit, NoHide
		
		GoSub GenerateBudgetResult

		GuiControl, , BudgetResult, %BudgetResult%
	Return
	BudgetResult_Changed:
		Gui, Submit, NoHide
		
		GoSub GenerateBudgetResult2
		
		GuiControl, , BudgetResult2, %BudgetResult2%
	Return
	CopyBudgetResult_Click:
		clipboard := BudgetResult2
	Return
		
	BudgetTool_ImportClipboard:
		USBankText := clipboard

		GuiControl, , USBankText, %USBankText%
		GoTo BudgetTool_Changed
	
	
	
	
	GenerateBudgetResult:
		BudgetResult =
		Loop, Parse, USBankText, `n, `r
		{
			; Extract data:
			If (!RegexMatch(A_LoopField, usBankExtract, data))
				Continue
			dataDesc := RegexReplace(dataDesc, usBankTrimText, "")
			
			BudgetResult = 
			(ltrim
				%dataDateMo%/%dataDateDay% %dataDesc%`t`t-%dataAmt%
				%BudgetResult%
			)
		}
	Return
	GenerateBudgetResult2:
		; Sort the lines of text:
		BudgetResult2 := BudgetResult
		Sort BudgetResult2, F NaturalCompare
		; StringSplit Lines, BudgetResult, `n, `r
		; Loop
		; {
			; done := true
			; Loop %Lines0%
			; {
				; s := A_Index - 1
				; d := A_Index
				; If (NaturalCompare(Lines%s%, Lines%d%, 1) > 0) {
					; LinesSwap := Lines%s%
					; Lines%s% := Lines%d%
					; Lines%d% := LinesSwap
					; done := false
				; }
			; }
			; If (done)
				; break
		; }
		
		; BudgetResult2 := "Sorted!" . BudgetResult
	Return
	