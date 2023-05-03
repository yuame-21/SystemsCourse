#
# Usage: ./calculator <op> <arg1> <arg2>
#

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

# int main(int argc, char argv[][])
main:
  # Function prologue
  enter $0, $0

  # Variable mappings:
  # op -> %r12
  # arg1 -> %r13
  # arg2 -> %r14
  movq 8(%rsi), %r12  # op = argv[1]
  movq 16(%rsi), %r13 # arg1 = argv[2]
  movq 24(%rsi), %r14 # arg2 = argv[3]


  # Convert 1st operand to long int
  movq %r13, %rdi
  callq atol
  movq %rax, %r13
  
  # Convert 2nd operand to long int
  movq %r14, %rdi
  callq atol
  movq %rax, %r14

  # Copy the first char of op into an 8-bit register
  movb 0(%r12), %al
  
  # compare entered operation
  cmpb $'+, %al
  je add

  cmpb $'-, %al
  je sub

  cmpb $'*, %al
  je mult

  cmpb $'/, %al
  je div

  jmp error

  # functions
  add: addq %r14, %r13
       movq %r13, %rsi
       jmp print_out

  sub: subq %r14, %r13
       movq %r13, %rsi
       jmp print_out
  
  mult: imulq %r13, %r14
        movq %r14, %rsi
        jmp print_out

  div: cmp $0, %r14 # makes sure division is valid
       je div_error 
  
       movq %r13, %rax # division
       cqo # extends the sign
       idiv %r14
       movq %rax, %rsi
       jmp print_out
   
  error: mov $0, %al
         mov $message, %rdi
         call printf 
         jmp exit
  
  div_error: mov $0, %al
             mov $div_message, %rdi
             call printf
	     jmp exit
  
  print_out: mov $0, %al
             mov $format, %rdi
             call printf
             jmp exit

  # Function epiloge
  exit:
   leave
   ret


# Start of the data section
.data

format: 
  .asciz "%ld\n"
 
div_message: 
  .asciz "Cannot divide by zero \n"

message:
 	.asciz "Unknown operation \n "
