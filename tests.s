# Dummy code to demonstrate modulo function

.data
dividend:    .quad 42       # Dummy dividend (replace with your value)
divisor:     .quad 10       # Dummy divisor (replace with your value)

.text
.globl main
.type main, @function

main:
    movq dividend(%rip), %rax  # Load the dummy dividend into %rax
    cqto                         # Sign-extend %rax into %rdx
    movq divisor(%rip), %rdi   # Load the dummy divisor into %rdi
    idivq %rdi                  # Divide %rdx:%rax by the divisor (%rdi)

    # Result:
    # %rax contains the quotient (result of division)
    # %rdx contains the remainder

    # Dummy print for demonstration
    movq %rax, %rdi             # Move the quotient to %rdi for printf
    movq $format, %rax          # Load the format string
    call printf                 # Call printf

    # Exit program
    xorq %rax, %rax
    ret

section .data
format: .string "Result: %ld\n"
