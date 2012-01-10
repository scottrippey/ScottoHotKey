; Auto-Execute:
	; GoSub ShowOrderGUI
Return

#o::
	GoSub ShowOrderGUI
Return


ShowOrderGUI:
	GoSub PrepareVariables
	GoSub LoadGUI
	GoSub RestoreVariables
	OrderSaved()
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
		
	; If ProductList =
		; GoSub LoadAllProducts

	orderItems1 := FindProduct(orderItems1, "INDEX")
	orderItems2 := FindProduct(orderItems2, "INDEX")
	orderItems3 := FindProduct(orderItems3, "INDEX")
	orderItems4 := FindProduct(orderItems4, "INDEX")
	orderItems5 := FindProduct(orderItems5, "INDEX")
	orderItems6 := FindProduct(orderItems6, "INDEX")
	
	If SalesRepIndex =
		SalesRepIndex = 1
	If GLAccountIndex =
		GLAccountIndex = 1
	
Return

RestoreVariables:
	; Restore all GUI input back to the appropriate variables
	customerState := StateInfo(customerState, "ABBR")
	shippingState := StateInfo(shippingState, "ABBR")
	billingState := StateInfo(billingState, "ABBR")

	RegexMatch(customerName, "^(\S+)", customerFirstName)
	RegexMatch(customerName, "(\S+)$", customerLastName)
	
	; Retrieve the last 4 digits for paymentCCNumberC:
	RegexMatch(paymentCCNumber, "^(?<A>....)?(?<B>.*?)(?<C>....)?$", paymentCCNumber)

	orderShippingService =
	IfInString orderShippingMethod, UPS
		orderShippingService = UPS
	IfInString orderShippingMethod, USPS
		orderShippingService = USPS
	
	
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

	orderItems1 := FindProduct(orderItems1, "TITLE")
	orderItems2 := FindProduct(orderItems2, "TITLE")
	orderItems3 := FindProduct(orderItems3, "TITLE")
	orderItems4 := FindProduct(orderItems4, "TITLE")
	orderItems5 := FindProduct(orderItems5, "TITLE")
	orderItems6 := FindProduct(orderItems6, "TITLE")
	
	
	SalesRepName 	:= SalesRep%SalesRepIndex%Name
	SalesRepEmail 	:= SalesRep%SalesRepIndex%Email
	SalesRepPTID 	:= SalesRep%SalesRepIndex%PTID
	SalesRepInitials := SalesRep%SalesRepIndex%Initials
	
	GLAccount		:= GLAccount%GLAccountIndex%

	virtualMerchantPasteIndex := 1
	sendCCNumber := true
	
Return


















LoadGUI:

;;;;;;;;;;;;; Create the GUI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Create a unique OrderWindowKey:
Loop 90
{	OrderWindowKey = OrderWindow#%A_Index%,
	IfNotInString OrderWindowKeys, %OrderWindowKey%
		break ; We found a unique key
	If A_Index = 90
		Return ; Too many!!!
}
OrderWindowKeys .= OrderWindowKey
GuiUniqueDefault(OrderWindowKey)
Gui, +LabelOrdersGui_

Gui, Add, Text, vOrderWindowKey Hidden w0 h0, %OrderWindowKey%


Gui, Add, GroupBox, x2 y2 w250 h140 , Import Info From: (shortcut: Win+C)
	Gui, Add, Button, x12 y22 w230 h20 gImportOSCommerce_Click, Web Order =>
	Gui, Add, Button, x12 y42 w230 h20 gImportACT_Click, ACT! =>
	Gui, Add, Button, x12 y62 w230 h20 gImportPT_Click, PeachTree =>
	
	Gui, Add, Button, x12 y92 w170 h20 gNew_Click, &New Order Window
	Gui, Add, Button, x182 y92 w60 h20 gClearAll_Click, &Clear All
	;Gui, Add, Button, x12 y92 w230 h20 gRevert_Click, &Revert Changes
	Gui, Add, Button, x12 y112 w230 h20 gLoadAllOrderVars_Click, &Load From File...
Gui, Add, GroupBox, x262 y2 w250 h140 , Export Info To: (shortcut: Win+V)
	Gui, Add, Button, x272 y22 w230 h20 gExportVM_Click, <= &Virtual Merchant
	Gui, Add, Button, x272 y42 w230 h20 gExportACT_Click, <= AC&T!
	Gui, Add, Button, x272 y62 w230 h20 gExportPT_Click, <= &PeachTree
	
	Gui, Add, Button, x272 y92 w230 h20 gApply_Click +Default, &Apply
	;Gui, Add, Button, x272 y92 w230 h20 gCopy_Click, &Copy Fields to Clipboard
	Gui, Add, Button, x272 y112 w230 h20 gSaveAllOrderVars_Click, &Save To File...

Gui, Add, Button, x522 y2 w250 h40 gHelp_Click, Help (User's Guide)
	
Gui, Add, GroupBox, x522 y42 w250 h100 , Other Information
Gui, Add, Text, x532 y62 w70 h20 , Sales Agent
	Gui, Add, DropDownList, x602 y62 w160 AltSubmit vSalesRepIndex gSalesRep_Or_OrderSource_Changed Choose%SalesRepIndex% , %AllSalesReps%
Gui, Add, Text, x532 y112 w70 h20 , Order Source
	Gui, Add, DropDownList, x602 y112 w160 AltSubmit vGLAccountIndex gSalesRep_Or_OrderSource_Changed Choose%GLAccountIndex%, %AllGLAccounts%

	
	
	
	
	
	
	
	
	


	
		
	
	





Gui, Add, GroupBox, x2 y152 w250 h200  , Customer Info
	Gui, Add, Button, x202 y152 w40 h20 vcustomerAddressCopy gCustomerAddress_Click, Copy
Gui, Add, Text, x12 y172 w70 h20 gcustomer_Label_Click, Company
	Gui, Add, Edit, x82 y172 w160 h20 g_Changed vcustomerCompany, %customerCompany%
Gui, Add, Text, x12 y192 w70 h20 gcustomer_Label_Click, Name
	Gui, Add, Edit, x82 y192 w160 h20 g_Changed vcustomerName, %customerName%
Gui, Add, Text, x12 y212 w70 h20 gcustomer_Label_Click, Address
	Gui, Add, Edit, x82 y212 w160 h20 g_Changed vcustomerAddress, %customerAddress%
Gui, Add, Text, x12 y232 w70 h20 gcustomer_Label_Click, Address 2
	Gui, Add, Edit, x82 y232 w160 h20 g_Changed vcustomerAddress2, %customerAddress2%
Gui, Add, Text, x12 y252 w70 h20 gcustomer_Label_Click, City
	Gui, Add, Edit, x82 y252 w160 h20 g_Changed vcustomerCity, %customerCity%
Gui, Add, Text, x12 y272 w70 h20 , State, Zip
	Gui, Add, DropDownList, x82 y272 w120 gCustomerState_Changed Sort AltSubmit vcustomerState Choose%customerState%, %allStates%
	Gui, Add, Edit, x202 y272 w40 h20 gcustomerZip_Changed vcustomerZip, %customerZip%
Gui, Add, Text, x12 y292 w70 h20 gcustomer_Label_Click, Country
	Gui, Add, Edit, x82 y292 w160 h20 g_Changed vcustomerCountry, %customerCountry%
Gui, Add, Text, x12 y312 w70 h20 gcustomer_Label_Click, Phone
	Gui, Add, Edit, x82 y312 w160 h20 gcustomerPhone_Changed vcustomerPhone, %customerPhone%
Gui, Add, Text, x12 y332 w70 h20 gcustomer_Label_Click, Email
	Gui, Add, Edit, x82 y332 w160 h20 g_Changed vcustomerEmail, %customerEmail%

	
Gui, Add, GroupBox, x262 y152 w250 h165 , Shipping Info
	Gui, Add, CheckBox, x342 y152 w120 h20 vshippingSame Checked%shippingSame% gShippingSame_CheckChanged , Same As Customer
	Gui, Add, Button, x462 y152 w40 h20 vshippingAddressCopy gShippingAddress_Click, Copy
Gui, Add, Text, x272 y172 w70 h20 gshipping_Label_Click, Company
	Gui, Add, Edit, x342 y172 w160 h20 g_Changed vshippingCompany, %shippingCompany%
Gui, Add, Text, x272 y192 w70 h20 gshipping_Label_Click, Name
	Gui, Add, Edit, x342 y192 w160 h20 g_Changed vshippingName, %shippingName%
Gui, Add, Text, x272 y212 w70 h20 gshipping_Label_Click, Address
	Gui, Add, Edit, x342 y212 w160 h20 g_Changed vshippingAddress, %shippingAddress%
Gui, Add, Text, x272 y232 w70 h20 gshipping_Label_Click, Address 2
	Gui, Add, Edit, x342 y232 w160 h20 g_Changed vshippingAddress2, %shippingAddress2%
Gui, Add, Text, x272 y252 w70 h20 gshipping_Label_Click, City
	Gui, Add, Edit, x342 y252 w160 h20 g_Changed vshippingCity, %shippingCity%
Gui, Add, Text, x272 y272 w70 h20 , State, Zip
	Gui, Add, DropDownList, x342 y272 w120 gShippingState_Changed Sort AltSubmit vshippingState Choose%shippingState%, %allStates%
	Gui, Add, Edit, x462 y272 w40 h20 gshippingZip_Changed vshippingZip, %shippingZip%
Gui, Add, Text, x272 y292 w70 h20 gshipping_Label_Click, Country
	Gui, Add, Edit, x342 y292 w160 h20 g_Changed vshippingCountry, %shippingCountry%
GoSub ShippingSame_CheckChanged
	
Gui, Add, GroupBox, x522 y152 w250 h165 , Billing Info
	Gui, Add, CheckBox, x602 y152 w120 h20 vbillingSame Checked%billingSame% gBillingSame_CheckChanged, Same As Customer
	Gui, Add, Button, x722 y152 w40 h20 vbillingAddressCopy gBillingAddress_Click, Copy
Gui, Add, Text, x532 y172 w70 h20 gbilling_Label_Click, Company
	Gui, Add, Edit, x602 y172 w160 h20 g_Changed vbillingCompany, %billingCompany%
Gui, Add, Text, x532 y192 w70 h20 gbilling_Label_Click, Name
	Gui, Add, Edit, x602 y192 w160 h20 g_Changed vbillingName, %billingName%
Gui, Add, Text, x532 y212 w70 h20 gbilling_Label_Click, Address
	Gui, Add, Edit, x602 y212 w160 h20 g_Changed vbillingAddress, %billingAddress%
Gui, Add, Text, x532 y232 w70 h20 gbilling_Label_Click, Address 2
	Gui, Add, Edit, x602 y232 w160 h20 g_Changed vbillingAddress2, %billingAddress2%
Gui, Add, Text, x532 y252 w70 h20 gbilling_Label_Click, City
	Gui, Add, Edit, x602 y252 w160 h20 g_Changed vbillingCity, %billingCity%
Gui, Add, Text, x532 y272 w70 h20 , State, Zip
	Gui, Add, DropDownList, x602 y272 w120 gBillingState_Changed Sort AltSubmit vbillingState Choose%billingState%, %allStates%
	Gui, Add, Edit, x722 y272 w40 h20 gbillingZip_Changed vbillingZip, %billingZip%
Gui, Add, Text, x532 y292 w70 h20 gbilling_Label_Click, Country
	Gui, Add, Edit, x602 y292 w160 h20 g_Changed vbillingCountry, %billingCountry%
GoSub BillingSame_CheckChanged
	
Gui, Add, GroupBox, x2 y352 w250 h150 , Payment Info
Gui, Add, Text, x12 y372 w70 h20 gpayment_Label_Click, Card Type
	Gui, Add, Edit, x82 y372 w160 h20 Readonly vpaymentCCType, %paymentCCType%
Gui, Add, Text, x12 y392 w70 h20 gpayment_Label_Click, Name
	Gui, Add, Edit, x82 y392 w160 h20 g_Changed vpaymentCCName, %paymentCCName%
Gui, Add, Text, x12 y412 w70 h20 gpayment_Label_Click, Number
	Gui, Add, Edit, x82 y412 w160 h20 gCCNumber_Changed vpaymentCCNumber, %paymentCCNumber%
Gui, Add, Text, x12 y432 w70 h20 gpayment_Label_Click, Expires
	Gui, Add, Edit, x82 y432 w80 h20 gCCExpires_Changed vpaymentCCExpires, %paymentCCExpires%
Gui, Add, Text, x162 y432 w40 h20 gpayment_Label_Click, Security
	Gui, Add, Edit, x202 y432 w40 h20 g_Changed vpaymentCCCode, %paymentCCCode%
Gui, Add, Button, x172 y452 w70 h20 gDeclined_Click, Declined?
GoSub CCNumber_Changed
	
Gui, Add, GroupBox, x262 y312 w250 h210 , Order Totals
Gui, Add, Text, x272 y332 w70 h20 gorder_Label_Click, Description
	Gui, Add, Edit, x342 y332 w160 h20 g_Changed vorderDescription, %orderDescription%
	
; Gui, Add, Text, x272 y352 w70 h20 , Sales Tax
	; Gui, Add, Edit, x342 y352 w160 h20 g_Changed vorderTax, %orderTax%
; Gui, Add, Text, x272 y372 w70 h20 , Total
	; Gui, Add, Edit, x342 y372 w160 h20 gUpdateRemainingBalance vorderAmount, %orderAmount%

Gui, Add, Text, x272 y352 w70 h20 , Shipping
	Gui, Add, ComboBox, x342 y352 w120 g_Changed vorderShippingMethod , %orderShippingMethod%|| |UPS Ground|UPS 2 Day Air|UPS Next Day Air
	Gui, Add, Edit, x462 y352 w40 h20 g_Changed vorderShippingCost , %orderShippingCost%
Gui, Add, Text, x272 y372 w70 h20 , CA Sales Tax
	Gui, Add, Edit, x342 y372 w160 h20 g_Changed vorderTax, %orderTax%
Gui, Add, Text, x272 y392 w70 h20 , Discount
	Gui, Add, Edit, x342 y392 w80 h20 g_Changed vorderCoupon, %orderCoupon%
	Gui, Add, Edit, x422 y392 w80 h20 g_Changed vorderDiscount, %orderDiscount%
Gui, Add, Text, x272 y412 w70 h20 , Order Total
	Gui, Add, Edit, x342 y412 w160 h20 gUpdateRemainingBalance vorderAmount, %orderAmount%
	
	
	
	
Gui, Add, GroupBox, x272 y442 w230 h62 , 
	Gui, Add, CheckBox, x282 y442 w90 h20 vInternational Checked%International% gInternational_CheckedChanged, International
	Gui, Add, CheckBox, x382 y442 w60 h20 vInternationalVerified Checked%InternationalVerified% gInternationalVerified_CheckedChanged, Verified?
	Gui, Add, Button, x442 y442 w70 h20 gVerifyConversion_Click, Conversion?
Gui, Add, Text, x282 y462 w100 h20 , Verification Charges
	Gui, Add, Edit, x382 y462 w40 h20 gUpdateRemainingBalance vRandomCharge1, %RandomCharge1%
	Gui, Add, Edit, x422 y462 w40 h20 gUpdateRemainingBalance vRandomCharge2, %RandomCharge2%
	Gui, Add, Edit, x462 y462 w40 h20 gUpdateRemainingBalance vRandomCharge3, %RandomCharge3%
Gui, Add, Text, x282 y482 w100 h20 , Remaining Total
	Gui, Add, Edit, x382 y482 w120 h20 Readonly vRemainingBalance, %RemainingBalance%
GoSub International_CheckedChanged
GoSub InternationalVerified_CheckedChanged
GoSub UpdateRemainingBalance

Gui, Add, GroupBox, x522 y312 w250 h210 , Ordered Products
	Gui, Add, ComboBox, x532 y332 w40 g_Changed vOrderItemsQty1 , %OrderItemsQty1%|| |1|2|3|5|10|15|20|30
	Gui, Add, DropDownList, x572 y332 w170 gProductList1_Changed AltSubmit vOrderItems1 Choose%orderItems1% , %ProductList%
	Gui, Add, Button, x742 y332 w20 h20 gShowProductNumbers1, ?
	
	Gui, Add, ComboBox, x532 y362 w40 g_Changed vOrderItemsQty2 , %OrderItemsQty2%|| |1|2|3|5|10|15|20|30
	Gui, Add, DropDownList, x572 y362 w170 gProductList2_Changed AltSubmit vOrderItems2 Choose%orderItems2% , %ProductList%
	Gui, Add, Button, x742 y362 w20 h20 gShowProductNumbers2, ?
	
	Gui, Add, ComboBox, x532 y392 w40 g_Changed vOrderItemsQty3 , %OrderItemsQty3%|| |1|2|3|5|10|15|20|30
	Gui, Add, DropDownList, x572 y392 w170 gProductList3_Changed AltSubmit vOrderItems3 Choose%orderItems3% , %ProductList%
	Gui, Add, Button, x742 y392 w20 h20 gShowProductNumbers3, ?
	
	Gui, Add, ComboBox, x532 y422 w40 g_Changed vOrderItemsQty4 , %OrderItemsQty4%|| |1|2|3|5|10|15|20|30
	Gui, Add, DropDownList, x572 y422 w170 gProductList4_Changed AltSubmit vOrderItems4 Choose%orderItems4% , %ProductList%
	Gui, Add, Button, x742 y422 w20 h20 gShowProductNumbers4, ?
	
	Gui, Add, ComboBox, x532 y452 w40 g_Changed vOrderItemsQty5 , %OrderItemsQty5%|| |1|2|3|5|10|15|20|30
	Gui, Add, DropDownList, x572 y452 w170 gProductList5_Changed AltSubmit vOrderItems5 Choose%orderItems5% , %ProductList%
	Gui, Add, Button, x742 y452 w20 h20 gShowProductNumbers5, ?
	
	Gui, Add, ComboBox, x532 y482 w40 g_Changed vOrderItemsQty6 , %OrderItemsQty6%|| |1|2|3|5|10|15|20|30
	Gui, Add, DropDownList, x572 y482 w170 gProductList6_Changed AltSubmit vOrderItems6 Choose%orderItems6% , %ProductList%
	Gui, Add, Button, x742 y482 w20 h20 gShowProductNumbers6, ?
	
	

Gui, Add, GroupBox, x522 y522 w250 h80 , Comments
	Gui, Add, Edit, x532 y542 w230 h50 g_Changed vComments, %Comments%
	


Gui, +AlwaysOnTop +OwnDialogs
	; Generated using SmartGUI Creator 4.0
Gui, Show, h617 w787, Order Helper

Return











