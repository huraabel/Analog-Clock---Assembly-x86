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
;aici declaram date
vector DW 7000h,2,5,10,1,-4,8000h,8001h,7fffh
min DW 0
max DW 0
n DW 18

format db "%X",0ah,0
.code
start:
	
	
	mov ECX,0;
	mov EAX,0;
	mov EDX,0;
	mov EBX,0;
	mov DX,vector[ECX]
	
	
	minim:
	initializare:
		xchg dx,bx
		mov ECX,0  
	mi:
		mov BX,vector[ECX]
		add ECX,2;
		
		cmp BX,DX
		jl  initializare
		
		cmp CX,n
		jz iesire
		
		cmp BX,DX
	jnl mi
	
	iesire:
		mov min,DX
	
		mov ECX,0;
		mov EAX,0;
		mov EDX,0;
		mov EBX,0;
		mov DX,vector[ECX]
	
	
	maxim:
	initializare1:
		xchg DX,BX
		mov ECX,0;
	M:
		mov BX,vector[ECX]
		add ECX,2;
		
		cmp BX,DX
		jg  initializare1
		
		cmp CX,n
		jz iesire1
		
		cmp BX,DX
	jng M
	iesire1:
	mov max,DX
	
	mov eax,0
	mov ax,min
	push eax
	push offset format
	call printf
	add esp,8
	
	mov eax,0
	mov ax,max
	push eax
	push offset format
	call printf
	add esp,8
	
	
	push 0
	call exit
end start
