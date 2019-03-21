.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc:proc
extern scanf:proc
extern printf:proc
extern fgets:proc
extern gets:proc
extern getchar:proc
extern fflush:proc
extern strlen:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format_char db "%c",0ah,0
format_int db "%d",0ah,0
endl db " ",0ah,0
format_sir db "%s",0ah,0
c1 db "c1=",0
c2 db "c2=",0
dati_sir db "sir=",0

len dd 0
var db "                                              ",0
x dd '0'
y dd '0'

.code

change proc
push ebp
mov ebp,esp
pusha

	mov esi,[ebp+8]
	
	
	push esi
	call strlen
	add esp,4
	mov len,eax
	
	
	mov eax,[ebp+12]
	mov ebx,[ebp+16]
	mov ecx,len
	mov edx,0
	
	
	mov al,byte ptr[ebp+12]
	mov ah,byte ptr[ebp+16]
	mov ecx,len
	mov edx,0
	
	for1:
		
		cmp byte ptr[esi],al
		jne next
		mov byte ptr[esi],ah
		
		next:
		
		inc esi
	loop for1
	
	mov eax,[ebp+12]
	mov ebx,[ebp+16]
	mov ecx,len
	mov edx,0
	
	

popa
mov esp,ebp
pop ebp
ret 12
change endp

start:
	
	push offset dati_sir
	call printf
	add esp,4
	
	push offset var
	call gets
	add esp,4
	
	
	
	push offset endl
	call printf
	add esp,4
	
	push offset c1
	call printf
	add esp,4
	
	call getchar
	mov x,eax
	
	
	
	call getchar ; curata
	
	push offset c2
	call printf
	add esp,4
	
	call getchar
	mov y,eax
	

	
	push y
	push x
	push offset var
	call change
	
	
	push offset var
	call printf
	add esp,4


	push 0
	call exit
end start
