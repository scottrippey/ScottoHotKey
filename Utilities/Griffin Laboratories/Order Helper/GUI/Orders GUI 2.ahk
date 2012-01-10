	; auto execute:
		orderIsSaved = true
	Return

;Region " CloseOrder / OrderSaved / OrderChanged "

	CloseOrder(doNotPrompt = false) {
		global
		
		; GoSub ApplyChanges
		If (Not orderIsSaved And Not doNotPrompt)
		{	Gui +OwnDialogs
			MsgBox, 0x1144, Order Closing..., Any changes you have made to this information will be lost.  Continue?
			IfMsgBox No
				Return false
		}
		
		; Get the unique key used by this window:
		GUIControlGet OrderWindowKey
		GUIUniqueDestroy(OrderWindowKey)
		Return true
	}
	OrderSaved() {
		global
		orderIsSaved := true
		GuiControl Disable, &Apply
	}
	OrderChanged() {
		global
		orderIsSaved := false
		GuiControl Enable, &Apply
	}
;EndRegion



;Region " Buttons "


	OrdersGui_Close:
	OrdersGui_Escape:
		; GoSub ApplyChanges
		
		If Not CloseOrder()
			Return
	Return



	Revert_Click:
	RefreshOrderGUI:
		If Not CloseOrder()
			Return
		GoSub ShowOrderGUI
	Return

	Apply_Click:
	ApplyChanges:
		Gui Submit, NoHide
		GoSub RestoreVariables
		OrderSaved()
		
		
		; Save a temporary copy of the file:
		tempCC := paymentCCNumberB
		tempFN := orderFN
		
		If (customerLastName = "") {
			If (customerFirstName = "") {
				orderFN = %A_Now% (Unknown).txt
			} Else {
				orderFN = %A_Now% (%customerFirstName%).txt
			}
		} Else {
				orderFN = %A_Now% (%customerLastName%, %customerFirstName%).txt
		}

		IfExist %orderFN%
			FileDelete %orderFN%
		orderFN = %A_Temp%\Order Helper\%orderFN%
		GoSub SaveAllOrderVars
		
		orderFN := tempFN
		paymentCCNumberB := tempCC
	Return



	New_Click:
		; Gui +OwnDialogs
		; MsgBox, 0x144, Clear Order Info..., This will clear all data from this form, and cannot be undone!  Continue?
		; IfMsgBox No
			; Return	
		GoSub ClearAllOrderVars
		GoSub ShowOrderGUI
	Return
	ClearAll_Click:
		Gui +OwnDialogs
		MsgBox, 0x141, Clear Order Info..., This will clear all data from this form, and cannot be undone!  Continue?
		IfMsgBox Cancel
			Return
		CloseOrder(true)
		; If Not CloseOrder()
			; Return
		GoSub ClearAllOrderVars
		GoSub ShowOrderGUI
	Return

	; Copy_Click:
		; GoSub ApplyChanges
		; ItemsToCopy =
		; (ltrim comments
			; customerCompany
			; customerName
			; customerAddress
			; customerAddress2
			; customerCity
			; customerState
			; customerZip
			; customerCountry
			; customerPhone
			; customerEmail
			; ? shippingSame
			; shippingCompany
			; shippingName
			; shippingAddress
			; shippingAddress2
			; shippingCity
			; shippingState
			; shippingZip
			; shippingCountry
			; ? billingSame
			; billingCompany
			; billingName
			; billingFirstName
			; billingAddress
			; billingAddress2
			; billingCity
			; billingState
			; billingZip
			; billingCountry
			; ?
			; paymentCCType
			; paymentCCNumber
			; paymentCCCode
			; paymentCCExpires
			; orderDescription
			; orderTax
			; orderShippingService
			; orderShippingMethod
			; orderShippingCost
			; orderAmount
			; RemainingBalance
			; OrderItems1
			; OrderItems2
			; OrderItems3
			; OrderItems4
			; OrderItems5
			; OrderItems6
			; Comments
		; )
		; cqIndex = 0
		; cqCount = 0
		; skip := false
		; Loop, parse, ItemsToCopy, `n
		; {
			; If RegexMatch(A_LoopField, "\? ?(.*)", SkipVar)
			; {	
					; If SkipVar1 =	
					; skip := false
				; Else
				; {	If (%SkipVar1%)
						; skip := true
					; Else
						; skip := false
				; }
				; continue
			; }
			; If (skip)
				; continue	
					
			; value := %A_LoopField%
			; If value =
				; continue
				
			; cqCount++
			; ClipDisplay%cqCount% := value
			; ClipAll%cqCount% := value
		; }
	; Return


;EndRegion

;Region " Import, Export Buttons "

	LoadAllOrderVars_Click:
		If Not CloseOrder()
			Return
		Gui +OwnDialogs
		FileSelectFile orderFN, 1, %orderFN%, Open Order Info..., Text Documents (*.txt)
		If orderFN =
			return
		
		GoSub LoadAllOrderVars
		GoSub ShowOrderGUI
		GoSub RestoreVariables ; needed so our variables don't stay in their altered state
	Return
	SaveAllOrderVars_Click:
		GuiControlGet myTemp, , orderDescription
		If orderFN =
			orderFN := myTemp . ".txt"
		Else If myTemp !=
			orderFN := RegexReplace(orderFN, "[^\\]+$", myTemp . ".txt")
		
		Gui +OwnDialogs
		FileSelectFile orderFN, S16, %orderFN%, Save Order Info As..., Text Documents (*.txt)
		If orderFN =
			return
		If Not RegexMatch(orderFN, "i).*\.txt$")
			orderFN .= ".txt"
		
		GoSub ApplyChanges
		GoSub SaveAllOrderVars
		OrderSaved()
	Return




	ImportOSCommerce_Click:
		If Not CloseOrder()
			Return
		IfWinExist osCommerce ;- www.griffinlab.com - Mozilla Firefox
			WinActivate
		Else
		{	Gui +OwnDialogs
			MsgBox Please open osCommerce in Firefox before clicking this button.
			Return
		}
		GoSub ClearAllOrderVars
		GoSub GetOrderFromOSCommerce
		;GoSub RefreshOrderGUI
		OrderChanged()
	Return
	ImportACT_Click:
		If Not CloseOrder()
			Return
		IfWinExist ACT!
			WinActivate
		Else
		{	Gui +OwnDialogs
			MsgBox Please open ACT before clicking this button.
			Return
		}
		GoSub ClearAllOrderVars
		GoSub GetActInfo
		OrderChanged()
	Return
	ImportPT_Click:
		If Not CloseOrder()
			Return
		IfWinExist ahk_class WindowsForms10.Window.8.app.0.378734a
			WinActivate
		Else
		{	Gui +OwnDialogs
			MsgBox Please open the Customer Information page in PeachTree before clicking this button.
			Return
		}
		GoSub GetPTInfo
		OrderChanged()
	Return


	ExportVM_Click:
			myTemp := sendCCNumber ; Keep these values
			myTemp2 := virtualMerchantPasteIndex
		
		GoSub ApplyChanges
		
			sendCCNumber := myTemp ; Restore the values
			virtualMerchantPasteIndex := myTemp2
		
		
		IfWinExist Virtual Merchant ;- www.myvirtualmerchant.com - Mozilla Firefox
			WinActivate
		Else
		{	Gui +OwnDialogs
			MsgBox Please open Virtual Merchant in Firefox before clicking this button.
			Return
		}
		GoSub SendOrderToVirtualMerchant
		OrderSaved()
	Return
	ExportACT_Click:
		GoSub ApplyChanges
		GoSub SetActInfo
		OrderSaved()
	Return
	ExportPT_Click:
		GoSub ApplyChanges
		GoSub SetPTInfo
		OrderSaved()
	Return




;EndRegion

;Region " UI Enhancements "

	Declined_Click:
		GoSub LoadDeclinedMessage

		clipboard := msg
		Gui +OwnDialogs
		MsgBox The following message has been copied to the clipboard: `n%msg%
	Return
		
	ShippingSame_CheckChanged:
		GuiControlGet myTemp, , shippingSame
		GuiControl Disable%myTemp%, shippingAddressCopy
		GuiControl Disable%myTemp%, shippingCompany
		GuiControl Disable%myTemp%, shippingName
		GuiControl Disable%myTemp%, shippingAddress
		GuiControl Disable%myTemp%, shippingAddress2
		GuiControl Disable%myTemp%, shippingCity
		GuiControl Disable%myTemp%, shippingState
		GuiControl Disable%myTemp%, shippingZip
		GuiControl Disable%myTemp%, shippingCountry
		OrderChanged()
	Return
	BillingSame_CheckChanged:
		GuiControlGet myTemp, , billingSame
		GuiControl Disable%myTemp%, billingAddressCopy
		GuiControl Disable%myTemp%, billingCompany
		GuiControl Disable%myTemp%, billingName
		GuiControl Disable%myTemp%, billingAddress
		GuiControl Disable%myTemp%, billingAddress2
		GuiControl Disable%myTemp%, billingCity
		GuiControl Disable%myTemp%, billingState
		GuiControl Disable%myTemp%, billingZip
		GuiControl Disable%myTemp%, billingCountry
		OrderChanged()
	Return
	International_CheckedChanged:
		GuiControlGet myTemp, , International
		GuiControl Enable%myTemp%, InternationalVerified
		
		If (myTemp AND RandomCharge1 = "" and RandomCharge2 = "" and RandomCharge3 = "") {
			GoSub CreateRandomCharges
			SetFormat Float, 0.2
			GuiControl, , RandomCharge1, %RandomCharge1%
			GuiControl, , RandomCharge2, %RandomCharge2%
			GuiControl, , RandomCharge3, %RandomCharge3%
		}
		GuiControl Enable%myTemp%, RandomCharge1
		GuiControl Enable%myTemp%, RandomCharge2
		GuiControl Enable%myTemp%, RandomCharge3
		GuiControl Enable%myTemp%, RemainingBalance
		OrderChanged()
	Return
	InternationalVerified_CheckedChanged:
		GuiControlGet myTemp, , InternationalVerified
		;NotInternationalVerified := 1 - myTemp
		If myTemp
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
		OrderChanged()
	Return


	UpdateRemainingBalance:
		GuiControlGet myTemp1, , RandomCharge1
		GuiControlGet myTemp2, , RandomCharge2
		GuiControlGet myTemp3, , RandomCharge3
		GuiControlGet myTemp, , orderAmount
		SetFormat Float, 0.2
		RemainingBalance := myTemp - myTemp1 - myTemp2 - myTemp3
		
		GuiControl, , RemainingBalance, %RemainingBalance%
		OrderChanged()
	Return
	CustomerState_Changed:
		addressSection = Customer
		GoTo _State_Changed
	ShippingState_Changed:
		addressSection = Shipping
		GoTo _State_Changed
	BillingState_Changed:
		addressSection = Billing
		GoTo _State_Changed
	_State_Changed:
		GuiControlGet myTemp, , %addressSection%Country
		If myTemp = 
			GuiControl, , %addressSection%Country, United States
		OrderChanged()
	Return	
	
	CustomerZip_Changed:
		addressSection = Customer
		GoTo _Zip_Changed
	ShippingZip_Changed:
		addressSection = Shipping
		GoTo _Zip_Changed
	BillingZip_Changed:
		addressSection = Billing
	_Zip_Changed:
		OrderChanged()
		; See if the state is blank:
		GuiControlGet myTemp, , %addressSection%State
		If myTemp != 1
			Return
		; Check if the zip is complete:
		GuiControlGet myTemp, , %addressSection%Zip
		If Not RegexMatch(myTemp, "^\d{5}$")
			Return

		myTemp := FindZip(myTemp, "INDEX") ; Find the zip code state index
		GuiControl, Choose, %addressSection%State, |%myTemp%
	Return
		



	CustomerPhone_Changed:
		GuiControlGet myTemp, , customerPhone
		If RegexMatch(myTemp, "^(\d{3})$")
			Send -
		If RegexMatch(myTemp, "^(\d{3})\D(\d{3})$")
			Send -
		If RegexMatch(myTemp, "^(\d{3})\D(\d{3})\D(\d{4})$", phone) {
			;GuiControl, , customerPhone, %phone1%-%phone2%-%phone3%
			GuiControl, Focus, customerEmail
		}
		OrderChanged()
	Return
		
		
	_Changed:
		OrderChanged()
	Return

	
	
	
;EndRegion

;Region " Credit Card Processing "
	CCNumber_Changed:
		; Verify the credit card number, and determine the type of card
		
		; CC info obtained from http://www.regular-expressions.info/creditcard.html
		GuiControlGet myTemp, , paymentCCNumber
		
		paymentCCType = 
		partialCCType =
		; * Visa: ^4[0-9]{12}(?:[0-9]{3})?$ All Visa card numbers start with a 4. New cards have 16 digits. Old cards have 13.
		If RegexMatch(myTemp, "^4[0-9]{12}(?:[0-9]{3})?$")
			paymentCCType = Visa
		; * MasterCard: ^5[1-5][0-9]{14}$ All MasterCard numbers start with the numbers 51 through 55. All have 16 digits.
		Else If RegexMatch(myTemp, "^5[1-5][0-9]{14}$")
			paymentCCType = Master Card
		; * American Express: ^3[47][0-9]{13}$ American Express card numbers start with 34 or 37 and have 15 digits.
		Else If RegexMatch(myTemp, "^3[47][0-9]{13}$")
			paymentCCType = American Express
		; * Diners Club: ^3(?:0[0-5]|[68][0-9])[0-9]{11}$ Diners Club card numbers begin with 300 through 305, 36 or 38. All have 14 digits. There are Diners Club cards that begin with 5 and have 16 digits. These are a joint venture between Diners Club and MasterCard, and should be processed like a MasterCard.
		Else If RegexMatch(myTemp, "^3(?:0[0-5]|[68][0-9])[0-9]{11}$")
			paymentCCType = Diners Club
		; * Discover: ^6(?:011|5[0-9]{2})[0-9]{12}$ Discover card numbers begin with 6011 or 65. All have 16 digits.
		Else If RegexMatch(myTemp, "^6(?:011|5[0-9]{2})[0-9]{12}$")
			paymentCCType = Discover
		; * JCB: ^(?:2131|1800|35\d{3})\d{11}$ JCB cards beginning with 2131 or 1800 have 15 digits. JCB cards beginning with 35 have 16 digits. 
		Else If RegexMatch(myTemp, "^(?:2131|1800|35\d{3})\d{11}$")
			paymentCCType = JCB
		
		; Let's see if the number partially matches a credit card:
		
		; * Visa: ^4[0-9]{12}(?:[0-9]{3})?$ All Visa card numbers start with a 4. New cards have 16 digits. Old cards have 13.
		Else If RegexMatch(myTemp, "^4[0-9]*$")
			partialCCType = Visa (incomplete)
		; * MasterCard: ^5[1-5][0-9]{14}$ All MasterCard numbers start with the numbers 51 through 55. All have 16 digits.
		Else If RegexMatch(myTemp, "^5[1-5][0-9]*$")
			partialCCType = Master Card (incomplete)
		; * American Express: ^3[47][0-9]{13}$ American Express card numbers start with 34 or 37 and have 15 digits.
		Else If RegexMatch(myTemp, "^3[47][0-9]*$")
			partialCCType = American Express (incomplete)
		; * Diners Club: ^3(?:0[0-5]|[68][0-9])[0-9]{11}$ Diners Club card numbers begin with 300 through 305, 36 or 38. All have 14 digits. There are Diners Club cards that begin with 5 and have 16 digits. These are a joint venture between Diners Club and MasterCard, and should be processed like a MasterCard.
		Else If RegexMatch(myTemp, "^3(?:0[0-5]|[68][0-9])[0-9]*$")
			partialCCType = Diners Club (incomplete)
		; * Discover: ^6(?:011|5[0-9]{2})[0-9]{12}$ Discover card numbers begin with 6011 or 65. All have 16 digits.
		Else If RegexMatch(myTemp, "^6(?:011|5[0-9]{2})[0-9]*$")
			partialCCType = Discover (incomplete)
		; * JCB: ^(?:2131|1800|35\d{3})\d{11}$ JCB cards beginning with 2131 or 1800 have 15 digits. JCB cards beginning with 35 have 16 digits. 
		Else If RegexMatch(myTemp, "^(?:2131|1800|35\d{3})\d*$")
			partialCCType = JCB (incomplete)
					
		Else If myTemp =
			partialCCType = 
		Else
			partialCCType = Unknown

		If paymentCCType !=
		{	; Let's verify using the Luhn algorithm
			; http://en.wikipedia.org/wiki/Luhn_algorithm^


			; 1. Counting from the check digit, which is the rightmost, and moving left, double the value of every second digit.
			; 2. Sum the digits of the products together with the undoubled digits from the original number.
			; 3. If the total ends in 0 (put another way, if the total modulo 10 is equal to 0), then the number is valid according to the Luhn formula; else it is not valid.
			d := 2 - (StrLen(myTemp) & 1)
			s := 0
			Loop Parse, myTemp
			   s += 9 < (y := d*A_LoopField) ? y-9 : y, d := 3-d
			; That's the shortest Luhn Algorithm I've ever seen!  I think I copied it from AutoHotKey forums -- sorry to whomever I stole this from!

			If Mod(s,10) > 0
				paymentCCType .= " (invalid card number) "
			Else
				GuiControl, Focus, paymentCCExpires ; auto-advance
		} else {
			paymentCCType := partialCCType
		}

		GuiControl, , paymentCCType, %paymentCCType%
		OrderChanged()
	Return
	CCExpires_Changed:
		GUIControlGet myTemp, , paymentCCExpires
		If RegexMatch(myTemp, "^(1[012]|0[0-9])[1-9][0-9]$")
			GuiControl, Focus, paymentCCCode ; auto-advance
	Return

;EndRegion

;Region " Products "

	ShowProductNumbers1:
		GuiControlGet myTemp, , orderItems1
		GoTo ShowProductNumbers
	ShowProductNumbers2:
		GuiControlGet myTemp, , orderItems2
		GoTo ShowProductNumbers
	ShowProductNumbers3:
		GuiControlGet myTemp, , orderItems3
		GoTo ShowProductNumbers
	ShowProductNumbers4:
		GuiControlGet myTemp, , orderItems4
		GoTo ShowProductNumbers
	ShowProductNumbers5:
		GuiControlGet myTemp, , orderItems5
		GoTo ShowProductNumbers
	ShowProductNumbers6:
		GuiControlGet myTemp, , orderItems6
		GoTo ShowProductNumbers
	ShowProductNumbers:
		productNumbers := FindProduct(myTemp, "NUMBERS")
		Gui +OwnDialogs
		MsgBox Product Numbers (for PeachTree):`n%productNumbers%
	Return

	ProductList1_Changed:
		ProductListIndex = 1
		GoTo ProductList_Changed
	ProductList2_Changed:
		ProductListIndex = 2
		GoTo ProductList_Changed
	ProductList3_Changed:
		ProductListIndex = 3
		GoTo ProductList_Changed
	ProductList4_Changed:
		ProductListIndex = 4
		GoTo ProductList_Changed
	ProductList5_Changed:
		ProductListIndex = 5
		GoTo ProductList_Changed
	ProductList6_Changed:
		ProductListIndex = 6
		GoTo ProductList_Changed
	ProductList_Changed:
		; If a product is selected, and there is no quantity, let's put a default quantity
		GuiControlGet myTemp, , OrderItemsQty%ProductListIndex%
		If myTemp =
		{	ctrl = OrderItemsQty%ProductListIndex%
			GuiControl, Text, %ctrl%, 1
		}
		OrderChanged()
	Return
		
		
;EndRegion

;Region " International Verification Charges "

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


	VerifyConversion_Click:
		GoSub VerifyConversionValues
		GuiControl, , InternationalVerified

		OrderChanged()
	Return	
	VerifyConversionValues:
		Gui +OwnDialogs
		
		; Try to extract from the clipboard
		clip := clipboard
		GoSub BackupClipboard
		
		; Monitor clipboard activity:
		SetTimer CheckClipboardForVerificationCharges, 250
		If (false) {
			CheckClipboardForVerificationCharges:
				IfWinNotExist Verification Conversion ; The inputbox is gone, so quit
				{	SetTimer CheckClipboardForVerificationCharges, Off
					Return
				}
				
				; Check the clipboard:
				ClipWait, .5
				If ErrorLevel = 1
					Return

				; Search the clipboard for any values:
				clip := clipboard
				clipboard =
				lastPos = 1
				Loop
				{	lastPos := RegexMatch(clip, "\b\d*[.]\d\d\b", extractedAmount, lastPos)
					If lastPos = 0
						Return

					lastPos += StrLen(extractedAmount)
					
					ControlSend, , %extractedAmount%`,{Space} ; Send this to the Verification Conversion window without activating it
				}
			Return
		}
		
		SetTimer MakeVerificationConversionAlwaysOnTop, -50
			If (false) {
				MakeVerificationConversionAlwaysOnTop:
					WinSet, AlwaysOnTop, On, Verification Conversion
				Return
			}
		InputBox VerifiedCharges, Verification Conversion, Please enter the verified charge amounts:,,,,,,,,0.00, 0.00, 0.00
		If ErrorLevel = 1 ; Cancelled
		{	GoSub RestoreClipboard
			Return
		}
		GoSub RestoreClipboard

		; Extract the 3 charges from the input:
		lastPos = 1
		Loop, 3
		{	lastPos := RegexMatch(VerifiedCharges, "\b\d*[.]\d\d\b", VerifiedCharge%A_Index%, lastPos)
			If StrLen(VerifiedCharge%A_Index%) > 0
				lastPos += StrLen(VerifiedCharge%A_Index%)
			Else
			{	; Couldn't find 3 amounts, so cancel:
				MsgBox Error: expected 3 amounts!  Cancelling.
				Return
			}
		}
		
		
		; OK, to compare the 3 charge amounts, we must first sort, and then compare the ratio of all 3 amounts.
		OriginalCharges = %RandomCharge1%`n%RandomCharge2%`n%RandomCharge3%
		VerifiedCharges = %VerifiedCharge1%`n%VerifiedCharge2%`n%VerifiedCharge3%
		Sort OriginalCharges, N ; Sort Numerically
		Sort VerifiedCharges, N ; Sort Numerically
		StringSplit OriginalCharges, OriginalCharges, `n
		StringSplit VerifiedCharges, VerifiedCharges, `n
		
		; Usually, during currency conversion, there is a conversion rate plus a constant.
		; Example: pesos = USD * 13 + 100    <= The conversion is x13, plus a charge of 100 for converting.
		;			V    =  A  * R  + C
		; We will attempt to use the two higher charges to determine what the lowest charge should be.
		R := (VerifiedCharges3 - VerifiedCharges2) / (OriginalCharges3 - OriginalCharges2)
		C := VerifiedCharges3 - (OriginalCharges3 * R)

		SetFormat Float, 0.2
		
		; Now let's calculate what the lowest charge should be:
		VerifiedAmount1 := OriginalCharges1 * R + C
		;Compare this value with the submitted value:
		difference := abs(VerifiedAmount1 - VerifiedCharges1) / VerifiedCharges1
		If difference < .02 ; Allow 2% error
		{	MsgBox, 0x40, Correct!,
			(ltrim
				These verified charges appear correct!
				
				Conversion Ratio: 	$1 (USD) = %R% (%billingCountry% $)	Cost: %C% (%billingCountry% $)
				Actual Amount:	Verified:	Calculated:
				#1	$%OriginalCharges1%	%VerifiedCharges1%	%VerifiedAmount1%
				#2	$%OriginalCharges2%	%VerifiedCharges2%	%VerifiedCharges2%
				#3	$%OriginalCharges3%	%VerifiedCharges3%	%VerifiedCharges3%
			)
			InternationalVerified := true
		} Else {
			difference *= 100
			MsgBox, 0x10, NOT CORRECT,
			(ltrim comments
				These verification charges are NOT correct.
				
				Conversion Ratio: 	$1 (USD) = %R% (%billingCountry% $)	Cost: %C% (%billingCountry% $)
				Actual Amount:	Verified:	Calculated:
				#1	$%OriginalCharges1%	%VerifiedCharges1%	%VerifiedAmount1%	<=	Error: %difference%`% 							;%;
				#2	$%OriginalCharges2%	%VerifiedCharges2%	%VerifiedCharges2%
				#3	$%OriginalCharges3%	%VerifiedCharges3%	%VerifiedCharges3%
			)
			InternationalVerified := false
		}
	Return
	
	
	
	
	
	
	
	
;EndRegion

;Region " SalesRep, OrderSource "
	
	
	SalesRep_Or_OrderSource_Changed:
		GuiControlGet SalesRepIndex
		GuiControlGet GLAccountIndex

		SalesRepName 	:= SalesRep%SalesRepIndex%Name
		SalesRepEmail 	:= SalesRep%SalesRepIndex%Email
		SalesRepPTID 	:= SalesRep%SalesRepIndex%PTID
		SalesRepInitials := SalesRep%SalesRepIndex%Initials
		
		GLAccount		:= GLAccount%GLAccountIndex%
	Return


;EndRegion

;Region " Label Clicking Enhancements "

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
		; Fix some of the not-obvious titles:
		StringReplace target, target, Address 2, Address2
		StringReplace target, target, Security, Code
		StringReplace target, target, Card Type, Type
		target := RegexReplace(target, "[ ,].+", "") ; Limit to only the first word of the label
		; Get the value of the associated text box:
		GuiControlGet myTemp, , %target%
		
		toggleIndex++
		If (lastTarget != target) {
			lastTarget := target
			toggleIndex = 2
			originalTitle := myTemp
		}
		
		If toggleIndex = 1
			myTemp := originalTitle
		Else {
			If target CONTAINS paymentCCName
			{	GuiControlGet myTemp, , customerName
				toggleIndex = 0
			}
			Else If target CONTAINS Company,Name,Address,City,Country,Email
			{	If toggleIndex = 2
					StringUpper myTemp, myTemp, T
				Else If toggleIndex = 3
					StringUpper myTemp, myTemp
				Else If toggleIndex = 4
				{	StringLower myTemp, myTemp
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
				
				myTemp := RegexReplace(myTemp, "^\D*1?\D*(\d{3})\D*(\d{3})\D*(\d{4})\D*$", format)
			}
			Else If target CONTAINS paymentCCNumber
			{	myTemp := RegexReplace(myTemp, "(?<=....).(?=....)", "x")
			
				toggleIndex = 0
			}
			Else If target CONTAINS Description
			{	GuiControlGet myTemp, , customerName
				RegexMatch(myTemp, "\b\w*\s*$", myTemp)
				FormatTime DateStamp, , yyMMdd
				myTemp = %myTemp% %DateStamp% %SalesRepInitials%
				
				toggleIndex = 0
			}
		}
		


		GuiControl, , %target%, %myTemp%
		GuiControl, Focus, %target%
		
		OrderChanged()
	Return

	CustomerAddress_Click:
		; Copy the address to the clipboard:
		addressSection = Customer
		GoTo CopyAddress
	BillingAddress_Click:
		addressSection = Billing
		GuiControlGet myTemp, , billingSame
		If (myTemp)
			GoTo CustomerAddress_Click
		GoTo CopyAddress
	ShippingAddress_Click:
		addressSection = Shipping
		GuiControlGet myTemp, , shippingSame
		If (myTemp)
			GoTo CustomerAddress_Click
		; (fall through:)
	CopyAddress:
		
		format = {Company}{Company?`n:}{Name}`n{Address}{Address2?`n:}{Address2}`n{City}, {State} {Zip}{Country?`n:}{Country}
		allKeys = Company, Name, Address, Address2, City, State, Zip, Country
		Loop, parse, allKeys, CSV, %A_Space%
		{	variable = %addressSection%%A_LoopField%
			GuiControlGet value, , %variable%
			If A_LoopField = State
				value := StateInfo(value, "ABBR")

			StringReplace format, format, {%A_LoopField%}, %value%, All
			; Conditional formatting:
			If (value = "")
				replacement = $2
			Else
				replacement = $1
			format := RegexReplace(format, "is)\{" . A_LoopField . "\?([^:]*):([^}]*)\}", replacement)
		}
		clipboard := format
	Return
;EndRegion

;Region " Help "

	Help_Click:
		Gui +OwnDialogs
		
		helpFile = Work\Order Helper\Order Helper User's Guide.html
		IfExist %helpFile%
			Run %helpFile%
		Else
		{	SetButtonNames("Help Not Found...", "&Open Folder", "Cancel")
			MsgBox 0x1044, Help Not Found..., The Help file could not be found.
			IfMsgBox Yes
				Run %A_WorkingDir%
		}
	Return

;EndRegion
