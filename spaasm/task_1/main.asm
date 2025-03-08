section   .data
filename  db 'example.txt', 0; The name of the file to open
;filename db 'double.txt', 0; The name of the file to open
;filename db 'single.txt', 0; The name of the file to open
message   db 'closing', 10
fmt       db "%d", 10, 0; Format string "%d\n" to include newline
newline   db 10

section .bss
buffer  resb 512; Reserve space for buffer . This var will be the first one to hold the file input
current_buffer resb 512;this variable will be loading chars till newline or 0
prev_buffer resb 512;for storing prev string
num_buffer resb 20 ; used for debugging

section .text
global  main; Entry point for the program
extern  printf

main:
	;   Open the file (sys_open)
	mov rax, 2; sys_open
	mov rdi, filename; Pointer to the file name
	mov rsi, 0; Flags readonly
	mov rdx, 0
	syscall

	test rax, rax; ensure file has been opened
	js   exit; If no then exit

	mov rdi, rax; Store file descriptor in rdi
	mov r12, 0; Initialize buffer index
	mov r14, 0; Index in current_buffer
	mov r15, 0; Index in prev_buffer

load_file:
	;   Read into buffer
	mov rax, 0; sysread
	mov rsi, buffer; Pointer to the buffer
	mov rdx, 512; Number of bytes to read (buffer size)
	syscall

	test rax, rax; Check if EOF (0 bytes read) or error (-1)
	jle  close_file; If 0 or negative, close and exit

	mov r13, rax; Store number of bytes read
	jmp read_file_by_char

read_file_by_char:
	cmp byte [buffer +r12], 10
	je  cmp_strings

	cmp r12, r13
	jge close_file; If index >= bytes read, close the file

	;debug   part
	;lea     rsi, [buffer + r12]; Load address of buffer[r12]
	;mov     rax, 1; sys_write syscall
	;mov     rdi, 1; File descriptor (stdout)
	;mov     rdx, 1; Print 1 byte
	;syscall ; Make the system call

	;      Append the current character to the currentbuffer
	lea    rdi, [current_buffer + r14]; Address of current_buffer[r14]
	mov    al, [buffer + r12]; Load the character from the input buffer
	mov    [rdi], al; Store the character in the current buffer
	inc    r12; Move to the next character
	inc    r14; Increment the output buffer index
	;debug part
	;mov   rax, r12; debug thing for printing the position of pointer
	;call  print_number; meow
	jmp    read_file_by_char

cmp_strings:
	inc r12; Move to the next buffer character
	cmp r14, r15; Compare lengths of current and previous buffers
	jne prepare_copy; If lengths are different, copy the new string

	lea rdi, [prev_buffer + r15 + 1]
	mov byte [rdi], 0; Append null terminator to prev_buffer

	;    Use rep cmpsb to compare strings efficiently
	mov  rsi, current_buffer; Load address of current_buffer
	mov  rdi, prev_buffer; Load address of prev_buffer
	mov  rcx, r14; Set number of bytes to compare (length of current_buffer)
	cld  ; Clear direction flag for forward comparison
	repe cmpsb; Compare bytes while equal

	jnz prepare_copy; If a mismatch is found, copy the string
	mov r14, 0; Reset index in current_buffer
	jmp read_file_by_char; Continue reading the file

strings_equal:
	mov r14, 0; reset r14 pointer
	je  read_file_by_char

prepare_copy:
	mov rdi, prev_buffer; Destination buffer (prev_buffer)
	mov rsi, current_buffer; Source buffer (current_buffer)
	mov rcx, r14; Number of bytes to copy (length of current_buffer)
	mov r15, r14; Save length for later use
	cld ; Ensure forward copying
	rep movsb; Copy RCX bytes from [RSI] to [RDI]

	;   After copy, reset current_buffer
	mov rdi, current_buffer; Destination (current_buffer)
	mov rcx, 512; Size of buffer
	xor rax, rax; Set AL to 0
	rep stosb; Fill buffer with 0s

	mov r14, 0; Reset index in current_buffer

	;   Print the prev_buffer
	jmp print_message

print_message:
	;mov byte [prev_buffer+r15], 10
	mov  rax, 1; system call for write
	mov  rdi, 1; file handle 1 is stdout
	mov  rsi, prev_buffer; address of string to output
	mov  rdx, r15; number of bytes
	syscall
	mov  rax, 1; system call for write
	mov  rdi, 1; file handle 1 is stdout
	mov  rsi, newline; address of string to output
	mov  rdx, 1; number of bytes
	syscall
	mov  r14, 0
	jmp  read_file_by_char

close_file:
	;debug
	;mov    rax, 1; system call for write
	;mov    rdi, 1; file handle 1 is stdout
	;mov    rsi, message; address of string to output
	;mov    rdx, 8; number of bytes
	;syscall
	;       Close the file (sys_close)
	mov     rax, 3; sys_close system call number (3)
	mov     rdi, rdi; File descriptor (stored in rdi)
	syscall ; Make the system call

exit:
	mov rax, 60; System call for exit
	xor rdi, rdi; Exit code 0
	syscall

print_number:
	;   debug functions
	sub rsp, 8; Align stack (System V ABI requires 16-byte alignment)

	mov  rdi, fmt; 1st argument: format string
	mov  rsi, rax; 2nd argument: integer to print
	xor  rax, rax; Clear rax (printf uses it for float handling)
	call printf; Call printf

	add rsp, 8; Restore stack alignment
	ret
