; Auto Execute:
	AllOrderVars = 
	(ltrim comments
		customerCompany
		customerName
		customerAddress
		customerAddress2
		customerCity
		customerState
		customerZip
		customerCountry
		customerPhone
		customerEmail
		shippingCompany
		shippingName
		shippingAddress
		shippingAddress2
		shippingCity
		shippingState
		shippingZip
		shippingCountry
		billingCompany
		billingName
		billingFirstName
		billingAddress
		billingAddress2
		billingCity
		billingState
		billingZip
		billingCountry
		paymentCCType
		paymentCCName
		paymentCCNumberA
		;paymentCCNumberB
		paymentCCNumberC
		paymentCCCode
		paymentCCExpires
		orderDescription
		orderTax
		orderShippingService
		orderShippingMethod
		orderShippingCost
		orderAmount
		orderCoupon
		orderDiscount
		International
		InternationalVerified
		RandomCharge1
		RandomCharge2
		RandomCharge3
		RemainingBalance
		OrderItems1
		OrderItems2
		OrderItems3
		OrderItems4
		OrderItems5
		OrderItems6
		OrderItemsQty1
		OrderItemsQty2
		OrderItemsQty3
		OrderItemsQty4
		OrderItemsQty5
		OrderItemsQty6
		Comments
	)
	GoSub ClearAllOrderVars
	; GoSub SaveAllOrderVars
	; GoSub LoadAllOrderVars
Return

ShowAllOrderVars:
	msg =
	Loop Parse, AllOrderVars, `n, %A_Tab%%A_Space%`r
	{
		value := %A_LoopField%
		msg = %msg%%A_LoopField%`t=`t%value%`n
	}
	msgbox All Variables: `n%msg%
Return
ClearAllOrderVars:
	Loop Parse, AllOrderVars, `n, %A_Tab%%A_Space%`r
	{
		%A_LoopField% =
	}
Return


SaveAllOrderVars: ; Inputs "orderFN"
	msg =
	Loop Parse, AllOrderVars, `n
	{	value := %A_LoopField%
		StringReplace value, value, `n, ``n, All
		msg = %msg%%A_LoopField%`t=`t%value%`n
	}
	IfExist %orderFN%
		FileDelete %orderFN%
	FileAppend, %msg%, %orderFN%
Return
LoadAllOrderVars: ; Inputs "orderFN"
	ErrorLevel =
	Loop, Read, %orderFN%
	{	
		RegexMatch(A_LoopReadLine, "^(?<Name>\w+)\t=\t(?<Value>.*)$", field)
		StringReplace fieldValue, fieldValue, ``n, `n, All
		%fieldName% := fieldValue
	}
	If ErrorLevel
		MsgBox There was an error opening %orderFN%
	paymentCCNumberB = ` XXXX XXXX` 
Return
