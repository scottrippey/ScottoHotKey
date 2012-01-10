#IfWinActive FTP Log On
	; This fixes the fact that KeePass doesn't work with these
	; generic "FTP Log On" windows, so we will add the website to the title:
	^!a::
		IfWinExist FTP Log On, www.vocalog.com
			WinSetTitle www.vocalog.com - FTP Log On
		IfWinExist FTP Log On, www.griffinlab.com
			WinSetTitle www.griffinlab.com - FTP Log On
		
		Send ^!a
	Return

#IfWinActive Log On As
	^!a::
		SetTitleMatchMode Slow

		IfWinExist Log On As, www.vocalog.com
			WinSetTitle www.vocalog.com - FTP Log On
		IfWinExist Log On As, www.griffinlab.com
			WinSetTitle www.griffinlab.com - FTP Log On

		SetTitleMatchMode Fast

		
		Send ^!a
	Return



#IfWinActive
