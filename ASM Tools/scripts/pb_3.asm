.386
.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
msg DB "Introdu un numar pentru a fi ghicit: ", 0
a DD 0
aformat DB "%d", 0

msg_mic DB "Mai mic. ", 0
msg_mare DB "Mai mare. ", 0
msg_egal DB "Ai ghicit! %d", 0

cnt dd 0
.code
start:
	;aici se scrie codul
	mov edi, 0
	
	upper:
		push offset msg 
		call printf
		add ESP, 4
	
		push offset a
		push offset aformat
		call scanf
		add ESP, 8
	
	 inc cnt
	
	cmp a, edi
	jl less
	jg greater
	
	push cnt
	push offset msg_egal
	call printf 
	add ESP, 8

	jmp cont
	
	less: 
		push offset msg_mic
		call printf 
		add ESP, 4
		inc EBX
		jmp upper
	
	greater:
		push offset msg_mare
		call printf 
		add ESP, 4
		inc EBX
		jmp upper
	;terminarea programului
	
	cont:
	push 0
	call exit
end start
