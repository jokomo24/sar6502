; Basys 3 Test Program for sar6502 CPU
; This program displays CPU status on LEDs and 7-segment displays

.segment "CODE"
.org $E000

; I/O addresses
IO_LED = $0200
IO_SEG = $0201
IO_AN = $0202
IO_STATUS = $0203

; Main program starts here
start:
    ; Initialize stack
    ldx #$FF
    txs
    
    ; Clear all LEDs
    lda #$00
    sta IO_LED
    
    ; Initialize 7-segment display
    lda #$0F        ; All anodes on
    sta IO_AN
    
    ; Main loop
main_loop:
    ; Display CPU status on LEDs
    lda IO_STATUS
    sta IO_LED
    
    ; Display address on 7-segment (example)
    lda #$AA        ; Pattern for testing
    sta IO_SEG
    
    ; Simple delay loop
    ldx #$FF
delay1:
    ldy #$FF
delay2:
    dey
    bne delay2
    dex
    bne delay1
    
    ; Change pattern
    lda IO_SEG
    eor #$FF        ; Invert pattern
    sta IO_SEG
    
    ; Another delay
    ldx #$FF
delay3:
    ldy #$FF
delay4:
    dey
    bne delay4
    dex
    bne delay3
    
    ; Jump back to main loop
    jmp main_loop

; Vectors segment
.segment "VECTORS"
.org $FFFA
.word start    ; NMI vector ($FFFA-$FFFB)
.word start    ; Reset vector ($FFFC-$FFFD)
.word start    ; IRQ vector ($FFFE-$FFFF) 