TITLE Project 6 - Strings and Macros     (Proj6_chenxia3.asm)

; Author: Xiao Yu Chen
; Last Modified: 12/05/2021
; OSU email address: chenxia3@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 12/05/2021
; Description: This program is designed to implement two macros used to get 10 integers from the user in the form of a string of digits. The
;				program converts these strings into signed numerical values after validiation and stores this value in a memory variable. It 
;				stores each of these integers in an array and then displays them, their sum, and their truncated average.

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------
; Name: mGetString
; 
; Recieves a prompt to display to the user and gets the user's input in the form of a string.
; Stores this string in the memory variable referenced by storage_ref.
;
; Preconditions: prompt_ref is a valid string
;
; Postconditions: none
;
; Receives:
;	text_ref = reference to the string to be displayed
;
; Returns: storage_ref stores the user input string, input_
; ---------------------------------------------------------------------------------
mGetString MACRO prompt_ref: REQ, storage_ref: REQ, input_len: REQ
   push					edx
   push					ecx
   push					eax

   mDisplayString		prompt_ref
   mov					edx, storage_ref
   mov					ecx, 32
   call					ReadString
   mov					input_len, eax

   pop					eax
   pop					ecx
   pop					edx
ENDM

; ---------------------------------------------------------------------------------
; Name: mDisplayString
; 
; Receicves a reference to a string and displays it to the user.
;
; Preconditions: text_ref is a valid string
;
; Postconditions: none
;
; Receives:
;	text_ref = reference to the string to be displayed
;
; Returns: none
; ---------------------------------------------------------------------------------
mDisplayString MACRO text_ref: REQ
	push		edx
	mov			edx, text_ref
	call		WriteString
	pop			edx
ENDM

	LOWER = 48
	UPPER = 57

.data

	intro_1				BYTE		"String Primitive Converter by Xiao Yu Chen", 13, 10, 0
	intro_2				BYTE		"This program will prompt for 10 signed integers. Each input must be at most 32 bits long.", 13, 10, 0
	intro_3				BYTE		"After 10 valid inputs, I will display the list of inputs along with their sum and average value.", 13, 10, 0
	prompt				BYTE		"Please enter a signed integer: ", 0
	error				BYTE		"ERORR: Not a number or the input was too large.", 0
	num_title			BYTE		"You entered the following numbers: ", 13, 10, 0
	sum_title			BYTE		"The sum of these numbers is: ", 0
	avg_title			BYTE		"The truncated average of these numbers is: ", 0
	count				DWORD		10
	input				BYTE		?
	input_len			DWORD		?
	num					SDWORD		?
	num_array			SDWORD		10 DUP(?)


.code
main PROC
	
	mDisplayString		OFFSET intro_1
	call				CrLf
	mDisplayString		OFFSET intro_2
	mDisplayString		OFFSET intro_3
	call				CrLf
		
	mov					ecx, count
	mov					edi, OFFSET num_array

_GetAndStore:
	push				OFFSET input_len
	push				OFFSET prompt
	push				OFFSET error
	push				OFFSET input
	push				OFFSET num
	call				ReadVal
	mov					eax, num
	mov					[edi], eax
	add					edi, 4
	loop				_GetAndStore

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: ReadVal
; 
; Uses the mGetString macro to get user input in the form of a string of digits. Validates user input.
; If valid, converts the string to a numerical representation and stores it in a memory variable.
; If invalid or not given an input, displays an error and re-prompts the user.
;
; Preconditions: mGetString is passed a prompt string to display and a SDWORD for storage
;
; Postconditions:  is changed
;
; Receives:
;	[ebp + 24] = reference to input length
;	[ebp + 20] = reference to the prompt
;	[ebp + 16] = reference to the error message
;	[ebp + 12] = reference to the user input, stored as a string
;	[ebp + 8] = reference to user input, stored as a signed integer
;
; Returns: num stores a valid signed integer
; ---------------------------------------------------------------------------------
ReadVal PROC
	LOCAL				sum: BYTE
	push				ebp
	mov					ebp, esp

	push				ecx
	push				esi
	push				eax

_PromptUser:
	mGetString			[ebp + 28], [ebp + 20], [ebp + 32]
	mov					ecx, [ebp + 32]
	mov					esi, [ebp + 20]
	mov					bl, 0
	cld

_Convert:
	lodsb
	cmp					al, LOWER
	jl					_PromptUser
	cmp					al, UPPER
	jg					_PromptUser
	mov					sum, al
	mov					al, bl
	add					al, sum
	mov					bl, al
	loop				_Convert

	mov					al, bl

	pop					eax
	pop					esi
	pop					ecx
		
	pop					ebp
	ret					20
ReadVal ENDP


END main
