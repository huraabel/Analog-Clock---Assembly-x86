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


vec dd 6,2,12,4,24
l dd 5

k dd 0
x dd 0

a1 dd 0
b1 dd 0
x1 dd 0
a2 dd 0
b2 dd 0
x2 dd 0


n dd 0
d dd 0
.code
compare2variables macro a,b,c1
	local less,exit2
	pusha
	mov eax,[a]
	mov ebx,[b]
	cmp eax,ebx
	jl less
	mov [c1],1
	jmp exit2
	mov [c1],2
	exit2:
	popa
endm

is_prim macro a,x
local for1,good
pusha
mov eax,a
mov ebx,1
 
mov edi,0 
for1:
	
	mov edx,0
	push eax
	div ebx
	
	cmp edx,0
	jne good
		inc edi
		
	good:
	pop eax
	add ebx,1
cmp ebx,eax
jle for1

cmp edi,2
je prim
mov [x],0
jmp end1
prim:
mov [x],1
popa

end1:
endm

divandassign macro a,b,c1
	pusha
	mov edx,0
	mov eax,[a]
	mov ebx,[b]
	div ebx
	mov [c1],eax
	popa
endm



divizibil macro a,b,c1
	local inegal,exit1
	pusha
	mov edx,0
	mov eax,[a]
	mov ebx,[b]
	div ebx
	
	cmp edx,0
	jne inegal
	mov [c1],1
	jmp exit1
	inegal:
	mov [c1],0
	
	exit1:
	popa
endm


nr_div_prim proc
push ebp
mov ebp,esp

	mov k,0
	mov esi,[ebp+8]
	mov n,esi
	
	mov ecx,1
	mov d,ecx
	
	for2:
		divizibil n,d,x
		
	
		
		cmp x,1
		jne nu_diviz
				is_prim d,x
				cmp x,1
				jne nu_prim
					
					while1:
					
					
					divandassign n,d,n
					inc k
					
					divizibil n,d,x
					cmp x,1
					je while1
				
				nu_prim:
			
		nu_diviz:
	
	inc d
	mov esi,n
	cmp d,esi
	jle for2
	
	mov eax,k

mov esp,ebp
pop ebp
ret 4
nr_div_prim endp




	start:
	
	lea esi,vec
	mov ebx,0
	mov edx,0
	mov ecx,l
	
	for3:
	mov edx,ebx
	add edx,4
	push ecx
	dec ecx
		for4:
		cmp ecx,0
		jle next
		
		mov eax,[esi+edx]
		
		pusha
		push [esi+edx]
		call nr_div_prim
		mov a1,eax
		popa
		
		mov edi,[esi+ebx]
		
		pusha
		push [esi+ebx]
		call nr_div_prim
		mov a2,eax
		popa
		
		
		mov eax,a1
		cmp eax,a2
		jg no_swap
			mov eax,[esi+ebx]
			push eax
			mov eax,[esi+edx]
			mov [esi+ebx],eax
			pop eax
			mov [esi+edx],eax
			
		
		no_swap:
		
		
		
	
	add edx,4	
	loop for4
	
	next:
	pop ecx
	add ebx,4
	loop for3
	
	
	lea esi,vec
	mov ebx,0
	mov edx,0
	mov ecx,l
	
	
	
	for5:
		pusha
		push [esi+ebx]
		push offset format_int_no_endl
		call printf
		add esp,8
		popa
		
		pusha
		
		push [esi+ebx]
		call nr_div_prim
		
		
		popa
		
		add ebx,4
	
	loop for5
	
	
	push 0
	call exit
end start
