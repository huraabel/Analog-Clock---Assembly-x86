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
format db "%d",0ah,0
nr dd 11
.code
start:
	;suma nr impare mai mici decat un numar, facut cu macro
	
	suma macro nr
	local sum_bucla_par,sum_bucla_impar,sum_bucla,sum_end
		mov eax,0
		dec nr
		mov ecx,nr
		
		test ecx,ecx
		jz sum_end
	sum_bucla:
		
		push eax
		mov ebx,2
		mov eax,ecx
		mov edx,0
		div bx
		pop eax
		
		cmp edx,0
		jne sum_bucla_impar
		sum_bucla_par:
			dec ecx
			jmp sum_bucla
		
		sum_bucla_impar:
		
		add eax,ecx
		loop sum_bucla
	sum_end:
		
	endm
	
	suma nr
	
	push eax
	push offset format
	call printf
	
	mov nr,5
	suma nr
	
	push eax
	push offset format
	call printf
	
	
	push 0
	call exit
end start
