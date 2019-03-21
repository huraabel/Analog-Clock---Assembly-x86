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
N dd 5
rez dq 0
form db "%lf",0
.code
start:
		finit
		mov ecx,N
		jecxz iesire
		
		fldz ; initializare stiva coprocesor
	
		
		loop_:
			fild N
			fild N
			fsqrt
			fdivr
			fadd
			
			dec N
			
		loop loop_
		
		fstp rez
	
	push dword ptr[rez+4]
	push dword ptr[rez]
	push offset form
	call printf
	
	iesire:
	
	push 0
	call exit
end start
