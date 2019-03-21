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
x db "Ana are 20 de ani.",0
l dd $-x

.code
start:
	
	lea esi,x
	mov ecx,l
	mov al,'a'
	mov ah,'z'
	
	mov bl,'A'
	mov bh,'Z'
	
	et:
		;mov al,[esi]
		cmp [esi],al
		jb iesire
		cmp [esi],ah
		ja iesire
		
		sub byte ptr[esi],20h  ; sub al,20h
							   ; mov [esi],al
		iesire:
		inc esi
	
	loop et
	
	push offset x
	call printf
	
	push 0
	call exit
end start
