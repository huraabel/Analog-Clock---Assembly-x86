.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf:proc
extern fopen:proc
extern fclose:proc
extern fprintf:proc
extern fscanf:proc
extern fgets:proc
extern scanf:proc
extern gets:proc
extern getchar:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
format_char db "%c ",0
format_int db "%X ",0ah,0
format_int_no_endl db "%x ",0
format_sir db "%s",0ah,0
format_int_scan db "%d\n",0ah,0
format_float db "%.3f ",0

endl db " ",0ah,0



;Se citesc de la tastatura maxim 100 de char, 
;pana la primirea caracterului ‘*’/ enter. 
;Toate se pun intr-un sir X, apoi, 
;literele mici in Y, iar cifrele (0-9) in Z. 
;Daca numarul de cifre e mai mare 
;ca cel de litere sa se afiseze inNumbers, altfel inLetters. 

get db '0'

x db 100 dup('0')
y db 100 dup('0')
z db 100 dup('0')
lungx dd 0
lungy dd 0
lungz dd 0

letters db "letters",0ah,0
numbers db "numbers",0ah,0
same db "same",0ah,0

contor dd 0
.code
start:

	lea esi,x
	lea edi,y
	lea ecx,z
	
	for0:
	pusha
	inc lungx
	
	push offset get
	call getchar
	add esp,4
	mov [esi],al
	popa
	
	pusha
	call getchar
	popa
	
	mov al,[esi]
	
	cmp al,'0'
	jl letter
	cmp al,'9'
	jg letter
	
	mov [edi],al
	inc edi
	inc lungy
	jmp next
	
	letter:
	mov [ecx],al
	inc ecx
	inc lungz
	
	
	
	next:
	cmp al,'*'
	je end1
	cmp al,10
	je end1
	
	inc esi
	jmp for0
	
	end1:
	
	
	lea esi,y
	mov ecx,lungy
	for1:
		pusha
		push [esi]
		push offset format_char
		call printf
		add esp,8
		popa
	inc esi
	loop for1
	
	push offset endl
	call printf
	call printf
	add esp,4
	
	lea esi,z
	mov ecx,lungz
	for2:
		pusha
		push [esi]
		push offset format_char
		call printf
		add esp,8
		popa
	inc esi
	loop for2
	
	push offset endl
	call printf
	call printf
	add esp,4
	
	
	mov eax,lungy
	cmp eax,lungz
	jl let
	je sameln
	push offset numbers
	call printf
	add esp,4
	jmp end2
	
	let:
	push offset letters
	call printf
	add esp,4
	jmp end2
	
	sameln:
	push offset same
	call printf
	add esp,4
	jmp end2
	
	
	end2:
	
	push 0
	call exit
end start
