.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc:proc
extern scanf:proc
extern printf:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format db "%d\n",0
endl db " ",0ah,0
format_printf db "%d ",0ah,0

A dd 3 dup (3 dup (1))
B dd 2,1,0
  dd 1,1,1
  dd 2,1,1
n dd ($-B) / 4;  
det dd 1  
.code
start:
	
	lea esi,B
	mov ebx,0
	
	
	
	mov edi,[esi+ebx]
	
	mov eax,det
	mov ecx,3
	cal_1_det:
		mov edx,[esi+ebx]
		mul edx
		add ebx,16
	loop cal_1_det
	mov det,eax
	
	
	
	
	mov eax,1
	mov ebx,4
	mov ecx,[esi+4]
	mul ecx
	mov ecx,[esi+20]
	mul ecx
	mov ecx,[esi+24]
	mul ecx
	add det,eax
	
	
	
	mov eax,1
	mov ecx,[esi+8]
	mul ecx
	mov ecx,[esi+12]
	mul ecx
	mov ecx,[esi+28]
	mul ecx
	add det,eax
	
	
	mov eax,1
	mov ecx,[esi+8]
	mul ecx
	mov ecx,[esi+16]
	mul ecx
	mov ecx,[esi+24]
	mul ecx
	sub det,eax
	
	
	
	
	mov eax,1
	mov ecx,[esi+0]
	mul ecx
	mov ecx,[esi+20]
	mul ecx
	mov ecx,[esi+28]
	mul ecx
	sub det,eax
	

	
	mov eax,1
	mov ecx,[esi+4]
	mul ecx
	mov ecx,[esi+12]
	mul ecx
	mov ecx,[esi+32]
	mul ecx
	sub det,eax
	
	
	pusha
	push det
	push offset format_printf
	call printf
	add esp,8
	popa
	
	push 0
	call exit
end start
