; pixels 0-2-4-6 go up and down
; Frame 1
LOADI Wreg 85
OUT Wreg 1
JMP 4

; Frame 2
LOADI Wreg 85
OUT Wreg 2
JMP 7

; Frame 3
LOADI Wreg 85
OUT Wreg 4
JMP 10

; Frame 4
LOADI Wreg 85
OUT Wreg 8
JMP 13

; Frame 5
LOADI Wreg 85
OUT Wreg 16
JMP 16

; Frame 6
LOADI Wreg 85
OUT Wreg 32
JMP 19

; Frame 7
LOADI Wreg 85
OUT Wreg 64
JMP 22

; Frame 8
LOADI Wreg 85
OUT Wreg 128
JMP 0
