; Auto-execute:


	; List of states:
	allStates =
	(ltrim comments join|
	; The first line should be blank:

	AK - Alaska
	AL - Alabama
	AR - Arkansas
	AZ - Arizona
	CA - California
	CO - Colorado
	CT - Connecticut
	DE - Delaware
	FL - Florida
	GA - Georgia
	HI - Hawaii
	IA - Iowa
	ID - Idaho
	IL - Illinois
	IN - Indiana
	KS - Kansas
	KY - Kentucky
	LA - Louisiana
	MA - Massachusetts
	MD - Maryland
	ME - Maine
	MI - Michigan
	MN - Minnesota
	MO - Missouri
	MS - Mississippi
	MT - Montana
	NC - North Carolina
	ND - North Dakota
	NE - Nebraska
	NH - New Hampshire
	NJ - New Jersey
	NM - New Mexico
	NV - Nevada
	NY - New York
	OH - Ohio
	OK - Oklahoma
	OR - Oregon
	PA - Pennsylvania
	RI - Rhode Island
	SC - South Carolina
	SD - South Dakota
	TN - Tennessee
	TX - Texas
	UT - Utah
	VA - Virginia
	VT - Vermont
	WA - Washington
	WI - Wisconsin
	WV - West Virginia
	WY - Wyoming
	;
	;
	;
	; Non-State abbreviations:
	;
	;
	; AE - Armed Forces Africa
	; AA - Armed Forces Americas (except Canada)
	; AE - Armed Forces Canada
	; AE - Armed Forces Europe
	; AE - Armed Forces Middle East
	; AP - Armed Forces Pacific
	; AS - American Samoa
	; DC - District Of Columbia
	; FM - Federated States Of Micronesia
	; GU - Guam
	; MH - Marshall Islands
	; MP - Northern Mariana Islands
	; PW - Palau
	; PR - Puerto Rico
	; VI - Virgin Islands
	)
Return


LoadAllZips:
	allZips =
	(ltrim comments
	; Obtained from http://www.visitingdc.com/zip-code/zip-code-finder.asp
	01001 - 02791  Massachusetts
	02801 - 02940  Rhode Island
	03031 - 03897  New Hampshire
	03901 - 04992  Maine
	05001 - 05907  Vermont
	06001 - 06928  Connecticut
	07001 - 08989  New Jersey
	10001 - 14925  New York
	15001 - 19640  Pennsylvania
	19701 - 19980  Delaware
	20001 - 20599  Washington DC
	20101 - 24658  Virginia
	20601 - 21930  Maryland
	24701 - 26886  West Virginia
	27006 - 28909  North Carolina
	29001 - 29945  South Carolina
	30002 - 31999  Georgia
	32003 - 34997  Florida
	35004 - 36925  Alabama
	37010 - 38589  Tennessee
	38601 - 39776  Mississippi
	40003 - 42788  Kentucky
	43001 - 45999  Ohio
	46001 - 47997  Indiana
	48001 - 49971  Michigan
	50001 - 52809  Iowa
	53001 - 54990  Wisconsin
	55001 - 56763  Minnesota
	57001 - 57799  South Dakota
	58001 - 58856  North Dakota
	59001 - 59937  Montana
	60001 - 62999  Illinois
	63001 - 65899  Missouri
	66002 - 67954  Kansas
	68001 - 69367  Nebraska
	70001 - 71497  Louisiana
	71601 - 72959  Arkansas
	73001 - 74966  Oklahoma
	73301 - 88595  Texas
	80001 - 81658  Colorado
	82001 - 83414  Wyoming
	83201 - 83877  Idaho
	84001 - 84791  Utah
	85001 - 86556  Arizona
	87001 - 88439  New Mexico
	88901 - 89883  Nevada
	90001 - 96162  California
	96701 - 96898  Hawaii
	97001 - 97920  Oregon
	98001 - 99403  Washington
	99501 - 99950  Alaska
	)
Return






; Returns the state name or abbreviation or index
; @param state: can be an Index, abbreviation or full state name
; @param StateOrAbbrOrIndex: determines what to return.  Must be either ABBR, STATE, or INDEX
; @returns State name, State Abbreviation, or State Index.
StateInfo(state, StateOrAbbrOrIndex = "ABBR") {
	global allStates
	
	If state is not integer
		If (StrLen(state) = 2)
			state .= " - "

	result =
	resultIndex = 0
	Loop, parse, allStates, |
	{	
		If state is integer
		{	If (A_Index = state) {	
				result := A_LoopField
				resultIndex := A_Index
				break
			}
		}
		Else IfInString A_LoopField, %state%
		{	result := A_LoopField
			resultIndex := A_Index
			break
		}
	}

	; Figure out what info we are requesting:
	If StateOrAbbrOrIndex = ABBR
		RegexMatch(result, "..", result)
	Else If StateOrAbbrOrIndex = STATE
		RegexMatch(result, "(?<= - ).+", result)
	Else ; INDEX
		result := resultIndex
	
	Return result
}



; Looks up the zip code and returns the state.
FindZip(zip, StateOrAbbrOrIndex = "ABBR") {
	Global allZips
	GoSub LoadAllZips
	
	Loop, parse, allZips, `n, `r
	{	
		RegexMatch(A_LoopField, "(\d{5}) - (\d{5})  (.*)", zipRange)
		If zip between %zipRange1% and %zipRange2%
		{	allZips =
			Return StateInfo(zipRange3, StateOrAbbrOrIndex)
		}
	}
	allZips =
	Return StateInfo("Unknown", StateOrAbbrOrIndex)
}






























