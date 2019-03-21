.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf :proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
sir dd 1,2,3,4,5,6,7,8,9
n dd ($-sir)/4 ; lungimea sirului, impartim la 4
format db "%d",0
x dd 8             ; x dd ? neinitializat
.code

	bsearch proc
		;nu avem variabile locale deci nu ne trbuie astea:
	;push ebp
	;mov ebp,esp
	
	mov esi,[esp+4] ;adresa sir
	mov ecx,[esp+8]; lungimea sir
	mov ebx,[esp+12] ; x
	
	mov eax,0
	
	cmp ecx,1 ; iesim daca lungimea e 1
	je comparatie ; daca unu nu mai fac shiftare la dreapta
	
	shr ecx,1 ; imparim la 2
	
	comparatie:
		cmp [esi+ecx*4] , ebx ; comparam x cu sir[pozitie]
		jne  et
		
		;mov eax,1
		;ret 12
		et:
			cmp [esi+ecx*4],ebx
			jg mic
			shl ecx,2
			add esi,ecx
			shr ecx,2
			
			
			add esi,ecx
			push ebx
			push ecx
			push esi
			jmp et1
			
			mic:
			push ebx
			push ecx
			push esi
			
			et1:
			call bsearch
			
			mov eax,1
			ret 12
			
	
	;mov esp,ebp
	;pop ebp
	iesire1:
	
		ret 12
	bsearch endp
	
	

start:
	push x
	push n
	push offset sir
	call bsearch
	
	
	
	push eax
	push offset format
	call printf
	

	push 0
	call exit
end start

;
;
;	ebp
;	adresa ret
; 	esp+8 primul param
;	esp+12 param2
;	esp+16 param3