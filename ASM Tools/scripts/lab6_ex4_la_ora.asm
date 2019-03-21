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
;aici declaram date

poz dd 0 dup(100)
sir db 0 dup(100)

.code
start:
	mov ecx,0
	mov esi,0
	citire:
		fgets(sir)
		ftell
		cmp poz[esi],eax ; cand cele 2 coincid atunci se termina
		
		je fisier_terminat
		inc esi ; pt ca pozitia prima e zero
		mov poz[esi],eax  ;sau faci push la asta
		
	loop citire
	fisier_terminat:
	
	
	dec esi
	mov ecx,esi
	
	scriere:
		fseek(poz[ecx])
		fgets(sir)
		fprintf(sir)
	
	loop scriere	
	
	
	push 0
	call exit
end start
