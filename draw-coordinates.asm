; this sample prints 16x16 color map,
; it uses all possible colors.

draw_row macro
next_row:
    inc     dh
    cmp     dh, 13
    je      get_col
    mov     dl, 0
    
    next_char:
    
    ; set cursor position at (dl,dh):
    mov     ah, 02h
    int     10h
    
    mov     al, '.'
    mov     bh, 0
    mov     cx, 1
    mov     ah, 09h
    int     10h
    
    ;inc     bl      ; next attributes.
    
    inc     dl
    cmp     dl, 40
    je      next_row
    jmp     next_char   
endm


draw_column macro
    get_col:
    mov     dl, 20
    mov     dh, 0   ; current row.
    jmp next_char2  
    
    next_col:
    ;inc     dh
    cmp     dh, 25
    je      stop_print
    
    
    next_char2:   
    
    
    
    
    ; set cursor position at (dl,dh):
    mov     ah, 02h
    int     10h
    
    mov     al, '.'
    mov     bh, 0
    mov     cx, 1
    mov     ah, 09h
    int     10h
    
    ;inc     bl      ; next attributes.
    
    inc     dh
    cmp     dh, 25
    je      next_col
    jmp     next_char2
endm
       



org     100h   

jmp start

;-------------------------s---------------------------       
msg1  db 0Dh,0Ah, 'enter first number: $'

msg2  db 0Dh,0Ah, 'enter second number: $'       
       

;----------------------------------------------------
 
a dw ?
b dw ?

;----------------------------------------------------

start:

lea dx, msg1
mov ah, 09h     ; output string at ds:dx
int 21h  

mov ah,01h  ; dos function to read a character with echo from keyboard
                ; result (character entered) is stored in al
int 21h     ; dos interrupt 21h 
 

add al,48
mov dl,al
mov ah, 02h     ; output string at ds:dx
int 21h



;---------------------------------------------------- 

; set video mode:
; text mode. 40x25. 16 colors. 8 pages.
mov     ax, 1
int     10h

; blinking disabled for compatibility with dos,
; emulator and windows prompt do not blink anyway.
mov     ax, 1003h
mov     bx, 0      ; disable blinking.
int     10h


               
mov     dl, 0   ; current column.
mov     dh, 12   ; current row.

mov     bl, 3   ; current attributes.

 



jmp     next_char  

;----------------------------------------------------


draw_row   

;----------------------------------------------------

draw_column      

;----------------------------------------------------
stop_print:



; set cursor position at (dl,dh):
mov     dl, 10  ; column.
mov     dh, 5   ; row.
mov     ah, 02h
int     10h

; test of teletype output,
; it uses color attributes
; at current cursor position:
mov     al, 'x'
mov     ah, 0eh
int     10h


; wait for any key press:
mov ah, 0
int 16h


ret
