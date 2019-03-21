.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf:proc
extern scanf:proc
extern getchar:proc
extern fopen:proc
extern fprintf:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format db "%d",0ah,0
format_scan db "%d",0
msg db "mesage",0ah,0

read db "r",0
write db "a",0
nume_fisier db "test3.txt",0

x dd 0
.code
start:
	
	jmp de_aici
	
	apel0 macro func
	call func
	endm
	
	apel1 macro func,form
	push offset form
	call func
	add esp,8
	endm
	
	apel2 macro func,form,reg
	push reg
	push form
	call func
	add esp,8
	endm
	
	apel3 macro func,form,file,reg
	push reg
	push form
	push file
	call func
	add esp,12
	endm
	de_aici:
	
	mov eax,4
	apel2 printf,offset format,eax
	apel2 printf,offset format,7
	
	apel2 scanf, offset format_scan,offset x
	apel2 printf,offset format,x
	
	apel1 printf,msg
	
	apel2 fopen,offset nume_fisier,offset write
	
	apel3 fprintf,offset format,eax, x	
	
	push 0
	call exit
end start
