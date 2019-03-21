.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern fprintf: proc
extern fread: proc
extern fopen: proc
extern fclose: proc
extern exit: proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;keyb input
sir_msg DB "Introdu sirul pentru inversare: ", 0
sir DB 35 dup(0)
format_sir DB "%s", 0

format_c DB "%c", 0 
write_file DB "w", 0 ;
filename DB "fisier.txt", 0 

.code
start:
	push offset sir_msg 
	call printf 
	add ESP, 4
	
	push offset sir
	push offset format_sir
	call scanf
	add ESP, 8
	
	;strlen(sir)
	lea EDI, sir
	mov AL, 0
	repne scasb
	
	sub EDI, offset sir
	sub EDI, 2
	xor ESI, ESI ;sterg continutul source indexului -> in ESI pun contorul
	xor EBX, EBX ; -//- reg base -> in EBX pun caracterele
	
	;push la caracterele din sirul input
	pushy:
		cmp ESI, EDI
		jg write_f
		mov BL, sir[ESI]
		push EBX
		inc ESI
	loop pushy
	
	;write in file
	write_f:
	push offset write_file
	push offset filename
	call fopen
	add ESP, 8
	mov ESI, EAX
	
	write:
		cmp EDI, 0
		jl close_f
		push offset format_c
		push ESI
		call fprintf
		add ESP, 12
		dec EDI
	loop write
	
	close_f:
		push ESI
		call fclose
		add ESP, 4	
	push 0
	call exit
end start