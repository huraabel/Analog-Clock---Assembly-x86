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

sir db 1,2,3,4
media db 0
f db "media=%X   formatul este: [AH=rest:2 bytes][AL=cat:2 bytes]", 0ah,0dh,0

.code
start:
	;Sa se scrie un program care calculeaza media unui sir de numere ^ntregi din memorie.
	;Numerele sunt de tip octet. Media va fi memorata ca valoare ^ntreaga ^ntr-o variabila
	;de tip octet.
	
	mov eax,0 ; initiem cu zero ca are valori rezidual ce nu imi trebuie
	mov ecx,0 ; contor
	lea esi,sir
	
	mov al,[esi]
	add esi,1 ; incrementez cu ca e byte
	add cl,1 ; calculez cate elemente
	add al,[esi]
	add esi,1
	add cl,1
	add al,[esi]
	add esi,1
	add cl,1
	add al,[esi]
	add cl,1
	
	
	mov edx,0
	div cl ; impart cu cate elemente sunt sa aflu media
	
	mov media ,al 
	
	mov eax,0
	mov al,media
	
	push eax
	lea ebx,f
	push ebx
	call printf
	

	
	
	;terminarea programului
	push 0
	call exit
end start
