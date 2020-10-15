;
; Mem map
; 0x000000	-> IVT
; 0x000400	-> BDA (BIOS data)
; 0x000500	-> Bottom limit of stack; ~30KiB
; 0x007c00	-> 512 bytes where boot sector is loaded (this code)
; 0x007E00	-> more memory; ~480KiB
; 0x080000	-> EBDA (Extended BIOS Data)
; 0x0A0000	-> Video display memory
; 0x0C0000	-> Other BIOS stuff
; 0x100000	-> High memory area
;

ORG 0x7C00
BITS 16
	; boot sector loaded in at addr 0x7c00
start:
	; clear segment regs
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00	; grow stack down from this bit

	cld		; clear direction flag
	mov si, STR	; put pointer to STR in si

; print something
pr_loop:
	lodsb		; load byte from si into al
	or al, al	; check for 0
			; al = lower 8 bits of ax
	jz done
	mov ah, 0xE	; print char with bios function
	int 0x10
	jmp pr_loop

done:
	jmp done

STR:	db "Boot stage 1", 0

	; pad with 0s up until table entries for primary partitions (MBR)
	times 0x01be-($-start) db 0 ; $ = current addr (beginning of line),
				    ; $$ = beginning of current section (but we use start here)
	; 4 MBR table entries (just pad for now)
	times 0x10*4 db 0
	; boot sector signature
	db 0x55
	db 0xAA
	
