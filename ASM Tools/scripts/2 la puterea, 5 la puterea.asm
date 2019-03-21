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
format db "%f",0ah,0
gasit_msg db "gasit",0
nu_gasit_msg db "nu gasit",0

sir_ordonat dw 1,2,4,7,9,13
x dd 0.333
y dd 1.0
rez dd 0
a dd 5.0
.code

start:
	;calculati 2^(1/3) si 5^(1/3) cu f2xm1 si fy12x
	
	;2^(1/3
	finit
	fld x
	f2xm1	; st(0) <= s^st(0)-1
	fadd y
	
	;5^(1/3)
	finit
	fld x	;st0
	fld a	;st1
	fyl2x ; st(1)<=st(1)*log2(st0), elimina st0
	f2xm1
	fadd y
	;f2xm1
	;fadd y
	
	
	
finish:
	push 0
	call exit
end start
