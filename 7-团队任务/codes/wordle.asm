# ecall 31 display a0
# ecall 28 wait for ReadyInput
# ecall 30 read a char

# buf start at 0
# ans start at 20
# cnt start at 40

.text

addi t0, zero, 20
addi t1, zero, 'd'
sw t1, 0(t0)
addi t1, zero, 'e'
sw t1, 4(t0)
addi t1, zero, 'b'
sw t1, 8(t0)
addi t1, zero, 'u'
sw t1, 12(t0)
addi t1, zero, 'g'
sw t1, 16(t0)

# cnt 
addi t0, zero, 20 # address
addi t1, zero, 40 # bound
cntLoop:
    lw a0, 0(t0)
    addi t2, zero, 'a'
    sub t2, a0, t2
    slli t2, t2, 2
    addi t2, t2, 40 # bias 
    lw a0, 0(t2)
    addi a0, a0, 1
    sw a0, 0(t2)
    addi t0, t0, 4
    bne t0, t1, cntLoop

MainLoop:
    # display message
    addi a7, zero, 31
    addi a0, zero, '>'
    ecall
    addi a0, zero, ' '
    ecall

    addi t0, zero, 0 # address
    addi t1, zero, 20 # bound
    addi a7, zero, 28 # need press ReadyInput button
    ecall

    inputLoop:
        addi a7, zero, 30 # clear a char
        ecall
        sw a0, 0(t0) # a0 should use a wire
        addi t0, t0, 4
        bne t0, t1, inputLoop
    

    addi t0, zero, 0 # address
    outputLoop:
        lw a0, 0(t0)
        addi a7, zero, 31
        ecall
        addi t0, t0, 4
        bne t0, t1, outputLoop

    addi a7, zero, 31 # display a char
    addi a0, zero, 10 # new line
    ecall
    addi a0, zero, ':'
    ecall
    addi a0, zero, ' '
    ecall
        
    addi t0, zero, 0
    addi t1, zero, 20 # address and bound
    addi t2, zero, 20
    addi a4, zero, 0
    correctLoop:
        lw a1, 0(t0)
        lw a2, 0(t2)
        beq a1, a2, correct
        lw a0, 0(t0)
        addi a2, zero, 'a'
        sub a2, a0, a2
        slli a2, a2, 2
        addi a2, a2, 40 # bias 
        lw a0, 0(a2)
        bne a0, zero, chu
        j noo
        correct:
            addi a0, zero, 'T'
            addi a4, a4, 1
            j prt
        chu:
            addi a0, zero, '-'
            j prt
        noo:
            addi a0, zero, '.'
            j prt
        prt:
            addi a7, zero, 31
            ecall
        addi t0, t0, 4
        addi t2, t2, 4
        bne t0, t1, correctLoop
    
    addi a7, zero, 31 # display a char
    addi a0, zero, 10 # new line
    ecall

    addi a5, zero, 5
    beq a5, a4, success

    j MainLoop

success:
    addi a7, zero, 31
    addi a0, zero, 'W'
    ecall
    addi a0, zero, 'I'
    ecall
    addi a0, zero, 'N'
    ecall

    addi a7, zero, 10
    ecall
