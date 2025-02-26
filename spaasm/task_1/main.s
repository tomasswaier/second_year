	.file	"main.c"
	.intel_syntax noprefix
# GNU C17 (GCC) version 14.2.1 20250207 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 14.2.1 20250207, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -O0 -fno-asynchronous-unwind-tables -fno-stack-protector -fno-exceptions -fomit-frame-pointer -fno-pic
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
	sub	rsp, 136	#,
# main.c:6:   while (scanf("%s", riadok) > 0) {
	jmp	.L2	#
.L9:
# main.c:7:     for (int i = 0; riadok[i] != '\0' && prevRiadok[i] != '\0'; i++) {
	mov	DWORD PTR [rsp+124], 0	# i,
# main.c:7:     for (int i = 0; riadok[i] != '\0' && prevRiadok[i] != '\0'; i++) {
	jmp	.L3	#
.L6:
# main.c:8:       if (riadok[i] != prevRiadok[i]) {
	mov	eax, DWORD PTR [rsp+124]	# tmp108, i
	cdqe
	movzx	edx, BYTE PTR [rsp+64+rax]	# _1, riadok[i_8]
# main.c:8:       if (riadok[i] != prevRiadok[i]) {
	mov	eax, DWORD PTR [rsp+124]	# tmp110, i
	cdqe
	movzx	eax, BYTE PTR [rsp+rax]	# _2, prevRiadok[i_8]
# main.c:8:       if (riadok[i] != prevRiadok[i]) {
	cmp	dl, al	# _1, _2
	je	.L4	#,
# main.c:9:         printf("output:%s\n", riadok);
	lea	rax, [rsp+64]	# tmp111,
	mov	rsi, rax	#, tmp111
	mov	edi, OFFSET FLAT:.LC0	#,
	mov	eax, 0	#,
	call	printf	#
# main.c:10:         break;
	jmp	.L5	#
.L4:
# main.c:7:     for (int i = 0; riadok[i] != '\0' && prevRiadok[i] != '\0'; i++) {
	add	DWORD PTR [rsp+124], 1	# i,
.L3:
# main.c:7:     for (int i = 0; riadok[i] != '\0' && prevRiadok[i] != '\0'; i++) {
	mov	eax, DWORD PTR [rsp+124]	# tmp113, i
	cdqe
	movzx	eax, BYTE PTR [rsp+64+rax]	# _3, riadok[i_8]
# main.c:7:     for (int i = 0; riadok[i] != '\0' && prevRiadok[i] != '\0'; i++) {
	test	al, al	# _3
	je	.L5	#,
# main.c:7:     for (int i = 0; riadok[i] != '\0' && prevRiadok[i] != '\0'; i++) {
	mov	eax, DWORD PTR [rsp+124]	# tmp115, i
	cdqe
	movzx	eax, BYTE PTR [rsp+rax]	# _4, prevRiadok[i_8]
# main.c:7:     for (int i = 0; riadok[i] != '\0' && prevRiadok[i] != '\0'; i++) {
	test	al, al	# _4
	jne	.L6	#,
.L5:
# main.c:14:     for (i = 0; riadok[i] != '\0'; i++) {
	mov	DWORD PTR [rsp+120], 0	# i,
# main.c:14:     for (i = 0; riadok[i] != '\0'; i++) {
	jmp	.L7	#
.L8:
# main.c:15:       prevRiadok[i] = riadok[i];
	mov	eax, DWORD PTR [rsp+120]	# tmp117, i
	cdqe
	movzx	edx, BYTE PTR [rsp+64+rax]	# _5, riadok[i_9]
# main.c:15:       prevRiadok[i] = riadok[i];
	mov	eax, DWORD PTR [rsp+120]	# tmp119, i
	cdqe
	mov	BYTE PTR [rsp+rax], dl	# prevRiadok[i_9], _5
# main.c:14:     for (i = 0; riadok[i] != '\0'; i++) {
	add	DWORD PTR [rsp+120], 1	# i,
.L7:
# main.c:14:     for (i = 0; riadok[i] != '\0'; i++) {
	mov	eax, DWORD PTR [rsp+120]	# tmp121, i
	cdqe
	movzx	eax, BYTE PTR [rsp+64+rax]	# _6, riadok[i_9]
# main.c:14:     for (i = 0; riadok[i] != '\0'; i++) {
	test	al, al	# _6
	jne	.L8	#,
# main.c:17:     prevRiadok[i] = '\0';
	mov	eax, DWORD PTR [rsp+120]	# tmp123, i
	cdqe
	mov	BYTE PTR [rsp+rax], 0	# prevRiadok[i_9],
.L2:
# main.c:6:   while (scanf("%s", riadok) > 0) {
	lea	rax, [rsp+64]	# tmp124,
	mov	rsi, rax	#, tmp124
	mov	edi, OFFSET FLAT:.LC1	#,
	mov	eax, 0	#,
	call	__isoc99_scanf	#
# main.c:6:   while (scanf("%s", riadok) > 0) {
	test	eax, eax	# _7
	jg	.L9	#,
	mov	eax, 0	# _17,
# main.c:19: }
	add	rsp, 136	#,
	ret	
	.size	main, .-main
	.ident	"GCC: (GNU) 14.2.1 20250207"
	.section	.note.GNU-stack,"",@progbits
