.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
nr dw 0FFFFh
msg db "numarul are %d bituri de 1",0ah,0
.code
start:
	
	mov eax,0
	mov ecx,16
	
	et:
		
		shl nr ,1
		
		jnc fals
		add eax,1
		
		fals:
	
			dec ecx
			cmp ecx,0
	jne et
	
	push eax
	push offset msg
	call printf
	
	push 0
	call exit
end start
