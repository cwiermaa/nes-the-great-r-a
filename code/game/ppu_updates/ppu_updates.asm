
Game.NMI.PPUUpdates:
	jsr Game.NMI.UpdateBG
	lda Standard.$2001
	sta $2001
	jmp Game.NMI.PPUReturn

Game.NMI.SkipUpdate:
;Note: If we are skipping PPU updates, in the event that we have not completed frame processing,
;We cannot write to BG -OR- draw sprites. Since this is the case, we must assume that sprite #0
;will remain in place from last frame. So if updates are being skipped, sprite #0 must already be displayed
;on screen.

	lda #$00
	sta $2006
	sta $2005
	sta $2005
	sta $2006
	lda Standard.$2000
	and #$FC
	sta $2000
	lda Standard.$2001
	sta $2001
	jmp Game.NMI.PPUReturn


Game.NMI.UpdateBG:
;Function: copies a column of tiles and attributes to the background, given a reference address for tiles and attributes.
;The column of tiles is 30 entries, 1 tile wide.
	lda Standard.$2000				;3
	ora #$04					;5
	sta $2000					;9

	lda Game.PPUUpdates.TilePPUH				;12
	sta $2006					;16
	lda Game.PPUUpdates.TilePPUL				;19
	and #$1F
	ora #$80
	sta $2006					;23

	ldy #0						;25
	ldx #5						;27
	clc						;29
-
	lda Game.PPUUpdates.TileColumn,y			;3
	sta $2007					;7
	lda Game.PPUUpdates.TileColumn+1,y			;10
	sta $2007					;14
	lda Game.PPUUpdates.TileColumn+2,y			;17
	sta $2007					;21
	lda Game.PPUUpdates.TileColumn+3,y			;24
	sta $2007					;28
	lda Game.PPUUpdates.TileColumn+4,y			;31
	sta $2007					;35
	tya						;44
	adc #5						;46
	tay						;48
	dex						;50
	bne -						;53
							;53 * 6 = 318 - 1 = 317

	lda Game.PPUUpdates.TileColumn+25
	sta $2007

	ldy Game.PPUUpdates.AttributePPUH			;320
	lda Game.PPUUpdates.AttributePPUL			;323

	clc

	sty $2006.w					;327
	ora #$08
	sta $2006					;331

	ldx Game.PPUUpdates.AttributeColumn			;334
	stx $2007.w					;338
	ldx Game.PPUUpdates.AttributeColumn+4		;341
	

	stx $2007.w					;345

	sty $2006.w					;349
	adc #$08					;351
	sta $2006					;355
	ldx Game.PPUUpdates.AttributeColumn+1		;358
	stx $2007.w					;362
	ldx Game.PPUUpdates.AttributeColumn+5		;365
	

	stx $2007.w					;369

	sty $2006.w					;373
	adc #$08					;375
	sta $2006					;379
	ldx Game.PPUUpdates.AttributeColumn+2		;382
	stx $2007.w					;386
	ldx Game.PPUUpdates.AttributeColumn+6		;389
	

	stx $2007.w					;393


	sty $2006.w					;397
	adc #$08					;399
	sta $2006					;403
	ldx Game.PPUUpdates.AttributeColumn+3		;407
	stx $2007.w					;411
							;+29
							;447

	lda #Standard.OAMPage
	sta $4014

	lda Standard.$2000
	and #$FC
	sta $2000


;***************** Status Bar Updating **********************
	lda #$20
	sta $2006
	lda #$63
	sta $2006

	lda Game.NMI.BG.Health0
	sta $2007
	lda Game.NMI.BG.Health1
	sta $2007
	lda Game.NMI.BG.Health2
	sta $2007


	lda #$20
	sta $2006
	lda #$6A
	sta $2006

	lda Game.NMI.BG.Lives0
	sta $2007
	lda Game.NMI.BG.Lives1
	sta $2007

	ldx #$4C
	lda Game.Player.PowerUp
	and #$80
	beq +
	ldx #$3D
+

	lda #$20
	sta $2006
	lda #$4F
	sta $2006

	stx $2007.w
	stx $2007.w

	lda #$20
	sta $2006
	lda #$6F
	sta $2006

	stx $2007.w
	stx $2007.w


	lda #$20	
	sta $2006
	lda #$74
	sta $2006

	lda Game.NMI.BG.Ammo0
	sta $2007
	lda Game.NMI.BG.Ammo1
	sta $2007


	lda #$20
	sta $2006
	lda #$79
	sta $2006

	clc
	lda Standard.Main.Convert.DecHundredThousands
	adc #1
	sta $2007
	lda Standard.Main.Convert.DecTenThousands
	adc #1
	sta $2007
	lda Standard.Main.Convert.DecThousands
	adc #1
	sta $2007
	lda Standard.Main.Convert.DecHundreds
	adc #1
	sta $2007
	lda Standard.Main.Convert.DecTens
	adc #1
	sta $2007
	lda Standard.Main.Convert.DecOnes
	adc #1
	sta $2007

;*****************/Status Bar Updating **********************
	ldy Game.NMI.Palette.Low.w
	beq +
	lda #$3F
	sta $2006
	sty $2006.w
	
	lda Game.NMI.Palette.1
	sta $2007
	lda Game.NMI.Palette.2
	sta $2007
	lda Game.NMI.Palette.3
	sta $2007
+
	lda #$00
	sta $2006
	sta $2005
	sta $2005
	sta $2006
	rts