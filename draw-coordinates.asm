
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

clear_screen macro
    
    mov ax,00
    mov cx,0000h
    mov dx,184fh
    int 10h

endm
    
    
set_video macro  
    mov ah, 0   ; set display mode function.
    mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
    int 10h
endm

draw_coordinates macro
    set_video  
    mov cx, 0  ; column
    mov dx, 100  ; row
    
    x_coordinate:
    mov al, 15  ; white
    mov ah, 0ch ; put pixel
    int 10h
    
    inc cx
    cmp cx,320
    jl x_coordinate
    
    
    
    mov cx, 160  ; column
    mov dx, 0  ; row
    
    
    y_coordinate:
    
    mov al, 15  ; white
    mov ah, 0ch ; put pixel
    int 10h
    
    inc dx
    cmp dx,200
    jl y_coordinate  
endm


org 100h

jmp start
msg1  db 0Dh,0Ah, 'enter first number(a): $'

msg2  db 0Dh,0Ah, 'enter second number(b): $'   


var_a db ?
var_b db ?

start:

set_video

CALL getParameter

clear_screen


draw_coordinates

clear_screen



;------------------------ 








ret

getParameter  PROC

    lea dx, msg1
    mov ah, 09h     ; output string at ds:dx
    int 21h  
    
    mov ah,01h      ; dos function to read a character with echo from keyboard
                    ; result (character entered) is stored in al
    int 21h
    mov var_a,al
    
    lea dx, msg2
    mov ah, 09h     ; output string at ds:dx
    int 21h  
    
    mov ah,01h      ; dos function to read a character with echo from keyboard
                    ; result (character entered) is stored in al
    int 21h
    mov var_b,al
     
    ret              ; return to caller.
getParameter  ENDP


end


