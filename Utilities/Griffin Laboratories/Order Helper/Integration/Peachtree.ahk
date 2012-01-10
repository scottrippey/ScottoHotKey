; Peachtree
; Info:
; Customer Info:
;	ahk_class WindowsForms10.Window.8.app.0.378734a ; (Old)
;	ahk_class WindowsForms10.Window.8.app.0.33c0d9d ; (New)
;	Maintain Customers/Prospects
; Sales Order:
;	


; #IfWinActive ahk_class WindowsForms10.Window.8.app.0.378734a
#IfWinActive Maintain Customers/Prospects
#t::
#IfWinActive ahk_class SO_JRNL
#t::
TestPTInfo:
	Method = TESTSHOW
	GoSub GetOrTestPTInfo
Return
; #IfWinActive ahk_class WindowsForms10.Window.8.app.0.378734a
#IfWinActive Receipts
#v::
#IfWinActive Maintain Customers/Prospects
#v::
#IfWinActive ahk_class SO_JRNL
#v::
	; Wait for the Windows key up:
	KeyWait LWin
	KeyWait RWin
SetPTInfo:
	Method = POST
	customerState := StateInfo(customerState, "ABBR")
	If customerCompany =
		CUSTID := RegexReplace(customerName, "^(.*?)\s*(\S+)$", "Z" . (International ? "I" : "") . "-$2, $1")
	Else
		CUSTID := customerCompany
		
	CUSTTYPE := RegexMatch(orderItems1, "i)(TruTone|SolaTone)") ? "LARY" : RegexMatch(orderItems1, "i)(SoniVox|BoomVox)") ? "VOX" : ""
	
	; IfWinExist ahk_class WindowsForms10.Window.8.app.0.378734a ; (Customer Information form)
	IfWinExist Maintain Customers/Prospects
	{
		WinActivate
		; Define all PT-Form labels:
				; OLD:
				; ; PTFormTitle = ahk_class WindowsForms10.Window.8.app.0.378734a
				; NEW:
				ctrlCustomerID = WindowsForms10.EDIT.app.0.33c0d9d1 ; CUSTID
				PTFormTitle = Maintain Customers/Prospects
				PTFormInfo =
				(ltrim comments
					; WindowsForms10.EDIT.app.0.33c0d9d1 = CUSTID
					; WindowsForms10.EDIT.app.0.33c0d9d22 = customerName
					WindowsForms10.EDIT.app.0.33c0d9d2 = billingName
					WindowsForms10.EDIT.app.0.33c0d9d10 = billingAddress
					WindowsForms10.EDIT.app.0.33c0d9d12 = billingAddress2
					WindowsForms10.EDIT.app.0.33c0d9d13 = billingCity
					WindowsForms10.EDIT.app.0.33c0d9d14 = billingState
					WindowsForms10.EDIT.app.0.33c0d9d15 = billingZip
					WindowsForms10.EDIT.app.0.33c0d9d11 = billingCountry 
					WindowsForms10.EDIT.app.0.33c0d9d4 = CUSTTYPE
					WindowsForms10.EDIT.app.0.33c0d9d7 = customerPhone
					WindowsForms10.EDIT.app.0.33c0d9d5 = customerEmail
				)
				ctrlCustomerTabs = WindowsForms10.SysTabControl32.app.0.33c0d9d1
				ctrlCopyShipButton = WindowsForms10.BUTTON.app.0.33c0d9d14
				ctrlShippingAddress = WindowsForms10.Window.8.app.0.33c0d9d23
				ctrlGLAccount = WindowsForms10.EDIT.app.0.33c0d9d23
				ctrlPricingLevel = WindowsForms10.EDIT.app.0.33c0d9d25



				;ctrlControlBeforeShippingAddress2 = &Copy
		; Done with the PT labels.


		; Select the General tab
		SendMessage, 0x1330, 0,, %ctrlCustomerTabs%  ; 0x1330 is TCM_SETCURFOCUS.
		Sleep 30
		
		; See if the Customer ID has been filled in; if not, fill in the first few letters:
		ControlGetText CUSTIDtext, %ctrlCustomerID%
		ControlFocus %ctrlCustomerID% ; Activate the CUSTID box

		If CUSTIDtext =
		{	;StringLeft CUSTID, CUSTID, 7 ; Only enter the first 7 letters of the CUSTID
			SendRaw %CUSTID%
			Return
		}
		If customerCompany =
			SendRaw `t%customerName%
		Else
			SendRaw `t%customerCompany%


		
		
		; Fill the data from the form:
		If !FillForm(PTFormTitle, PTFormInfo, Method)
			Return
		Sleep 1000
		

		msg =
			
		; Fill in the secondary address:
		; Select the Shipping tab:
		SendMessage, 0x1330, 1,, %ctrlCustomerTabs% ; 0x1330 is TCM_SETCURFOCUS.
		Sleep 100
		ControlFocus %ctrlCustomerTabs%
		If (shippingSame and billingSame) {
		
			; ; Click the Copy button:
			; ControlGetPos x,y,w,h, %ctrlCopyShipButton%
			; x += w/2
			; y += h/2
			; CoordMode Mouse, Relative
			; Click %x%,%y%
			Send {Tab 2}{Space}
			Sleep 1000
		} Else {
			; ; Enter the shipping address:
			; ControlGetPos x,y,,, %ctrlShippingAddress%
			; x += 5
			; y += 5
			; CoordMode Mouse, Relative
			; Click %x%,%y%
			Send {Tab 3}
			SendRaw,
			(ltrim join comments 
				%shippingName%`t
				%shippingAddress%`t
				%shippingAddress2%`t
				%shippingCity%`t
				%shippingState%`t
				%shippingZip%`t
				%shippingCountry%`t
			)
			Sleep 1500
			msg = Shipping Address is different from Billing Address.`n
		}
		
		If customerState = CA
			msg .= "Choose a Sales Tax city, since this customer lives in California.`n"

			
		; Select the Sales Info tab:
		SendMessage, 0x1330, 3,, %ctrlCustomerTabs% ; 0x1330 is TCM_SETCURFOCUS.
		Sleep 100
		ControlFocus %ctrlCustomerTabs%
		
		; Fill in the Sales Info:
		; ControlFocus %ctrlGLAccount%
		; SendRaw %GLAccount%
		; ControlFocus %ctrlPricingLevel%
		; Send R{Enter} ; (RETAIL)
		SendRaw `t`t%GLAccount%`t`t`t`tR`r

		; Gui +OwnDialogs
		; MsgBox,
		; (ltrim
			; Just a reminder, the following things still need to be checked:
			; %msg%Change tabs over to "Sales Info" and choose a GL Sales Account and a Pricing Level.
		; )
		
	} Else IfWinExist ahk_class SO_JRNL ; (Sales Order Form)
	{
		WinActivate
		ctrlCUSTID = BBD_EditCust1
		; See if the Customer ID has been filled in; if not, fill in the first few letters:
		ControlGetText CUSTIDtext, %ctrlCUSTID%
		ControlFocus %ctrlCUSTID% ; Activate the CUSTID box
		If CUSTIDtext =
		{	;StringLeft CUSTID, CUSTID, 7 ; Only enter the first 7 letters of the CUSTID
			SendRaw %CUSTID%
			Return
		}
		
		
		PTFormTitle = ahk_class SO_JRNL
		PTFormInfo =
		(ltrim comments
			;BBD_EditCust1 = CUSTID ; &Customer ID: 
			ABD_Edit2 = orderDescription ; Customer &PO 
			Edit1 *= orderShippingMethod ; Ship Via ("*=" -> skip blank check)
			BBD_EditSalesRep1 = SalesRepPTID ; Sa&les Rep 
			;ABD_Dollars1 = orderTax ; Sales Ta&x: 
			ABD_Dollars2 = orderShippingCost ; Frei&ght: 
		)
		IF !FillForm(PTFormTitle, PTFormInfo, Method)
			Return

			
			
		ControlFocus BBD_EditSalesRep1, ahk_class SO_JRNL ; Focus the Sales Rep box
		Send {Tab 3}
		; Now we are focused on the QTY box, so let's loop for each orderItems
		Loop, 6
		{
			orderItemNumbers := FindProduct(orderItems%A_Index%,"NUMBERS")
			orderItemQty := orderItemsQty%A_Index%
			Loop, parse, orderItemNumbers, `n, *
			{
				If A_LoopField =
					continue
				ProductNumber := A_LoopField
				ProductPrice =
				ProductDesc =
				If RegexMatch(ProductNumber, ProductNumberPattern, m) {
					ProductNumber := mNum
					ProductQuantity := mQty
					ProductPrice := mPrice
					ProductDesc := mDesc
					If ProductQuantity != 
						orderItemQty *= ProductQuantity
				}
					
				SendRaw,
				(ltrim join comments
					%orderItemQty%`t ; Quantity
					%ProductNumber%`t ; Item Number
					`t ; U/M (?)
					%ProductDesc%`t ; Description
					%GLACCOUNT%`t ; Account
					%ProductPrice%`t ; Price
					`t ; Tax Code
					`t ; Total Price
					`t ; Job
				)
			}
		}
		
		If orderDiscount !=
		{	If orderCoupon !=
				discDesc = Web Coupon "%orderCoupon%"
			Else
				discDesc = Special One-Time Discount
			SendRaw,
			(ltrim join comments
				1`t
				`t
				`t
				%discDesc%`t
				%GLACCOUNT%`t
				-%orderDiscount%`t
				`t
				`t
				`t
			)
		}
		
		
		
		TRACK = Track #
		If orderShippingService = UPS
			TRACK = Track UPS
		Else If orderShippingService = USPS
			TRACK = Track US
		SendRaw,
		(ltrim join comments
			1`t ; Quantity
			%TRACK% ; Item Number
		)

		

		
		Gui +OwnDialogs
		MsgBox,
		(ltrim
			Just a reminder, the following things still need to be checked:
			Check all items, check quantities, check prices.
			Change the Shipping Method.
			Enter a Track method according to the shipping method.
			Enter the Freight charges.
			Check the Shipping Address.
		)

	} Else IfWinExist Receipts ; (Receive money from customer)
	{	
		WinActivate
		ctrlCUSTID = BBD_EditCust1
		; See if the Customer ID has been filled in; if not, fill in the first few letters:
		ControlGetText CUSTIDtext, %ctrlCUSTID%
		ControlFocus %ctrlCUSTID% ; Activate the CUSTID box
		If CUSTIDtext =
		{	;StringLeft CUSTID, CUSTID, 7 ; Only enter the first 7 letters of the CUSTID
			SendRaw %CUSTID%
			Return
		}
		; ctrlReference = ABD_Edit2
		; ctrlReceipt = ABD_Edit3
		; ctrlPayment = Edit1
		; ctrlPrepayment = CPTCheckbox1
		; ctrlList = EListEdit2
		
		amount := RandomCharge1 + RandomCharge2 + RandomCharge3

		
		Reference =
		Loop, 3
		{	GUI +OwnDialogs
			If AuthCode%A_Index% =
				InputBox AuthCode%A_Index%, Reference Numbers, Please enter the reference number from Receipt #%A_Index% of 3.
			Reference .= AuthCode%A_Index%
			If A_Index < 3
				Reference .= ","
		}
		
		
		ControlFocus %ctrlCUSTID%
		Sleep 100
		SendRaw,
		(ltrim join comments
			`t
			%Reference%`t
			`t
			`t
			%paymentCCType%`t
			`t
			`t
			` `t
			`t
			Verification Charges for %orderDescription%`t
			`t
			%amount%
		)
		
		; ControlFocus %ctrlCUSTID%
		; SendRaw %CUSTID%
		
		; ControlFocus %ctrlReceipt%
		; SendRaw %orderDescription%
		
		; ControlFocus %ctrlPayment%
		; SendRaw %paymentCCType%
		
		; ControlFocus %ctrlPrepayment%
		; Send {Space}
		
		; SendRaw,
		; (ltrim join comments
			; `t`t
			; Verification Charges for %orderDescription%`t
			; `t
			; %amount%
		; )
		
		; Done.
	}
	
	
Return
; #IfWinActive ahk_class WindowsForms10.Window.8.app.0.378734a
#IfWinActive Maintain Customers/Prospects
#c::
#IfWinActive ahk_class SO_JRNL
#c::
GetPTInfo:
	Method = GET
	GoSub GetOrTestPTInfo



	GoSub RefreshOrderGUI
Return



	

GetOrTestPTInfo:
	;IfWinExist ahk_class WindowsForms10.Window.8.app.0.378734a ; (Customer Information form)
	IfWinExist Maintain Customers/Prospects ; (Customer Information form)
	{
		; PTFormTitle = ahk_class WindowsForms10.Window.8.app.0.378734a
		PTFormTitle = Maintain Customers/Prospects
		; (from the laptop)
		PTFormInfo =
		(ltrim comments
			; ; ;WindowsForms10.EDIT.app.0.378734a1 = CUSTID ; *Customer ID: 
			; ; ;WindowsForms10.EDIT.app.0.378734a22 = customerName ; Name: 
			; ; WindowsForms10.EDIT.app.0.378734a2 = customerName ; Contact: 
			; ; WindowsForms10.EDIT.app.0.378734a10 = customerAddress ; Billing Address: 
			; ; WindowsForms10.EDIT.app.0.378734a12 = customerAddress2 ; Billing Address: 
			; ; WindowsForms10.EDIT.app.0.378734a13 = customerCity ; City, ST, Zip: 
			; ; WindowsForms10.EDIT.app.0.378734a14 = customerState ; City, ST, Zip: 
			; ; WindowsForms10.EDIT.app.0.378734a15 = customerZip ; City, ST, Zip: 
			; ; WindowsForms10.EDIT.app.0.378734a11 = customerCountry ; Country: 
			; ; WindowsForms10.EDIT.app.0.378734a4 = CUSTTYPE ; Customer Type:   
			; ; WindowsForms10.EDIT.app.0.378734a7 = customerPhone ; Telephone 1: 
			; ; WindowsForms10.EDIT.app.0.378734a5 = customerEmail ; E-mail: 
			; ; ;WindowsForms10.SysTabControl32.app.0.378734a1 = (Tab Control) ;  
			; ; ;WindowsForms10.BUTTON.app.0.378734a8 = (Copy to Ship Address)
			; NEW:
			; WindowsForms10.EDIT.app.0.33c0d9d1 = CUSTID
			; WindowsForms10.EDIT.app.0.33c0d9d22 = customerName
			WindowsForms10.EDIT.app.0.33c0d9d2 = customerName
			WindowsForms10.EDIT.app.0.33c0d9d10 = customerAddress
			WindowsForms10.EDIT.app.0.33c0d9d12 = customerAddress2
			WindowsForms10.EDIT.app.0.33c0d9d13 = customerCity
			WindowsForms10.EDIT.app.0.33c0d9d14 = customerState
			WindowsForms10.EDIT.app.0.33c0d9d15 = customerZip
			WindowsForms10.EDIT.app.0.33c0d9d11 = customerCountry 
			WindowsForms10.EDIT.app.0.33c0d9d4 = CUSTTYPE
			WindowsForms10.EDIT.app.0.33c0d9d7 = customerPhone
			WindowsForms10.EDIT.app.0.33c0d9d5 = customerEmail
			;
			; For Testing:
			WindowsForms10.EDIT.app.0.33c0d9d1 = CUSTID
		)
	} Else IfWinExist ahk_class SO_JRNL ; (Sales Order form)
	{	
		PTFormTitle = ahk_class SO_JRNL
		PTFormInfo =
		(ltrim comments
			;BBD_EditCust1 = CUSTID ; &Customer ID: 
			ABD_Edit2 = orderDescription ; Customer &PO 
			Edit5 = orderShippingMethod ; Ship Via 
			BBD_EditSalesRep1 = SalesRepPTID ; Sa&les Rep 
			ABD_Dollars2 = orderTax ; Sales Ta&x: 
			ABD_Dollars3 = orderShippingCost ; Frei&ght: 
		)
	} Else {
		Gui +OwnDialogs
		MsgBox Could not find Peachtree; please make sure Peachtree is open!
		Return
	}
	
	FillForm(PTFormTitle, PTFormInfo, Method)
Return



#IfWinActive
