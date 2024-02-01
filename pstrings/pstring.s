.extern printf
.extern scanf
.section .rodata
pstrlen_fmt:
    .string "first pstring length: %d, second pstring length: %d\n"
swapcase_ij_fmt:
    .string "length: %d, string: %s\n"
read_i_j_fmt:
    .string "%d %d"
invalid_input_fmt:
    .string "invalid input!\n"

.section .text
.globl pstrlen, swapCase,  pstrijcpy
pstrlen:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Restore a backup in memory of Addr of pstr
    subq $16, %rsp
    movq %rdi, (%rsp)

    # Move the byte(size of str) in to AL
    xorq %rax, %rax             # Cleanup RAX
    movb (%rdi), %al            # AL = length of pstr

    # Restore the addr of pstr - Calle saved
    movq (%rsp), %rdi           # Restore the value of addr pstr

    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp             # Return RSP to RBP
    popq %rbp                   # Return RBP to the old RBP to close the memory frame
    ret                         # Return the memory frame

swapCase:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Allocat
    subq $16, %rsp
    movq %rdi, (%rsp)

    # Increment str1, str2 to point on the first letter
    // incq %rsi
    // incq %rdx
    incq %rdi

    # Init counters
    xor %rax, %rax              # Set the RAX = counterLenStr1 = 0
    // xor %rbx, %rbx              # Set the RBX = counterLenStr2 = 0

# Loop throght str and switch uppper case to lower and lower to upper
.loop_case_str:
    cmpb $0, (%rdi)             # If char == '\0' than check str2
    je .cleanup_swapcase
    incq %rax                   # not the last char than increment counter length
    cmpb $65, (%rdi)            # compare if the char is not a letter, less than 'A'
    jl .cleanup_swapcase          # if less than 'A' jump to check str2
    cmpb $90, (%rdi)            # compare if char is in range 'A' - 'Z'
    jle .swapCase           # if a capital letter than jump to switch from upper case to lower case
    cmpb $97, (%rdi)            # compare if the char is not a letter, less than 'a' but greater than 'Z'
    jl .cleanup_swapcase          # if less than 'a' and greater than 'Z' jump to check str2
    cmpb $122, (%rdi)           # compare if char is in range 'a' - 'z'
    jle .swapCase           # if a lower case letter than jump to switch from lower case to upper case
    jmp .cleanup_swapcase         # jump to the next str
.swapCase:
    xorl $32, (%rdi)            # change case by using a mast and XORing with 32
    incq %rdi                   # point to the next byte(char) in str1
    jmp .loop_case_str

// .loop_case_str2:
//     cmpb $0, (%rdx)             # If char == '\0' than break the loop
//     je .print_case_res
//     incq %rbx                   # not the last char than increment counter length
//     cmpb $65, (%rdx)            # compare if the char is not a letter, less than 'A'
//     jl .print_case_res          # if less than 'A' jump to check str2
//     cmpb $90, (%rdx)            # compare if char is in range 'A' - 'Z'
//     jle .swapStr2Case           # if a capital letter than jump to switch from upper case to lower case
//     cmpb $97, (%rdx)            # compare if the char is not a letter, less than 'a' but greater than 'Z'
//     jl .print_case_res          # if less than 'a' and greater than 'Z' jump to check str2
//     cmpb $122, (%rdx)           # compare if char is in range 'a' - 'z'
//     jle .swapStr2Case           # if a lower case letter than jump to switch from lower case to upper case
//     jmp .print_case_res         # jump to the next str

// .swapStr2Case:
//     xorl $32, (%rdx)            # change case by using a mast and XORing with 32
//     incq %rdx                   # point to the next byte(char) in str1
//     jmp .loop_case_str2

.cleanup_swapcase:
    # Restore the addr of str1
    // movq 16(%rsp), %rdx         # RDX = adrr str1
    movq (%rsp), %rax         # RDX = adrr str1
    movq (%rsp), %rdi         # RDX = adrr str1

    // # Print the changed strings and there lengths
    // movq $swapcase_ij_fmt, %rdi    # RDI = string literal 
    // movq %rax, %rsi             # RSI = counter_str1
    // xorq %rax, %rax
    // call printf

    // # Restore the addr of str2
    // movq 24(%rsp), %rdx         # RDX = adrr str2

    // # Print the changed strings and there lengths
    // movq $swapcase_ij_fmt, %rdi # RDI = string literal 
    // movq %rbx, %rsi             # RSI = counter_str2
    // xorq %rax, %rax
    // call printf

    // # Restore the addr of str1 and str2 and choice
    // movq 8(%rsp), %rdi          # Restore the value of choise
    // movq 16(%rsp), %rsi         # Restore the value of addr str1
    // movq 24(%rsp), %rdx         # Restore the value of addr str2

    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp
    popq %rbp
    // xorq %rax, %rax
    ret

pstrijcpy:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Restore a backup in memory of Addr of pstr1 and pstr2
    subq $32, %rsp
    movq %rsi, 24(%rsp)
    movq %rdi, 16(%rsp)
    // movq %rdi, 8(%rsp)

    // # Read i and j from user
    // movq $read_i_j_fmt, %rdi
    // leaq 4(%rsp), %rsi
    // movq %rsp, %rdx
    // xorq %rax, %rax
    // call scanf

    // # Clean up r8 and r9 to hold i and j
    // xorq %r8, %r8
    // xorq %r9, %r9

    // # move i and j to register that need to hold adrd for the length function
    // movl 4(%rsp), %r8d          # R8 = i
    // movl (%rsp), %r9d           # R9 = j

    # Reset RAX(count_len_str1), RBX(count_len_str2) to 0
    xorq %rax, %rax             # RAX(countlenstr1) = 0
    xorq %rbx, %rbx             # RBX(countlenstr2) = 0

    # Restore the addr of str1 and str2 and choice
    // movq 16(%rsp), %rsi         # Restore the value of addr str1
    // movq 24(%rsp), %rdx         # Restore the value of addr str2

    # Move the byte(size of str1 and str2) in to AL, BL
    movb (%rdi), %al            # AL = length of str1
    movb (%rsi), %bl            # BL = length of str2

.check_i_j_valid:
    # Check that i and j are valid and in the range in order to continue
    cmp %cl, %dl                # Compare i and j
    jg .invalid_input           # if i > j jmp to invalid_input

    # Check the if i is valid
    cmp $0, %dl            
    jl .invalid_input           # if i < 0 jmp to invalid_input
    cmp %al, %dl
    jg .invalid_input           # if i > len(str1) jmp to invalid_input
    cmp %bl, %dl
    jg .invalid_input           # if i > len(str2) jmp to invalid_input

    # Check the if j is valid
    cmp $0, %cl            
    jl .invalid_input           # if j < 0 jmp to invalid_input
    cmp %al, %cl
    jg .invalid_input           # if j > len(str1) jmp to invalid_input
    cmp %bl, %cl
    jg .invalid_input           # if j > len(str2) jmp to invalid_input

    xorq %r14, %r14
    xorq %r15, %r15
    mov %al, %r14b            # R14 = len str1
    mov %bl, %r15b            # R15 = len str2

    # Reset RAX, RBX to 0
    xorq %rax, %rax             # RAX = counterLoopStr1

    // # Restore the addr of str1 and str2
    // movq 16(%rsp), %rsi         # Restore the value of addr str1
    // movq 24(%rsp), %rdx         # Restore the value of addr str2

    # Increment str1, str2 to point on the first letter
    incq %rdi       # str1
    incq %rsi       # str2
    xorq %r8, %r8

.prefix_loop:
    cmpb $0, (%rdi)             # If char == '\0' than check str2
    je .cleanup
    cmp %al, %dl              # if pointing on the i-th index jump to the copy lable to copy the string
    je .cpyIUntilJ              # jump to the copy part to copy from i to j
    incq %rax                   # if not equal - increment lenStr1
    incq %rdi                   # increment in order to read the next byte(char)
    jmp .prefix_loop            # continue reading the suffix

.cpyIUntilJ:
    cmp %cl, %al
    jg .print_cpy_str           # if i > j => means that read the whole part to copy jmp to print the results
    movb (%rsi), %r8b            # Load a byte(char) from RDX(str2) into the CL
    movb %r8b, (%rdi)            # Store the byte(char) in CL to the destination address RSI
    incq %rax                   # Increment couter loop of str1
    incq %rdi                   # increment in order to read the next byte(char) in str1
    incq %rsi                   # increment in order to read the next byte(char) in str2
    jmp .cpyIUntilJ

.invalid_input:
    # Print that the input was invalid and exit the program
    movq $invalid_input_fmt, %rdi 
    xorq %rax, %rax
    call printf
    jmp .cleanup

.print_cpy_str:
    # Restore the addr of str1
    movq 16(%rsp), %rdx         # Restore the value of addr str1

    # Print the destination copied string
    movq $swapcase_ij_fmt, %rdi 
    movq %r14, %rsi
    xorq %rax, %rax
    call printf

    movq 24(%rsp), %rdx         # Restore the value of addr str2
    # Print the source string
    movq $swapcase_ij_fmt, %rdi 
    movq %r15, %rsi
    xorq %rax, %rax
    call printf
    jmp .cleanup

.cleanup:
    # Restore the addr of str1 and str2 and choice
    // movq 8(%rsp), %rdi          # Restore the value of choise
    movq 16(%rsp), %rdi         # Restore the value of addr str1
    movq 24(%rsp), %rsi         # Restore the value of addr str2

    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp
    popq %rbp
    // xorq %rax, %rax
    ret
    