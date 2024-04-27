first_start:
    li $8, 10000            # Initialize $8 with 1000 (loop counter)
    li $9, 10000            # Initialize $8 with 1000 (loop counter)
    li $10, 0
    li $11, 1
    j loop
third_jump:
    j loop
second_jump:
    j third_jump
loop:
    beq $8, $0, end_loop # Branch to endloop if $8 equals 0
    addiu $8, $8, -1         # Decrement $8 by 1
inner_loop:
    beq $9, $0, end_inner_loop # Branch to endloop if $8 equals 0
    j inner_cont
inner_end:
    beq $10, $0 inner_beg
inner_stop:
    bne $11, $0 inner_end
inner_cont:
    j inner_stop
inner_beg:
    addiu $9, $9, -1         # Decrement $8 by 1
    j inner_cont1
inner_end1:
    beq $10, $0 inner_beg1
inner_stop1:
    bne $11, $0 inner_end1
inner_cont1:
    j inner_stop1
inner_beg1:
    j inner_loop
end_inner_loop:
    j second_jump           # Jump back to loop
end_loop:
    halt