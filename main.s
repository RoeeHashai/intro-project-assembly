.extern printf
.extern scanf
.extern srand
.extern rand
.extern time

.section .data
    seed:
        .space 4   # Allocate 4 bytes in the data section for the seed

.section .rodata
user_configSeed_fmt:
    .string "Enter configuration seed: "
scanf_fmt:
    .string "%d"
user_guess_fmt:
    .string "What is your guess? "
result_fmt:
    .string "%d\n"
win_msg:
    .string "Congratz! You won!\n"
gameover_msg:
    .string "Game over, you lost :(. The correct answer was "
incorrectString:
    .string "Incorrect.\n"

.section .text
.globl main
.type	main, @function

main:
    # Function prologue - create a new stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Print the prompt
    movq $user_configSeed_fmt, %rdi     # Load the format string for printf
    xorq %rax, %rax                     # Clear the RAX register
    call printf                         # Call the printf function with the provided format string

    # Read the seed input
    movq $scanf_fmt, %rdi               # Move the format addr to RDI         
    movq $seed, %rsi                    # Move the seed addr addr to RDI 
    xorq %rax, %rax                     # Clean RAX
    call scanf

    # Set the seeds for srand
    movq [seed], %rdi                   # Move the value of seed to rdi prepare for the srand function
    call srand

    subq $16, %rsp                      # Allocate memory for the value guess value to the 
    call rand                           # Call rand
    movq %rax, (%rsp)                   # Move the random number to the stack

    # Perform modulo 10
    movq $10, %rdi                      # Divisor
    movq (%rsp), %rax                   # Load the integer from the top of the stack
    xorq %rdx, %rdx                     # Clear the high part of the dividend
    idiv %rdi                           # Divide rdx:rax by the divisor
    movq %rdx, (%rsp)                   # Store the remainder back on the stack

    # Initialize loop counter
    movb $0, %bl                        # BL = counter of loop
    subq $16, %rsp                      # Allocate memory for the users guess

.loop:
    # Print the prompt for guess
    movq $user_guess_fmt, %rdi          # Move the user guess format to RDI
    xorq %rax, %rax                     # Cleanup RAX
    call printf                         # Call printf

    # Read the next guess from the user
    movq $scanf_fmt, %rdi               # Move the scanf format to RDI       
    movq %rsp, %rsi                     # Load the address of the allocated space into RSI
    xorq %rax, %rax                     # Cleanup RAX
    call scanf                          # Call scanf

    # Load values from memory into registers
    movq (%rsp), %rcx                   # Load value at the top of the stack into %rcx
    movq 16(%rsp), %rsi                 # Load value at offset 16 from the stack into %rbx

    # Compare the values in registers
    cmpq %rcx, %rsi                     # Compare %rsi with %rcx
    je .correct_guess                   # Jump to corrcet guess if the user guess correct

    # Print the incorrect message
    movq $incorrectString, %rdi         # Move the incorrect format to RDI
    xorq %rax, %rax                     # Cleanup RAX
    call printf                         # Call printf

    # Increment loop counter
    incb %bl                            # BL = counter of the loop for maximun gusses

    # Check if loop need to stop
    cmpb $5, %bl                        # Check if the counter is 5 to stop
    jl .loop                            # If not at 5 continue with the loop
    jmp .game_over                      # If didn't guess correct and out of guesses

.correct_guess:
    # Print the prompt
    movq $win_msg, %rdi                 # Move the win-msg format to RDI
    xorq %rax, %rax                     # Clean up RAX
    call printf                         # Call printf
    jmp .done                           # jump to cleanup code

.game_over:
    # Print the prompt
    movq $gameover_msg, %rdi            # Move the game over msg format to RDI
    xorq %rax, %rax                     # Clean up RAX
    call printf                         # Call printf

    # Print the prompt
    movq $result_fmt, %rdi              # Move to result format to RDI
    movq 16(%rsp), %rsi                 # Move the value of the real guess from memory to rsi in order to print it to user
    xorq %rax, %rax                     # Clean up RAX
    call printf                         # Call printf

.done:
    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp                     # Move the RSP to the bottom of the stack
    popq %rbp                           # Restore the old bottom stack addr back to RBP
    xorq %rax, %rax                     # Clean up RAX
    ret                                 # Exit the function
