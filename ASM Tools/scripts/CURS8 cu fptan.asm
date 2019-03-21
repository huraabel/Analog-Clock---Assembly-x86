.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
x dd 3.0
.code
start:
	; tg x = sinx/cosx
	; sin^2x + cos^2x =1
	
	
	; caulceaza sin(x) cu fptan
	finit 
	fldpi
	fld x
	fdiv
	fptan
	fld st(1)
	fmul st(0),st(2)
	fld st(0)
	
	fadd st(0), st(2)
	fdiv
	fsqrt
	
	
	
	push 0
	call exit
end start
