.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc:proc
extern scanf:proc
extern printf:proc
extern scanf:proc
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
format_int db "%d ",0ah,0
format_int_no_endl db "%d ",0
format_int_scan db "%d\n",0ah,0

endl db " ",0ah,0
format_sir db "%s",0ah,0

sum dd 0
sir db "1+1+7+7=?",0
a db '0'
; sa se calculeze suma cifrelor din sir ex: 1 +2 + 1 + 2+3+ 3=12
.code

solve proc
push ebp
mov ebp,esp
pusha

mov eax,[ebp+8]

cmp al,'0'
	jg unu
	add sum,0
	jmp end1
	
	unu:
	cmp al,'1'
	jg doi
	add sum,1
	jmp end1
	
	doi:
	cmp al,'2'
	jg trei
	add sum,2
	jmp end1
	
	trei:
	cmp al,'3'
	jg patru
	add sum,3
	jmp end1
	
	patru:
	cmp al,'4'
	jg cinci
	add sum,4
	jmp end1
	
	cinci:
	cmp al,'5'
	jg sase
	add sum,5
	jmp end1
	
	sase:
	cmp al,'6'
	jg sapte
	add sum,6
	jmp end1
	
	sapte:
	cmp al,'7'
	jg opt
	add sum,7
	jmp end1
	
	opt:
	cmp al,'8'
	jg noua
	add sum,8
	jmp end1
	
	noua:
	cmp al,'9'
	jg end1
	add sum,9
	
	end1:


	
popa
mov esp,ebp
pop ebp
ret 4
solve endp



start:
	;aflam lungimea
	push offset sir
	call strlen
	add esp,4
	
	
	mov ecx,eax
	lea esi,sir
	
	;parcurgere sir
	for1:
		mov al,byte ptr[esi]
		cmp al,'0'
		jl next
		cmp al,'9'
		jg next
		
		push eax
		call solve
		
		next:
		inc esi
	loop for1
	
		;afis suma
		push sum
		push offset format_int
		call printf
		add esp,8
	
	
	push 0
	call exit
end start
