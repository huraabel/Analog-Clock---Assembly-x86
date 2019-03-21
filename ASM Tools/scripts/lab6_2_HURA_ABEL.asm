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
extern getchar:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
 
 format_scan db "%c",0
 format_print db "%c",0,0ah
 n dd 0
 n_egal db "n=",0
  
 x dd 0
 format db "%d",0
 disclaimer db "baga numar dublu pt nr de caractere ce vrei sa citesti",0ah,0
 msg db "cititi caracterele:",0ah,0
 
mode_write DB "w", 0
file_name DB "fisier.txt", 0
file_pointer dd 0 
.code
start:
	
	; sa stii ca tare mult m-am chinuit cu problema asta, te rog sa-mi explici cum rezolv chestia cu \n
	; la citirea caracterelor
	
	push offset disclaimer
	call printf
	add esp,4
	
	push offset n_egal
	call printf
	add esp,4
	
	push offset n
	push offset format
	call scanf
	add esp,4
	
	push offset msg
	call printf
	add esp,4
	
	mov ecx,n ; se face de floor(ecx/2) pt ca (cred) caracterele numar par citite iau direct valoarea \n
				; nu stiu sa o rezolv, sry
	
	
		
et:	
	push ecx
	
	
	call getchar
	mov x,eax
	
	pop ecx
	push x
	
loop et

	push offset mode_write
	push offset file_name
	call fopen
	add ESP, 8
	
	mov file_pointer,eax ;save pointer
	
mov edi,n
et2:
	
	
	push offset format_print
	push file_pointer
	call fprintf
	add esp,12
	
	dec edi
	cmp edi,0
jne et2

	
	push file_pointer
	call fclose
	add esp,4

	push 0
	call exit
end start
