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
    movq 8(%rsp), %rdi      # Restore the value of choice
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
    movq $swapcase_ij_fmt, %rdi    # RDI = string literal 
    movq %rax, %rsi             # RSI = counter_str1
    xorq %rax, %rax
    call printf

    # Restore the addr of str2
    movq 24(%rsp), %rdx         # RDX = adrr str2

    # Print the changed strings and there lengths
    movq $swapcase_ij_fmt, %rdi # RDI = string literal 
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

    # Restore a backup in memory of Addr of pstr1 and pstr2
    subq $32, %rsp
    movq %rdx, 24(%rsp)
    movq %rsi, 16(%rsp)
    movq %rdi, 8(%rsp)

    # Read i and j from user
    movq $read_i_j_fmt, %rdi
    leaq 4(%rsp), %rsi
    movq %rsp, %rdx
    xorq %rax, %rax
    call scanf

    xorq %r8, %r8
    xorq %r9, %r9
    # move i and j to register that need to hold adrr for the length function
    movl 4(%rsp), %r8d       # R8 = i
    movl (%rsp), %r9d        # R9 = j

    # Reset RAX(count_len_str2), RBX(count_len_str2) to 0
    xorq %rax, %rax              # RAX(countlenstr1) = 0
    xorq %rbx, %rbx               # RBX(countlenstr2) = 0

    # Restore the addr of str1 and str2 and choice
    movq 16(%rsp), %rsi         # Restore the value of addr str1
    movq 24(%rsp), %rdx         # Restore the value of addr str2

    # Increment str1, str2 to point on the first letter instead STX (Start of Text)
    incq %rsi
    incq %rdx

# Calc length of str1
.clac_len_str1_loop:
    cmpb $0, (%rsi)         # If char == '\0' than break
    je .clac_len_str2_loop
    incq %rax               # not the last char than increment counter
    incq %rsi               # point to the next byte(char) in str1
    jmp .clac_len_str1_loop
# Calc length of str2
.clac_len_str2_loop:
    cmpb $0, (%rdx)         # If char == '\0' than break
    je .check_i_j_valid
    incq %rbx               # not the last char than increment counter
    incq %rdx               # point to the next byte(char) in str2
    jmp .clac_len_str2_loop
    // # Restore the addr of str1 and str2 and choice
    // movq 16(%rsp), %rsi     # Restore the value of addr str1
    // movq 24(%rsp), %rdx     # Restore the value of addr str2
    // call pstrlen

    // # Move the lengths from the rax represented as 00000000 00000000 lenstr2 lenstr1 to RSI, RDX
    // xorq %rsi, %rsi         # Reset RSI to 0    
    // xorq %rdx, %rdx         # Reset RDX to 0
    // movb %al, %sil          # Move MSB byte to SIL ro store the len of str1
    // movw %ax, %dx           # Move 2 bytes to DX
    // shrq $8, %rdx           # Shift right RDX to store the len of str2
.check_i_j_valid:
    # Check that i and j are valid and in the range in order to contine
    cmp %r8, %r9          # Compare i and j
    jg .invalid_input       # if i > j jmp to invalid_input
    # Check the if i is valid
    cmp $0, %r8            
    jl .invalid_input       # if i < 0 jmp to invalid_input
    cmp %rax, %r8
    jg .invalid_input       # if i > len(str1) jmp to invalid_input
    cmp %rbx, %r8
    jg .invalid_input       # if i > len(str2) jmp to invalid_input

    # Check the if j is valid
    cmp $0, %r9            
    jl .invalid_input       # if j < 0 jmp to invalid_input
    cmp %rax, %r9
    jg .invalid_input       # if j > len(str1) jmp to invalid_input
    cmp %rbx, %r9
    jg .invalid_input       # if j > len(str2) jmp to invalid_input

    movq %rax, %r14         # R14 = len str1
    movq %rbx, %r15         # R15 = len str2

    # Reset RAX, RBX to 0
    xorq %rax, %rax         # RAX = counterLoopStr1
 //   xorq %rbx, %rbx         # RBX = counterLoopStr2

    # Restore the addr of str1 and str2
    movq 16(%rsp), %rsi     # Restore the value of addr str1
    movq 24(%rsp), %rdx     # Restore the value of addr str2

    # Increment str1, str2 to point on the first letter instead STX (Start of Text)
    incq %rsi
    incq %rdx

.prefix_loop:
    cmpb $0, (%rsi)         # If char == '\0' than check str2
    je .cleanup
    cmpq %rax, %r8          # if pointing on the i-th index jump to the copy lable to copy the string
    je .cpyIUntilJ          # jump to the copy part to copy from i to j
    incq %rax               # if not equal - increment lenStr1
    incq %rsi               # increment in order to read the next byte(char)
    jmp .prefix_loop        # continue reading the suffix

.cpyIUntilJ:
    cmp %rax, %r9
    jg .print_cpy_str       # if i > j => means that read the whole part to copy jmp to print the results
    movb (%rdx), %cl        # Load a byte(char) from RDX(str2) into the CL
    movb %cl, (%rsi)        # Store the byte(char) in CL to the destination address RSI
    incq %rax               # Increment couter loop of str1
    incq %rsi               # increment in order to read the next byte(char) in str1
    incq %rdx               # increment in order to read the next byte(char) in str2
 //   incq %rbx               # Increment couter loop of str2
    jmp .cpyIUntilJ

.invalid_input:
    # Print that the input was invalid and exit the program
    movq $invalid_input_fmt, %rdi # RDI = string literal 
    xorq %rax, %rax
    call printf
    jmp .cleanup

.print_cpy_str:
    # Restore the addr of str1
    movq 16(%rsp), %rdx     # Restore the value of addr str1

    # Print the destination copied string
    movq $swapcase_ij_fmt, %rdi # RDI = string literal 
    movq %r14, %rsi
    xorq %rax, %rax
    call printf

    movq 24(%rsp), %rdx     # Restore the value of addr str2
    # Print the source string
    movq $swapcase_ij_fmt, %rdi # RDI = string literal 
    movq %r15, %rsi
    xorq %rax, %rax
    call printf
    jmp .cleanup

.cleanup:
    # Restore the addr of str1 and str2 and choice
    movq 8(%rsp), %rdi          # Restore the value of choise
    movq 16(%rsp), %rsi         # Restore the value of addr str1
    movq 24(%rsp), %rdx         # Restore the value of addr str2

    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp
    popq %rbp
    xorq %rax, %rax
    ret
    