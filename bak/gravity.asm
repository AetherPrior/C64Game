KERNAL_CLEAR_SCREEN=$E544

VICII_REG=$DD00

TXT_FGCOLOR=$D020
TXT_BGCOLOR=$D021

VICII_CTRL_0=$D011
VICII_CTRL_1=$D016

SPRITE_COLOR_MODE=$D01C
SPRITE_MULTI_COLOR_0=$D025
SPRITE_MULTI_COLOR_1=$D026
SPRITE_REG=$D015

; 10 SYS4096
*=$0801

        BYTE    $0B, $08, $0A, $00, $9E, $34, $30, $39, $36, $00, $00, $00

*=$1000

        JMP START

GRAVITY_
        BYTE 01

Y_VEL
        BYTE 1

X_VEL
        BYTE 10

POSX
        BYTE 0
POSY
        BYTE 0 

START
        
        ; Enable multicolor bitmap mode for multicolor sprites
        LDA VICII_CTRL_0
        ORA #%00100000 ; SET BMM
        AND #%10111111 ; CLEAR ECM
        STA VICII_CTRL_0
        
        LDA VICII_CTRL_1
        ORA #%00010000 ; SET MCM
        STA VICII_CTRL_1

        ;clrscr and set color to be black
@CLRSCR
        jsr KERNAL_CLEAR_SCREEN
        LDA #$00
        STA TXT_FGCOLOR
        LDA #$00
        STA TXT_BGCOLOR
        LDA #$02
        STA $DD00      ;VIC2 16K MEMORY AT $4000
        LDX #$90
        STX $D018     ;SELECT BLOCK $4000-$6000 for bitmap
                      ;BLOCK $6000-$6400 FOR SCREEN

        LDY #$00      ; FILL $2000 00s from $4000
        TYA
        STY $FB
        LDX #$40
        STX $FC
        LDX #$20
        
@FILLB
        STA ($FB),Y
        INY 
        BNE @FILLB
        
        INC $FC
        DEX
        BNE @FILLB

@SPRITE

        ; Set sprite 0 to be in multicolor mode
        LDA #$01
        STA SPRITE_COLOR_MODE

        ; Set the colors for the sprite
        LDA #$06
        STA SPRITE_MULTI_COLOR_0 ; MULTICOLOR reg 0
        LDA #$07
        STA SPRITE_MULTI_COLOR_1 ; multicolor reg 1
        LDA #$00
        STA $D027 ; sprite color for sprite 0
        

        ; Load the sprite 

        LDA #$C0 ; $C0*$40 = $3000
        STA $07F8 ;set pointer for sprite

        LDA #$01   ; sprite #0 data
        STA SPRITE_REG ; turn on sprites

        LDA #$80
        STA $D000 ; X for sprite 0
        STA $D001 ; Y for sprite 0
        ; if x > 255 set $D010's first bit to 1 and set $d00x with (x-256)

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
        SBC GRAVITY_
        STA Y_VEL
        
        JMP @LOOP

@END    
        RTS
*=$3000
        incbin "mysprite.spt",1,1