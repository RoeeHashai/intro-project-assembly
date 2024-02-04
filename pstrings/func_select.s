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
    movq %rdx, 24(%rsp)     # RDX = addr of pstr2
    movq %rsi, 16(%rsp)     # RSI = addr of pstr1
    movq %rdi, 8(%rsp)      # RDI = addr of choice

    cmp $31, %edi           # compare the cmd in EDI to 31
    je .cmd_31              # if equal jump to the cmd_31 label
    cmp $33, %edi           # compare the cmd in EDI to 33
    je .cmd_33              # if equal jump to the cmd_33 label
    cmp $34, %edi           # compare the cmd in EDI to 34
    je .cmd_34              # if equal jump to the cmd_34 label
    jmp .cmd_invalid        # if the command is invalid jump to the invalid label

.cmd_31:
    movq %rsi, %rdi         # Move RSI(addr of pstr1) to RDI
    call pstrlen            # Call the pstrlen
    movb %al, %r8b          # Move the length of pstr1 to R8B

    movq %rdx, %rdi         # Move RSI(addr of pstr2) to RDI
    call pstrlen            # Call the pstlen 
    movb %al, %r9b          # Move the length of pstr2 to R9B

    # Print the lengths
    movq $pstrlen_fmt, %rdi # RDI = string literal 
    xorq %rsi, %rsi         # Clean up RSI
    xorq %rdx, %rdx         # Clean up RDX
    movb %r8b, %sil         # move length of the pst1 to SIL
    movb %r9b, %dl          # move length of the pst2 to DL
    xorq %rax, %rax         # Clean up RAX     
    call printf             # Clean up printf
    jmp .cleanup            # Jump to cleanup

.cmd_33:
    movq %rsi, %rdi         # Move RSI(addr of pstr1) to RDI
    call pstrlen            # Call pstrlen for pstr1
    xorq %r8, %r8           # Clean up R8
    movb %al, %r8b          # Move the res of pstlen to R8B
    movq 16(%rsp), %rdi     # Move the addr of pstlen1 to RDI
    call swapCase           # Call swapCase
    movq $swapcase_ij_fmt, %rdi # Move the printing format to RDI
    xorq %rsi, %rsi         # Cleanup RSI
    movb %r8b, %sil         # Move the len of pstlen1 to SIL
    movq %rax, %rdx         # Move the addr return from rax(pst1 after swapping cases) to RDX
    call printf             # Call printf

    movq 24(%rsp), %rdi     # Move from memory addr of pstr2 to RDI
    call pstrlen            # Call pstrlen for pstr2
    xorq %r8, %r8           # Clean up R8
    movb %al, %r8b          # Move the res of pstlen to R8B
    movq 24(%rsp), %rdi     # Move from memory addr of pstr2 to RDI
    call swapCase           # Call swapCase
    movq $swapcase_ij_fmt, %rdi # RDI = string literal
    xorq %rsi, %rsi         # Cleanup RSI    
    movb %r8b, %sil         # Move the len of pstlen2 to SIL
    movq %rax, %rdx         # Move the addr return from rax(pst2 after swapping cases) to RDX
    call printf             # Call printf
    jmp .cleanup            # goto cleanup code exit the function

.cmd_34:
    # Read i and j from user
    movq $read_i_j_fmt, %rdi
    leaq 4(%rsp), %rsi      # Load the addr of rsp+4 (i) to RSI
    movq %rsp, %rdx         # Move RSP to RDX the addr of j
    xorq %rax, %rax         # Cleanup RAX
    call scanf              # Call scanf to read i and j

    # Clean up to hold i and j
    xorq %rdx, %rdx         # Cleanup RDX
    xorq %rcx, %rcx         # Cleanup RCX

    # Prepare the the arguments for the pstijcpy
    movb 4(%rsp), %dl       # EDX  = i
    movb (%rsp), %cl        # ECX = j
    movq 16(%rsp), %rdi     # RDI = addr of pstr1
    movq 24(%rsp), %rsi     # RSI = addr of pstr2
    call pstrijcpy          # Call pstrijcpy

    jmp .cleanup            # Cleanup the code exit the function

.cmd_invalid:
    # Print that input was invalid
    movq $invalid_option_fmt, %rdi  # Move the invalid option fmt to RDI
    xorq %rax, %rax         # Cleanup RAX
    call printf             # Call printf
    jmp .cleanup            # Jump to cleanup the code and exit the function

.cleanup:
    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp         # Move RSP to RBP
    popq %rbp               # Pop the old addr of RBP back to RBP
    xorq %rax, %rax         # Cleanup RAX
    ret                     # return

