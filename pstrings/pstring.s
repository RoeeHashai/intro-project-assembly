.extern printf
.extern scanf
.section .rodata
pstrlen_fmt:
    .string "first pstring length: %d, second pstring length: %d\n"

swapcase_fmt:
    .string "length: %d, string: %s\n"
.section .text
.globl pstrlen, swapCase,  pstrijcpy
pstrlen:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Restore a backup in memory of Addr of pstr1 and pstr2
    subq $32, %rsp
    movq %rdx, 24(%rsp)
    movq %rsi, 16(%rsp)
    movq %rdi, 8(%rsp)

    # Increment str1, str2 to point on the first letter instead STX (Start of Text)
    incq %rsi
    incq %rdx

    # Init counters
    xor %rax, %rax          # Set the RAX = counterLenStr1 = 0
    xor %rbx, %rbx          # Set the RBX = counterLenStr2 = 0
    
# Calculate the len of str1 - loop until the \0 char
.loop_len_str1:
    cmpb $0, (%rsi)         # If char == '\0' than break
    je .loop_len_str2
    incq %rax               # not the last char than increment counter
    incq %rsi               # point to the next byte(char) in str1
    jmp .loop_len_str1


# Calculate the len of str2 - loop until the \0 char
.loop_len_str2:
    cmpb $0, (%rdx)         # If char == '\0' than break
    je .print_len_res       # break the loop and print the result of len str1 and str2
    incq %rbx               # not the last char than increment counter
    incq %rdx               # point to the next byte(char) in str1
    jmp .loop_len_str2

# Print the results of the calculations
.print_len_res:
    # Saved the leng of str1, str2 for later usage with bitwise operations
    xorq %r15, %r15          # clean up R15
    movq %rbx, %r15          # RCX = len of str2
    shlq $8, %r15            # shift 8 bits the lenstr2
    orq %rax, %r15           # bitwise OR to RAX, keep the len of str1 in the first byte
    # R15 = 00000000 00000000 lenstr2 lenstr1

    # Print the lengths
    movq $pstrlen_fmt, %rdi # RDI = string literal 
    movq %rax, %rsi         # RSI = counter_str1
    movq %rbx, %rdx         # RDX = counter_str2
    xorq %rax, %rax
    call printf

    # Restore the addr of str1 and str2 and choice
    movq 8(%rsp), %rdi      # Restore the value of choise
    movq 16(%rsp), %rsi     # Restore the value of addr str1
    movq 24(%rsp), %rdx     # Restore the value of addr str2

    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp
    popq %rbp
    movq %r15, %rax
    ret

swapCase:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Restore a backup in memory of Addr of pstr1 and pstr2
    subq $32, %rsp
    movq %rdx, 24(%rsp)
    movq %rsi, 16(%rsp)
    movq %rdi, 8(%rsp)

    # Increment str1, str2 to point on the first letter instead STX (Start of Text)
    incq %rsi
    incq %rdx

    # Init counters
    xor %rax, %rax              # Set the RAX = counterLenStr1 = 0
    xor %rbx, %rbx              # Set the RBX = counterLenStr2 = 0

# Loop throght str1 and switch uppper case to lower and lower to upper
.loop_case_str1:
    cmpb $0, (%rsi)             # If char == '\0' than check str2
    je .loop_case_str2
    incq %rax                   # not the last char than increment counter length
    cmpb $65, (%rsi)            # compare if the char is not a letter, less than 'A'
    jl .loop_case_str2          # if less than 'A' jump to check str2
    cmpb $90, (%rsi)            # compare if char is in range 'A' - 'Z'
    jle .swapStr1Case           # if a capital letter than jump to switch from upper case to lower case
    cmpb $97, (%rsi)            # compare if the char is not a letter, less than 'a' but greater than 'Z'
    jl .loop_case_str2          # if less than 'a' and greater than 'Z' jump to check str2
    cmpb $122, (%rsi)           # compare if char is in range 'a' - 'z'
    jle .swapStr1Case           # if a lower case letter than jump to switch from lower case to upper case
    jmp .loop_case_str2         # jump to the next str
.swapStr1Case:
    xorl $32, (%rsi)            # change case by using a mast and XORing with 32
    incq %rsi                   # point to the next byte(char) in str1
    jmp .loop_case_str1

.loop_case_str2:
    cmpb $0, (%rdx)             # If char == '\0' than break the loop
    je .print_case_res
    incq %rbx                   # not the last char than increment counter length
    cmpb $65, (%rdx)            # compare if the char is not a letter, less than 'A'
    jl .print_case_res          # if less than 'A' jump to check str2
    cmpb $90, (%rdx)            # compare if char is in range 'A' - 'Z'
    jle .swapStr2Case           # if a capital letter than jump to switch from upper case to lower case
    cmpb $97, (%rdx)            # compare if the char is not a letter, less than 'a' but greater than 'Z'
    jl .print_case_res          # if less than 'a' and greater than 'Z' jump to check str2
    cmpb $122, (%rdx)           # compare if char is in range 'a' - 'z'
    jle .swapStr2Case           # if a lower case letter than jump to switch from lower case to upper case
    jmp .print_case_res         # jump to the next str

.swapStr2Case:
    xorl $32, (%rdx)            # change case by using a mast and XORing with 32
    incq %rdx                   # point to the next byte(char) in str1
    jmp .loop_case_str2

.print_case_res:
    # Restore the addr of str1
    movq 16(%rsp), %rdx         # RDX = adrr str1

    # Print the changed strings and there lengths
    movq $swapcase_fmt, %rdi    # RDI = string literal 
    movq %rax, %rsi             # RSI = counter_str1
    xorq %rax, %rax
    call printf

    # Restore the addr of str2
    movq 24(%rsp), %rdx         # RDX = adrr str2

    # Print the changed strings and there lengths
    movq $swapcase_fmt, %rdi    # RDI = string literal 
    movq %rbx, %rsi             # RSI = counter_str2
    xorq %rax, %rax
    call printf

    # Restore the addr of str1 and str2 and choice
    movq 8(%rsp), %rdi          # Restore the value of choise
    movq 16(%rsp), %rsi         # Restore the value of addr str1
    movq 24(%rsp), %rdx         # Restore the value of addr str2

    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp
    popq %rbp
    xorq %rax, %rax
    ret

pstrijcpy:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp
    popq %rbp
    xorq %rax, %rax
    ret
    