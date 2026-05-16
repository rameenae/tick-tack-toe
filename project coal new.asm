.model small
.stack 100h

.data
new_line db 13,10,"$"

; -------- GAME BOARD --------
game_draw db "| | | |",13,10
          db "| | | |",13,10
          db "| | | |",13,10,"$"

board_state db 9 dup(32)

win_flag db 0           ; 0=none, 1=win, 2=draw
player_turn db 0        ; 0 = X, 1 = O
game_mode db 0          ; 0 = PvC, 1 = PvP

; -------- MESSAGES --------
mode_message db "Select Mode:",13,10,"1) Player vs Player,",13,10,"2) Player vs CPU",13,10," $"
game_start_message db "Tic-Tac-Toe Start!",13,10,"$"
player_turn_message db "Player "
turn_message db "'s turn",13,10,"$"
type_message db "Type position (1-9): $"
invalid_message db "Invalid move! Try again.",13,10,"$"
win_message db " wins!",13,10,"$"
draw_message db "It's a draw!",13,10,"$"

.code
start:
    mov ax,data
    mov ds,ax
    mov es,ax

    call clear_board
    call clear_screen

; -------- MODE SELECTION --------
    lea dx,mode_message
    call print
    call read_keyboard

    cmp al,'1'
    je set_pvp
    mov game_mode,0
    jmp mode_done

set_pvp:
    mov game_mode,1

mode_done:
    call clear_screen
    lea dx,game_start_message
    call print

; ================= MAIN LOOP =================
main_loop:
    call clear_screen
    call build_game_draw
    lea dx,game_draw
    call print

    lea dx,new_line
    call print

; -------- TURN MESSAGE --------
    lea dx,player_turn_message
    call print

    cmp player_turn,0
    je print_x
    mov dl,'O'
    jmp print_turn

print_x:
    mov dl,'X'

print_turn:
    mov ah,2
    int 21h

    lea dx,turn_message
    call print

; -------- PLAYER MOVE --------
player_move:
    lea dx,type_message
    call print
    call read_keyboard

    cmp al,'1'
    jl invalid_input
    cmp al,'9'
    jg invalid_input

    sub al,'1'
    mov bl,al
    call update_board

    cmp al,0FFh
    je invalid_input

; -------- CHECK GAME STATUS --------
after_move:
    call check_win
    cmp win_flag,1
    je game_over

    call check_draw
    cmp win_flag,2
    je game_over

    call change_player

; -------- CPU MOVE (Only PvC) --------
    cmp game_mode,1
    je main_loop

    cmp player_turn,1
    jne main_loop
    call cpu_move
    jmp after_move

invalid_input:
    lea dx,invalid_message
    call print
    jmp main_loop

; ================= GAME OVER =================
game_over:
    call clear_screen
    call build_game_draw
    lea dx,game_draw
    call print
    lea dx,new_line
    call print

    cmp win_flag,1
    jne draw_print

    lea dx,player_turn_message
    call print
    cmp player_turn,0
    je win_x
    mov dl,'O'
    jmp win_char

win_x:
    mov dl,'X'

win_char:
    mov ah,2
    int 21h
    lea dx,win_message
    call print
    jmp exit

draw_print:
    lea dx,draw_message
    call print

exit:
    mov ah,4Ch
    int 21h

; ================= UTILITIES =================
change_player:
    xor player_turn,1
    ret

update_board:
    cmp byte ptr [board_state+bx],32
    jne invalid_move

    cmp player_turn,0
    je draw_x
    mov byte ptr [board_state+bx],'O'
    mov al,0
    ret

draw_x:
    mov byte ptr [board_state+bx],'X'
    mov al,0
    ret

invalid_move:
    mov al,0FFh
    ret

; -------- CPU RANDOM MOVE --------
cpu_move:
cpu_try:
    mov ah,00h
    int 1Ah
    mov ax,dx
    xor dx,dx
    mov cx,9
    div cx
    mov bx,dx

    cmp byte ptr [board_state+bx],32
    jne cpu_try
    mov byte ptr [board_state+bx],'O'
    ret

; -------- BUILD BOARD --------
build_game_draw:
    mov al,[board_state]     
    mov [game_draw+1],al
    mov al,[board_state+1]   
    mov [game_draw+3],al
    mov al,[board_state+2]   
    mov [game_draw+5],al
    mov al,[board_state+3]   
    mov [game_draw+10],al
    mov al,[board_state+4]   
    mov [game_draw+12],al
    mov al,[board_state+5]   
    mov [game_draw+14],al
    mov al,[board_state+6]   
    mov [game_draw+19],al
    mov al,[board_state+7]   
    mov [game_draw+21],al
    mov al,[board_state+8]   
    mov [game_draw+23],al
    ret

; -------- WIN CHECK --------   

check_win:
    mov win_flag,0

    mov si,0
row_loop:
    cmp si,9
    je col_check
    mov al,[board_state+si]
    cmp al,32
    je next_row
    cmp al,[board_state+si+1]
    jne next_row
    cmp al,[board_state+si+2]
    jne next_row
    mov win_flag,1
    ret
next_row:
    add si,3
    jmp row_loop

col_check:
    mov si,0
col_loop:
    cmp si,3
    je diag_check
    mov al,[board_state+si]
    cmp al,32
    je next_col
    cmp al,[board_state+si+3]
    jne next_col
    cmp al,[board_state+si+6]
    jne next_col
    mov win_flag,1
    ret
next_col:
    inc si
    jmp col_loop

diag_check:
    mov al,[board_state]
    cmp al,32
    jne d1
    jmp d2
d1:
    cmp al,[board_state+4]
    jne d2
    cmp al,[board_state+8]
    jne d2
    mov win_flag,1
    ret
d2:
    mov al,[board_state+2]
    cmp al,32
    je done
    cmp al,[board_state+4]
    jne done
    cmp al,[board_state+6]
    jne done
    mov win_flag,1
done:
    ret

; -------- DRAW CHECK --------
check_draw:
    mov cx,0
    mov si,0
draw_loop:
    cmp cx,9
    je draw_found
    cmp byte ptr [board_state+si],32
    je draw_exit
    inc cx
    inc si
    jmp draw_loop
draw_found:
    mov win_flag,2
draw_exit:
    ret

; -------- CLEAR BOARD --------
clear_board:
    mov cx,9
    mov si,0
cb_loop:
    mov byte ptr [board_state+si],32
    inc si
    loop cb_loop
    ret

; -------- IO --------
print:
    mov ah,9
    int 21h
    ret

read_keyboard:
    mov ah,1
    int 21h
    ret

clear_screen:
    mov ah,0
    mov al,3
    int 10h
    ret

end start
