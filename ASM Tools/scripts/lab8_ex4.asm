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
p dd 1.2,3.0,0,4.9,8.27

n equ ($-p)/4
X dd 2.0

f db "%.3f",0ah,0
fd db "%d",0ah,0
rez dq 0.0

msg db "rez=",0


.code
start:

	
	finit
	mov ecx,n
	mov esi,0
	
	cmp ecx,0
	je iesire
	
	loop_:
	
		fld p[esi] ;in st0 este coeficientul curent
		
		mov ebx,ecx
		
		sub ebx,1
		cmp ebx,0
		jz cont
			fld1 
			putere:
			;in ecx-1 este gradul lui x (in ebx)
			
			fmul x
			dec ebx
			jnz putere
			
		fmul st(0),st(1)
		fadd rez
		fst rez
		
		finit	
		cont:
		add esi,4
		
		
	loop loop_
	
	;rezolvare ultimul termen
	sub esi,4
	fld rez
	fld p[esi]
	fadd
	fstp rez
	
	
	push offset msg
	call printf
	add esp,4
	
	push dword ptr[rez+4]
	push 0
	push offset f
	call printf
	
	
	iesire:
	push 0
	call exit
end start
