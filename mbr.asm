	org 0x7c00		; Our load address

	mov ah, 0xe		; Configure BIOS teletype mode

	mov bx, 0		; May be 0 because org directive.
	mov dx, 0x02
	mov cx, 0x01


loop:				; Write a 0x0-terminated ascii string
	mov ah, 0x86
	mov al, 0x00
	int 0x15
	mov ah, 0xe
	mov al, [here + bx]	
	int 0x10
	cmp al, 0x0
	je interloops12
	add bx, 0x1		
	jmp loop

interloops12:
	mov bx, 0
	jmp loop2

interloops21:
	mov bx, 0
	jmp loop

loop2:				; Write a 0x0-terminated ascii string
	mov ah, 0x86
	mov al, 0x00
	int 0x15
	mov ah, 0xe
	mov al, [here2 + bx]	
	int 0x10
	cmp al, 0x0
	je interloops21
	add bx, 0x1		
	jmp loop2


end:				; Jump forever (same as jmp end)
	jmp $

here:				; C-like NULL terminated string

	db 0xd, '*', 0xd, 0xa, '**', 0xd, 0xa, '***', 0xd, 0xa,'****', 0xd, 0xa, '*****', 0xd, 0xa, 0x0
	
here2:

	db 0xd, '****', 0xd, 0xa, '***', 0xd, 0xa, '**', 0xd, 0xa, 0x0
	
	times 510 - ($-$$) db 0	; Pad with zeros
	dw 0xaa55		; Boot signature
