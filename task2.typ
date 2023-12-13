#import "@preview/polylux:0.3.1": *
#import "unipd.typ": *

#new-section[ Task 2 ]
#slide[
  - Store the strings in the code section rather than building on the stack;

  - Explain what the following code does;

  - Use this technique to build some code that executes:

    #align(center, `/usr/bin/env`)

    passing the following environment variables:

    #align(center, ```
      a=11
      b=22
    ```)
]

#new-section[ Task 2: Solution ]

#slide[
  #text(size: 18pt, ```asm
  jmp short two
one:
  pop ebx ; [1] pop the return address that call just pushed, it will
          ;     point to the db instruction, that is the string data
  xor eax, eax
  mov [ebx+7], al ; write "\0" in place of the * in the string data
  mov [ebx+8], ebx ; write the pointer to "/bin/sh" in place of "AAAA"
  mov [ebx+12], eax ; write 0 in place of "BBBB"
  lea ecx, [ebx+8] ; let ecx = ebx + 8, that is the address of argv[]
  xor edx, edx 
  mov al, 0x0b
  int 0x80 ; Invoke execve()
two:
  call one
  db '/bin/sh*AAAABBBB' ; [2] Put the literal string as bytes in the code
  ```)
]

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
    mov [ebx+24], ebx   ; argv[0] points "/usr/bin/env" 
    mov [ebx+28], eax   ; argv[1] = 0
    lea ecx, [ebx+24]
  ```
  #let right = ```asm
    ; Setup env
    mov [ebx+40], eax   ; env[2] = 0
    lea eax, [ebx+13]
    mov [ebx+32], eax   ; env[0] points "a=11"
    lea eax, [ebx+18]
    mov [ebx+36], eax   ; env[1] points "b=22"
    lea edx, [ebx+32]
    xor eax, eax
    mov al,  0x0b
    int 0x80
  ```

  #grid(columns: (1fr, 1fr), column-gutter: 1em, left, right)
  #v(10%)

  ```asm
  two:
    call one
    db '/usr/bin/env*a=11*b=22* AAAABBBBCCCCDDDDEEEE'
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
