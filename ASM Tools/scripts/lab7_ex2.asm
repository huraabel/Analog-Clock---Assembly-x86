.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf:proc
extern scanf:proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format db "%d",0ah,0
citire db "%d",0
printare db "nr=",0

err db "DIV BY ZERO ",0
e_prim db "e prim",0ah,0
nu_e_prim db "nu e prim",0ah,0

nr dd 0


testare dd 0
contor dd 0
.code
start:
	;o functie cu 2 param, care verif daca primul e divizibil cu al 2-lea
	;folosind asta, fa o functie care verif. daca un nr e prim
	;primul e fastcall(ret sterge) al doilea e cdecl(noi stergem)
	
	jmp aici_incepe
	
	divizibil proc
		push ebp
		mov ebp,esp
		;sub esp,8
		
	
		mov eax,[ebp+8] ; primul parametru : a
		mov [ebp-4],eax
		
		mov ebx,[ebp+12] ; al doilea param: b
		mov [ebp-8],ebx
		
		cmp ebx,0
		je zero
		
		mov edx,0
		div ebx
		cmp edx,0
		je unu
		jne zero
		
		zero:
			mov eax,0
			cmp ebx,0
			je div_zero
			jmp cont
				div_zero:
					push eax
					push offset err
					call printf
					add esp,4
					pop eax
					jmp finish
		unu:
			mov eax,1
		
		cont:		

		mov esp,ebp
		pop ebp
		
		ret 8
	divizibil endp
	
	prim proc
		push ebp
		mov ebp,esp
	
		mov ecx,[ebp+8] ; parametru : nr
		mov [ebp-4],ecx
		
		loop_:
		inc contor
		mov ecx,contor
		cmp ecx,nr
		je end_loop
		
		mov eax,0
		
		push contor
		push nr
		call divizibil
		
		cmp eax,1
		je plus
		jmp loop_
		plus:
			add testare,1
			jmp loop_
		
		end_loop:
		
		mov esp,ebp
		pop ebp
		ret 
	prim endp
	
	aici_incepe:
	
	push offset printare
	call printf
	add esp,4
	
	push offset nr
	push offset citire
	call scanf
	add esp,8
	
	
	cmp nr,0
	jle nu
	
	
	push nr
	call prim
	add esp,4
	
	;push eax
	cmp testare,1
	je da
	jne nu
	da:
	
	push offset e_prim
	call printf
	add esp,4
	jmp finish
	
	nu:
	push offset nu_e_prim
	call printf
	add esp,4
	
	
finish:	
	push 0
	call exit
end start
