#import "@preview/polylux:0.3.1": *
#import "unipd.typ": *

#new-section[ Task 1.d ]
#slide[
  TODO: Task
]

#new-section[ Task 1.d: Solution ]
#slide[
  #let left = ```asm
    ; Setup command
    xor  eax, eax
    push eax
    push "/env"
    push "/bin"
    push "/usr"
    mov  ebx, esp
    
    ; Construct the argument array argv[]
    xor  eax, eax
    push eax          ; argv[1] = 0
    push ebx          ; argv[0] points "/usr/bin/env"
    mov  ecx, esp
    
    ; Setup environment strings
    xor eax, eax
    push eax
    push "1234"
    push "aaa="       ; "aaa=1234"
    push eax
    push "5678"
    push "bbb="       ; "bbb=5678"
    ```
  #let right = ```asm
    mov  eax, "###4"
    shr  eax, 24
    push eax
    push "=123"
    push "cccc"       ; "cccc=1234"
    mov  edx, esp
    
    ; Construct the environment array
    xor  eax, eax
    push eax          ; env[3] = 0
    push edx          ; env[2] points "cccc=1234"
    lea  eax, [edx + 12]
    push eax          ; env[1] points "bbb=5678"
    lea  eax, [edx + 24]
    push eax          ; env[0] points "aaa=1234"
    mov  edx, esp      

    ; Invoke execve()
    xor  eax, eax     ; eax = 0x00000000
    mov   al, 0x0b    ; eax = 0x0000000b
    int 0x80
  ```
  
  #text(size: 16pt, grid(columns: (1fr, 1.3fr), column-gutter: 1em, left, right))
]

// TODO: Show stack?

#slide[
  #align(center, v(-10%) + scale(x: 90%, y: 90%, image("exe1d.png")))
]

#slide[
  #place(center + horizon, v(20%) + scale(x: 85%, y: 85%, image("obj1d.png")))
]
