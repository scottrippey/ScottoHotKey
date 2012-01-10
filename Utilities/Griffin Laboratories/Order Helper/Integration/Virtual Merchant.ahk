#IfWinActive Virtual Merchant ;- www.myvirtualmerchant.com - Mozilla Firefox
SendOrderToVirtualMerchant:
#v::
	KeyWait LWin
	; Clean up the address:
	; Retrieve the billing address numbers:
	addressPattern =
	(ltrim
		ixm)
		P[ .]*O[ .]Box \s* (?<A>\d+)
		|
		.*?(?<B>\d+) .*
	)
	If Not RegexMatch(billingAddress, addressPattern, billingAddressNumbers)
		virtAddress := billingAddress
	Else If billingAddressNumbersA !=
		virtAddress = PO Box %billingAddressNumbersA%
	Else
		virtAddress = %billingAddressNumbersB%
	; Clean up the zip:
	If Not RegexMatch(billingZip, "ix)^\d{0,5}", virtZip)
		virtZip := billingZip
	
	
	
	virtAmount := orderAmount
	; Prepare the info:
	If (International AND InternationalVerified) {
		virtAmount := RemainingBalance
	}
	
	
	If orderTax = 
		orderTax := 0

	
	If (International AND NOT InternationalVerified) {
		if (sendCCNumber) {
			virtualMerchantPasteIndex--
		} else if (virtualMerchantPasteIndex = 1) {
			virtAmount := RandomCharge1
		} else if (virtualMerchantPasteIndex = 2) {
			virtAmount := RandomCharge2
		} else if (virtualMerchantPasteIndex = 3) {
			virtAmount := RandomCharge3
		}
		virtualMerchantPasteIndex++
		If (virtualMerchantPasteIndex > 3)
			virtualMerchantPasteIndex = 1
	}
	
	
	
	
	
	If (sendCCNumber) {
		Send %paymentCCNumber%
		sendCCNumber := false
		Return
	} 
	
	
	
	; Ask if we should paste customer code and tax:
	SetTimer ChangeMCButtonNames, 50
	Gui +OwnDialogs
	MsgBox, 0x1023, Paste Customer Code and Sales Tax?, Do I need to paste the Customer Code and Sales Tax?
	If (false) { ; (Wrap this subroutine)
		ChangeMCButtonNames:
			IfWinNotExist Paste Customer Code and Sales Tax?
				return ; Keep waiting
			SetTimer ChangeMCButtonNames, Off
			WinActivate
			ControlSetText Button1, &Both
			ControlSetText Button2, Sales &Tax
			ControlSetText Button3, &None
		Return
	}
	IfMsgBox Yes ; Both
		CUSTCODEANDTAX = %paymentCCNumberC%{TAB}%orderTax%{TAB}
	IfMsgBox No  ; Sales Tax
		CUSTCODEANDTAX = %orderTax%{TAB}
	IfMsgBox Cancel ; None
		CUSTCODEANDTAX = 

	IfWinExist Virtual Merchant
		WinActivate ; Make sure we haven't lost focus

	
	if (paymentCCType = "Visa") {
		virtualmerchantPaste =
		(ltrim join comments
			%paymentCCExpires%`t
			%virtAmount%`t
			`t
			%paymentCCCode%`t
			%CUSTCODEANDTAX%
			%orderDescription%`t
			`t
			`t
			`t
			%virtAddress%`t
			`t
			`t
			`t
			%virtZip%`t
		)
	} else {
		virtualmerchantPaste =
		(ltrim join comments
			%paymentCCExpires%`t
			%virtAmount%`t
			%paymentCCCode%`t
			%CUSTCODEANDTAX%
			%orderDescription%`t
			`t
			`t
			`t
			%virtAddress%`t
			`t
			`t
			`t
			%virtZip%`t
		)
	}
	StringReplace virtualmerchantPaste, virtualmerchantPaste, {TAB}, %A_Tab%, All
	
	SendRaw %virtualmerchantPaste%
	sendCCNumber := true
	
	
	; Let's attempt to get the Auth code if it's international:
	If (International AND NOT InternationalVerified) {
			GoSub BackupClipboard
			
			Gui -OwnDialogs
			SetTimer WaitForAuthInputBox, 50
			InputBox AuthCode%virtualMerchantPasteIndex%, Enter Auth Code..., Please enter the Authorization Code for this charge: `n(or just copy 6 digits to the clipboard),,,,,,,,XXXXXX
			If (false) { ; (Wrap this subroutine)
				WaitForAuthInputBox:
					IfWinNotExist Enter Auth Code...
						Return
					SetTimer WaitForAuthInputBox, Off
					WinSet AlwaysOnTop, On
					WinSet Transparent, 200

					clipboard =
					SetTimer UpdateAuthInputBox, 100
					; (Fall-through:)
				UpdateAuthInputBox:
					IfWinExist Enter Auth Code...
					{	
						newClip := clipboard
						If Not RegexMatch(newClip, "^\w{6}$")
							Return
						WinActivate
						Send %newClip%{Enter}
					}
					SetTimer UpdateAuthInputBox, Off
				Return
			}
			
			GoSub RestoreClipboard
	}

Return	

#IfWinActive
