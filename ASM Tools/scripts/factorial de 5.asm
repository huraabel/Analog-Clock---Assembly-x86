.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern fopen:proc
extern fclose:proc
extern printf:proc
extern fprintf:proc
extern fgets:proc
extern fseek:proc
extern ftell:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
 
 
 format db "%d",0ah,0
 
 sir dd 1,2,3,4
 dest dd 0

 n dd 5

.code
start:
	factorial macro n
	local fact_bucla,fact_final
		push ecx
		push edx
		mov eax,1
		mov ecx,n
		test ecx,ecx
		jz fact_final
		
	fact_bucla:
	mul ecx
	loop fact_bucla
	fact_final:
		pop edx
		pop ecx
	endm
	
	factorial n
	
	push eax
	push offset format
	call printf
	
	push 0
	call exit
end start
