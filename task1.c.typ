#import "@preview/polylux:0.3.1": *
#import "unipd.typ": *

#new-section[ Task 1.c ]
#slide[
  - Extend Task 1.b to execute:
  
  #align(center, `/bin/sh -c "ls -la"`)

  - Need to add the arguments to the `argv` list:

  #align(center, ```
  argv[3] = 0
  argv[2] = "ls -la"
  argv[1] = "-c"
  argv[0] = "/bin/sh"
  ```)
]

#new-section[ Task 1.c: Solution ]
#slide[
  #let left = ```asm
    ; "/bin/sh"
    mov  eax, "#/sh"
    shr  eax, 8
    push eax          
    push "/bin"
    mov  ebx, esp
    
    ; "-c"
    mov  eax, "##-c"
    shr  eax, 16
    push eax
    
    ; "ls -la"
    mov  eax, "##la"
    shr  eax, 16
    push eax
    push "ls -"
  ```
  #let right = ```asm
    ; Construct the argument array argv
    mov  ecx, esp
    xor  eax, eax
    push eax          ; argv[3] = 0
    push ecx          ; argv[2] points "ls -la"
    lea  eax, [ecx + 8]
    push eax          ; argv[1] points "-c"
    lea  eax, [ecx + 12]
    push eax          ; argv[0] points "/bin/sh"
    mov  ecx, esp

    ; For environment variable 
    xor  edx, edx     ; No env variables 

    ; Invoke execve()
    xor  eax, eax     ; eax = 0x00000000
    mov   al, 0x0b    ; eax = 0x0000000b
    int 0x80
  ```
  #text(size: 18pt, grid(columns: (1fr, 1.5fr), left, right))
]

  // #let chars = (`l`, `s`, ` `, `-`, `l`, `a`, `\0`, `\0`, `-`, `c`, `\0`, `\0`, `/`, `b`, `i`, `n`, `/`, `s`, `h`, `\0`)
  // #grid(columns: (auto,) * chars.len(), ..chars.map(it => rect(width: 1.5em, height: 1.5em, align(center + horizon, it))))
// TODO: Show stack?

#slide[
  #align(center, v(-10%) + scale(x: 90%, y: 90%, image("exe1c.png")))
]

#slide[
  #place(center + horizon, v(20%) + scale(x: 85%, y: 85%, image("obj1c.png")))
]

