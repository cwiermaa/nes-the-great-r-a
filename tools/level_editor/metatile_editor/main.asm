.include "memory.asm"
.include "module.asm"

.bank 0 SLOT 0
.orga $8000
.section "CHR" FORCE
.incbin "tileset.CHR"
.ends

.bank 3 SLOT 3
.orga $E000
.section "Fixed" FORCE	

RESET:
	cld
	sei
	ldx #$FF
	txs

	lda #$00
	sta $2000
	sta $2001

;Clear RAM
	ldx #0
	txa
-
	sta $0,x
	sta $100.w,x
	sta $200.w,x
	sta $300.w,x
	sta $400.w,x
	sta $500.w,x
	sta $600.w,x
	sta $700.w,x
	inx
	bne -

;Load sample palettes

	ldx #16
	tay
-
	lda $6D00.w,y
	sta $30,y
	iny
	dex
	bne -

;Load text
	lda #$22
	sta $2006
	lda #$C3
	sta $2006
	ldx #5
	ldy #0
-
	lda String.2x2.w,y
	sta $2007
	iny
	dex
	bne -

	lda #$22
	sta $2006
	lda #$93
	sta $2006
	ldx #5
	ldy #0
-
	lda String.8x2.w,y
	sta $2007
	iny
	dex
	bne -

;Load pattern table on name table
	lda #$20
	sta $2006
	sta $21
	sta $2006
	sta $20
	ldx #0
	ldy #0
-
	stx $2007.w
	inx
	txa
	and #$0F
	bne +
	clc
	lda $20
	adc #$20
	sta $20
	lda $21
	adc #0
	sta $21
	sta $2006
	lda $20
	sta $2006
+
	dey
	bne -

;Load CHR data
	jsr LoadCHR


;******* Software Initialization ********
	lda #<Game.Main.Mode0
	sta Game.MainL
	lda #>Game.Main.Mode0
	sta Game.MainH

	lda #<Game.NMI.Mode0
	sta Game.NMIL
	lda #>Game.NMI.Mode0
	sta Game.NMIH

	lda #<Game.Main.Mode0.EventTest
	sta Game.Main.Mode0.EventL
	lda #>Game.Main.Mode0.EventTest
	sta Game.Main.Mode0.EventH
;***************************************
	lda #$80
	sta $2000
	lda #$1E
	sta $2001

Loop:
	jmp (Game.MainL)

LoopReturn:
	lda Game.VBLCount
-
	cmp Game.VBLCount
	beq -
	jmp Loop

IRQ:
	rti
	
NMI:
	jmp (Game.NMIL)

Palette:
	.db $3F,$00,$10,$30,$3F,$01,$11,$31,$3F,$02,$12,$32,$3F,$03,$13,$33
	.include "mode0.asm"

String.2x2:
	.db $03,$00,$25,$00,$03

String.8x2:
	.db $09,$00,$25,$00,$03

LoadFromA000:
	ldy #0
-
	lda $A000.w,y
	sta Game.2x2TL.w,y
	lda $A100.w,y
	sta Game.2x2TR.w,y
	lda $A200.w,y
	sta Game.2x2BL.w,y
	lda $A300.w,y
	sta Game.2x2BR.w,y
	
	lda $A400.w,y
	sta Game.8x2TL.w,y
	lda $A500.w,y
	sta Game.8x2TR.w,y
	lda $A600.w,y
	sta Game.8x2BL.w,y
	lda $A700.w,y
	sta Game.8x2BR.w,y
	
	lda $A800.w,y
	sta Game.8x2Attributes.w,y
	
	lda $A900.w,y
	sta Game.2x2TileTypes.w,y
	iny
	bne -
	rts
	
.ends

.bank 3 SLOT 3
.orga $FFFA
.section "vectors" FORCE
.dw NMI
.dw RESET
.dw IRQ
.ends