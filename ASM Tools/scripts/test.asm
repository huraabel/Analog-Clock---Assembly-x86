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
extern strlen:proc
extern strcat:proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
format_char db "%c ",0
format_int db "%X ",0ah,0
format_int_no_endl db "%x ",0

format_sir db "%s",0ah,0
format_int_scan db "%d\n",0ah,0
format_float db "%.3f ",0

endl db " ",0ah,0


student struct
nume db 20 dup(?)
varsta dd ?
student ends


v student <>
n dd 0
nu db "name=",0
va db "varsta=",0
negal db "n=",0

hura db "hura",0
abel db "abel",0
space db " ",0
.code
start:


	
	
	
	

	
	
	push 0
	call exit
end start
