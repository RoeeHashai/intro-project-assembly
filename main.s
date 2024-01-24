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
    .string "%d\n"

.section .text
.globl main
.type	main, @function

main:
    # Starting stack frame
    pushq %rbp
    movq %rsp, %rbp

    # Print the prompt
    movq $user_configSeed_fmt, %rdi
    xorq %rax, %rax
    call printf

    # Read the seed input
    movq $scanf_fmt, %rdi
    movq $seed, %rsi
    xorq %rax, %rax
    call scanf

    # Set the seeds for srand
    movq $seed, %rdi
    call srand

    # Initialize loop counter
    movb $0, %bl  # Counter register
    // # Debugging output
    // movzb %bl, %rsi
    // movq $result_fmt, %rdi
    // xorq %rax, %rax
    // call printf
    # Allocate space for the local variable (4 bytes assuming 32-bit integer)
    subq $16, %rsp

.loop:
    # Print the prompt for guess
    movq $user_guess_fmt, %rdi
    xorq %rax, %rax
    call printf
    // # Debugging output
    // movq %rcx, %rsi
    // movq $result_fmt, %rdi
    // xorq %rax, %rax
    // call printf
    # Read the guess input
    movq $scanf_fmt, %rdi
    movq %rsp, %rsi  # Load the address of the allocated space into rsi
    xorq %rax, %rax
    call scanf

    # Increment loop counter
    incb %bl

    // # Debugging output
    // movb %bl, %sil
    // movq $result_fmt, %rdi
    // xorq %rax, %rax
    // call printf
    
    # Check if loop need to stop
    cmpb $5, %bl
    jl .loop

.done:
    # Restore stack pointer
    movq %rbp, %rsp

    # Exit program
    xorq %rax, %rax
    popq %rbp
    ret
