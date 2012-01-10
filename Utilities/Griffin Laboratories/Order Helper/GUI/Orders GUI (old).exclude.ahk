#o::
	GoSub ShowOrderGUI
Return


ShowOrderGUI:
	GoSub PrepareVariables
	GoSub LoadGUI
	;GoSub RestoreVariables
Return


PrepareVariables:
	;;;;;;;;;;;;; Prepare variables for the GUI ;;;;;;;;;;;;;;;;;
	; Get the drop-down-box state index:
	customerState := StateInfo(customerState, "INDEX")
	shippingState := StateInfo(shippingState, "INDEX")
	billingState := StateInfo(billingState, "INDEX")

	paymentCCNumber := paymentCCNumberA . paymentCCNumberB . paymentCCNumberC

	; Compare addresses:
	billingSame = 0
	If (billingCompany	=	customerCompany
			AND billingName	=	customerName
			AND billingAddress	=	customerAddress
			AND billingAddress2	=	customerAddress2
			AND billingCity	=	customerCity
			AND billingState	=	customerState
			AND billingZip	=	customerZip
			AND billingCountry	=	customerCountry) {
		billingSame = 1
	}
	shippingSame = 0
	If (shippingCompany	=	customerCompany
			AND shippingName	=	customerName
			AND shippingAddress	=	customerAddress
			AND shippingAddress2	=	customerAddress2
			AND shippingCity	=	customerCity
			AND shippingState	=	customerState
			AND shippingZip	=	customerZip
			AND shippingCountry	=	customerCountry) {
		shippingSame = 1
	}
	
	If International = 
		International = 0
	If InternationalVerified =
		InternationalVerified = 0
		
	If ProductList =
		GoSub LoadAllProducts
Return

RestoreVariables:
	; Restore all GUI input back to the appropriate variables
	customerState := StateInfo(customerState, "ABBR")
	shippingState := StateInfo(shippingState, "ABBR")
	billingState := StateInfo(billingState, "ABBR")

	; Retrieve the last 4 digits for paymentCCNumberC:
	RegexMatch(paymentCCNumber, "^(?<A>....)?(?<B>.*?)(?<C>....)?$", paymentCCNumber)

	if billingSame
	{	billingCompany	:=	customerCompany
		billingName		:=	customerName
		billingAddress	:=	customerAddress
		billingAddress2	:=	customerAddress2
		billingCity		:=	customerCity
		billingState	:=	customerState
		billingZip		:=	customerZip
		billingCountry	:=	customerCountry
	}
	if shippingSame
	{	shippingCompany	:=	customerCompany
		shippingName	:=	customerName
		shippingAddress	:=	customerAddress
		shippingAddress2:=	customerAddress2
		shippingCity	:=	customerCity
		shippingState	:=	customerState
		shippingZip		:=	customerZip
		shippingCountry	:=	customerCountry
	}
	

Return


















LoadGUI:

;;;;;;;;;;;;; Create the GUI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GUIDefault("OrdersGUI")
; Gui, 8:Default
Gui, +LabelOrdersGui



Gui, Add, GroupBox, x2 y2 w250 h140 , Import Info From:
	Gui, Add, Button, x12 y22 w230 h20 gImportOSCommerce_Click, osCommerce =>
	Gui, Add, Button, x12 y62 w230 h20 gClear_Click, &New Order Window
	Gui, Add, Button, x12 y92 w230 h20 gRevert_Click, &Revert Changes
	Gui, Add, Button, x12 y112 w230 h20 gLoadAllOrderVars_Click, &Load From File...
Gui, Add, GroupBox, x262 y2 w250 h140 , Export Info To:
	Gui, Add, Button, x272 y22 w230 h20 gExportVM_Click, <= &Virtual Merchant
	Gui, Add, Button, x272 y42 w230 h20 gExportACT_Click, <= AC&T!
	Gui, Add, Button, x272 y62 w230 h20 gExportPT_Click, <= &PeachTree
	Gui, Add, Button, x272 y92 w230 h20 gApply_Click +Default, &Apply
	Gui, Add, Button, x272 y112 w230 h20 gSaveAllOrderVars_Click, &Save To File...
Gui, Add, GroupBox, x522 y2 w250 h140 , Comments
	Gui, Add, Edit, x532 y22 w230 h110 vComments, %Comments%


	
	
	






Gui, Add, GroupBox, x2 y152 w250 h200 , Customer Info
Gui, Add, Text, x12 y172 w70 h20 gcustomer_Label_Click, Company
	Gui, Add, Edit, x82 y172 w160 h20 vcustomerCompany, %customerCompany%
Gui, Add, Text, x12 y192 w70 h20 gcustomer_Label_Click, Name
	Gui, Add, Edit, x82 y192 w160 h20 vcustomerName, %customerName%
Gui, Add, Text, x12 y212 w70 h20 gcustomer_Label_Click, Address
	Gui, Add, Edit, x82 y212 w160 h20 vcustomerAddress, %customerAddress%
Gui, Add, Text, x12 y232 w70 h20 gcustomer_Label_Click, Address 2
	Gui, Add, Edit, x82 y232 w160 h20 vcustomerAddress2, %customerAddress2%
Gui, Add, Text, x12 y252 w70 h20 gcustomer_Label_Click, City
	Gui, Add, Edit, x82 y252 w160 h20 vcustomerCity, %customerCity%
Gui, Add, Text, x12 y272 w70 h20 , State, Zip
	Gui, Add, DropDownList, x82 y272 w120 Sort AltSubmit vcustomerState Choose%customerState%, %allStates%
	Gui, Add, Edit, x202 y272 w40 h20 vcustomerZip, %customerZip%
Gui, Add, Text, x12 y292 w70 h20 gcustomer_Label_Click, Country
	Gui, Add, Edit, x82 y292 w160 h20 vcustomerCountry, %customerCountry%
Gui, Add, Text, x12 y312 w70 h20 gcustomer_Label_Click, Phone
	Gui, Add, Edit, x82 y312 w160 h20 vcustomerPhone, %customerPhone%
Gui, Add, Text, x12 y332 w70 h20 gcustomer_Label_Click, Email
	Gui, Add, Edit, x82 y332 w160 h20 vcustomerEmail, %customerEmail%

	
Gui, Add, GroupBox, x262 y152 w250 h165 , Shipping Info
	Gui, Add, CheckBox, x352 y152 w150 h20 vshippingSame Checked%shippingSame% gShippingSame_CheckChanged , Same As Customer Info
Gui, Add, Text, x272 y172 w70 h20 gshipping_Label_Click, Company
	Gui, Add, Edit, x342 y172 w160 h20 vshippingCompany, %shippingCompany%
Gui, Add, Text, x272 y192 w70 h20 gshipping_Label_Click, Name
	Gui, Add, Edit, x342 y192 w160 h20 vshippingName, %shippingName%
Gui, Add, Text, x272 y212 w70 h20 gshipping_Label_Click, Address
	Gui, Add, Edit, x342 y212 w160 h20 vshippingAddress, %shippingAddress%
Gui, Add, Text, x272 y232 w70 h20 gshipping_Label_Click, Address 2
	Gui, Add, Edit, x342 y232 w160 h20 vshippingAddress2, %shippingAddress2%
Gui, Add, Text, x272 y252 w70 h20 gshipping_Label_Click, City
	Gui, Add, Edit, x342 y252 w160 h20 vshippingCity, %shippingCity%
Gui, Add, Text, x272 y272 w70 h20 , State, Zip
	Gui, Add, DropDownList, x342 y272 w120 Sort AltSubmit vshippingState Choose%shippingState%, %allStates%
	Gui, Add, Edit, x462 y272 w40 h20 vshippingZip, %shippingZip%
Gui, Add, Text, x272 y292 w70 h20 gshipping_Label_Click, Country
	Gui, Add, Edit, x342 y292 w160 h20 vshippingCountry, %shippingCountry%
GoSub ShippingSame_CheckChanged
	
Gui, Add, GroupBox, x522 y152 w250 h165 , Billing Info
	Gui, Add, CheckBox, x612 y152 w150 h20 vbillingSame Checked%billingSame% gBillingSame_CheckChanged, Same As Customer Info
Gui, Add, Text, x532 y172 w70 h20 gbilling_Label_Click, Company
	Gui, Add, Edit, x602 y172 w160 h20 vbillingCompany, %billingCompany%
Gui, Add, Text, x532 y192 w70 h20 gbilling_Label_Click, Name
	Gui, Add, Edit, x602 y192 w160 h20 vbillingName, %billingName%
Gui, Add, Text, x532 y212 w70 h20 gbilling_Label_Click, Address
	Gui, Add, Edit, x602 y212 w160 h20 vbillingAddress, %billingAddress%
Gui, Add, Text, x532 y232 w70 h20 gbilling_Label_Click, Address 2
	Gui, Add, Edit, x602 y232 w160 h20 vbillingAddress2, %billingAddress2%
Gui, Add, Text, x532 y252 w70 h20 gbilling_Label_Click, City
	Gui, Add, Edit, x602 y252 w160 h20 Disabled%billingSame% vbillingCity, %billingCity%
Gui, Add, Text, x532 y272 w70 h20 , State, Zip
	Gui, Add, DropDownList, x602 y272 w120 Sort AltSubmit vbillingState Choose%billingState%, %allStates%
	Gui, Add, Edit, x722 y272 w40 h20 vbillingZip, %billingZip%
Gui, Add, Text, x532 y292 w70 h20 gbilling_Label_Click, Country
	Gui, Add, Edit, x602 y292 w160 h20 vbillingCountry, %billingCountry%
GoSub BillingSame_CheckChanged
	
Gui, Add, GroupBox, x2 y352 w250 h100 , Payment Info
Gui, Add, Text, x12 y372 w70 h20 gpayment_Label_Click, Card Type
	Gui, Add, Edit, x82 y372 w160 h20 Readonly vpaymentCCType, %paymentCCType%
Gui, Add, Text, x12 y392 w70 h20 gpayment_Label_Click, Name
	Gui, Add, Edit, x82 y392 w160 h20 vpaymentCCName, %paymentCCName%
Gui, Add, Text, x12 y412 w70 h20 gpayment_Label_Click, Number
	Gui, Add, Edit, x82 y412 w160 h20 gCCNumber_Changed vpaymentCCNumber, %paymentCCNumber%
Gui, Add, Text, x12 y432 w70 h20 gpayment_Label_Click, Expires
	Gui, Add, Edit, x82 y432 w80 h20 vpaymentCCExpires, %paymentCCExpires%
Gui, Add, Text, x162 y432 w40 h20 gpayment_Label_Click, Security
	Gui, Add, Edit, x202 y432 w40 h20 vpaymentCCCode, %paymentCCCode%
GoSub CCNumber_Changed
	
Gui, Add, GroupBox, x262 y312 w250 h150 , Order Totals
Gui, Add, Text, x272 y332 w70 h20 gorder_Label_Click, Description
	Gui, Add, Edit, x342 y332 w160 h20 vorderDescription, %orderDescription%
Gui, Add, Text, x272 y352 w70 h20 , Sales Tax
	Gui, Add, Edit, x342 y352 w160 h20 vorderTax, %orderTax%
Gui, Add, Text, x272 y372 w70 h20 , Total
	Gui, Add, Edit, x342 y372 w160 h20 gUpdateRemainingBalance vorderAmount, %orderAmount%

Gui, Add, GroupBox, x272 y392 w230 h60 , 
	Gui, Add, CheckBox, x282 y392 w90 h20 vInternational Checked%International% gInternational_CheckedChanged, International
	Gui, Add, CheckBox, x382 y392 w60 h20 vInternationalVerified Checked%InternationalVerified% gInternationalVerified_CheckedChanged, Verified?
Gui, Add, Text, x282 y412 w100 h20 , Verification Charges
	Gui, Add, Edit, x382 y412 w40 h20 gUpdateRemainingBalance vRandomCharge1, %RandomCharge1%
	Gui, Add, Edit, x422 y412 w40 h20 gUpdateRemainingBalance vRandomCharge2, %RandomCharge2%
	Gui, Add, Edit, x462 y412 w40 h20 gUpdateRemainingBalance vRandomCharge3, %RandomCharge3%
Gui, Add, Text, x282 y432 w100 h20 , Remaining Total
	Gui, Add, Edit, x382 y432 w120 h20 Readonly vRemainingBalance, %RemainingBalance%
GoSub International_CheckedChanged
GoSub InternationalVerified_CheckedChanged
GoSub UpdateRemainingBalance

Gui, Add, GroupBox, x522 y312 w250 h150 , Ordered Products
	Gui, Add, DropDownList, x532 y332 w210 AltSubmit vOrderItems1 Choose%orderItems1% , %ProductList%
	Gui, Add, DropDownList, x532 y362 w210 AltSubmit vOrderItems2 Choose%orderItems2% , %ProductList%
	Gui, Add, DropDownList, x532 y392 w210 AltSubmit vOrderItems3 Choose%orderItems3% , %ProductList%
	Gui, Add, DropDownList, x532 y422 w210 AltSubmit vOrderItems4 Choose%orderItems4% , %ProductList%
	Gui, Add, Button, x742 y332 w20 h20 gShowProductNumbers1, ?
	Gui, Add, Button, x742 y362 w20 h20 gShowProductNumbers2, ?

	Gui, Add, Button, x742 y392 w20 h20 gShowProductNumbers3, ?
	Gui, Add, Button, x742 y422 w20 h20 gShowProductNumbers4, ?
	

Gui, +AlwaysOnTop +OwnDialogs
	; Generated using SmartGUI Creator 4.0
Gui, Show, h477 w787, Order Information

Return















ApplyChanges:
	Gui Submit, NoHide
	GoSub RestoreVariables
Return
CancelChanges:
	Gui Cancel
	Gui Destroy
Return




	
Clear_Click:
	MsgBox, 0x1134, Clear All..., Are you sure you want to clear all fields?
	IfMsgBox No
		Return
	GoSub ClearAllOrderVars
	GUIDefault("OrdersGUI")
	; Gui, 8:Default
	Gui Cancel
	Gui Destroy
	GoSub ShowOrderGUI
Return

Apply_Click:
	GUIDefault("OrdersGUI")
	Gui Submit, NoHide
	; Gui Destroy
	GoSub RestoreVariables
Return

Revert_Click:
	GoSub OrdersGuiClose
	IfMsgBox No
		Return
	GoSub ShowOrderGUI
Return
OrdersGuiEscape:
OrdersGuiClose:
	MsgBox, 0x1134, Revert Changes..., Are you sure you want to discard all changes?
	IfMsgBox No
		Return
	GUIDefault("OrdersGUI")
	Gui Cancel
	Gui Destroy
Return







LoadAllOrderVars_Click:
	GUIDefault("OrdersGUI")

	FileSelectFile orderFN, 1, %orderFN%, Open Order Info..., Text Documents (*.txt)
	If orderFN =
		return

	GoSub LoadAllOrderVars
	
	GoSub CancelChanges
	GoSub ShowOrderGUI
Return
SaveAllOrderVars_Click:
	GUIDefault("OrdersGUI")

	GuiControlGet, desc, , orderDescription
	If desc !=
		orderFN := RegexReplace(orderFN, "[^\\]*$", desc . ".txt")
	
	FileSelectFile orderFN, S16, %orderFN%, Save Order Info As..., Text Documents (*.txt)
	If orderFN =
		return
	If Not RegexMatch(orderFN, "i).*\.txt$")
		orderFN .= ".txt"
	
	GoSub ApplyChanges
	GoSub SaveAllOrderVars
	
Return







ImportOSCommerce_Click:
	GUIDefault("OrdersGUI")
	IfWinExist osCommerce - www.griffinlab.com - Mozilla Firefox
		WinActivate
	Else
	{	MsgBox Please open osCommerce in Firefox before clicking this button.
		Return
	}
	GoSub GetOrderFromOSCommerce
Return

ExportVM_Click:
	GUIDefault("OrdersGUI")
	IfWinExist Virtual Merchant - www.myvirtualmerchant.com - Mozilla Firefox
		WinActivate
	Else
	{	MsgBox Please open Virtual Merchant in Firefox before clicking this button.
		Return
	}
	GoSub SendOrderToVirtualMerchant
Return
ExportACT_Click:
	GUIDefault("OrdersGUI")
	GoSub SetActInfo
Return
ExportPT_Click:
	GUIDefault("OrdersGUI")
	GoSub SetPTInfo
Return





ShippingSame_CheckChanged:
	GuiControlGet shippingSame
	GuiControl Disable%shippingSame%, shippingCompany
	GuiControl Disable%shippingSame%, shippingName
	GuiControl Disable%shippingSame%, shippingAddress
	GuiControl Disable%shippingSame%, shippingAddress2
	GuiControl Disable%shippingSame%, shippingCity
	GuiControl Disable%shippingSame%, shippingState
	GuiControl Disable%shippingSame%, shippingZip
	GuiControl Disable%shippingSame%, shippingCountry
Return
BillingSame_CheckChanged:
	GuiControlGet billingSame
	GuiControl Disable%billingSame%, billingCompany
	GuiControl Disable%billingSame%, billingName
	GuiControl Disable%billingSame%, billingAddress
	GuiControl Disable%billingSame%, billingAddress2
	GuiControl Disable%billingSame%, billingCity
	GuiControl Disable%billingSame%, billingState
	GuiControl Disable%billingSame%, billingZip
	GuiControl Disable%billingSame%, billingCountry
Return
International_CheckedChanged:
	GuiControlGet International
	GuiControl Enable%International%, InternationalVerified
	
	If (International AND RandomCharge1 = "" and RandomCharge2 = "" and RandomCharge3 = "") {
		GoSub CreateRandomCharges
		SetFormat Float, 0.2
		GuiControl, , RandomCharge1, %RandomCharge1%
		GuiControl, , RandomCharge2, %RandomCharge2%
		GuiControl, , RandomCharge3, %RandomCharge3%
	}
	GuiControl Enable%International%, RandomCharge1
	GuiControl Enable%International%, RandomCharge2
	GuiControl Enable%International%, RandomCharge3
	GuiControl Enable%International%, RemainingBalance
Return
InternationalVerified_CheckedChanged:
	GuiControlGet InternationalVerified
	NotInternationalVerified := 1 - InternationalVerified
	If InternationalVerified
	{
		GuiControl, +ReadOnly, RandomCharge1
		GuiControl, +ReadOnly, RandomCharge2
		GuiControl, +ReadOnly, RandomCharge3
		GuiControl, -ReadOnly, RemainingBalance
	} Else {
		GuiControl, -ReadOnly, RandomCharge1
		GuiControl, -ReadOnly, RandomCharge2
		GuiControl, -ReadOnly, RandomCharge3
		GuiControl, +ReadOnly, RemainingBalance
	}
	

Return


UpdateRemainingBalance:
	GuiControlGet RandomCharge1
	GuiControlGet RandomCharge2
	GuiControlGet RandomCharge3
	GuiControlGet orderAmount
	SetFormat Float, 0.2
	RemainingBalance := orderAmount - RandomCharge1 - RandomCharge2 - RandomCharge3
	
	GuiControl, , RemainingBalance, %RemainingBalance%
Return
CCNumber_Changed:
	; Verify the credit card number, and determine the type of card
	
	; CC info obtained from http://www.regular-expressions.info/creditcard.html
	GuiControlGet paymentCCNumber
	
	paymentCCType = 
	partialCCType =
    ; * Visa: ^4[0-9]{12}(?:[0-9]{3})?$ All Visa card numbers start with a 4. New cards have 16 digits. Old cards have 13.
	If RegexMatch(paymentCCNumber, "^4[0-9]{12}(?:[0-9]{3})?$")
		paymentCCType = Visa
    ; * MasterCard: ^5[1-5][0-9]{14}$ All MasterCard numbers start with the numbers 51 through 55. All have 16 digits.
	Else If RegexMatch(paymentCCNumber, "^5[1-5][0-9]{14}$")
		paymentCCType = Master Card
    ; * American Express: ^3[47][0-9]{13}$ American Express card numbers start with 34 or 37 and have 15 digits.
	Else If RegexMatch(paymentCCNumber, "^3[47][0-9]{13}$")
		paymentCCType = American Express
    ; * Diners Club: ^3(?:0[0-5]|[68][0-9])[0-9]{11}$ Diners Club card numbers begin with 300 through 305, 36 or 38. All have 14 digits. There are Diners Club cards that begin with 5 and have 16 digits. These are a joint venture between Diners Club and MasterCard, and should be processed like a MasterCard.
	Else If RegexMatch(paymentCCNumber, "^3(?:0[0-5]|[68][0-9])[0-9]{11}$")
		paymentCCType = Diners Club
    ; * Discover: ^6(?:011|5[0-9]{2})[0-9]{12}$ Discover card numbers begin with 6011 or 65. All have 16 digits.
	Else If RegexMatch(paymentCCNumber, "^6(?:011|5[0-9]{2})[0-9]{12}$")
		paymentCCType = Discover
    ; * JCB: ^(?:2131|1800|35\d{3})\d{11}$ JCB cards beginning with 2131 or 1800 have 15 digits. JCB cards beginning with 35 have 16 digits. 
	Else If RegexMatch(paymentCCNumber, "^(?:2131|1800|35\d{3})\d{11}$")
		paymentCCType = JCB
	
	; Let's see if the number partially matches a credit card:
	
    ; * Visa: ^4[0-9]{12}(?:[0-9]{3})?$ All Visa card numbers start with a 4. New cards have 16 digits. Old cards have 13.
	Else If RegexMatch(paymentCCNumber, "^4[0-9]*$")
		partialCCType = Visa (incomplete)
    ; * MasterCard: ^5[1-5][0-9]{14}$ All MasterCard numbers start with the numbers 51 through 55. All have 16 digits.
	Else If RegexMatch(paymentCCNumber, "^5[1-5][0-9]*$")
		partialCCType = Master Card (incomplete)
    ; * American Express: ^3[47][0-9]{13}$ American Express card numbers start with 34 or 37 and have 15 digits.
	Else If RegexMatch(paymentCCNumber, "^3[47][0-9]*$")
		partialCCType = American Express (incomplete)
    ; * Diners Club: ^3(?:0[0-5]|[68][0-9])[0-9]{11}$ Diners Club card numbers begin with 300 through 305, 36 or 38. All have 14 digits. There are Diners Club cards that begin with 5 and have 16 digits. These are a joint venture between Diners Club and MasterCard, and should be processed like a MasterCard.
	Else If RegexMatch(paymentCCNumber, "^3(?:0[0-5]|[68][0-9])[0-9]*$")
		partialCCType = Diners Club (incomplete)
    ; * Discover: ^6(?:011|5[0-9]{2})[0-9]{12}$ Discover card numbers begin with 6011 or 65. All have 16 digits.
	Else If RegexMatch(paymentCCNumber, "^6(?:011|5[0-9]{2})[0-9]*$")
		partialCCType = Discover (incomplete)
    ; * JCB: ^(?:2131|1800|35\d{3})\d{11}$ JCB cards beginning with 2131 or 1800 have 15 digits. JCB cards beginning with 35 have 16 digits. 
	Else If RegexMatch(paymentCCNumber, "^(?:2131|1800|35\d{3})\d*$")
		partialCCType = JCB (incomplete)
				
	Else If paymentCCNumber =
		partialCCType = 
	Else
		partialCCType = Unknown

	If paymentCCType !=
	{	; Let's verify using the Luhn algorithm
		; http://en.wikipedia.org/wiki/Luhn_algorithm^


		; 1. Counting from the check digit, which is the rightmost, and moving left, double the value of every second digit.
		; 2. Sum the digits of the products together with the undoubled digits from the original number.
		; 3. If the total ends in 0 (put another way, if the total modulo 10 is equal to 0), then the number is valid according to the Luhn formula; else it is not valid.
		d := 2 - (StrLen(paymentCCNumber) & 1)
		s := 0
		Loop Parse, paymentCCNumber
		   s += 9 < (y := d*A_LoopField) ? y-9 : y, d := 3-d

		If Mod(s,10) > 0
			paymentCCType .= " (invalid card number) "
	} else {
		paymentCCType := partialCCType
	}

	GuiControl, , paymentCCType, %paymentCCType%
Return
	

	
	
	
	
	
	
ShowProductNumbers1:
	GuiControlGet orderItems1
	productIndex := orderItems1
	GoTo ShowProductNumbers
ShowProductNumbers2:
	GuiControlGet orderItems2
	productIndex := orderItems2
	GoTo ShowProductNumbers
ShowProductNumbers3:
	GuiControlGet orderItems3
	productIndex := orderItems3
	GoTo ShowProductNumbers
ShowProductNumbers4:
	GuiControlGet orderItems4
	productIndex := orderItems4
	GoTo ShowProductNumbers
ShowProductNumbers:
	GUIDefault("OrdersGUI")
	productNumbers := FindProduct(productIndex, "NUMBERS")
	msgbox %productNumbers%
Return
	
	
	
	

CreateRandomCharges:
	SetFormat Float, 0.2
	NumberOfRandomCharges = 3
	; Create the random charges:
	RandomIndex := 1
	Loop {
		Random RandomCharge%RandomIndex%, 100, 250
		RandomCharge%RandomIndex% := RandomCharge%RandomIndex% / 100
		; Make sure the RandomCharge number is +/-.10 from the previous
		Loop %RandomIndex% {
			If (A_Index < RandomIndex) {
				diff := RandomCharge%A_Index% - RandomCharge%RandomIndex%
				If (diff < 0)
					diff := -diff
				if (diff < .10) {
					RandomIndex--
					break
				}
			}
		}
		RandomIndex++
		If (RandomIndex > NumberOfRandomCharges)
			break
	}
	
	; Calculate the charge totals:
	TotalCharges := RandomCharge1 + RandomCharge2 + RandomCharge3
	RemainingBalance := orderAmount - TotalCharges
Return





order_Label_Click:
	target = order%A_GuiControl%
	GoTo _Label_Click
customer_Label_Click:
	target = customer%A_GuiControl%
	GoTo _Label_Click
billing_Label_Click:
	target = billing%A_GuiControl%
	GoTo _Label_Click
shipping_Label_Click:
	target = shipping%A_GuiControl%
	GoTo _Label_Click
payment_Label_Click:
	target = paymentCC%A_GuiControl%
	GoTo _Label_Click

_Label_Click:
	GUIDefault("OrdersGUI")
	; Fix some of the not-obvious titles:
	StringReplace target, target, Address 2, Address2
	StringReplace target, target, Security, Code
	StringReplace target, target, Card Type, Type
	target := RegexReplace(target, "[ ,].+", "") ; Limit to only the first word of the label
	; Get the value of the associated text box:
	GuiControlGet, title, , %target%
	
	toggleIndex++
	If (lastTarget != target) {
		lastTarget := target
		toggleIndex = 2
		originalTitle := title
	}
	
	If toggleIndex = 1
		title := originalTitle
	Else {
		If target CONTAINS paymentCCName
		{	GuiControlGet, title, , customerName
			toggleIndex = 0
		}
		Else If target CONTAINS Company,Name,Address,City,Country,Email
		{	If toggleIndex = 2
				StringUpper title, title, T
			Else If toggleIndex = 3
				StringUpper title, title
			Else If toggleIndex = 4
			{	StringLower title, title
				toggleIndex = 0
			}
		}
		Else If target CONTAINS Phone
		{	If toggleIndex = 2
				format = $1-$2-$3
			Else {
				format = ($1) $2-$3
				toggleIndex = 0
			}
			
			title := RegexReplace(title, "^\D*1?\D*(\d{3})\D*(\d{3})\D*(\d{4})\D*$", format)
		}
		Else If target CONTAINS paymentCCNumber
		{	title := RegexReplace(title, "(?<=....).(?=....)", "x")
		
			toggleIndex = 0
		}
		Else If target CONTAINS Description
		{	GuiControlGet, title, , customerName
			RegexMatch(title, "\b\w*\s*$", title)
			FormatTime DateStamp, , yyMMdd
			title = %title% %DateStamp% SR
			
			toggleIndex = 0
		}
	}
	


	GuiControl, , %target%, %title%
	GuiControl, Focus, %target%
Return

	
	
	
