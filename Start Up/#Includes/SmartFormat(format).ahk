
	;;;Summary
	;;; 	Perses the format for custom placeholders 
	;;;		that allow specific formatting, and returns the
	;;;		formatted string.
	;;;		For more information, please see http://www.codeproject.com/KB/string/Custom_Formatting.aspx
	;;;		Also, outputs any errors in a variable named formatErrors.
	;;;Example:
	;;; 	someNumber = 55.5
	;;; 	out := SmartFormat("Your number is {someNumber:0.00}") ; Returns "Your number is 55.50"
	;;;		itemCount = 4 or 1
	;;;		out := SmartFormat("There {itemCount:is|are} {itemCount} {itemCount:item|items}") ; Returns "There are 4 items" or "There is 1 item"
	;;;EndSummary
	SmartFormat(format, placeholderChars = "{:}", allowedSelectors = "[\w-+*/%^]") { ;Function
		global
		local charOpen, charClose, charFormat
		charOpen := SubStr(placeholderChars, 1, 1)
		charFormat := SubStr(placeholderChars, 2, 1)
		charClose := SubStr(placeholderChars, 3, 1)
	
		local output, isOpen, isSelector, Selector, SelectorFormat
		output =
		isOpen := 0
		
		
		formatErrors =
		; Parse the format:
		; The format string has 3 portions:
		; Literal Text {Selector:SelectorFormat} Literal Text
		Loop, parse, format
		{	
			If (isOpen = 0) {
				; Literal text area:
				If (A_LoopField = charOpen)
				{	isOpen++
					isSelector := true
					Selector =
					SelectorFormat =
					; hasNested := false
				}
				Else
					output .= A_LoopField
			} Else {	; We are already open
				If (isSelector) {
				; Selector portion:
					If (A_LoopField = charOpen AND Selector = "") {
						; We have {{, which is an escape sequence.
						output .= charOpen
						isOpen--
					} Else If (A_LoopField = charFormat) {
						isSelector := false
					} Else If (A_LoopField = charClose) {
						isOpen--
						output .= FormatOutput(SelectorEval(Selector), SelectorFormat)
					}
					Else If !RegexMatch(A_LoopField, allowedSelectors)
					{
						; This character is an invalid character for a variable name!
						; Don't add it to the selector, and mark this error.
						If (formatErrors = "")
							formatErrors := "Invalid characters: "
						Else
							formatErrors .= ", "
						formatErrors .= A_LoopField . " at position " . A_Index
					}
					Else
						Selector .= A_LoopField
				} Else {
					; SelectorFormat portion
					If (A_LoopField = charOpen) {
						isOpen++
						SelectorFormat .= A_LoopField
					} Else If (A_LoopField = charClose) {
						isOpen--
						If (isOpen > 0)
							SelectorFormat .= A_LoopField
						Else
							output .= FormatOutput(SelectorEval(Selector), SelectorFormat)
					} Else {
						SelectorFormat .= A_LoopField
					}
				}
				
			}
			
		}
		Return output
	} ;EndFunction
	
	;Region " Formatting Plugins "
	
	;;;Summary
	;;; This function takes in a Selector and returns its value.
	;;;
	;;; It supports simple equations as well!
	;;; Example: SelectorEval("Index + 1 * 2") -- If Index = 1 then Output = 4.
	;;; Notice the order of operations is always left-to-right.
	;;;EndSummary
	SelectorEval(Selector) { ;Function
		global
		local value, currentValue, tokenRegex, token, token1, token2
		tokenRegex := "x) ^ ([-+*/.%^])? \s* (\w+) \s*"
		value :=
		Loop
		{
			; Extract the next token:
			If (RegexMatch(Selector, tokenRegex, token)) {
				; Remove this token:
				Selector := RegexReplace(Selector, tokenRegex, "", "", 1)
				
				; Evaluate the token:
				If token2 is number
					currentValue := token2 + 0
				Else
					currentValue := %token2%
				
				; Evaluate the operator:
				If token1 = +
					value += currentValue
				Else If token1 = -
					value -= currentValue
				Else If token1 = *
					value *= currentValue
				Else If token1 = /
					value /= currentValue
				Else If token1 = .
					value .= currentValue
				Else If token1 = ^
					value := value ** currentValue
				Else If (token1 = "%")
					value := mod(value, currentValue)
				Else
					value := currentValue
			} Else {
				break
			}
		}

		Return value
	} ;EndFunction
	
	;;;Summary
	;;; This function takes in a value and a format, and formats the value accordingly.
	;;; Example:
	;;; 	{MyFloat:000.000}
	;;; 	value = MyFloat = 1.1
	;;; 	format = 000.000
	;;;		Outputs: 001.100
	;;; Can be used for:
	;;; 	Conditional formatting:
	;;;			There {count:is|are} {count} {count:person|people}
	;;;			[Neg] | [Zero] | One | Many
	;;;			true | false
	;;;			past | future
	;;;			String | Empty
	;;;		Numerical formatting:
	;;;			value = 11.11
	;;;			0.0 outputs 11.1
	;;;			000.000 outputs 011.110
	;;;		Date formatting:
	;;;			birthday = 1/1/2000
	;;;			MM/dd/yyyy outputs 01/01/2000
	;;;			dddd, MMMM d, yyyy outputs Friday, January 1, 2000
	;;;EndSummary
	FormatOutput(value, format) { ;Function
	
		If format =
			Return value

		output := 
		If (Plugin_ConditionalFormatting(value, format, output))
			Return output
		If (Plugin_NumberFormatting(value, format, output))
			Return output
		If (Plugin_DateFormatting(value, format, output))
			Return output
		If (Plugin_StringFormatting(value, format, output))
			Return output
		
		
		; Just output the default with no formatting:
		output := value
		Return output
	} ;EndFunction

	Plugin_ConditionalFormatting(value, format, ByRef output) { ;Function
		; See if we're doing "conditional formatting":
		splitCount := UnnestedSplitCount(format, "|")
		If (splitCount >= 2) {
			; Let's do "conditional formatting"
			; Determine the "type" of the value,
			; and then based on the type,
			; determine the splitIndex to use:
			splitIndex := -1
			If value IS number ; It's a number (or a date?)
			{	
				; If (splitCount >= 4) ; Neg | Zero | One | Many
				; {	If (value < 0)
						; splitIndex := 1 
					; Else If (value = 0)
						; splitIndex := 2 
					; Else If (value = 1)
						; splitIndex := 3 
					; Else
						; splitIndex := 4 
				; } Else If (splitCount = 3) ; Zero | One | Many
				If (splitCount >= 3) ; Zero | One | ...
				{	
					splitIndex := value + 1
				} Else If (splitCount = 2) ; One | Many
				{	If (value = 1)
						splitIndex := 1 
					Else
						splitIndex := 2 
				}
			} Else If value IN true,false ; It's a boolean (or a string boolean)
			{	If value IN true ; True | False
					splitIndex := 1 
				Else
					splitIndex := 2 
			} Else If value IS time ; It's a date
			{	EnvSub, value, %A_Now%, Seconds
				If (value <= 0) ; Past | Future
					splitIndex := 1 
				Else
					splitIndex := 2 
			} Else { ; It's a string
				If value !=	; Something | Nothing
				{	
					splitIndex := 1
					
					; If the subFormat is empty, we want to output the whole string:
					subFormat := UnnestedSplit(format, "|", splitIndex)
					If (subFormat = "")
						output := value
					Else
						output := SmartFormat(subFormat)
					Return true
				}
				Else
					splitIndex := 2 
			}
			
			; output the selected splitIndex:
			subFormat := UnnestedSplit(format, "|", splitIndex)
			output := SmartFormat(subFormat)
			Return true
		}
		
		return false
	} ;EndFunction
	
	Plugin_NumberFormatting(value, format, ByRef output) { ;Function
		; Format a number?
		If value IS number
		{	
			If RegexMatch(format, "^(0*)(\.0*)?$", digits) { ; Allow a format of "000.000" to specify zero padding
				digits1 := StrLen(digits1)
				digits2 := StrLen(digits2) - 1
				
				If digits2 < 1
					digits2 = 0

				If value IS integer
				{	digits1 := digits1 - StrLen(value)
					; digits2 := 0
				} Else { ; Its a float
					digits1 := digits1 - (InStr(value, ".") - 1)
					digits2 := digits2 - (StrLen(value) - InStr(value, "."))
				}
				
				output := value
				; Add the extra padding zeros:
				If digits1 > 0
					Loop, %digits1%
						output = 0%output%
				If digits2 > 0
				{	If Not InStr(output, ".")
						output .= "."
					Loop, %digits2%
						output = %output%0
				} else if digits2 < 0
				{ ; Trim the digits
					output := SubStr(output, 1, StrLen(output) + digits2)
				}
				Return true
			}
		}
		Return false
	} ;EndFunction
	
	Plugin_DateFormatting(value, format, ByRef output) { ;Function
		; Format a date?
		If (RegexMatch(format, "^[yMdhmst: ,/-]+$")) { ; see if the format looks like a date format
			If value IS time
			{	FormatTime output, %value%, %format%
				Return true
			}
			; ; Try to parse the date, but don't use it if its just the default date.
			; valueDate := DateParse(value)
			; defaultDate := DateParse("")
			; If (valueDate != defaultDate) {
				; FormatTime output, %valueDate%, %format%
				; Return true
			; }
		}
		Return false
	} ;EndFunction
	
	Plugin_StringFormatting(value, format, ByRef output) { ;Function
		; Format a string?
		If format IN U,u ; Upper-case
			StringUpper output, value
		Else If format IN L,l ; Lower-case
			StringLower output, value
		Else If format IN T,t ; Title-case
			StringUpper output, value, T

		Else If format IN P,p ; Pascal-case
			output := CamelCase(value, true, false)
		Else If format IN PP,pp ; Pascal-case lower
			output := CamelCase(value, true, true)

		Else If format IN C,c ; Camel-case
			output := CamelCase(value, false, false)
		Else If format IN CC,cc ; Camel-case lower
			output := CamelCase(value, false, true)
		Else
			Return false ; Not handled
		Return true ; Handled
	} 
	CamelCase(value, firstUpper = false, forceLower = false){
		output =
		forceUpper := firstUpper
		Loop, parse, value
		{
			If A_LoopField IN `r,`n, ,`t
			{
				forceUpper := true
				continue
			}
			char := A_LoopField
			If (forceUpper)
				StringUpper char, char
			Else If (forceLower)
				StringLower char, char
				
			output .= char

			forceUpper := false
		}
		return output
	}
	;EndFunction

	;EndRegion
	
	
	;Region " Special Utility Functions for plugins "
	
	;;;Summary
	;;; Counts the number of "unnested" splits in the format.
	;;; Useful for parameter splitting.
	;;; 
	;;; Example: UnnestedSplitCount(" abc def | ghi {jkl: mno | pqr | stu } | vwx yz ", "|") = 3
	;;;EndSummary
	UnnestedSplitCount(format, char) { ;Function
		Return UnnestedSplit(format, char, -1)
	} ;EndFunction
	
	;;;Summary
	;;; Finds "unnested" instances of the split char, and splits the string;
	;;; returns the split specified by the index.
	;;;
	;;; Example: UnnestedSplit(" abc def | ghi {jkl: mno | pqr | stu } | vwx yz ", "|", 2) = " ghi {jkl: mno | pqr | stu } "
	;;;EndSummary
	UnnestedSplit(format, char, index) { ;Function
		count := 1
		open := 0
		start := 1
		Loop, parse, format
		{
			If (A_LoopField = "{") {
				open++
			} Else If (A_LoopField = "}") {
				open--
			} Else If (A_LoopField = char) {
				if (open = 0) {
					If (count = index) {
						; This is the split index that we want:
						return SubStr(format, start, A_Index - start)
					}
					start := A_Index + 1
					count++
				}
			}
		}
		
		; See if we just want the count:
		If (index = -1)
			return count
			
		; Return the last item:
		return SubStr(format, start)
	} ;EndFunction
	
	;EndRegion

	
	;Region " Special Formatting Functions "
	
	;;;Summary
	;;; Formats seconds into text.
	;;;EndSummary
	TimeFromSeconds(totalSeconds,abbr=true,fill=true) { ;Function
		Hours := floor(totalSeconds / 3600) 
		Minutes := mod(floor(totalSeconds / 60), 60)
		Seconds := mod(totalSeconds, 60)
		time =
		if (Hours >= 1)
			time .= Hours . (abbr ? "h " : (Hours = 1 ? " hour " : " hours "))
		if ((Hours >= 1 AND fill) OR Minutes >= 1)
			time .= Minutes . (abbr ? "m " : (Minutes = 1 ? " minute " : " minutes "))
		If ((Hours >= 1 AND fill) OR (Minutes >= 1 AND fill) OR (Seconds >= 1) OR (Hours = 0 AND Minutes = 0))
		time .= Seconds . (abbr ? "s" : (Seconds = 1 ? " second" : " seconds"))
		Return time
	} ;EndFunction
	
	;EndRegion
	