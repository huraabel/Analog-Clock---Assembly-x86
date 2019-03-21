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
sir dw 1,2,3,4
n dw 4
sum dw 0
format db "%d",0
.code
start:
	
	lea esi,sir
	mov eax,0
	mov ecx,4
	
	et:
		
		mov ax,[esi]
		add sum,ax
		add esi,2
		
		
		cmp cx,1
		dec cx
	jne et
	
	
	mov ax,sum
	push eax
	push offset format
	call printf
	
	
	push 0
	call exit
end start
