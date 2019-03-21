.486
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
format_int db "%X ",0ah,0
format_int_no_endl db "%x ",0
format_sir db "%s",0ah,0
format_int_scan db "%d\n",0ah,0
format_float db "%.3f ",0

endl db " ",0ah,0

;;Se da un vector V de 200 numere strict pozitive si se cere:
;-sa se pune in vectorul V1 toate numerele mai mari de 1234h
;->V2 numerele ramase
;-sa se determine valoarea medie(MED) a vectorului V1

v dd 1000h,2000h,1230h,1h,23h,6000h,5777h
lung dd ($-v)/4
v1 dd 200 dup(0)
v2 dd 200 dup(0)
lungv2 dd 0
lungv1 dd 0

x dd 0
medie dq 0.0

.code


start:
	
	mov ecx,lung
	lea esi,v
	lea edi,v1
	lea edx,v2
	
	
	
	for0:
	mov eax,[esi]
	cmp eax,1234h
	jle make_v2
		;makes v1
		mov eax,[esi]
		mov [edi],eax
		add edi,4
		inc lungv1
		jmp goto_next
	
	make_v2:
		mov eax,[esi]
		mov [edx],eax
		add edx,4
		inc lungv2
	
	goto_next:
		
		
	add esi,4
	loop for0
	
	
	lea edi,v1
	mov ecx,lungv1
	for1:
		;pusha
		;push [edi]
		;push offset format_int_no_endl
		;call printf
		;add esp,8
		;popa
		
		finit
		mov eax,[edi]
		mov x,eax
		fild x
		fld medie
		fadd
		fstp medie
		
		;pusha
		;push x
		;push offset format_int
		;call printf
		;add esp,8
		;popa
		
		add edi,4
	loop for1
	
	fld medie
	fild lungv1
	fdiv
	fstp medie
	
	push dword ptr[medie+4]
	push dword ptr[medie]
	push offset format_float
	call printf
	add esp,12
	
	
	
	
	push offset endl
	call printf
	add esp,4
	
	push 0
	call exit
end start
