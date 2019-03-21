.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern fgets:proc
extern fopen:proc
extern fclose:proc
extern printf:proc
extern getc:proc
extern ftell:proc
extern fseek:proc
extern fprintf:proc
extern putchar:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
s db 0
s2 db  0

is_first_line db 1

read db "r",0

write db "a",0

nume db "test2.txt",0

nume2 db "test3.txt",0

seek_end dd 2
seek_cur dd 1

i dd -1

format db "%s",0
format_endl db "%s",0ah,0
format2 db "%d",10,13,0
endl db " ",0ah,0

.code

start:
	push offset read
	push offset nume
	call fopen
	add esp,8
	
	mov esi,eax   ; aici e pointer read
	
	
	push offset write
	push offset nume2
	call fopen
	add esp,8
	
	mov edi,eax     ; aici e pointer write
	
	
	
	
	push seek_end  ; mergem la sfarsitul fisierului
	push 0
	push esi
	call fseek;
	add esp,12
	
	
	push esi
	call ftell ; in eax va fi pozitia
	add esp,4
	
	mov ebx,eax	;  pozitia punem in ebx
	
	push seek_end
	push -1
	push esi
	call fseek; ; fseek(read,-1,seek_end)
	add esp,12
	
	
	et:
		;iau caracterul
		push esi
	    call getc ; getc(read)
		add esp,4
		
		
		
		;compar caracterul cu \n
		cmp eax,10
		;daca caracterul este \n 
		je et2
		;daca caracterul nu este \n
		jmp et3
		
		et2:
			;punem in s randul cu fgets
			
			push esi
			push 99
			push offset s
			call fgets
			add esp,12
			
			;aflam lungimea randului din s
			mov edx,0 ;contor lungime
			lea ecx,s
			strlen:
				inc edx
				inc ecx
				mov al,[ecx]
				test al,al ; zero inseamna ca e '\0'
			jnz strlen
				
			
			
			
			;facem lungimea negativa
			xor eax,eax
			sub eax,edx
			
			;scadem lungimea lui s pt a ajunge unde am ramas
			;fgets ne lasa la sfarsitul unui rand
			
			push seek_cur
			push eax
			push esi ; pointer read
			call fseek;				;<=> fseek(file_pointer, -lungime, 1); 1==seek_cur?
			add esp,12
			
			
			;printam s
			cmp is_first_line,1
			je cu_endl
			jne fara_endl
				cu_endl:
				
				push offset s
				push offset format_endl
				push edi
				call fprintf
				add esp,12
				mov is_first_line,0
				jmp urm
					
			fara_endl:
			push offset s
			push offset format
			push edi
			call fprintf
			add esp,12
			
			urm:
			
			
			;pt a trece la randul urmator trecem peste \t si \n
			push seek_cur
			push -4
			push esi
			call fseek; ; fseek(file,-4,SEEK_CUR);
			add esp,12
			
			
			;de asemenea decrementam si ebx(nr total de caractere) cu 2
			
			
			sub ebx,2 
			
			cmp ebx,0
			jne et
			jmp cont
		et3:
			;mergem cu un caracter la stanga
			
			cmp is_first_line,1
			je et2
			
			push 1
			push -2
			push esi
			call fseek;
			add esp,12
			
			;decrementam si ebx-ul
			dec ebx
			cmp ebx,0
			jne et
			jmp cont
	cont:
		
		
		
		push 0 ; seek_set
		push 0
		push esi
		call fseek
		add esp,12
	
	
		push esi
		push 99
		push offset s2
		call fgets
		add esp,12
	
		
		push offset s2
		push offset format
		push edi
		call fprintf
		add esp,12
		
		
	push 0
	call exit
end start


