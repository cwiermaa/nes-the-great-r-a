Game.ObjectDraw.PushObject:
;Function: Given the address of an object's RAM, the graphical information of that object will be pushed onto the graphics
;stack and that object may be drawn.
;Expected: Address of object information stored in Game.AIRAM.PointerL, and at (Address) the Type, Graphical Map ;Address, X Coordinate, and Y Coordinate.
;EDIT: Graphics Map Address loaded in (high)A and (low)Y, type in X.

	pha
	tya
	pha
	txa
	pha

	ldx Game.ObjectDraw.GraphicsStack.Index.w
	cpx #$7E
	beq +

	pla
	sta Game.ObjectDraw.GraphicsStack.Type.w,x
	pla
	sta Game.ObjectDraw.GraphicsStack.MapL.w,x
	pla
	sta Game.ObjectDraw.GraphicsStack.MapH.w,x
	ldy Game.AIRAM.Current
	lda AIRAM.3.w,y
	sta Game.ObjectDraw.GraphicsStack.XL.w,x
	lda AIRAM.4.w,y
	sta Game.ObjectDraw.GraphicsStack.XH.w,x
	lda AIRAM.2.w,y
	sta Game.ObjectDraw.GraphicsStack.Y.w,x
	clc
	lda Game.ObjectDraw.GraphicsStack.Index
	adc #6
	sta Game.ObjectDraw.GraphicsStack.Index
	inc Game.ObjectDraw.NumOfObjects
+
	rts

Game.ObjectDraw.PushSingle.0:
;Function: Given the Y offset of an object's RAM and the tile, the single sprite will be pushed onto the graphics stack ;depending on the information given.
;Expected: Address of object in Game.AIRAM.PointerL and Y offset in array which gives coordinates in order XL, XH, Y. ;And Tile loaded in A. Assumes attribute 0 and Type 3.

	ldx Game.ObjectDraw.GraphicsStack.Index.w
	cpx #$7E
	beq +
	sta Game.ObjectDraw.GraphicsStack.Tile.w,x
	lda #3
	sta Game.ObjectDraw.GraphicsStack.Type.w,x
	lda #0
	sta Game.ObjectDraw.GraphicsStack.Attribute.w,x
	ldy Game.AIRAM.Current
	lda Game.Items.ItemXL.w,y
	sta Game.ObjectDraw.GraphicsStack.XL.w,x
	lda Game.Items.ItemXH.w,y
	sta Game.ObjectDraw.GraphicsStack.XH.w,x
	lda Game.Items.ItemY.w,y
	sta Game.ObjectDraw.GraphicsStack.Y.w,x
	clc
	lda Game.ObjectDraw.GraphicsStack.Index
	adc #6
	sta Game.ObjectDraw.GraphicsStack.Index
	inc Game.ObjectDraw.NumOfObjects
+
	rts

Game.ObjectDraw.PushSingle.1:

	ldx Game.ObjectDraw.GraphicsStack.Index.w
	cpx #$7E
	beq +
	sta Game.ObjectDraw.GraphicsStack.Tile.w,x
	lda #3
	sta Game.ObjectDraw.GraphicsStack.Type.w,x
	lda #1
	sta Game.ObjectDraw.GraphicsStack.Attribute.w,x
	ldy Game.AIRAM.Current
	lda Game.Items.ItemXL.w,y
	sta Game.ObjectDraw.GraphicsStack.XL.w,x
	lda Game.Items.ItemXH.w,y
	sta Game.ObjectDraw.GraphicsStack.XH.w,x
	lda Game.Items.ItemY.w,y
	sta Game.ObjectDraw.GraphicsStack.Y.w,x
	clc
	lda Game.ObjectDraw.GraphicsStack.Index
	adc #6
	sta Game.ObjectDraw.GraphicsStack.Index
	inc Game.ObjectDraw.NumOfObjects
+
	rts

Game.ObjectDraw.PushSingle.2:
	ldx Game.ObjectDraw.GraphicsStack.Index.w
	cpx #$7E
	beq +
	sta Game.ObjectDraw.GraphicsStack.Tile.w,x
	lda #3
	sta Game.ObjectDraw.GraphicsStack.Type.w,x
	lda #2
	sta Game.ObjectDraw.GraphicsStack.Attribute.w,x
	ldy Game.AIRAM.Current
	lda Game.Items.ItemXL.w,y
	sta Game.ObjectDraw.GraphicsStack.XL.w,x
	lda Game.Items.ItemXH.w,y
	sta Game.ObjectDraw.GraphicsStack.XH.w,x
	lda Game.Items.ItemY.w,y
	sta Game.ObjectDraw.GraphicsStack.Y.w,x
	clc
	lda Game.ObjectDraw.GraphicsStack.Index
	adc #6
	sta Game.ObjectDraw.GraphicsStack.Index
	inc Game.ObjectDraw.NumOfObjects
+
	rts

Game.ObjectDraw.PushSingle.3:
	ldx Game.ObjectDraw.GraphicsStack.Index.w
	cpx #$7E
	beq +
	sta Game.ObjectDraw.GraphicsStack.Tile.w,x
	lda #3
	sta Game.ObjectDraw.GraphicsStack.Type.w,x
	lda #3
	sta Game.ObjectDraw.GraphicsStack.Attribute.w,x
	ldy Game.AIRAM.Current
	lda Game.Items.ItemXL.w,y
	sta Game.ObjectDraw.GraphicsStack.XL.w,x
	lda Game.Items.ItemXH.w,y
	sta Game.ObjectDraw.GraphicsStack.XH.w,x
	lda Game.Items.ItemY.w,y
	sta Game.ObjectDraw.GraphicsStack.Y.w,x
	clc
	lda Game.ObjectDraw.GraphicsStack.Index
	adc #6
	sta Game.ObjectDraw.GraphicsStack.Index
	inc Game.ObjectDraw.NumOfObjects
+
	rts

Game.ObjectDraw.PushSingle.Player.0:
;Function: Given the Y offset of an object's RAM and the tile, the single sprite will be pushed onto the graphics stack ;depending on the information given.
;Expected: Y offset in bullet info array which gives coordinates in order XL, XH, Y. ;And Tile loaded in A. Assumes attribute 0 and Type 3.

	ldx Game.ObjectDraw.GraphicsStack.Index.w
	cpx #$7E
	beq +
	sta Game.ObjectDraw.GraphicsStack.Tile.w,x
	lda #3
	sta Game.ObjectDraw.GraphicsStack.Type.w,x
	lda #0
	sta Game.ObjectDraw.GraphicsStack.Attribute.w,x
	sec
	lda Game.Player.Bullet0,y
	sbc #4
	sta Game.ObjectDraw.GraphicsStack.XL.w,x
	iny
	lda Game.Player.Bullet0,y
	sbc #0
	sta Game.ObjectDraw.GraphicsStack.XH.w,x
	iny
	sec
	lda Game.Player.Bullet0,y
	sbc #4
	sta Game.ObjectDraw.GraphicsStack.Y.w,x
	clc
	lda Game.ObjectDraw.GraphicsStack.Index
	adc #6
	sta Game.ObjectDraw.GraphicsStack.Index
	inc Game.ObjectDraw.NumOfObjects
+
	rts

Game.ObjectDraw.PushSingle.Player.0.Flipped:
;Function: Given the Y offset of an object's RAM and the tile, the single sprite will be pushed onto the graphics stack ;depending on the information given.
;Expected: Y offset in bullet info array which gives coordinates in order XL, XH, Y. ;And Tile loaded in A. Assumes attribute 0 and Type 3.

	ldx Game.ObjectDraw.GraphicsStack.Index.w
	cpx #$7E
	beq +
	sta Game.ObjectDraw.GraphicsStack.Tile.w,x
	lda #3
	sta Game.ObjectDraw.GraphicsStack.Type.w,x
	lda #$40
	sta Game.ObjectDraw.GraphicsStack.Attribute.w,x
	sec
	lda Game.Player.Bullet0,y
	sbc #4
	sta Game.ObjectDraw.GraphicsStack.XL.w,x
	iny
	lda Game.Player.Bullet0,y
	sbc #0
	sta Game.ObjectDraw.GraphicsStack.XH.w,x
	iny
	sec
	lda Game.Player.Bullet0,y
	sbc #4
	sta Game.ObjectDraw.GraphicsStack.Y.w,x
	clc
	lda Game.ObjectDraw.GraphicsStack.Index
	adc #6
	sta Game.ObjectDraw.GraphicsStack.Index
	inc Game.ObjectDraw.NumOfObjects
+
	rts

Game.ObjectDraw.DrawObjects:
	lda Game.ObjectDraw.NumOfObjects
	beq ++
	clc
	lda Game.ObjectDraw.OAMPage.Index
	adc #$04
	sta Game.ObjectDraw.OAMPage.Index
	lda #63
	sta Game.ObjectDraw.OAMPage.SpritesLeft
	ldy #0
	sty Game.ObjectDraw.GraphicsStack.Index.w

-
	lda Game.ObjectDraw.GraphicsStack.Type.w,y
	tax
	lda Game.ObjectDraw.TypeJumpTableL.w,x
	sta Standard.Main.TempAdd0L
	lda Game.ObjectDraw.TypeJumpTableH.w,x
	sta Standard.Main.TempAdd0H
	jmp (Standard.Main.TempAdd0L)

Game.ObjectDraw.DrawObjectsReturn:
	dec Game.ObjectDraw.NumOfObjects
	bne -
	jsr Game.ObjectDraw.ClearUnused
++
	rts


Game.ObjectDraw.DrawNormal:
;Function: Given an address of data, 16-bit X coordinate, and 8-bit Y coordinate, the metasprite with the info at the address
;Will be copied to OAM. This draws the object unflipped.

	lda Game.ObjectDraw.GraphicsStack.MapL.w,y
	sta Standard.Main.TempAdd0L
	lda Game.ObjectDraw.GraphicsStack.MapH.w,y
	sta Standard.Main.TempAdd0H

	sec
	lda Game.ObjectDraw.GraphicsStack.XL.w,y
	sbc Game.ScreenXL
	sta Standard.Main.ZTempVar1
	lda Game.ObjectDraw.GraphicsStack.XH.w,y
	sbc Game.ScreenXH
	sta Standard.Main.ZTempVar2

	clc
	lda Game.ObjectDraw.GraphicsStack.Y.w,y
	adc #31						;The sprite delay thing
	sta Standard.Main.ZTempVar3
	
	bcc +
	
	tya
	clc
	adc #6
	tay
	jmp Game.ObjectDraw.DrawObjectsReturn
+
	tya
	pha
	ldy #0
	lda (Standard.Main.TempAdd0L),y
	sta Standard.Main.ZTempVar4
	iny
	iny
	ldx Game.ObjectDraw.OAMPage.Index

-
	cpx #0
	bne +
	ldx #12

+
	tya
	pha
	clc
	lda Standard.Main.ZTempVar3
	adc (Standard.Main.TempAdd0L),y
	bcs +
	sta Standard.Main.ZTempVar5
	iny
	clc
	lda Standard.Main.ZTempVar1
	adc (Standard.Main.TempAdd0L),y
	sta Standard.Main.ZTempVar6
	lda Standard.Main.ZTempVar2
	adc #0
	bne +

	lda Standard.Main.ZTempVar5
	sta Game.ObjectDraw.OAMPage.Y.w,x
	lda Standard.Main.ZTempVar6
	sta Game.ObjectDraw.OAMPage.X.w,x
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectDraw.OAMPage.Tile.w,x
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectDraw.OAMPage.Attribute.w,x
	

	pla
	clc
	adc #4
	tay

	txa
	clc
	adc #12
	tax

	dec Game.ObjectDraw.OAMPage.SpritesLeft
	beq ++
	dec Standard.Main.ZTempVar4
	bne -
	pla
	clc
	adc #6
	tay
	stx Game.ObjectDraw.OAMPage.Index.w
	jmp Game.ObjectDraw.DrawObjectsReturn
+
	pla
	clc
	adc #4
	tay

	dec Standard.Main.ZTempVar4
	bne -

	pla
	clc
	adc #6
	tay
	stx Game.ObjectDraw.OAMPage.Index.w
	jmp Game.ObjectDraw.DrawObjectsReturn
++
	pla
	clc
	adc #6
	tay
	rts

;******************
Game.ObjectDraw.DrawFlipped:
;Function: Given an address of data, 16-bit X coordinate, and 8-bit Y coordinate, the metasprite with the info at the address
;Will be copied to OAM. This draws the object flipped.

	lda Game.ObjectDraw.GraphicsStack.MapL.w,y
	sta Standard.Main.TempAdd0L
	lda Game.ObjectDraw.GraphicsStack.MapH.w,y
	sta Standard.Main.TempAdd0H

	sec
	lda Game.ObjectDraw.GraphicsStack.XL.w,y
	sbc Game.ScreenXL
	sta Standard.Main.ZTempVar1
	lda Game.ObjectDraw.GraphicsStack.XH.w,y
	sbc Game.ScreenXH
	sta Standard.Main.ZTempVar2

	clc
	lda Game.ObjectDraw.GraphicsStack.Y.w,y
	adc #31						;The sprite delay thing
	sta Standard.Main.ZTempVar3

	bcc +
	
	tya
	clc
	adc #6
	tay
	jmp Game.ObjectDraw.DrawObjectsReturn
+

	tya
	pha
	ldy #0
	lda (Standard.Main.TempAdd0L),y
	sta Standard.Main.ZTempVar4
	iny
	clc
	lda Standard.Main.ZTempVar1
	adc (Standard.Main.TempAdd0L),y
	sta Standard.Main.ZTempVar1
	lda Standard.Main.ZTempVar2
	adc #0
	sta Standard.Main.ZTempVar2
	iny
	ldx Game.ObjectDraw.OAMPage.Index

-
	cpx #0
	bne +
	ldx #12

+
	tya
	pha
	clc
	lda Standard.Main.ZTempVar3
	adc (Standard.Main.TempAdd0L),y
	bcs +
	sta Standard.Main.ZTempVar5
	iny
	sec
	lda Standard.Main.ZTempVar1
	sbc (Standard.Main.TempAdd0L),y
	sta Standard.Main.ZTempVar6
	lda Standard.Main.ZTempVar2
	sbc #0
	bne +

	lda Standard.Main.ZTempVar5
	sta Game.ObjectDraw.OAMPage.Y.w,x
	lda Standard.Main.ZTempVar6
	sta Game.ObjectDraw.OAMPage.X.w,x
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectDraw.OAMPage.Tile.w,x
	iny
	lda (Standard.Main.TempAdd0L),y
	eor #$40
	sta Game.ObjectDraw.OAMPage.Attribute.w,x
	

	pla
	clc
	adc #4
	tay

	txa
	clc
	adc #12
	tax

	dec Game.ObjectDraw.OAMPage.SpritesLeft
	beq ++
	dec Standard.Main.ZTempVar4
	bne -
	pla
	clc
	adc #6
	tay
	stx Game.ObjectDraw.OAMPage.Index.w
	jmp Game.ObjectDraw.DrawObjectsReturn

+
	pla
	clc
	adc #4
	tay

	dec Standard.Main.ZTempVar4
	bne -

	pla
	clc
	adc #6
	tay
	stx Game.ObjectDraw.OAMPage.Index.w
	jmp Game.ObjectDraw.DrawObjectsReturn
++
	pla
	clc
	adc #6
	tay
	rts

Game.ObjectDraw.DrawLiteral:

	tya
	pha

	lda Game.ObjectDraw.GraphicsStack.MapL.w,y
	sta Standard.Main.TempAdd0L
	lda Game.ObjectDraw.GraphicsStack.MapH.w,y
	sta Standard.Main.TempAdd0H

	ldy #0
	lda (Standard.Main.TempAdd0L),y
	sta Standard.Main.ZTempVar4
	iny
	ldx Game.ObjectDraw.OAMPage.Index.w
-
	cpx #0
	bne +
	ldx #12
+
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectDraw.OAMPage.Y.w,x
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectDraw.OAMPage.Tile.w,x
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectDraw.OAMPage.Attribute.w,x
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectDraw.OAMPage.X.w,x
	iny

	txa
	clc
	adc #12
	tax

	dec Game.ObjectDraw.OAMPage.SpritesLeft
	beq ++
	dec Standard.Main.ZTempVar4
	bne -

	pla
	clc
	adc #6
	tay
	stx Game.ObjectDraw.OAMPage.Index.w
	jmp Game.ObjectDraw.DrawObjectsReturn
++
	pla
	rts
Game.ObjectDraw.DrawSingle:
	tya
	pha

	sec
	lda Game.ObjectDraw.GraphicsStack.XL.w,y
	sbc Game.ScreenXL
	sta Standard.Main.ZTempVar1
	lda Game.ObjectDraw.GraphicsStack.XH.w,y
	sbc Game.ScreenXH
	bne +

	clc
	lda Game.ObjectDraw.GraphicsStack.Y.w,y
	adc #31						;The sprite delay thing
	sta Standard.Main.ZTempVar3
	bcs +

	ldx Game.ObjectDraw.OAMPage.Index
	cpx #0
	bne ++
	ldx #12

++
	lda Standard.Main.ZTempVar1
	sta Game.ObjectDraw.OAMPage.X,x
	lda Standard.Main.ZTempVar3
	sta Game.ObjectDraw.OAMPage.Y,x
	lda Game.ObjectDraw.GraphicsStack.MapL.w,y
	sta Game.ObjectDraw.OAMPage.Tile.w,x
	lda Game.ObjectDraw.GraphicsStack.MapH.w,y
	sta Game.ObjectDraw.OAMPage.Attribute.w,x

	clc
	txa
	adc #12
	sta Game.ObjectDraw.OAMPage.Index.w
	dec Game.ObjectDraw.OAMPage.SpritesLeft
	bne +
	pla
	rts
+
	pla
	clc
	adc #6
	tay
	jmp Game.ObjectDraw.DrawObjectsReturn

;**************
Game.ObjectDraw.ClearUnused:
	ldy Game.ObjectDraw.OAMPage.SpritesLeft
	ldx Game.ObjectDraw.OAMPage.Index
	cpx #0
	bne +
	ldx #12
+

	clc
-
	lda #$FF
	sta $300,x
	txa
	adc #12
	tax
	bcc +
	clc
	bne +
	ldx #12
+
	dey
	bne -
	rts

Game.ObjectDraw.TypeJumpTableL:
	.db <Game.ObjectDraw.DrawNormal,<Game.ObjectDraw.DrawFlipped,<Game.ObjectDraw.DrawLiteral,<Game.ObjectDraw.DrawSingle

Game.ObjectDraw.TypeJumpTableH:
	.db >Game.ObjectDraw.DrawNormal,>Game.ObjectDraw.DrawFlipped,>Game.ObjectDraw.DrawLiteral,>Game.ObjectDraw.DrawSingle
