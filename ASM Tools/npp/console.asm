.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf:proc
extern scanf:proc
extern gets:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data

line db ">",0
getline db "%s",0ah,0
endl db " ",0ah,0
.code
start:
	
	while1:
	
	lea eax,getline
	cmp eax,"exit"
	je exit1
	
	
	push offset line
	call printf
	add esp,4
	
	
	
	push offset getline
	call gets
	add esp,4
	push eax
	

	push offset getline
	call printf
	add esp,4
	
	push offset endl
	call printf
	add esp,4
	push offset endl
	call printf
	add esp,4	
	
	
	pop eax
	jmp while1
	
	exit1:
	
	
	push 0
	call exit
end start
