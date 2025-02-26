	.file	"main.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"output:%s\n"
.LC1:
	.string	"%s"
	.text
	.globl	main
	.type	main, @function
main:
	sub	rsp, 136
	jmp	.L2
.L9:
	mov	DWORD PTR [rsp+124], 0
	jmp	.L3
.L6:
	mov	eax, DWORD PTR [rsp+124]
	cdqe
	movzx	edx, BYTE PTR [rsp+64+rax]
	mov	eax, DWORD PTR [rsp+124]
	cdqe
	movzx	eax, BYTE PTR [rsp+rax]
	cmp	dl, al
	je	.L4
	lea	rax, [rsp+64]
	mov	rsi, rax
	mov	edi, OFFSET FLAT:.LC0
	mov	eax, 0
	call	printf
	jmp	.L5
.L4:
	add	DWORD PTR [rsp+124], 1
.L3:
	mov	eax, DWORD PTR [rsp+124]
	cdqe
	movzx	eax, BYTE PTR [rsp+64+rax]
	test	al, al
	je	.L5
	mov	eax, DWORD PTR [rsp+124]
	cdqe
	movzx	eax, BYTE PTR [rsp+rax]
	test	al, al
	jne	.L6
.L5:
	mov	DWORD PTR [rsp+120], 0
	jmp	.L7
.L8:
	mov	eax, DWORD PTR [rsp+120]
	cdqe
	movzx	edx, BYTE PTR [rsp+64+rax]
	mov	eax, DWORD PTR [rsp+120]
	cdqe
	mov	BYTE PTR [rsp+rax], dl
	add	DWORD PTR [rsp+120], 1
.L7:
	mov	eax, DWORD PTR [rsp+120]
	cdqe
	movzx	eax, BYTE PTR [rsp+64+rax]
	test	al, al
	jne	.L8
	mov	eax, DWORD PTR [rsp+120]
	cdqe
	mov	BYTE PTR [rsp+rax], 0
.L2:
	lea	rax, [rsp+64]
	mov	rsi, rax
	mov	edi, OFFSET FLAT:.LC1
	mov	eax, 0
	call	__isoc99_scanf
	test	eax, eax
	jg	.L9
	mov	eax, 0
	add	rsp, 136
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 14.2.1 20250207"
	.section	.note.GNU-stack,"",@progbits
