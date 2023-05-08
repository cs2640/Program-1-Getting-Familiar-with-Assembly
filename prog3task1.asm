.data
scores: .word 32, 56, 78, 66, 88, 90, 93, 100, 101, 82 
f: .asciiz "F"
d: .asciiz "D"
c: .asciiz "C"
b: .asciiz "B"
a: .asciiz "A"
extra: .asciiz "A with Extra Credit"
newline: .asciiz "\n"
name: .asciiz "Brian Zeng"
thegrade: .asciiz "The grade for "
ees: .asciiz " is: "
.text
main:
  li $t0, 0
  la $t1, scores
loop:
  lw $t2, ($t1)
  addi $t1, $t1, 4 
  addi $t0, $t0, 1
  li $t3, 0
  bge $t2, 60, check_d
  la $t6, f
  j print_grade
check_d:
  bge $t2, 70, check_c
  la $t6, d
  j print_grade
check_c:
  bge $t2, 80, check_b
  la $t6, c
  j print_grade
check_b:
  bge $t2, 90, check_a
  la $t6, b
  j print_grade
check_a:
  bge $t2, 101, check_extra
  la $t6, a
  j print_grade
check_extra:
  la $t6, extra
print_grade:
  #print score
  li $v0, 4
  la $a0, thegrade
  syscall
  li $v0, 1 
  move $a0, $t2 
  syscall
  li $v0, 4 
  la $a0, ees
  syscall
  #print grade
  li $v0, 4 
  move $a0, $t6  
  syscall
  li $v0, 4
  la $a0, newline 
  syscall
  blt $t0, 10, loop
  #print name and exit
  la $a0, name
  li $v0, 4 
  syscall
  li $v0, 10 
  syscall
