.extern printf
.extern scanf
.extern pstrlen
.extern swapCase
.extern pstrijcpy

.section .rodata
invalid_option_fmt:
    .string "invalid option!\n"

.section .text
.globl run_func
run_func:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp
    cmp $31, %edi       # compare the cmd in EDI to 31
    je .cmd_31          # if equal jump to the cmd_31 label
    cmp $33, %edi       # compare the cmd in EDI to 33
    je .cmd_33          # if equal jump to the cmd_33 label
    cmp $34, %edi       # compare the cmd in EDI to 34
    je .cmd_34          # if equal jump to the cmd_34 label
    jmp .cmd_invalid

.cmd_31:
    call pstrlen
    jmp .cleanup
.cmd_33:
    call swapCase
    jmp .cleanup
.cmd_34:
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

