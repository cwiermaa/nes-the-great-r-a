.include "memory.asm"
.include "module.asm"

.bank 0 SLOT 0
.orga $8000
.section "CHR" FORCE
.incdir "metatile_editor"
.incbin "tileset.CHR"
.ends

.bank 1 SLOT 1
.orga $A000
.section "Tiles" FORCE
.incbin "metatile.sav"	SKIP $1000
.incdir ""
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

	ldx #16
	ldy #0
-
	lda Game.Map.Palette.w,y
	sta $30,y
	iny
	dex
	bne -

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
;***************************************
	;jsr CopyA000ToSRAM
	
	lda #1
	sta Game.NewColumn
	lda #0
	sta Game.CursorX
	jsr DrawColumnOfTiles
	inc Game.CursorX
	jsr DrawColumnOfTiles
	inc Game.CursorX
	jsr DrawColumnOfTiles
	inc Game.CursorX
	jsr DrawColumnOfTiles

	lda #0
	sta Game.NewColumn
	sta Game.CursorX

	lda #$00
	sta $2005
	sta $2005

	lda #$1E
	sta Game.$2001
	sta $2001
	lda #$80
	sta Game.$2000
	sta $2000
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

CopyA000ToSRAM:

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
	sta Game.2x2Types.w,y
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