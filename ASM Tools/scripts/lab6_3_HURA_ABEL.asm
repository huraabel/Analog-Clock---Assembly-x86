.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf:proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

msg db "nr=",0
form db "%d",0
nr dd 0

de_ghicit dd 4

maimic db "mai mic",0ah,0dh,0
maimare db "mai mare",0ah,0dh,0
gasit db "ai gasit, nr. de incercari:%d",0ah,0dh,0
.code
start:
	; ghiceste un numar, daca mai mic afis "mai mic" daca mai mare afis "mai mare"
	; se afiseaza nr de incercari
	; nr randam cu rdtsc se face doar cu .586
	
	rdtsc
	mov de_ghicit,eax

	mov edi,0
	et:
		
		push offset msg
		call printf
		add esp,4
	
		push offset nr
		push offset form
		call scanf
		add esp,8
		
		inc edi
	
	mov ebx, de_ghicit
	cmp nr, ebx
	je egal
	jb mai_mare
	ja mai_mic
	
	egal:
		push edi
		push offset gasit
		call printf
		push 0
		call exit
	
	mai_mic:
		push offset maimic
		call printf
		add esp,4
		jmp et
	
	mai_mare:
		push offset maimare
		call printf
		add esp,4
		jmp et
	
	
	
end start
