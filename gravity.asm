; 10 SYS4096
SPRITE=$D015
*=$0801

        BYTE    $0B, $08, $0A, $00, $9E, $34, $30, $39, $36, $00, $00, $00

*=$1000

        JMP START

GRAVITY
        BYTE 01

Y_VEL
        BYTE 10

X_VEL
        BYTE 10

POSX
        BYTE 0
POSY
        BYTE 0 

START
        LDA SPRITE
        STA $FF

@LOOP 
        LDA Y_VEL
        CLC
        ADC POSY
        STA POSY
        BMI @END
        
        LDA X_VEL
        ADC POSX
        STA POSX

        LDA Y_VEL
        SEC
        SBC GRAVITY
        STA Y_VEL
        
        JMP @LOOP

@END    
        RTS