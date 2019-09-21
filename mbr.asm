	;; mbr.asm - a simple x86 bootloader with text-mode 
	;; animation describing a triangle made of asterisks
	;;
	;; created by Rafael Ceneme <rafael.ceneme@usp.br>
	;; 		  and Bruno Gazoni  <bruno.gazoni@usp.br>
	;; based on a template provided by Monaco F. J. <monaco@usp.br>
	;;

	org 0x7c00		; Our load address

	mov ah, 0xe		; Configure BIOS teletype mode

	mov bx, 0		; May be 0 because org directive.
	mov dx, 0x02	; Used as high value in 0x15 interrupt (wait)
	mov cx, 0x01	; Used as low value in 0x15 interrupt (wait)


loop:				; Write a 0x0-terminated ascii string (triangle of asterisks)
	mov ah, 0x86	
	mov al, 0x00	
	int 0x15		; Delay
	mov ah, 0xe
	mov al, [here + bx]	
	int 0x10		; Prints one char from the string 'here'
	cmp al, 0x0
	je interloops12 ; Goes to the next loop
	add bx, 0x1		
	jmp loop

interloops12:
	mov bx, 0		; Resets bx to 0
	jmp loop2		; Proceed to print a backwards triangle of asterisks

interloops21:
	mov bx, 0		; Resets bx to 0
	jmp loop		; Goes back to the first loop (forward triangle)

loop2:				; Write a 0x0-terminated ascii string (backwards triangle)
	mov ah, 0x86
	mov al, 0x00
	int 0x15		; Delay
	mov ah, 0xe
	mov al, [here2 + bx]	
	int 0x10		; Prints one char from the string 'here2'
	cmp al, 0x0
	je interloops21 ; Goes back to loop
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
