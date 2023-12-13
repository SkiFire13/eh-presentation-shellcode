#import "@preview/polylux:0.3.1": *
#import "unipd.typ": *

#new-section[ Task 2 ]
#slide[
  TODO: Task
]

#new-section[ Task 2: Solution ]

#slide[
  #set text(size: 16pt)
  #let left = ```asm
    jmp short two
  one:
    pop ebx
    xor eax, eax
    mov [ebx+12], al
    mov [ebx+17], al
    mov [ebx+22], al
    ; Setup argv
    mov [ebx+26], ebx   ; argv[0] points "/usr/bin/env" 
    mov [ebx+30], eax   ; argv[1] = 0
    lea ecx, [ebx+26]
  ```
  #let right = ```asm
    ; Setup env
    mov [ebx+42], eax   ; env[2] = 0
    lea eax, [ebx+13]
    mov [ebx+34], eax   ; env[0] points "a=11"
    lea eax, [ebx+18]
    mov [ebx+38], eax   ; env[1] points "b=22"
    lea edx, [ebx+34]
    xor eax, eax
    mov al,  0x0b
    int 0x80
    jmp short end
  ```

  #grid(columns: (1fr, 1fr), column-gutter: 1em, left, right)
  #v(10%)

  ```asm
  two:
    call one
    db '/usr/bin/env*a=11*b=22*   AAAABBBBCCCCDDDDEEEE'
  end:
  ```
]

// TODO: Show stack?

#slide[
  #align(center, v(-10%) + scale(x: 90%, y: 90%, image("exe2.png")))
]

#slide[
  #place(center + horizon, v(18%) + scale(x: 85%, y: 85%, image("obj2_p1.png")))
]
#slide[
  #place(center + horizon, v(20%) + scale(x: 85%, y: 85%, image("obj2_p2.png")))
]
