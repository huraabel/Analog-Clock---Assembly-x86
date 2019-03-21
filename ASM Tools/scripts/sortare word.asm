.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc:proc
extern scanf:proc
extern printf:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format db "%d\n",0
endl db " ",0ah,0
format_printf db "%X ",0
sir dw 15,-1,8,9,-4,7,17,-2,9,-10
l dd 10
aux dw 0
.code
start:
	lea esi, sir
	mov ecx, l
	mov ebx,0
	afis:
		mov eax,0
		mov ax,[esi+ebx]
		pusha
			push eax
			push offset format_printf
			call printf
			add esp,8
		popa
		add ebx,2;
	
	loop afis
	
	push offset endl
	call printf
	add esp,8
	
	mov ecx,l
	mov edi,0
	mov ebx,0
	lea esi,sir
	
	for1:
	mov ebx,edi
	add ebx,2
	push ecx
	dec ecx
		for2:
		cmp ecx,0
		jle next
		
		mov ax,[esi+edi]
		
		cmp ax,[esi+ebx]
		jle no_swap
			mov dx,[esi+ebx]
			mov [esi+ebx],ax
			mov [esi+edi],dx
		
		
		no_swap:
		add ebx,2
		loop for2
	next:
	pop ecx
	add edi,2
	loop for1
	
	
	
	
	lea esi, sir
	mov ecx, l
	mov ebx,0
	afis2:
		mov eax,0
		mov ax,[esi+ebx]
		pusha
			push eax
			push offset format_printf
			call printf
			add esp,8
		popa
		add ebx,2;
	
	loop afis2
	
	
	
	
	push 0
	call exit
end start
