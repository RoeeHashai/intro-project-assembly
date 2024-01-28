.extern printf
.extern scanf
.extern pstrlen
.extern swapCase
.extern pstrijcpy

.section .rodata
pstrlen_fmt:
    .string "first pstring length: %d, second pstring length: %d\n"
swapcase_ij_fmt:
    .string "length: %d, string: %s\n"
invalid_option_fmt:
    .string "invalid option!\n"
read_i_j_fmt:
    .string "%d %d"

.section .text
.globl run_func
run_func:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp
    # Restore the command, addr pstr1 and addr pstr2 in memory
    subq $32, %rsp
    movq %rdx, 24(%rsp) # RDX = addr of pstr2
    movq %rsi, 16(%rsp) # RSI = addr of pstr1
    movq %rdi, 8(%rsp)  # RDI = addr of choice

    cmp $31, %edi       # compare the cmd in EDI to 31
    je .cmd_31          # if equal jump to the cmd_31 label
    cmp $33, %edi       # compare the cmd in EDI to 33
    je .cmd_33          # if equal jump to the cmd_33 label
    cmp $34, %edi       # compare the cmd in EDI to 34
    je .cmd_34          # if equal jump to the cmd_34 label
    jmp .cmd_invalid

.cmd_31:
    movq %rsi, %rdi
    call pstrlen
    movb %al, %r8b
    # Print the lengths
    // movq $pstrlen_fmt, %rdi # RDI = string literal 
    // xorq %rax, %rax
    // call printf
    movq %rdx, %rdi
    call pstrlen
    movb %al, %r9b
    # Print the lengths
    movq $pstrlen_fmt, %rdi # RDI = string literal 
    xorq %rsi, %rsi
    xorq %rdx, %rdx
    movb %r8b, %sil
    movb %r9b, %dl
    xorq %rax, %rax
    call printf
    jmp .cleanup


.cmd_33:
    movq %rsi, %rdi
    call pstrlen
    xorq %r8, %r8
    movb %al, %r8b
    movq 16(%rsp), %rdi
    call swapCase
    movq $swapcase_ij_fmt, %rdi # RDI = string literal
    xorq %rsi, %rsi
    movb %r8b, %sil
    movq %rax, %rdx
    call printf

    movq 24(%rsp), %rdi
    call pstrlen
    xorq %r8, %r8
    movb %al, %r8b
    movq 24(%rsp), %rdi
    call swapCase
    movq $swapcase_ij_fmt, %rdi # RDI = string literal
    xorq %rsi, %rsi
    movb %r8b, %sil
    movq %rax, %rdx
    call printf
    jmp .cleanup

.cmd_34:
    # Read i and j from user
    movq $read_i_j_fmt, %rdi
    leaq 4(%rsp), %rsi
    movq %rsp, %rdx
    xorq %rax, %rax
    call scanf

    # Clean up to hold i and j
    xorq %rdx, %rdx
    xorq %rcx, %rcx

    # move i and j to register that need to hold adrd for the length function
    movl 4(%rsp), %edx          #  = i
    movl (%rsp), %ecx           #  = j
    movq 16(%rsp), %rdi
    movq 24(%rsp), %rsi
    call pstrijcpy

    jmp .cleanup



.cmd_invalid:
    # Print that input was invalid
    movq $invalid_option_fmt, %rdi
    xorq %rax, %rax
    call printf
    jmp .cleanup
.cleanup:
    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp
    popq %rbp
    xorq %rax, %rax
    ret

