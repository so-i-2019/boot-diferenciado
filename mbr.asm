	;; Copyright (c) 2019 - Mateus Ferreira Gomes mateusfgomes@usp.br
	;; 						Guilherme Targon Marques Barcellos guitargon@usp.br
	;;
	;; This is free software and distributed under GNU GPL vr.3. Please 
	;; refer to the companion file LICENSING or to the online documentation
	;; at https://www.gnu.org/licenses/gpl-3.0.txt for further information.


org 0x7c00			;Our load address

	;;Ensure segment:offset values are ok after program is loaded

mov bx, 0  ;Initializing bx --> 0
mov dx, 0  ;Initializing bx --> 0
mov cx, 0  ;Initializing bx --> 0
mov ax, 0  ;Initializing dh --> 0

mov ah, 0xe

text: times 30 db 0

printf_welcome:

	mov al, [welcome_string + bx] ;access the position 'bx' of the string

	cmp al, 0x0			;compare al with \0
	je bx_with_zero

	int 0x10			;print command
	add bx, 0x1			;iterate through the string

	jmp printf_welcome		;jump back


bx_with_zero:
	mov bx, 0
	je read_string

read_string:

	mov ah, 0		;Configure BIOS for reading
	int 0x16		;Read from the keyboard
	mov ah, 0xe		;Configure BIOS for printing

	cmp al, 0xd
	je put_terminator

	int 0x10		;print what's in al

	mov [text + bx], al ;move the character read to the array
	add bx, 0x1

	jmp read_string

put_terminator:

	mov cx, 0
	mov [text + bx], cx ;moves the null terminator to the string
	movzx edx, bx
	sub edx, 1
	mov bx, 0x0
	mov eax, 0x0

;bx // INICIO
;edx //FIM
mov bh, 0

palindrome:

	movzx ebx, bx ;16 --> 32 bits

	cmp ebx, edx  
	jg print_is_palindrome

	mov cl, [text+bx]
	cmp [text+edx], cl
	jne print_is_not_palindrome
	add bx, 1
	sub edx, 1

	jmp palindrome

print_is_palindrome:

	mov ah, 0xe

	mov al, 0xa		;prints a new line
	int 0x10		;print command
	mov al, 0xd		;goes to the begin of the line
	int 0x10		;print command

	mov bx, 0x0

	loop1:

	mov al, [is_palindrome + bx] ;access the position 'bx' of the string

	cmp al, 0x0			;compare al with \0
	je end

	int 0x10			;print command
	add bx, 0x1			;iterate through the string

	jmp loop1		;jump back

print_is_not_palindrome:

	mov ah, 0xe

	mov al, 0xa		;prints a new line
	int 0x10		;print command
	mov al, 0xd		;goes to the begin of the line
	int 0x10		;print command

	mov bx, 0x0

	loop2:

	mov al, [is_not_palindrome + bx] ;access the position 'bx' of the string

	cmp al, 0x0			;compare al with \0
	je end

	int 0x10			;print command
	add bx, 0x1			;iterate through the string

	jmp loop2		;jump back

end:

	jmp $

	welcome_string:	db 'Welcome.Checking palindrome string.Insert the string:', 0xd, 0xa, 0x0
	is_palindrome: db 'String IS palindrome!!!', 0xd, 0xa, 0x0
	is_not_palindrome: db 'String IS NOT palindrome!!!', 0xd, 0xa, 0x0

	times 510 - ($-$$) db 0	; Pad with zeros
	dw 0xaa55		; Boot signature
