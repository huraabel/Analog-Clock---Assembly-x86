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
 mode_write DB "w", 0	
 mode_read DB "r", 0
 file_name1 DB "fisier.txt", 0
 file_name2 db "fisier2.txt",0
 
 file_name3 db "fisier3.txt",0
 
 pointer_fisier_r dd 0
 pointer_fisier_w dd 0
 pointer_fisier_w1 dd 0
 
 get_fisier db "%s",0ah,0dh,0
 printare db "%s",0
 printare_endl db "%s",0ah,0
 
 format db "%x",0ah,0
 
 sir dd  0
 x dd 0

.code
start:
	; program care citeste din fisier text pe mai multe linii
	; si care pune in ordin inversa in alt fisier intregul continut
	;use fseek
	
	push offset mode_write
	push offset file_name2
	call fopen
	add ESP, 8
	
	mov pointer_fisier_w,eax
	
	push offset mode_write
	push offset file_name3
	call fopen
	add ESP, 8
	
	push eax ; aici avem pt write
	mov pointer_fisier_w1,eax
	
	push offset mode_read
	push offset file_name1
	call fopen
	add ESP, 8
	
	mov pointer_fisier_r,eax ; salvam eax
	
	
	mov edi,0
	et:
		
		
		push pointer_fisier_r
		push 20
		push offset sir
		call fgets
		add esp,12
		
		cmp eax,0
		je cont
		push eax
		
		push offset printare
		push pointer_fisier_w
		call fprintf
		add esp,12
		
		pop eax
		cmp eax,0
	jne et
	
	

	
	cont1:
		
		
		push offset printare_endl
		push pointer_fisier_w1
		call fprintf
		add esp,12
	
		dec edi
		cmp edi,1
	jne cont1	
	
	cont:
	
	
	push pointer_fisier_r
	call fclose
	add esp,4
	
	push pointer_fisier_w
	call fclose
	add esp,4
	
	push 0
	call exit
end start
