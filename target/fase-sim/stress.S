.option norvc
.section .text
.globl _start
_start:
  li t0, 0x80040000
  li t1, 1234567
  li t2, 13
1:
  div s5, t1, t2
  sd s5, 0(t0)
  ld s6, 0(t0)
  addi t0, t0, 64
  fdiv.d f4, f0, f1
  addi s4, s4, 1
  j 1b
