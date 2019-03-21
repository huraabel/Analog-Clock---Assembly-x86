.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern scanf: proc
extern printf:proc
extern fprintf:proc
extern fopen:proc
extern fclose:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
 msg DB "n=", 0
 msg1 db "v[%d]=",0
 n DD 0 		; nr de elem
 x dd 0 		; var de elem
 format DB "%d", 0
 
	
 mode_write DB "w", 0	
 file_name DB "fisier.txt", 0
 
 pointer_fisier dd 0
 printare_fisier db "%d ",0
 
.code
start:
	; citit de la tastatura un sir de numere
	; si puneti in ord inv intrun fisier
	
	; "n="
	push offset msg
	call printf
	add ESP, 4 ; curata memoria
 
	;citire n
	push offset n ;echivalent cu &n din C
	push offset format
	call scanf
	add ESP, 8 ;curata memoria
	
	
	mov edi,0
	
	et:
		;"v[...]="
		push edi
		push offset msg1
		call printf
		add ESP, 8 ; curata memoria
 
		;citire element
		push offset x ;echivalent cu &n din C
		push offset format
		call scanf
		add ESP, 8 ;curata memoria
	
		push x ; salvare element pe stiva
	
		inc edi
		cmp edi,n
	jne et
	
	
	; deschidem fisierul
	push offset mode_write
	push offset file_name
	call fopen
	add ESP, 8
	
	;salvare eax
	mov pointer_fisier, eax 
	
	mov edi,0
	et1:
		; printam in fisier
		push offset printare_fisier
		push pointer_fisier
		call fprintf
		add esp,12 ;cu 4 mai mult ca stergem elementul curent de pe stiva
	
		inc edi
		cmp edi,n
	jne et1
	
	push pointer_fisier ; trebuie pt fclose
	call fclose
	add ESP, 4
	
	push 0
	call exit
end start
