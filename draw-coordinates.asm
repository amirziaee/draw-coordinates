clear_screen macro
    
    mov ax,00
    mov cx,0000h
    mov dx,184fh
    int 10h

endm
    
;-------------------------------------------------------- 
    
set_video macro  
    mov ah, 0   ; set display mode function.
    mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
    int 10h
endm  

;-------------------------------------------------------- 

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

print_msg macro message
    
    lea dx, message
    mov ah, 09h     ; output string at ds:dx
    int 21h  


endm

;-------------------------------------------------------- 

dieOrLive macro
    set_video
    print_msg msg3
    print_msg msg4
    
    mov ah,00h
    int 16h
    cmp al,1Bh
    je exit
    cmp al,20h
    je start
    jne check_status

   
    
endm    


org 100h

jmp start
msg1  db 0Dh,0Ah, 'enter first number(a): $'

msg2  db 0Dh,0Ah, 'enter second number(b): $'

msg3  db 0Dh,0Ah, 'please press esc to exit... $' 
msg4  db 0Dh,0Ah, 'please press space comput a and b again... $'    


var_a dw ?
var_b dw ?
final_column dw ?
final_row dw ?        

;--------------------------------------------------------

start:

set_video

CALL getParameter  

CALL setParameter

clear_screen

draw_coordinates



draw_points: 


 
    mov cx, 160  ; column
    mov dx, 100  ; row
    mov al, 14  ; a color
    mov ah, 0ch ; put pixel
    int 10h
    
    
draw_line:
    inc cx
    dec dx
    mov al, 14  ; a color
    mov ah, 0ch ; put pixel
    int 10h
    cmp cx,final_column
    jle draw_line


CALL delay

clear_screen



;-------------------------------------------------------- 

check_status: 

dieOrLive


exit:
mov ah,4ch
int 21h

ret  

;-------------------------------------------------------- 


 



getParameter  PROC

    print_msg msg1
    
    mov ah,01h      ; dos function to read a character with echo from keyboard
                    ; result (character entered) is stored in al
    int 21h
    
    and ah,00
    
    xor ax,30h
    mov var_a,ax
    
    
    print_msg msg2
    
    mov ah,01h      ; dos function to read a character with echo from keyboard
                    ; result (character entered) is stored in al
    int 21h 
    and ah,00
    xor al,30h
    mov var_b,ax
     
    ret              ; return to caller.
getParameter  ENDP


setParameter PROC
    mov ax,3
    mov bx,var_a
    mul bx
    add var_b,ax
    push var_b
    add ax,160       ;comput current position in coordinate


    mov final_column,ax  ;set x
    pop ax
    mov dx,100
    sub dx,ax
    mov ax,dx       ;comput current position in coordinate
    and dx,00
    mov final_row,ax  ;set y
    ret
setParameter ENDP


delay PROC  
     
      mov cx, 7      ;high word.
      mov dx, 0fffh ;low word.
      mov ah, 86h    ;wait.
      int 15h
      ret
      
delay ENDP 
    


end


;    mov cx, 160  ; column
;    mov dx, 100  ; row
;    mov al, 15  ; white     
;    mov ah, 0ch ; put pixel
;    int 10h
;
;    
;    dx_continue:
;   dec dx
;    mov al, 14  ; a color
;    mov ah, 0ch ; put pixel
;    int 10h
;    cmp dx,final_row
;    jne dx_continue
;
;
;    mov cx,final_column  ; column     first point
;    mov dx, final_row  ; row    first point
;    mov al, 13  ; a color
;    mov ah, 0ch ; put pixel
;    int 10h
;
;
;
;