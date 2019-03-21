.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc:proc
extern scanf:proc
extern printf:proc
extern scanf:proc
extern fgets:proc
extern gets:proc
extern getchar:proc
extern fflush:proc
extern strlen:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format_char db "%c",0ah,0
format_int db "%d",0ah,0
format_int_no_endl db "%d",0
format_int_scan db "%d\n",0ah,0

endl db " ",0ah,0
format_sir db "%s",0ah,0
c1 db "c1=",0
c2 db "c2=",0
dati_sir db "sir=",0
dati_nr db "N=",0
N dd 0


.code

afis proc
push ebp
mov ebp,esp
pusha

	mov ecx,[ebp+8]
	

	cmp ecx,0
	jne not_zero
		pusha
		push 0
		push offset format_int
		call printf
		add esp,4
		popa
		ret 4
	not_zero:
	cmp ecx,1
	je one
		
	
	mov edi,1
	mov ebx,0
		
		for1:
			push ecx
			push edi
			
			mov ebx,1
			
			for2:
				pusha
				push ebx
				push offset format_int_no_endl
				call printf
				add esp,8
				popa
				
				inc ebx
			cmp ebx,edi
			jle for2
			
			pusha
			push offset endl
			call printf
			add esp,4
			popa
			
			
			pop edi
			pop ecx
			
			
			
			
			inc edi
			
		cmp edi,ecx	
		jle for1


popa
mov esp,ebp
pop ebp
ret 4
	one:
		push 1
		push offset format_int
		call printf
		add esp,4
	ret 4

afis endp

start:

	push offset dati_nr
	call printf
	add esp,4

	push offset N
	push offset format_int_scan
	call scanf
	add esp,8
	
	
	push N
	call afis

	push 0
	call exit
end start
