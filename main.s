.extern printf
.extern scanf
.extern srand
.extern rand
.extern time

.section .data
    seed:
        .space 4   # Allocate 4 bytes for the integer

.section .rodata
user_configSeed_fmt:
    .string "Enter configuration seed: "
scanf_fmt:
    .string "%d"
user_guess_fmt:
    .string "What is your guess? "
result_fmt:
    .string "%d.\n"
win_msg:
    .string "Congratz! You won!\n"
gameover_msg:
    .string "Game over, you lost :(. The Correct answer was "

.section .text
.globl main
.type	main, @function

main:
    # Function prologue - create a stack frame
    pushq %rbp          
    movq %rsp, %rbp

    # Print the prompt
    movq $user_configSeed_fmt, %rdi  # Load the format string for printf
    xorq %rax, %rax                  # Clear the RAX register
    call printf                      # Call the printf function with the provided format string

    # Read the seed input
    movq $scanf_fmt, %rdi
    movq $seed, %rsi
    xorq %rax, %rax
    call scanf

    # Set the seeds for srand
    movq [seed], %rdi
    call srand

    subq $16, %rsp
    call rand
    movq %rax, (%rsp)

    # Perform modulo 10
    movq $10, %rdi      # Divisor
    movq (%rsp), %rax   # Load the integer from the top of the stack
    xorq %rdx, %rdx     # Clear the high part of the dividend
    idiv %rdi           # Divide rdx:rax by the divisor
    movq %rdx, (%rsp)   # Store the remainder back on the stack

    # Initialize loop counter
    movb $0, %bl  # Counter register
    subq $16, %rsp

.loop:
    # Print the prompt for guess
    movq $user_guess_fmt, %rdi
    xorq %rax, %rax
    call printf

    movq $scanf_fmt, %rdi
    movq %rsp, %rsi  # Load the address of the allocated space into rsi
    xorq %rax, %rax
    call scanf

    # Load values from memory into registers
    movq (%rsp), %rax       # Load value at the top of the stack into %rax
    movq 16(%rsp), %rsi     # Load value at offset 16 from the stack into %rbx

    # Compare the values in registers
    cmpq %rax, %rsi         # Compare %rbx with %rax
    je .correct_guess

    # Increment loop counter
    incb %bl

    # Check if loop need to stop
    cmpb $5, %bl
    jl .loop
    jmp .game_over

.correct_guess:
    # Print the prompt
    movq $win_msg, %rdi
    xorq %rax, %rax
    call printf
    jmp .done

.game_over:
    # Print the prompt
    movq $gameover_msg, %rdi
    xorq %rax, %rax
    call printf
    # Print the prompt
    movq $result_fmt, %rdi
    movq 16(%rsp), %rsi
    xorq %rax, %rax
    call printf

.done:
    # Function epilogue - cleanup stack and exit
    movq %rbp, %rsp
    popq %rbp
    xorq %rax, %rax
    ret
