#IfWinActive Untitled - Notepad
#c::
#IfWinActive osCommerce ;- www.griffinlab.com - Mozilla Firefox
#c::
GetOrderFromOSCommerce:
	; Wait for the Windows key up:
	KeyWait LWin
	KeyWait RWin
	
	; Let's parse out the billing information:
	; Copy 
	GoSub BackupClipboard
	Send ^a ; Select all
	Send ^c ; Copy
	ClipWait 4 ; Wait for clipboard
	;Sleep 500 ; Wait for clipboard
	; Normalize the newline character from the clipboard:
	clip := clipboard

	
	; ; Get the web-order number:
	; ; (easiest way is to extract it from the order URL)
	; Send ^l ; Go to the address bar
	; Sleep 50
	; Send ^c ; Copy 
	; ClipWait 1
	; ;Sleep 500 ; Wait for clipboard
	; orderURL := clipboard
	; RegexMatch(orderURL, "(?<=oID\=)\d+", webOrderNumber)

ParseOrder: ; (entry-point for testing purposes)

	; Normalize carriage returns:
	StringReplace clip, clip, `r`n, `n, All
	;StringReplace clip, clip, `r, `n, All
	StringReplace clip, clip, `n, `r`n, All

	
;;;;;;;;;;;; Parsing Patterns ;;;;;;;;;;;;;;
	sectionPatterns =
	(	
		ixsm)
		^Order \#(?<webOrderNumber>\d+)	.*?
		^Customer:\s*	(?<Customer>.*?)
		^Shipping Address:\s*	(?<Shipping>.*?)
		^Billing Address:\s*	(?<Billing>.*?)
		^Payment Method:\s*	(?<Payment>.*?)
		^Products	.*?$\s\s	(?<Order>.*?)
		^Date Added
	)
	StringReplace sectionPatterns, sectionPatterns, %A_Space%, \s, All
	
	infoPattern =
	(
		ixm)
		(?:	^	(?<Company>.+)	\s\s	)?
			^	(?<Name>	(?<FirstName>[A-Za-z]+)	[^\r\n\d]*	)
		\s\s^	(?<Address>.*)
		(?:\s\s^(?<Address2>.+)		)?
		\s\s^	(?<City>.*?)		(, )	(?<State>.*)	\s	(?<Zip>[0-9-]+)
		\s\s^	(?<Country>United States)
		(?:\s\s^Telephone Number:	\s*	(?<Phone>.*)	
		\s\s^	E-Mail Address:	\s*	(?<Email>.*)		)?
	)
	StringReplace infoPattern, infoPattern, %A_Space%, \s, All	; Escape all the spaces
	StringReplace infoPattern, infoPattern, [\s, [%A_Space%, All ; Don't escape these spaces
	intlInfoPattern =
	(
		ixm)
		(?:	^	(?<Company>.+)	\s\s	)?
			^	(?<Name>	(?<FirstName>[A-Za-z]+)	[^\r\n\d]*	)
		\s\s^	(?<Address>.*)
		(?:\s\s^(?<Address2>.+)		)?
		\s\s^	(?<City>.*?)	(, )	(?<Zip>.+)
		\s\s^	(?<Country>.*?	(, )	.*)
		(?:\s\s^Telephone Number:	\s*	(?<Phone>.*)	
		\s\s^	E-Mail Address:	\s*	(?<Email>.*)		)?
	)	
	StringReplace intlInfoPattern, intlInfoPattern, %A_Space%, \s, All	; Escape all the spaces
	StringReplace intlInfoPattern, intlInfoPattern, [\s, [%A_Space%, All ; Don't escape these spaces
	
	billingPattern =
	(
		ixm)
	\s*^Credit Card Type:	\s*	(?<CCType>.*)
	\s*^Credit Card Owner:	\s*	(?<CCName>.*)
	\s*^Credit Card Number:	\s*	(?<CCNumberA>\d+)X*(?<CCNumberC>\d+)
	\s*^CVV2:	\s*	(?<CCCode>\d+)
	\s*^Credit Card Expires:	\s*	(?<CCExpires>\d+)
	)
	StringReplace billingPattern, billingPattern, %A_Space%, \s, All	; Escape all the spaces

	orderPattern =
	(
		ixsm)
		(?<Items>.*)
		Sub-Total:	.*?
		(?:	\s\s^	Discount Coupons:(?<Coupon>.+?):	\s+		-\$(?<Discount>[0-9.]+)	$)?
		(?:	\s\s^	CA Sales Tax:	\s+	\$(?<Tax>[0-9.]+)	$)?
		\s\s^	(?<ShippingService>.*?)		\s\(.*?\)\s		\((?<ShippingMethod>.*?)(:.*?)?\):\s*	\$(?<ShippingCost>\d+\.\d\d)
		\s\s^	Total:	\s*	\$(?<Amount>[0-9,.]+)
	)
	StringReplace orderPattern, orderPattern, %A_Space%, \s, All	; Escape all the spaces
	
	
;;;;;;;;;;;;; Do all the parsing ;;;;;;;;;;;;;;;
	GoSub ClearAllOrderVars
	
	If Not RegexMatch(clip, sectionPatterns, section) {
		MsgBox Could not find sectionPatterns!  Canceling. `n%clip%
		GoSub RestoreClipboard
		Return
	}
	webOrderNumber := sectionwebOrderNumber
	
	International := 0
	If Not RegexMatch(sectionCustomer, infoPattern, customer) {
		International := 1
		If Not RegexMatch(sectionCustomer, intlInfoPattern, customer) {
			International := 0
			MsgBox Customer Address Error: `n %sectionCustomer%
		}
	}
	If Not RegexMatch(sectionShipping, infoPattern, shipping) {
		If Not RegexMatch(sectionShipping, intlInfoPattern, shipping)
			MsgBox Shipping Address Error: `n %sectionShipping%
	}
	If Not RegexMatch(sectionBilling, infoPattern, billing) {
		If Not RegexMatch(sectionBilling, intlInfoPattern, billing)
			MsgBox Billing Address Error: `n %sectionBilling%
	}
	If Not RegexMatch(sectionPayment, billingPattern, payment)
		MsgBox Payment Details Error: `n %sectionPayment%
	If Not RegexMatch(sectionOrder, orderPattern, order) 
		MsgBox Order Error: `n %sectionOrder%
	
	; Process the infoPatterns:
	If RegexMatch(customerPhone, "^(\d{3})\D?(\d{3})\D?(\d{4})$", phone)
		customerPhone = %phone1%-%phone2%-%phone3%
	; See if the state matches the zip:
	addressSections = Customer,Shipping,Billing
	Loop, parse, addressSections, `,
	{	zip := %A_LoopField%Zip
		state := %A_LoopField%State
		zipState := FindZip(zip, "STATE")
		If (state != zipState)
		{	; The zip code doesn't match the state:
			SetButtonNames("State Mismatch", "&" zipState, "&" state)
			msg =
			(ltrim
				The %A_LoopField% Zip Code (%zip%) belongs to %zipState%,
				which does not match the %A_LoopField% State (%state%).
				
				Which is the correct state?
			)
			MsgBox 0x1044, State Mismatch, %msg%
			IfMsgBox Yes ; Correct the state:
				%A_LoopField%State := zipState
		}
	}
	
	
	; Process the shipping options:
	If orderShippingService = United Parcel Service
		orderShippingService = UPS
	If orderShippingService = United States Postal Service
		orderShippingService = USPS
	IfInString orderShippingMethod, Express Mail International (EMS)
		orderShippingMethod = EMS Int'l
	orderShippingMethod = %orderShippingService% %orderShippingMethod%

	
	; Parse out the order items:
	orderItemsCount := FindAllProducts(orderItems, "TITLE", orderItems1, orderItems2, orderItems3, orderItems4, orderItems5, orderItems6, orderItemsQty1, orderItemsQty2, orderItemsQty3, orderItemsQty4, orderItemsQty5, orderItemsQty6)

		
	; ; Get (or confirm) the web order number:
	orderDescription = Web #%webOrderNumber%
	
	
	; Get the middle CC digits:
	
	Gui -OwnDialogs
	SetTimer WaitForCCInputBox, 50
	InputBox paymentCCNumberB, Enter Middle Digits..., Please enter the Extra Order Info for %orderDescription% now: `n(or just copy 8 digits to the clipboard),,,,,,,,XXXXXXXX
	If (false) { ; (Wrap this subroutine)
		WaitForCCInputBox:
			IfWinNotExist Enter Middle Digits...
				Return
			SetTimer WaitForCCInputBox, Off
			WinSet AlwaysOnTop, On
			WinSet Transparent, 200

			clipboard =
			SetTimer UpdateCCInputBox, 100
			; (Fall-through:)
		UpdateCCInputBox:
			IfWinExist Enter Middle Digits...
			{	
				newClip := clipboard
				If Not RegexMatch(newClip, "^\d{7,8}$")
					Return
				WinActivate
				Send %newClip%{Enter}
			}
			SetTimer UpdateCCInputBox, Off
		Return
	}
	If (ErrorLevel = 1) {
		GoSub ClearAllOrderVars
		Msgbox Billing Information cancelled and cleared!
		GoSub RestoreClipboard
		Return
	}

	
;;;;;;;;;;;;;; Clean up some of the input ;;;;;;;;;;;;;;;
	StringReplace orderAmount, orderAmount, `,, , All ; Remove commas from the order amount
		
	
;;;;;;;;;;;;;;;; Process the International customer ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; by creating 3 verification charges ;;;;;;;;;;;;;;	
	
	; Do special processing if the customer is International:
	InternationalVerified = 0
	If (International) {
		SetFormat Float, 0.2
		FileCreateDir %A_Temp%\Order Helper
		tempFile = %A_Temp%\Order Helper\Verification Charges - %orderDescription%.txt
		IfNotExist %tempFile%
		{	
			GoSub CreateRandomCharges

			; Display a summary:
			GoSub LoadInternationalMessage
			
			FileDelete %tempFile%
			FileAppend %msg%, %tempFile%
			msg =
			; Open the file in notepad:
			Run %tempFile%
		} else {
			Run %tempFile%
			; The file already exists, so we should open it and extract the information:
			FileRead msg, %tempFile%
			;msgbox %msg%
			RegexMatch(msg, "xm) ^\$([0-9.-]+) \s+ \$([0-9.-]+) \s+ \$([0-9.-]+) \s+ ", RandomCharge)
			;msgbox %RandomCharge%
			msg =
			
			TotalCharges := RandomCharge1 + RandomCharge2 + RandomCharge3
			RemainingBalance := orderAmount - TotalCharges
			
			msg =
			(ltrim
				This customer's 3 charges were:
				$%RandomCharge1%
				$%RandomCharge2%
				$%RandomCharge3%
				----------------
				Total: $%TotalCharges%
				Original Balance: $%orderAmount%
				New Balance: $%RemainingBalance%
				----------------
				Have this customer's charges been verified?
			)
			; 0x4  = Yes/No
			; 0x20 = Icon Question
			; 0x1000 = System Modal
			SetTimer ChangeInternationalVerifiedButtons, 50
				If (false) {
					ChangeInternationalVerifiedButtons:
						IfWinNotExist International Customer Verified?
							Return
						SetTimer ChangeInternationalVerifiedButtons, Off
						WinActivate
						ControlSetText Button1, &Convert...
						ControlSetText Button2, &Yes
						ControlSetText Button3, &No
					Return
				}
			
			MsgBox, 0x1023, International Customer Verified?, %msg%

			IfMsgBox Yes ; This is the "Convert..." button
				GoSub VerifyConversionValues
			Else IfMsgBox No ; (this is actually the YES button
				InternationalVerified := true
			Else IfMsgBox Cancel ; (this is the NO button)
				InternationalVerified := false

		}
	}
	
	GLAccountIndex = 2 ; Internet Sales
	
	GoSub ShowOrderGUI ; test

	
;;;;;;;;;;;  We're done! ;;;;;;;;;;;;;;;;;;;;;
	virtualMerchantPasteIndex := 1
	sendCCNumber := true
	
	GoSub RestoreClipboard
return




#IfWinActive



























