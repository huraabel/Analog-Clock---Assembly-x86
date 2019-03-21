.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf:proc
extern fopen:proc
extern fclose:proc
extern fprintf:proc
extern fscanf:proc
extern fgets:proc
extern scanf:proc
extern gets:proc
extern getchar:proc
extern strlen:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
format_char db "%c ",0
format_int db "%X ",0ah,0
format_int_no_endl db "%x ",0
format_sir db "%s",0ah,0
format_int_scan db "%d\n",0ah,0
format_float db "%.3f ",0

endl db " ",0ah,0

sir db "                   ",0
siregal db "sir:",0
len dd 0

mic db 10 dup('0')
mare db 10 dup('0')
lmic dd 0
lmare dd 0




.code
;se da un sir, scoate litere mici si mari separat

start:

	push offset siregal
	call printf
	add esp,4
	
	push offset sir
	call gets
	add esp,4
	
	push offset sir
	call strlen
	add esp,4
	mov len,eax
	
	mov ecx,len
	lea esi,sir
	lea edi,mic
	lea ebx,mare
	
	for0:
		mov al,[esi]
	
		cmp al,'a'
		jl caps
		cmp al,'z'
		jg caps
	
		mov [edi],al
		inc edi
		inc lmic
	
		jmp next
	
		CAPS:
		cmp al,'A'
		jl next
		cmp al,'Z'
		jg next
	
		mov [ebx],al
		inc ebx
		inc lmare
	
		next:
		inc esi
	loop for0
	
	push offset endl
	call printf
	add esp,4
	
	lea edi,mic
	mov ecx,lmic
	cmp ecx,0
	jle jmp_mare
	
	for1:
		pusha
		push [edi]
		push offset format_char
		call printf
		add esp,8
		popa
	
	inc edi
	loop for1
	
	jmp_mare:
	
	push offset endl
	call printf
	add esp,4
	
	lea edi,mare
	mov ecx,lmare
	cmp ecx,0
	jle jmp_inexistent
	
	for2:
		pusha
		push [edi]
		push offset format_char
		call printf
		add esp,8
		popa
	
	inc edi
	loop for2
	
	
	jmp_inexistent:

	push 0
	call exit
end start
