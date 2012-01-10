#IfWinActive ACT! by Sage


#f::
	; Let's search for the customer:
	Send !ll ; Lookup LastName
	If Not RegexMatch(customerName, "(\S+)\s*$", LastName) ; Find the LastName
		Return
		
	SendRaw %LastName1%
	Send {Enter}
Return




#t::
TestActInfo:
	Method = TESTSHOW
	GoSub GetSetActInfo
Return
#v::
	; Wait for the Windows key up:
	KeyWait LWin
	KeyWait RWin
SetActInfo:
	Method = POST
	customerState := StateInfo(customerState, "ABBR")
	If RegexMatch(customerPhone, "\D*(\d{3})\D*(\d{3})\D*(\d{4})\D*(\d*)", PHONE) {
		PHONENUMBER = (%PHONE1%) %PHONE2%-%PHONE3%
		PHONEEXT := PHONE4
	} Else {
		PHONENUMBER := customerPhone
		PHONEEXT =
	}
	
	GoSub GetSetActInfo
Return
#c::
GetActInfo:
	Method = GET
	GoSub GetSetActInfo
	
	If PHONEEXT =
		customerPhone = %PHONENUMBER%
	Else
		customerPhone = %PHONENUMBER% x%PHONEEXT%


	GoSub RefreshOrderGUI
Return
	
	
	
GetSetActInfo:
	IfWinExist ahk_class WindowsForms10.Window.8.app.0.2004eee ; (Version 9.0)
	{	
		PTID := RegexReplace(customerName, "^(.*?)\s*(\S+)$", "Z" . (International ? "I" : "") . "-$2, $1")
		
		ActFormTitle = ACT! by Sage - Griffin
		;my computer:
		ActFormInfo =
		(ltrim comments
			WindowsForms10.EDIT.app.0.2004eee7 = customerCompany
			WindowsForms10.EDIT.app.0.2004eee5 = customerName
			WindowsForms10.EDIT.app.0.2004eee23 = PHONENUMBER
			WindowsForms10.EDIT.app.0.2004eee3 = PHONEEXT 
			WindowsForms10.EDIT.app.0.2004eee20 = customerAddress
			WindowsForms10.EDIT.app.0.2004eee21 = customerAddress2
			WindowsForms10.EDIT.app.0.2004eee19 = customerCity
			WindowsForms10.EDIT.app.0.2004eee17 = customerState
			WindowsForms10.EDIT.app.0.2004eee15 = customerZip
			WindowsForms10.EDIT.app.0.2004eee10 = customerCountry
			WindowsForms10.EDIT.app.0.2004eee16 = customerEmail
			WindowsForms10.EDIT.app.0.2004eee6 = customerType
			WindowsForms10.EDIT.app.0.2004eee1 = PTID
		)
	}
	Else {
		Gui +OwnDialogs
		MsgBox Could not put information into ACT; please make sure ACT! 9.0 is open!
		Return
	}
	
	FillForm(ActFormTitle, ActFormInfo, Method)
Return



#IfWinActive
