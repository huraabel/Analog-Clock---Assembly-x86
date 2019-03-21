.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf:proc
extern scanf:proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
a dd 0
b dd 0
suma dd 0

msg1 DB "a=", 0
msg2 db "b=",0
msg3 db "suma=",0
format DB "%d", 0

.code
start:
	; sa se citeasca 2 nr de la taste si afisati suma lor pe ecran
	
	push offset msg1
	call printf
	add ESP, 4 ; curata memoria
	
	push offset a ;echivalent cu &n din C
	push offset format
	call scanf
	add ESP, 8 ;curata memoria
	
	push offset msg2
	call printf
	add ESP, 4 ; curata memoria
	
	push offset b ;echivalent cu &n din C
	push offset format
	call scanf
	add ESP, 8 ;curata memoria
	
	mov eax,0
	add eax ,a
	add eax, b
	mov suma, eax
	
	
	push offset msg3
	call printf
	add esp,4
	
	push suma
	push offset format
	call printf
	add esp,8
	
	push 0
	call exit
end start
