Game.NMI.Mode0:
	pha
	txa
	pha
	tya
	pha

	jsr Game.NMI.Mode0.PPUUpdates
	jsr Game.NMI.Mode0.APUUpdates

	inc Game.VBLCount

	pla
	tay
	pla
	tax
	pla
	rti


Game.Main.Mode0:
	lda #0
	sta Game.NewColumn
	sta Game.TilePlaced
	jsr Game.Main.Mode0.HandleCharacter
	jsr HandleScroll
	jsr Game.Main.Mode0.DrawSprites
	jsr DrawColumnOfTiles
	jsr DrawEntireScreen
	jmp LoopReturn


Game.NMI.Mode0.PPUUpdates:

	jsr NMI.Palette.Update

	lda #3
	sta $4014

	lda Game.ScrollX
	sta $2005
	lda #$00
	sta $2005
	lda Game.$2000
	sta $2000
	lda Game.$2001
	sta $2001
	rts
Game.NMI.Mode0.APUUpdates:
	rts

;***********************************************
Game.Main.Mode0.HandleCharacter:
;Read Controller
	lda Game.ControlNew
	sta Game.ControlOld

	ldx #1
	stx $4016.w
	dex
	stx $4016.w
	stx Game.ControlNew
	ldx #8
-
	lda $4016
	lsr a
	rol Game.ControlNew
	dex
	bne -

;Trigger = New AND Old EOR New
	lda Game.ControlNew
	and Game.ControlOld
	eor Game.ControlNew
	sta Game.ControlTrigger

;Select current mode by pressing select
	lda Game.ControlTrigger
	and #$20
	beq +
	clc
	lda Game.Mode
	adc #1
	cmp #3
	bne ++
	lda #0
++
	sta Game.Mode
+

	lda Game.ControlTrigger
	and #$10
	beq +
	ldx #16
	ldy #0
-
	lda $30,y
	sta Game.Map.Palette.w,y
	iny
	dex
	bne -

+
	ldx Game.Mode
	lda ControllerModesL.w,x
	sta Game.TempAdd0L
	lda ControllerModesH.w,x
	sta Game.TempAdd0H

	jmp (Game.TempAdd0L)


ControllerModesL:
	.db <Mode0Control, <Mode1Control, <Mode2Control

ControllerModesH:
	.db >Mode0Control, >Mode1Control, >Mode2Control


Mode0Control:
;For general map editing
	lda Game.ControlTrigger
	and #8
	beq +
	dec Game.CursorY
	lda Game.CursorY
	bpl +
	lda #12
	sta Game.CursorY
+

	lda Game.ControlTrigger
	and #4
	beq +
	inc Game.CursorY
	lda Game.CursorY
	cmp #13
	bne +
	lda #0
	sta Game.CursorY
+

	lda Game.ControlTrigger
	and #2
	beq +
	dec Game.CursorX
+

	lda Game.ControlTrigger
	and #1
	beq +
	inc Game.CursorX
+

	lda Game.ControlTrigger
	and #$80
	beq +
	lda Game.CursorY
	ora #$60
	sta Game.TempAdd0H
	lda #$00
	sta Game.TempAdd0L
	ldy Game.CursorX
	lda Game.Current8x2
	sta (Game.TempAdd0L),y
	lda #1
	sta Game.TilePlaced
+
	rts
Mode1Control:
;For tile selection

	lda Game.ControlTrigger
	and #8
	beq +
	clc
	lda Game.Current8x2
	adc #$10
	sta Game.Current8x2
+	
	lda Game.ControlTrigger
	and #4
	beq +
	sec
	lda Game.Current8x2
	sbc #$10
	sta Game.Current8x2
+
	lda Game.ControlTrigger
	and #2
	beq +
	dec Game.Current8x2
+
	lda Game.ControlTrigger
	and #1
	beq +
	inc Game.Current8x2
+	
	rts

Mode2Control:
	lda Game.ControlTrigger
	and #1
	beq +
	clc
	lda Game.Current2x2
	adc #1
	and #3
	sta Game.Current2x2
+
	lda Game.ControlTrigger
	and #2
	beq +
	sec
	lda Game.Current2x2
	sbc #1
	and #3
	sta Game.Current2x2
+
	lda Game.ControlTrigger
	and #8
	beq +
	jsr Mode2.GetCurrent2x2Add
	ldy Game.Current8x2
	lda (Game.Current2x2L),y
	clc
	adc #1
	sta (Game.Current2x2L),y
	lda #1
	sta Game.UpdateWholeScreen
+
	lda Game.ControlTrigger
	and #4
	beq +
	jsr Mode2.GetCurrent2x2Add
	ldy Game.Current8x2
	lda (Game.Current2x2L),y
	sec
	sbc #1
	sta (Game.Current2x2L),y
	lda #1
	sta Game.UpdateWholeScreen
+

	lda Game.ControlTrigger
	and #$80
	beq ++

	ldx Game.Current8x2
	lda Game.8x2Attributes.w,x
	ldy Game.Current2x2
	beq +
-
	lsr a
	lsr a
	dey
	bne -
+
	clc
	adc #1
	and #3
	ldy Game.Current2x2
	beq +
-
	asl a
	asl a
	dey
	bne -
+
	sta Game.2x2Attribute
	ldx Game.Current2x2
	ldy Game.Current8x2
	lda Mode2.AttributeAND.w,x
	and Game.8x2Attributes.w,y
	ora Game.2x2Attribute
	sta Game.8x2Attributes.w,y
	lda #1
	sta Game.UpdateWholeScreen
++
	rts

Mode2.AttributeAND:
	.db $FC,$F3,$CF,$3F
	
Mode2.GetCurrent2x2Add:
	
	ldx Game.Current2x2
	lda Mode2Control2x2L.w,x
	sta Game.Current2x2L
	lda Mode2Control2x2H.w,x
	sta Game.Current2x2H
	rts
	
Mode2Control2x2H:
	.db >Game.8x2TL, >Game.8x2TR, >Game.8x2BL, >Game.8x2BR

Mode2Control2x2L:
	.db <Game.8x2TL, <Game.8x2TR, <Game.8x2BL, <Game.8x2BR
HandleScroll:
;Calculate camera coordinates
	lda Game.CursorX
	sta Game.ZTempVar1
	lda #$00
	lsr Game.ZTempVar1
	ror a
	lsr Game.ZTempVar1
	ror a
	sta Game.ZTempVar2
					;ZTempVar1 = Cursor X Pixel High, ZTempVar2 = Cursor X Pixel Low
					;If Cursor is beyond the right edge, scroll right. If behind the left, scroll left.
	clc
	lda Game.XCoordH
	adc #1
	and #$3F
	sta Game.ZTempVar5

	lda Game.ZTempVar2
	cmp Game.XCoordL
	bne +
	lda Game.ZTempVar5
	cmp Game.ZTempVar1
	bne +

	clc
	lda Game.XCoordL
	adc #$40
	sta Game.XCoordL
	lda Game.XCoordH
	adc #0
	and #$3F
	sta Game.XCoordH
	lda #1
	sta Game.NewColumn
+
	sec
	lda Game.XCoordL
	sbc #$40
	sta Game.ZTempVar3
	lda Game.XCoordH
	sbc #0
	and #$3F
	sta Game.ZTempVar4

	cmp Game.ZTempVar1
	bne +

	lda Game.ZTempVar3
	cmp Game.ZTempVar2
	bne +
	sec
	lda Game.XCoordL
	sbc #$40
	sta Game.XCoordL
	lda Game.XCoordH
	sbc #0
	and #$3F
	sta Game.XCoordH
	lda #1
	sta Game.NewColumn

+
;Calculate actual scroll
	lda Game.XCoordL
	sta Game.ScrollX
	lda Game.XCoordH
	and #1
	sta Game.ScrollXH
	lda Game.$2000
	and #$FE
	ora Game.ScrollXH
	sta Game.$2000
	rts
;***********************************
Game.Main.Mode0.DrawSprites:

	lda Game.CursorX
	sta Game.ZTempVar2
	lda #$00
	lsr Game.ZTempVar2
	ror a
	lsr Game.ZTempVar2
	ror a
	sta Game.ZTempVar1

	sec
	lda Game.ZTempVar1
	sbc Game.XCoordL
	sta Game.ZTempVar3

	lda Game.CursorY
	asl a
	asl a
	asl a
	asl a
	clc
	adc #31
	sta Game.ZTempVar4

;ZTempVar3 = X Coordinate
;ZTempVar4 = Y Coordinate

;Draw Current 8x2 metatile
	lda Game.ZTempVar4
	sta $304+$10
	sta $308+$10
	sta $304+$20
	sta $308+$20
	sta $304+$30
	sta $308+$30
	sta $304+$40
	sta $308+$40
	clc
	lda Game.ZTempVar4
	adc #8
	sta $30C+$10
	sta $310+$10
	sta $30C+$20
	sta $310+$20
	sta $30C+$30
	sta $310+$30
	sta $30C+$40
	sta $310+$40

	lda Game.ZTempVar3
	sta $307+$10
	sta $30F+$10
	clc
	lda Game.ZTempVar3
	adc #8
	sta $30B+$10
	sta $313+$10

	clc
	lda Game.ZTempVar3
	adc #16
	sta $307+$20
	sta $30F+$20
	clc
	lda Game.ZTempVar3
	adc #24
	sta $30B+$20
	sta $313+$20

	clc
	lda Game.ZTempVar3
	adc #32
	sta $307+$30
	sta $30F+$30
	clc
	lda Game.ZTempVar3
	adc #40
	sta $30B+$30
	sta $313+$30

	clc
	lda Game.ZTempVar3
	adc #48
	sta $307+$40
	sta $30F+$40
	clc
	lda Game.ZTempVar3
	adc #56
	sta $30B+$40
	sta $313+$40

;2x2 cursor info
	lda Game.Current2x2
	asl a
	asl a
	asl a
	asl a
	clc
	adc Game.ZTempVar3
	sta $367
	adc #8
	sta $36B
	clc
	lda Game.ZTempVar4
	adc #40
	sta $364
	sta $368
	jsr Mode2.GetCurrent2x2Add
	ldy Game.Current8x2
	lda (Game.Current2x2L),y
	pha
	and #$0F
	clc
	adc #1
	sta $369
	pla
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #1
	sta $365
	
	ldx Game.Current8x2
	ldy Game.8x2TL.w,x

	lda Game.2x2TL.w,y
	sta $305+$10
	lda Game.2x2TR.w,y
	sta $309+$10
	lda Game.2x2BL.w,y
	sta $30D+$10
	lda Game.2x2BR.w,y
	sta $311+$10

	ldx Game.Current8x2
	ldy Game.8x2TR.w,x

	lda Game.2x2TL.w,y
	sta $305+$20
	lda Game.2x2TR.w,y
	sta $309+$20
	lda Game.2x2BL.w,y
	sta $30D+$20
	lda Game.2x2BR.w,y
	sta $311+$20

	ldx Game.Current8x2
	ldy Game.8x2BL.w,x

	lda Game.2x2TL.w,y
	sta $305+$30
	lda Game.2x2TR.w,y
	sta $309+$30
	lda Game.2x2BL.w,y
	sta $30D+$30
	lda Game.2x2BR.w,y
	sta $311+$30

	ldx Game.Current8x2
	ldy Game.8x2BR.w,x

	lda Game.2x2TL.w,y
	sta $305+$40
	lda Game.2x2TR.w,y
	sta $309+$40
	lda Game.2x2BL.w,y
	sta $30D+$40
	lda Game.2x2BR.w,y
	sta $311+$40

	ldx Game.Current8x2
	ldy Game.8x2Attributes.w,x

	tya
	and #$03
	sta $306.w+$10
	sta $30A.w+$10
	sta $30E.w+$10
	sta $312.w+$10

	tya
	lsr a
	lsr a
	tay
	and #$03
	sta $306.w+$20
	sta $30A.w+$20
	sta $30E.w+$20
	sta $312.w+$20

	tya
	lsr a
	lsr a
	tay
	and #$03
	sta $306.w+$30
	sta $30A.w+$30
	sta $30E.w+$30
	sta $312.w+$30

	tya
	lsr a
	lsr a
	tay
	and #$03
	sta $306.w+$40
	sta $30A.w+$40
	sta $30E.w+$40
	sta $312.w+$40

	sec
	lda Game.ZTempVar4
	sbc #8
	sta $354
	sta $358

	clc
	lda Game.ZTempVar3
	sta $357
	adc #8
	sta $35B

	lda Game.Current8x2
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #1
	sta $355
	lda Game.Current8x2
	and #$0F
	clc
	adc #1
	sta $359
	lda Game.Mode
	bne +
	lda #0
	sta $356
	sta $35A
	sta $366
	sta $36A
	jmp ++
+
	cmp #1
	bne +
	lda #1
	sta $356
	sta $35A
	lda #0
	sta $366
	sta $36A
	jmp ++
+
	lda #0
	sta $356
	sta $35A
	lda #1
	sta $366
	sta $36A
++
	lda Game.CursorY
	ora #$60
	sta Game.TempAdd0H
	lda #$00
	sta Game.TempAdd0L

	ldy Game.CursorX
	lda (Game.TempAdd0L),y
	sta Game.ZTempVar1

	clc
	lda Game.ZTempVar4
	adc #16
	sta $35C
	sta $360

	clc
	lda Game.ZTempVar3
	sta $35F
	adc #8
	sta $363

	lda Game.ZTempVar1
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #1
	sta $35D
	lda Game.ZTempVar1
	and #$0F
	clc
	adc #1
	sta $361
	rts

;***********************************
LoadCHR:
	lda #$00
	sta $2006
	sta $2006
	sta $20
	tay
	lda #$80
	sta $21
	ldx #32
-
	lda ($20),y
	sta $2007
	iny
	bne -
	inc $21
	dex
	bne -
	rts

NMI.Palette.Update:
	lda Game.$2001
	bne +
	rts
+
	lda #$3F
	sta $2006
	lda #$00
	sta $2006

	lda $30
	sta $2007
	lda $31
	sta $2007
	lda $32
	sta $2007
	lda $33
	sta $2007
	lda $34
	sta $2007
	lda $35
	sta $2007
	lda $36
	sta $2007
	lda $37
	sta $2007
	lda $38
	sta $2007
	lda $39
	sta $2007
	lda $3A
	sta $2007
	lda $3B
	sta $2007
	lda $3C
	sta $2007
	lda $3D
	sta $2007
	lda $3E
	sta $2007
	lda $3F
	sta $2007

	lda $30
	sta $2007
	lda $31
	sta $2007
	lda $32
	sta $2007
	lda $33
	sta $2007
	lda $34
	sta $2007
	lda $35
	sta $2007
	lda $36
	sta $2007
	lda $37
	sta $2007
	lda $38
	sta $2007
	lda $39
	sta $2007
	lda $3A
	sta $2007
	lda $3B
	sta $2007
	lda $3C
	sta $2007
	lda $3D
	sta $2007
	lda $3E
	sta $2007
	lda $3F
	sta $2007

	lda #$00
	sta $2006
	sta $2006
+
	rts

DrawEntireScreen:
	lda Game.UpdateWholeScreen
	bne +
	rts
+
	lda Game.CursorX
	pha
	
	lda Game.XCoordL
	sta Game.ZTempVar8
	
	lda Game.XCoordH
	lsr a
	ror Game.ZTempVar8
	lsr a
	ror Game.ZTempVar8
	lsr a
	ror Game.ZTempVar8
	lsr a
	ror Game.ZTempVar8
	lsr a
	ror Game.ZTempVar8
	lsr a
	ror Game.ZTempVar8
	
	lda Game.ZTempVar8
	sta Game.CursorX
	jsr DrawColumnOfTilesCertain
	inc Game.CursorX
	jsr DrawColumnOfTilesCertain
	inc Game.CursorX
	jsr DrawColumnOfTilesCertain
	inc Game.CursorX
	jsr DrawColumnOfTilesCertain
	
	pla
	sta Game.CursorX
	
	lda #0
	sta Game.UpdateWholeScreen
	rts
	
DrawColumnOfTiles:
	lda Game.NewColumn
	bne +
	lda Game.TilePlaced
	bne +
	rts
+

DrawColumnOfTilesCertain:
;Force Vblank and draw entire column of tiles

;Calculate PPU address
	lda Game.CursorX			;Tile Address Low = (Cursor X AND #3 * 8)
						;Tile Address High = (Cursor X AND #4 + $20)
	and #3
	asl a
	asl a
	asl a
	clc
	adc #$80
	sta Game.ZTempVar1
	lda Game.CursorX
	and #4
	ora #$20
	sta Game.ZTempVar2
						;Game.ZTempVar1 - low, Game.ZTempVar2 - high
	lda #$00
	sta Game.$2001
	sta $2001

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

;************
	ldx Game.CursorX
	lda Game.Map.Row0.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.Row1.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.Row2.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.Row3.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.Row4.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.Row5.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.Row6.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.Row7.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.Row8.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.Row9.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.RowA.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.RowB.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX
	lda Game.Map.RowC.w,x
	tay					;The current 8x2 tile selected

	ldx Game.8x2TL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2TL.w,x
	sta $2007
	lda Game.2x2TR.w,x
	sta $2007

	clc
	lda Game.ZTempVar1
	adc #$20
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	adc #0
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006
	ldx Game.8x2TL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2TR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BL.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007
	ldx Game.8x2BR.w,y
	lda Game.2x2BL.w,x
	sta $2007
	lda Game.2x2BR.w,x
	sta $2007

;****************************
;Get attribute data
	lda Game.CursorX			;Attribute Address Low = (Cursor X AND #3 * 2)
						;Attribute Address High = (Cursor X AND #4 + $23)
	and #3
	asl a
	clc
	adc #$C8
	sta Game.ZTempVar1
	lda Game.CursorX
	and #4
	ora #$23
	sta Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006

	ldx Game.CursorX

	lda Game.Map.Row0.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar3
	lda Game.Map.Row1.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar4			;TTttoozz
						;33221100

						;zzoo ttTT
						;0011 2233

						;1100oozz
						;3322TTtt

	lda Game.ZTempVar3
	and #$0F
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	asl a
	asl a
	asl a
	asl a
	ora Game.ZTempVar5
	sta $2007
	lda Game.ZTempVar3
	lsr a
	lsr a
	lsr a
	lsr a
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	and #$F0
	ora Game.ZTempVar5
	sta $2007
;******************
	clc
	lda Game.ZTempVar1
	adc #8
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006


	lda Game.Map.Row2.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar3
	lda Game.Map.Row3.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar4			;TTttoozz
						;33221100

						;zzoo ttTT
						;0011 2233

						;1100oozz
						;3322TTtt

	lda Game.ZTempVar3
	and #$0F
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	asl a
	asl a
	asl a
	asl a
	ora Game.ZTempVar5
	sta $2007
	lda Game.ZTempVar3
	lsr a
	lsr a
	lsr a
	lsr a
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	and #$F0
	ora Game.ZTempVar5
	sta $2007
;******************

	clc
	lda Game.ZTempVar1
	adc #8
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006


	lda Game.Map.Row4.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar3
	lda Game.Map.Row5.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar4			;TTttoozz
						;33221100

						;zzoo ttTT
						;0011 2233

						;1100oozz
						;3322TTtt

	lda Game.ZTempVar3
	and #$0F
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	asl a
	asl a
	asl a
	asl a
	ora Game.ZTempVar5
	sta $2007
	lda Game.ZTempVar3
	lsr a
	lsr a
	lsr a
	lsr a
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	and #$F0
	ora Game.ZTempVar5
	sta $2007
;******************
	clc
	lda Game.ZTempVar1
	adc #8
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006


	lda Game.Map.Row6.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar3
	lda Game.Map.Row7.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar4			;TTttoozz
						;33221100

						;zzoo ttTT
						;0011 2233

						;1100oozz
						;3322TTtt

	lda Game.ZTempVar3
	and #$0F
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	asl a
	asl a
	asl a
	asl a
	ora Game.ZTempVar5
	sta $2007
	lda Game.ZTempVar3
	lsr a
	lsr a
	lsr a
	lsr a
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	and #$F0
	ora Game.ZTempVar5
	sta $2007
;******************
	clc
	lda Game.ZTempVar1
	adc #8
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006


	lda Game.Map.Row8.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar3
	lda Game.Map.Row9.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar4			;TTttoozz
						;33221100

						;zzoo ttTT
						;0011 2233

						;1100oozz
						;3322TTtt

	lda Game.ZTempVar3
	and #$0F
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	asl a
	asl a
	asl a
	asl a
	ora Game.ZTempVar5
	sta $2007
	lda Game.ZTempVar3
	lsr a
	lsr a
	lsr a
	lsr a
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	and #$F0
	ora Game.ZTempVar5
	sta $2007
;******************
	clc
	lda Game.ZTempVar1
	adc #8
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006


	lda Game.Map.RowA.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar3
	lda Game.Map.RowB.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar4			;TTttoozz
						;33221100

						;zzoo ttTT
						;0011 2233

						;1100oozz
						;3322TTtt

	lda Game.ZTempVar3
	and #$0F
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	asl a
	asl a
	asl a
	asl a
	ora Game.ZTempVar5
	sta $2007
	lda Game.ZTempVar3
	lsr a
	lsr a
	lsr a
	lsr a
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	and #$F0
	ora Game.ZTempVar5
	sta $2007
;******************
	clc
	lda Game.ZTempVar1
	adc #8
	sta Game.ZTempVar1
	lda Game.ZTempVar2
	sta $2006
	lda Game.ZTempVar1
	sta $2006


	lda Game.Map.RowC.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar3
	lda Game.Map.Row3.w,x
	tay					;The current 8x2 tile selected
	lda Game.8x2Attributes.w,y
	sta Game.ZTempVar4			;TTttoozz
						;33221100

						;zzoo ttTT
						;0011 2233

						;1100oozz
						;3322TTtt

	lda Game.ZTempVar3
	and #$0F
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	asl a
	asl a
	asl a
	asl a
	ora Game.ZTempVar5
	sta $2007
	lda Game.ZTempVar3
	lsr a
	lsr a
	lsr a
	lsr a
	sta Game.ZTempVar5
	lda Game.ZTempVar4
	and #$F0
	ora Game.ZTempVar5
	sta $2007
;******************
	lda #$00
	sta $2006
	sta $2006

	lda #$1E
	sta Game.$2001
	rts