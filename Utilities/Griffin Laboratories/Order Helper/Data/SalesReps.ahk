; auto-execute:
SalesRepName =
SalesRepEmail =
SalesRepPTID =
SalesRepInitials =



; Sales Reps
rawAllSalesReps =
(ltrim comments
	Name	= Scott Rippey
	Email	= sr@griffinlab.com
	PTID	= 43
	Initials = SR
	;
	Name	= Eric Howell
	Email	= eh@griffinlab.com
	PTID	= 42
	Initials = EH
	;
	Name	= Mark Robertson
	Email	= mr@griffinlab.com
	PTID	= ?????
	Initials = MR
)


SalesRepIndex =
AllSalesReps =
SalesRepCount = 1
Loop, parse, rawAllSalesReps, `n
{	
	varName = SalesRep%SalesRepCount%
	
	RegexMatch(A_LoopField, "\s*(?<Var>\w+)\s*=\s*(?<Value>.*)", line)
	
	If lineVar = Name
	{	SalesRepCount++
		AllSalesReps .= "|"
		AllSalesReps .= lineValue
		
		; Choose a default:
		IfInString lineValue, %A_UserName%
			SalesRepIndex := SalesRepCount
	}
		
	varName = SalesRep%SalesRepCount%%lineVar%
	%varName% := lineValue
}
rawAllSalesReps = ; (Free memory)


Return

