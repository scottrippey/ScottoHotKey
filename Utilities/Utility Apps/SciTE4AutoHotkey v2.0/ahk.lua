-- ahk.lua
-- =======

-- Part of SciTE4AutoHotkey
-- This file implements features specific to AHK in SciTE
-- March 1, 2009 - fincs

-- Functions:
--	AutoIndent
--	Indentation checker and fixer
--	No AutoComplete on comment/string

-- ============================== --
-- Define AutoHotkey lexer styles --
-- ============================== --

local SCE_AHK_DEFAULT      =  0
local SCE_AHK_COMMENTLINE  =  1
local SCE_AHK_COMMENTBLOCK =  2
local SCE_AHK_ESCAPE       =  3
local SCE_AHK_SYNOPERATOR  =  4
local SCE_AHK_EXPOPERATOR  =  5
local SCE_AHK_STRING       =  6
local SCE_AHK_NUMBER       =  7
local SCE_AHK_IDENTIFIER   =  8
local SCE_AHK_VARREF       =  9
local SCE_AHK_LABEL        = 10
local SCE_AHK_WORD_CF      = 11
local SCE_AHK_WORD_CMD     = 12
local SCE_AHK_WORD_FN      = 13
local SCE_AHK_WORD_DIR     = 14
local SCE_AHK_WORD_KB      = 15
local SCE_AHK_WORD_VAR     = 16
local SCE_AHK_WORD_SP      = 17
local SCE_AHK_WORD_UD      = 18
local SCE_AHK_VARREFKW     = 19
local SCE_AHK_ERROR        = 20

-- ============================================ --
-- OnChar event -- needed to execute AutoIndent --
-- ============================================ --

function OnChar(curChar)
	-- this script only works on AHK lexer

	-- check for new line
	if curChar == "\n" then
		-- then execute AutoIndent
		AutoIndent()
	end

	-- disable autocomplete on comment and string
	local curStyle = editor.StyleAt[editor.CurrentPos-2]
	if ((curStyle == SCE_AHK_COMMENTLINE) or (curStyle == SCE_AHK_COMMENTBLOCK) or (curStyle == SCE_AHK_STRING) or (curStyle == SCE_AHK_ERROR)) then
		if editor:AutoCActive() then
			editor:AutoCCancel()
		end
		return true
	end

	return false
end

-- =================== --
-- AutoIndent function --
-- =================== --

-- this function implements AutoIndent for AutoHotkey

function AutoIndent()
	-- get some info
	local prevPos = editor:LineFromPosition(editor.CurrentPos) - 1
	local prevLine = editor:GetLine(prevPos)
	local curPos = prevPos + 1
	local curLine = editor:GetLine(curPos)
	
	-- check for comments
	if string.find(prevLine, "^%s*;") ~= nil then
		return false
	end
	
	-- check if it's neccesary to deindent previous line
	if (string.find(prevLine, "^%s*}") ~= nil) then
		-- deindent the line only if there are tabs
		if (string.find(prevLine, "^%s+") ~= nil) then
			-- deindent previous line
			editor.CurrentPos = editor:PositionFromLine(prevPos)
			editor:Home()
			editor:BackTab()

			-- and deindent current line
			editor.CurrentPos = editor:PositionFromLine(curPos)
			editor:Home()
			editor:BackTab()
		end
	end

	-- check if it's neccesary to indent current line
	if ((string.find(prevLine, "^%s*{") ~= nil) or (string.find(prevLine, "{%s*$") ~= nil)) then
		-- yep
		editor.CurrentPos = editor:PositionFromLine(curPos)
		editor:LineEnd()
		editor:Tab()
	end
	
	-- go to current line
	editor.CurrentPos = editor:PositionFromLine(curPos)
	editor:LineEnd()
	
	return false
end

-- ==================================== --
-- Indentation checker & fixer function --
-- ==================================== --

-- this function checks the indentation of the script and if neccesary fixes it

function IndentationChecker()
	local tabs = 0
	local lineIndent = 0
	local curLine = ""

	-- loop for all lines
	local i = 0
	while true do
		i = i + 1

		-- get current line
		curLine = editor:GetLine(i)
		if curLine == nil then
			break
		end

		-- check for comments
		if string.find(curLine, "^%s*;") == nil then
			-- go to line
			editor.CurrentPos = editor:PositionFromLine(i)
			editor:Home()

			-- get line indentation
			lineIndent = editor.LineIndentation[i]

			-- deindent line if neccesary
			if lineIndent ~= 0 then
				for j = 1, lineIndent, 1 do
					editor:BackTab()
				end
			end

			-- indent line if neccesary
			if tabs ~= 0 then
				for j = 1, tabs, 1 do
					editor:Tab()
				end
			end

			-- and fix indentation
			-- indent "next" line if is neccesary
			if ((string.find(curLine, "^%s*{") ~= nil) or (string.find(curLine, "{%s*$") ~= nil)) then
				tabs = tabs + 1
			end

			-- deindent current line if is neccesary
			if (string.find(curLine, "^%s*}") ~= nil) then
				editor:Home()
				if (string.find(curLine, "%s-.*") ~= nil) then
					tabs = tabs - 1
					editor:BackTab()
				end
			end
		end

		-- go to end of line
		editor:LineEnd()
	end
end

-- ====================== --
-- Script Backup Function --
-- ====================== --

-- this functions creates backups for the files

function OnBeforeSave(filename)
	local backupAllowed = props['make.backup']
	if backupAllowed == "1" then
		os.remove(filename .. ".bak")
		os.rename(filename, filename .. ".bak")
	end
end

-- ============ --
-- Open Include --
-- ============ --

function OpenInclude()
	local CurrentLine = editor:GetLine(editor:LineFromPosition(editor.CurrentPos))
	if not string.find(CurrentLine, "^%s*%#[Ii][Nn][Cc][Ll][Uu][Dd][Ee]") then
		print("Not an include line!")
		return true
	end
	local place = string.find(CurrentLine, "%#[Ii][Nn][Cc][Ll][Uu][Dd][Ee]")
	local IncFile = string.sub(CurrentLine, place + 8)
	if string.find(IncFile, "^[Aa][Gg][Aa][Ii][Nn]") then
		IncFile = string.sub(IncFile, 6)
	end
	IncFile = string.gsub(IncFile, "\r", "") -- strip CR
	IncFile = string.gsub(IncFile, "\n", "") -- strip LF
	IncFile = string.sub(IncFile, 2)         -- strip space at the beginning
	IncFile = string.gsub(IncFile, "*i ", "") -- strip *i option
	IncFile = string.gsub(IncFile, "*I ", "")
	-- Delete comments
	local cplace = string.find(IncFile, ";")
	if cplace then
		IncFile = string.sub(IncFile, 1, cplace-1)
	end
	-- Delete spaces at the beginning if needed
	while true do
		ccc = string.find(IncFile, "^%s")
		if ccc then
			IncFile = string.sub(IncFile, ccc+1)
		else
			break
		end
	end
	-- Delete spaces at the end if needed
	while true do
		ccc = string.find(IncFile, "%s$")
		if ccc then
			IncFile = string.sub(IncFile, 1, ccc-1)
		else
			break
		end
	end
	-- print("Include: '" .. IncFile .. "'")
	if io.open(IncFile, "r") then
		io.close()
		scite.Open(IncFile)
	else
		print("File not found! Specified: '" .. IncFile .. "'")
	end
	return true
end

-- ================ --
-- Helper Functions --
-- ================ --
