.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf:proc
extern scanf:proc
;extern malloc:proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format db "%d",0ah,0
gasit_msg db "gasit",0
nu_gasit_msg db "nu gasit",0

sir_ordonat dw 1,2,4,7,9,13
x dw 4
.code

start:
	jmp aici
	
bsearch proc
		push ebp
		mov ebp,esp	
		
		
	loop_:
		
		cmp ecx,0
		je end_loop
		
		push ecx
		
		mov ax,[esi]
		cmp ax,x
		je am_gasit
		
		add esi,2
		push esi
		
		push eax
		push offset format
		call printf
		add esp,8
			
		pop esi
		pop ecx
	loop loop_
	
	
end_loop:	
		
	jmp nu_gasit
	am_gasit:
		push offset gasit_msg
		call printf
		add esp,4
		
		mov esp,ebp
		pop ebp
		ret 
		
	nu_gasit:
		push offset nu_gasit_msg
		call printf
		add esp,4
		
		mov esp,ebp
		pop ebp
		ret 
	bsearch endp		
	
	aici:
	lea esi,sir_ordonat
	mov eax,0
	mov ecx,6 ; nr de elem + 1
	
	
	call bsearch
	
finish:
	push 0
	call exit
end start
