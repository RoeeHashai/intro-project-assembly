/* 209853282 Roee Hashai */
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
.globl pstrlen
.type pstrlen, @function

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

.globl swapCase
.type swapCase, @function
swapCase:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Allocate memory to save the addr of RDI(pstr)
    subq $16, %rsp              # Allocate memory on the stack for Addr of pstr
    movq %rdi, (%rsp)           # Move RDI(addr pstr) to the allocated memory

    incq %rdi                   # Increment RDI to point to the next byte(the addr of the start of the string in the pstr struct)

# Loop throght pstr and switch uppper case to lower and lower to upper
.loop_case_str:
    cmpb $0, (%rdi)             # If char == '\0' than exit loop
    je .cleanup_swapcase
    cmpb $65, (%rdi)            # compare if the char is not a letter, less than 'A'
    jl .next_char               # if less than 'A' jump to check next char
    cmpb $90, (%rdi)            # compare if char is in range 'A' - 'Z'
    jle .swapCase               # if a capital letter than jump to switch from upper case to lower case
    cmpb $97, (%rdi)            # compare if the char is not a letter, less than 'a' but greater than 'Z'
    jl .next_char        # if less than 'a' and greater than 'Z' jump to check str
    cmpb $122, (%rdi)           # compare if char is in range 'a' - 'z'
    jle .swapCase               # if a lower case letter than jump to switch from lower case to upper case
    jmp .cleanup_swapcase       # jump to the cleanup frame

.next_char:
    incq %rdi                   # Move to next char
    jmp .loop_case_str           # Contiue the loop

# In case that its a letter swap the case of the char
.swapCase:
    xorl $32, (%rdi)            # change case by using a mask and XORing with 32
    incq %rdi                   # point to the next byte(char) in pstr
    jmp .loop_case_str          # Go back to loop and cotinue changing the all of the letters case

.cleanup_swapcase:
    # Restore the addr of pstr
    movq (%rsp), %rax           # RAX = adrr pstr - return this value to the caller

    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp             # Return RSP to RBP
    popq %rbp                   # Return RBP to the old RBP to close the memory frame
    ret                         # Return the memory frame

.globl pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Restore a backup in memory of Addr of pstr1 and pstr2
    subq $32, %rsp
    movq %rsi, 24(%rsp)
    movq %rdi, 16(%rsp)

    # Cleanup RAX, and RBX
    xorq %rax, %rax             # RAX(lenstr1) = 0
    xorq %rbx, %rbx             # RBX(lenstr2) = 0

    # Move the byte(size of str1 and str2) in to AL, BL
    movb (%rdi), %al            # AL = length of str1
    movb (%rsi), %bl            # BL = length of str2

    # Sub -1 from the length to meet the indices
    subb $1, %al                # AL = len pstr1 - 1
    subb $1, %bl                # BL = len pstr2 - 1

# CL = j, DL = i
# Check if the i and j are valid
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

    # Add 1 to meet the lengths size
    addb $1, %al                # AL = len pstr1 + 1
    addb $1, %bl                # BL = len pstr2 + 1

    # Backup lenghts of pst1 and 2 to R14, R15
    xorq %r14, %r14             # Cleanup R14
    xorq %r15, %r15             # Cleanup R15
    mov %al, %r14b              # R14 = len str1
    mov %bl, %r15b              # R15 = len str2

    # Reset RAX, RBX to 0
    xorq %rax, %rax             # RAX = conter of the loop

    # Increment pstr1, pstr2 to point on the first letter
    incq %rdi                   # RDI = addr str1
    incq %rsi                   # RSI = addr str2
    xorq %r8, %r8               # Cleanup R8  

.prefix_loop:
    cmpb $0, (%rdi)             # if char == '\0' than jump to cleanup code to exit
    je .cleanup
    cmp %al, %dl                # if pointing on the i-th index jump to the copy lable to copy the string
    je .cpyIUntilJ              # jump to the copy part to copy from i to j
    incq %rax                   # if not equal - increment counter of loop
    incq %rdi                   # increment RDI(pstr1) in order to read the next byte(char)
    incq %rsi                   # increment RSI(pstr2) in order to read the next byte(char)
    jmp .prefix_loop            # continue reading the prefix

.cpyIUntilJ:
    cmp %cl, %al                # compare the counter of the loop to j - i than stop and exit
    jg .print_final_str         # if i > j => means that read the whole part to copy jmp to print the results
    movb (%rsi), %r8b           # Load a byte(char) from RSI(addr pstr2) into the R8B(temp)
    movb %r8b, (%rdi)           # Store the byte(char) in R8B to the destination address RDI
    incq %rax                   # Increment counter loop
    incq %rdi                   # increment RDI(pstr1) in order to read the next byte(char)
    incq %rsi                   # increment RSI(pstr2) in order to read the next byte(char)
    jmp .cpyIUntilJ

.invalid_input:
    # Backup lenghts of pst1 and 2 to R14, R15
    xorq %r14, %r14             # Cleanup R14
    xorq %r15, %r15             # Cleanup R15
    mov %al, %r14b              # R14 = len str1
    mov %bl, %r15b              # R15 = len str2
    addb $1, %r15b              # Retrive the length str2
    addb $1, %r14b              # Retrive the length str1
    # Print that the input was invalid and exit the program
    movq $invalid_input_fmt, %rdi   # Move invalid input format to RDI to print it
    xorq %rax, %rax             # Cleanup RAX
    call printf                 # Call printf
    jmp .print_final_str        # Go to print the output without changes

.print_final_str:
    # Restore the addr of str1
    movq 16(%rsp), %rdx         # Restore the value of addr pstr1 it need to be returned
    addq $1, %rdx               # Add one byte to the addr for the string startin addr

    # Print the destination copied string
    movq $swapcase_ij_fmt, %rdi # Move printing format to RDI to print it
    movq %r14, %rsi             # Move the len of pstr1 to RSI
    xorq %rax, %rax             # Cleanup RAX
    call printf                 # Call printf

    movq 24(%rsp), %rdx         # Restore the value of addr pstr2
    addq $1, %rdx               # Add one byte to the addr for the string startin addr

    # Print the source string
    movq $swapcase_ij_fmt, %rdi # Move printing format to RDI to print it
    movq %r15, %rsi             # Move the len of pstr2 to RSI
    xorq %rax, %rax             # Cleanup RAX
    call printf                 # Call printf
    jmp .cleanup                # Go to cleanup to exit frame correctly

.cleanup:
    # Restore the addr of pstr1 and pstr2 and choice back to rdi and rsi - calle saved
    movq 16(%rsp), %rdi         # Restore the value of addr str1
    movq 24(%rsp), %rsi         # Restore the value of addr str2

    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp             # Return RSP to RBP
    popq %rbp                   # Return RBP to the old RBP to close the memory frame
    ret                         # Return the memory frame
