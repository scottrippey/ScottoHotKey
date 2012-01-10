LoadDeclinedMessage:
	Gui +OwnDialogs
	SetButtonNames("Reason for Declined...","Security Code","Lack of Funds","Other")
	MsgBox 0x1023, Reason for Declined..., Why was this card declined?
	IfMsgBox Yes ; Security Code
	msg =
	(ltrim join`r`n
		Dear %customerFirstName%,

		Thank you for your order!
		
		Unfortunately, we could not finish processing your order because your credit card was declined.
		
		It appears the security code from the back of the card was incorrect.
		
		If you would like us to try this card again, please reply to this email with the correct security code from the back of your card, or call us at 1-800-330-5969.

		Thank you,
		%SalesRepName%
		%SalesRepEmail%
		Griffin Laboratories
		1-800-330-5969
	)
	IfMsgBox No ; Insufficient Funds
	msg =
	(ltrim join`r`n
		Dear %customerFirstName%,

		Thank you for your order!
		
		Unfortunately, we could not finish processing your order because your credit card was declined.
		
		It appears you do not have sufficient funds for this transaction.
		
		If you would like us to continue processing your order, please reply to this email with a new payment method, or call us at 1-800-330-5969.

		Thank you,
		%SalesRepName%
		%SalesRepEmail%
		Griffin Laboratories
		1-800-330-5969
	)
	IfMsgBox Cancel ; Generic
	msg =
	(ltrim join`r`n
		Dear %customerFirstName%,

		Thank you for your order!
		
		Unfortunately, we could not finish processing your order because your credit card was declined.
		
		If you would like us to continue processing your order, please contact your bank and make sure they are not blocking this transaction.  Also please check that sufficient funds available on this card.
				
		Once you have confirmed with your bank that this transaction will be approved, please reply to this email or call us at 1-800-330-5969.

		Thank you,
		%SalesRepName%
		%SalesRepEmail%
		Griffin Laboratories
		1-800-330-5969 USA
		00+1+951-695-6727 Int'l
	)	
Return
LoadInternationalMessage:
	msg =
	(ltrim join`r`n
		Web #%webOrderNumber% (Order Total: $%orderAmount%)
		This customer is an International customer.
		To verify that this customer is the cardholder, you must have them verify 3 small charges.
		The charges to verify are:
		$%RandomCharge1%
		$%RandomCharge2%
		$%RandomCharge3%
		----------
		Total:	$%TotalCharges%
		
		The remaining balance:
		$%RemainingBalance%
		
		The following email should be sent to %customerName%:
		----------------------------------------------------
		
		Dear %customerFirstName%,

		Thank you for your order!
		To continue processing your order, we need to verify your credit card.

		To verify the security of your provided credit card we have billed 3 small charges to your credit card, not to exceed the amount of $30.00 US Dollars. To verify that you are the cardholder, we are asking that you reply to this e-mail with the exact amount of each charge, in US Dollars, placed on your card by Griffin Laboratories. Please call your Credit Card issuing bank to verify the charges.

		The amounts billed to your card as security charges will be applied to the payment of your order.

		We apologize for any inconvenience this may cause, but we wish to ensure secure internet purchasing for our International customers.

		Your order will be shipped as soon as we receive Credit Card verification, and are able to charge the remainder of your order to your provided credit card.

		Please feel free to contact us if you have any questions regarding your order.

		Best Regards,

		%SalesRepName%
		%SalesRepEmail%
		Griffin Laboratories
		1-800-330-5969 USA 			
		00+1+951-695-6727 Int'l
	)
Return
LoadLoanerMessage:
	; Figure out a return date that is 30 days from now:
	returnDate =
	returnDate += 30, days
	FormatTime, returnDate, %returnDate%, LongDate
	msg =
	(ltrim join`s
		This loaner kit must be returned to Griffin Laboratories at the address above.
		It must be returned by %returnDate% to avoid charges to your credit card.
	)
Return

