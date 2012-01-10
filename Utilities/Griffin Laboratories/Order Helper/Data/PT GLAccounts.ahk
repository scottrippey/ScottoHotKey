; Auto-execute:

rawAllGLAccounts =
(ltrim comments
;
; Enter the GL Accounts below, as listed in PeachTree
; (Title) = (Number)
;
Internet Sales = 40650
Phone Sales = 40850
Distributor Sales = 40000
;
;
;
;
)

AllGLAccounts =
Loop, parse, rawAllGLAccounts, `n
{
	RegexMatch(A_LoopField, "^\s*(.*?)\s*=\s*(.*?)\s*$", line)
	
	AllGLAccounts .= "|" . line1
	
	varName := "GLAccount" . (A_Index + 1)
	%varName% := line2	
}


Return

