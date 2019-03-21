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
param dd 3,2,1,4
grad dd 3
x dd 2
rez dd 0

format db "%d",0
.code
start:

	mov esi,0
	mov ecx,grad
	mov eax,1
	
	cmp grad,0
	je cont
	
	loop_:
		mov ebx,ecx
		
		inmultire:
			mul x
			dec ebx
			cmp ebx,0
		jnz inmultire
		
		mul param[esi]
		add esi,4
		add rez,eax
		mov eax,1
	loop loop_
	
	cont:
	
	
	mov eax,0
	add eax, param[esi]
	add rez,eax
	
	mov eax,rez
	
	push eax
	push offset format
	call printf
	
	push 0
	call exit
end start
