factorial macro n
	local fact_bucla,fact_final
		push ecx
		push edx
		mov eax,1
		mov ecx,n
		test ecx,ecx
		jz fact_final
		
	fact_bucla:
	mul ecx
	loop fact_bucla
	fact_final:
		pop edx
		pop ecx
	endm