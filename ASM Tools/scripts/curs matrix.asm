.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data

mat1 dw 1,2,3
	 dw 4,5,6
	 dw 7,8,9
mat2 dw 3 dup(3 dup(0))

.code
start:
	mov eax,0
	
	mov ebx,0
	mov ecx,3
	lea esi,mat1
	lea edi,mat2
	
	et2:
		et1:
			mov eax, [esi]
			mov [edi + ebx*2],eax
			add esi,2
			add edi,6
		loop et1
		
		inc ebx
		mov ecx,3 ;; cu grija
		lea edi,mat2
		
		cmp ebx,3
	jb et2
	
	
	
	
	push 0
	call exit
end start
