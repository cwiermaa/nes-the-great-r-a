Game.Main.LevelDecode.RetrieveColumn:
;Function: Given an X coordinate and a starting address of BG data, the next column of tiles and attributes
;to be copied to the PPU is retrieved. It takes the BG data below the given X coordinate and stores it into
;Game.PPUUpdates.TileColumn and Game.PPUUpdates.AttributeColumn
;Expected: Absolute X pixel coordinate, low in X, high in Y. Proper starting address of level data in
;Game.LevelAddressL/H.

	stx Standard.Main.ZTempVar1			;3
	stx Standard.Main.ZTempVar4			;6
	tya						;8
	sty Standard.Main.ZTempVar2			;11
	asl Standard.Main.ZTempVar1			;16
	rol a						;18
	asl Standard.Main.ZTempVar1			;23
	rol a						;25
	sta Standard.Main.ZTempVar3			;Current column of tile data	26

	ldy #0						;28
	ldx #0						;30
	sty Standard.Main.ZTempVar5			;33
-
	ldy Standard.Main.ZTempVar5			;3
	lda (Game.LevelAddressL),y		;8
	sta Standard.Main.TempAdd0L			;11
	iny						;13
	lda (Game.LevelAddressL),y		;18
	sta Standard.Main.TempAdd0H			;21
	iny						;23
	sty Standard.Main.ZTempVar5			;26
	ldy Standard.Main.ZTempVar3			;29
	lda (Standard.Main.TempAdd0L),y			;34
	sta Game.Main.LevelDecode.8x2Column.w,x	;38
	inx						;40
	cpx #13						;42
	bne -						;45

							;45 * 13 = 585 - 1 = 584 + 33 = 617

							;All 8x2 metatiles are in the proper array

	lda Standard.Main.ZTempVar4			;620
	and #$30					;623
	bne +						;626
	lda #<Game.Data.TileDefs.8x200
	sta Standard.Main.TempAdd0L
	lda #>Game.Data.TileDefs.8x200
	sta Standard.Main.TempAdd0H
	jmp ++
+
	cmp #$10					;628
	bne +						;631
	lda #<Game.Data.TileDefs.8x201
	sta Standard.Main.TempAdd0L
	lda #>Game.Data.TileDefs.8x201
	sta Standard.Main.TempAdd0H
	jmp ++

+
	cmp #$20					;633
	bne +						;636
	lda #<Game.Data.TileDefs.8x202
	sta Standard.Main.TempAdd0L
	lda #>Game.Data.TileDefs.8x202
	sta Standard.Main.TempAdd0H
	jmp ++

+
	lda #<Game.Data.TileDefs.8x203		;638
	sta Standard.Main.TempAdd0L			;641
	lda #>Game.Data.TileDefs.8x203		;643
	sta Standard.Main.TempAdd0H			;646

++

	ldx #0						;648
-
	ldy Game.Main.LevelDecode.8x2Column.w,x	;4
	lda (Standard.Main.TempAdd0L),y			;9
	sta Game.Main.LevelDecode.2x2Column.w,x	;13
	inx						;15
	cpx #13						;17
	bne -						;All 2x2 tiles have been fetched 20

							;20 * 13 = 260 + 648 = 908 - 1 = 907

	lda Standard.Main.ZTempVar4			;910
	and #8						;912
	bne +						;914

							;Do this if we're in the left column of the metatile
	ldx #0						;916
	stx Standard.Main.ZTempVar6			;919
	stx Standard.Main.ZTempVar7			;922
-
	ldx Standard.Main.ZTempVar6			;3
	ldy Game.Main.LevelDecode.2x2Column.w,x	;7
	ldx Standard.Main.ZTempVar7			;10
	lda Game.Data.TileDefs.2x2TL.w,y		;14
	sta Game.PPUUpdates.TileColumn.w,x			;18
	lda Game.Data.TileDefs.2x2BL.w,y		;22
	inx						;24
	sta Game.PPUUpdates.TileColumn.w,x			;28
	inx						;30
	inc Standard.Main.ZTempVar6			;35
	stx Standard.Main.ZTempVar7			;38
	cpx #26						;40
	bne -						;43
							;43 * 13 = 559 + 922 = 1481 - 1 = 1480
	jmp ++						;1483
+
	ldx #0
	stx Standard.Main.ZTempVar6
	stx Standard.Main.ZTempVar7
-
	ldx Standard.Main.ZTempVar6
	ldy Game.Main.LevelDecode.2x2Column.w,x
	ldx Standard.Main.ZTempVar7
	lda Game.Data.TileDefs.2x2TR.w,y
	sta Game.PPUUpdates.TileColumn.w,x
	lda Game.Data.TileDefs.2x2BR.w,y
	inx
	sta Game.PPUUpdates.TileColumn.w,x
	inx
	inc Standard.Main.ZTempVar6
	stx Standard.Main.ZTempVar7
	cpx #26
	bne -

++

	lda Standard.Main.ZTempVar4			;1486
	and #$20					;1488
	bne +						;1490
						;Load attribute data
							;TTttoozz
							;33221100

							;zzoo ttTT
							;0011 2233

							;1100oozz

	ldx #0						;1492
	stx Standard.Main.ZTempVar6			;1495
	stx Standard.Main.ZTempVar2			;1498
-
	ldx Standard.Main.ZTempVar2			;3
	ldy Game.Main.LevelDecode.8x2Column.w,x	;7
	lda Game.Data.TileDefs.Attributes.w,y	;11
	and #$0F					;13
	sta Standard.Main.ZTempVar5			;16
	inx						;18
	ldy Game.Main.LevelDecode.8x2Column.w,x	;22
	lda Game.Data.TileDefs.Attributes.w,y	;26
	asl a						;28
	asl a						;30
	asl a						;32
	asl a						;34
	ora Standard.Main.ZTempVar5			;37
	sta Standard.Main.ZTempVar5			;40
	inx						;42
	stx Standard.Main.ZTempVar2			;45
	ldx Standard.Main.ZTempVar6			;48
	lda Standard.Main.ZTempVar5			;51
	sta Game.PPUUpdates.AttributeColumn.w,x		;55
	inx						;57
	stx Standard.Main.ZTempVar6			;60
	cpx #7						;62
	bne -						;65
							;65 * 7 = 455 + 1498 = 1953
	jmp ++						;1956
+
							
							;00112233
							;zzoottTT

							;33221100
							;TTttoozz

							;0011 2233
							;zzoo ttTT

							;TTtt3322


	ldx #0

	stx Standard.Main.ZTempVar6			;Index of attribute column
	stx Standard.Main.ZTempVar2			;Index of 8x2 column
-
	ldx Standard.Main.ZTempVar2				;Load current index of 8x2 column
	ldy Game.Main.LevelDecode.8x2Column.w,x		;Load 8x2 tile as index for attribute definitions
	lda Game.Data.TileDefs.Attributes.w,y		;Load attribute value of 8x2 tile
	lsr a
	lsr a
	lsr a
	lsr a						;Keep high 4 bits
	sta Standard.Main.ZTempVar5				;Save them
	inx							;Increase index of 8x2 column
	ldy Game.Main.LevelDecode.8x2Column.w,x		;Get next 8x2 tile ID
	lda Game.Data.TileDefs.Attributes.w,y		;Get next 8x2 attribute
	and #$F0						;Take high 4 bits, make them the low bits
	
	
	ora Standard.Main.ZTempVar5				;Weld it to the high 4 bits of the other attribute data
	sta Standard.Main.ZTempVar5				;To complete the attribute.
	inx							;Increase index of 8x2 column
	stx Standard.Main.ZTempVar2				;Save it
	ldx Standard.Main.ZTempVar6				;Load index of attribute column in X
	lda Standard.Main.ZTempVar5				;Load complete attribute entry
	sta Game.PPUUpdates.AttributeColumn.w,x			;Store it in the attribute array
	inx							;Increase index of attribute column
	stx Standard.Main.ZTempVar6				;Save it
	cpx #7							;If there have been 7 entries, it's done.
	bne -
++

								;Approximately 2000 cycles (I've heard of worse)
	rts

Game.Main.LevelDecode.RetrieveColumnOfTypes:
;Function: Given an X coordinate and a starting address of BG data, a column of tile types is copied to $600-$700.
;Expected: Absolute X pixel coordinate, low in X, high in Y. Proper starting address of level data in
;Game.LevelAddressL/H.

	stx Standard.Main.ZTempVar1			;3
	stx Standard.Main.ZTempVar4			;6
	tya						;8
	sty Standard.Main.ZTempVar2			;11
	asl Standard.Main.ZTempVar1			;16
	rol a						;18
	asl Standard.Main.ZTempVar1			;23
	rol a						;25
	sta Standard.Main.ZTempVar3			;Current column of tile data	26

	ldy #0						;28
	ldx #0						;30
	sty Standard.Main.ZTempVar5			;33
-
	ldy Standard.Main.ZTempVar5			;3
	lda (Game.LevelAddressL),y		;8
	sta Standard.Main.TempAdd0L			;11
	iny						;13
	lda (Game.LevelAddressL),y		;18
	sta Standard.Main.TempAdd0H			;21
	iny						;23
	sty Standard.Main.ZTempVar5			;26
	ldy Standard.Main.ZTempVar3			;29
	lda (Standard.Main.TempAdd0L),y			;34
	sta Game.Main.LevelDecode.8x2Column.w,x	;38
	inx						;40
	cpx #13						;42
	bne -						;45

							;45 * 13 = 585 - 1 = 584 + 33 = 617

							;All 8x2 metatiles are in the proper array

	lda Standard.Main.ZTempVar4			;620
	and #$30					;623
	bne +						;626
	lda #<Game.Data.TileDefs.8x200
	sta Standard.Main.TempAdd0L
	lda #>Game.Data.TileDefs.8x200
	sta Standard.Main.TempAdd0H
	jmp ++
+
	cmp #$10					;628
	bne +						;631
	lda #<Game.Data.TileDefs.8x201
	sta Standard.Main.TempAdd0L
	lda #>Game.Data.TileDefs.8x201
	sta Standard.Main.TempAdd0H
	jmp ++

+
	cmp #$20					;633
	bne +						;636
	lda #<Game.Data.TileDefs.8x202
	sta Standard.Main.TempAdd0L
	lda #>Game.Data.TileDefs.8x202
	sta Standard.Main.TempAdd0H
	jmp ++

+
	lda #<Game.Data.TileDefs.8x203		;638
	sta Standard.Main.TempAdd0L			;641
	lda #>Game.Data.TileDefs.8x203		;643
	sta Standard.Main.TempAdd0H			;646

++

	ldx #0						;648
-
	ldy Game.Main.LevelDecode.8x2Column.w,x	;4
	lda (Standard.Main.TempAdd0L),y			;9
	sta Game.Main.LevelDecode.2x2Column.w,x	;13
	inx						;15
	cpx #13						;17
	bne -						;All 2x2 tiles have been fetched 20

							;20 * 13 = 260 + 648 = 908 - 1 = 907

;Load tile types in RAM.
;maybe
	lda Standard.Main.ZTempVar4			;910
	and #$F0					;912
	sta Standard.Main.TempAdd0L			;915

	lda Standard.Main.ZTempVar2			;918
	and #1						;920
	ora #6						;922
	sta Standard.Main.TempAdd0H			;925

	ldy #0						;927
-
	lda Game.Main.LevelDecode.2x2Column.w,y	;4
	tax						;6
	lda Game.Data.TileDefs.TileTypes.w,x	;10
	sta (Standard.Main.TempAdd0L),y			;15
	iny						;17
	cpy #13						;19
	bne -						;22
							;22 * 13 = 286

							;Approximately 1200 cycles (making the whole level decode 3200 									;cycles)
	rts

;***********************************************************
;Single Type Retrieval

Game.Main.AI.RetrieveSingleType.SkewX:
;This retrieves a tile type for enemy coordinates + a certain value for X coordinates.
;Expected: Width in A.

	clc
	adc Game.AI.XL
	tax
	lda Game.AI.XH
	adc #0
	pha
	lda Game.AI.YH
	tay
	pla
	jmp Game.Main.LevelDecode.RetrieveSingleType


Game.Main.AI.RetrieveSingleType.SkewY:
;This retrieves a tile type for enemy coordinates + a certain value for Y coordinates.
;Expected: Height in A.
;Warning: Destroys ZTempVar1

	clc
	adc Game.AI.YH
	sta Standard.Main.ZTempVar1

	lda Game.AI.XL
	tax

	lda Game.AI.XH
	ldy Standard.Main.ZTempVar1
	jmp Game.Main.LevelDecode.RetrieveSingleType

Game.Main.AI.RetrieveSingleType.SkewXY:
;This retrieves a tile type for enemy coordinates + a certain value for Y coordinates.
;Expected: Height in A, Width in X.

;Warning: Destroys ZTempVar1

	clc
	adc Game.AI.YH
	sta Standard.Main.ZTempVar1

	txa
	clc
	adc Game.AI.XL
	tax

	lda Game.AI.XH
	adc #0

	ldy Standard.Main.ZTempVar1
	jmp Game.Main.LevelDecode.RetrieveSingleType

Game.Main.AI.RetrieveSingleType:
	lda Game.AI.XL
	tax
	lda Game.AI.XH
	pha
	lda Game.AI.YH
	tay
	pla

Game.Main.LevelDecode.RetrieveSingleType:
;Total time: 31 cycles
;Function: Given an 8-bit Y coordinate and a 16-bit in-range (128 pixels before to 128 pixel beyond the screen) X coordinate, ;the tile type at those coordinates will be retrieved and returned in A.
;Expected: Y Coordinate in Y, X coordinate H in A, X coordinate L in X.
;Warnings: TempAdd0L/H are destroyed in this routine.

	and #1								;2
	ora #6								;4
	sta Standard.Main.TempAdd0H			;7 Get high byte depending on X High
	txa									;9
	and #$F0							;11 Get low byte (data row in $600-$700)
	sta Standard.Main.TempAdd0L			;14
	tya									;16 Y divided by 16 = tile row
	lsr a								;18
	lsr a								;20
	lsr a								;22
	lsr a								;24
	tay									;26
	lda (Standard.Main.TempAdd0L),y		;31 Y is the current tile row
	rts

;***********************************************************
;Retrieval of column of two types
Game.Main.AI.RetrieveColumnOfTwoTypes.SkewX:
;This retrieves a tile type for enemy coordinates + a certain value for X coordinates.
;Expected: Width in A.

	clc
	adc Game.AI.XL
	tax
	lda Game.AI.XH
	adc #0
	pha
	lda Game.AI.YH
	tay
	pla
	jmp Game.Main.LevelDecode.RetrieveColumnOfTwoTypes


Game.Main.AI.RetrieveColumnOfTwoTypes.SkewY:
;This retrieves a tile type for enemy coordinates + a certain value for Y coordinates.
;Expected: Height in A.
;Warning: Destroys ZTempVar1

	clc
	adc Game.AI.YH
	sta Standard.Main.ZTempVar1

	lda Game.AI.XL
	tax

	lda Game.AI.XH
	ldy Standard.Main.ZTempVar1
	jmp Game.Main.LevelDecode.RetrieveColumnOfTwoTypes

Game.Main.AI.RetrieveColumnOfTwoTypes.SkewXY:
;This retrieves a tile type for enemy coordinates + a certain value for Y coordinates.
;Expected: Height in A, Width in X.

;Warning: Destroys ZTempVar1

	clc
	adc Game.AI.YH
	sta Standard.Main.ZTempVar1

	txa
	clc
	adc Game.AI.XL
	tax

	lda Game.AI.XH
	adc #0

	ldy Standard.Main.ZTempVar1
	jmp Game.Main.LevelDecode.RetrieveColumnOfTwoTypes

Game.Main.AI.RetrieveColumnOfTwoTypes:
	lda Game.AI.XL
	tax
	lda Game.AI.XH
	pha
	lda Game.AI.YH
	tay
	pla

Game.Main.LevelDecode.RetrieveColumnOfTwoTypes:
;Total time: 47 cycles

	and #1								;2
	ora #6								;4
	sta Standard.Main.TempAdd0H			;7 Get high byte depending on X High
	txa									;9
	and #$F0							;11 Get low byte (data row in $600-$700)
	sta Standard.Main.TempAdd0L			;14
	tya									;16 Y divided by 16 = tile row
	lsr a								;18
	lsr a								;20
	lsr a								;22
	lsr a								;24
	tay									;26
	lda (Standard.Main.TempAdd0L),y		;31 Y is the current tile row
	pha									;34
	iny									;36
	lda (Standard.Main.TempAdd0L),y		;41
	tax									;43
	pla									;47
	rts

;***********************************************************
;Retrieval of column of three types

Game.Main.AI.RetrieveColumnOfThreeTypes.SkewX:
;This retrieves a tile type for enemy coordinates + a certain value for X coordinates.
;Expected: Width in A.

	clc
	adc Game.AI.XL
	tax
	lda Game.AI.XH
	adc #0
	pha
	lda Game.AI.YH
	tay
	pla
	jmp Game.Main.LevelDecode.RetrieveColumnOfThreeTypes


Game.Main.AI.RetrieveColumnOfThreeTypes.SkewY:
;This retrieves a tile type for enemy coordinates + a certain value for Y coordinates.
;Expected: Height in A.
;Warning: Destroys ZTempVar1

	clc
	adc Game.AI.YH
	sta Standard.Main.ZTempVar1

	lda Game.AI.XL
	tax

	lda Game.AI.XH
	ldy Standard.Main.ZTempVar1
	jmp Game.Main.LevelDecode.RetrieveColumnOfThreeTypes

Game.Main.AI.RetrieveColumnOfThreeTypes.SkewXY:
;This retrieves a tile type for enemy coordinates + a certain value for Y coordinates.
;Expected: Height in A, Width in X.

;Warning: Destroys ZTempVar1

	clc
	adc Game.AI.YH
	sta Standard.Main.ZTempVar1

	txa
	clc
	adc Game.AI.XL
	tax

	lda Game.AI.XH
	adc #0

	ldy Standard.Main.ZTempVar1
	jmp Game.Main.LevelDecode.RetrieveColumnOfThreeTypes

Game.Main.AI.RetrieveColumnOfThreeTypes:
	lda Game.AI.XL
	tax
	lda Game.AI.XH
	pha
	lda Game.AI.YH
	tay
	pla

Game.Main.LevelDecode.RetrieveColumnOfThreeTypes:
	and #1
	ora #6
	sta Standard.Main.TempAdd0H			;Get high byte depending on X High
	txa
	and #$F0					;Get low byte (data row in $600-$700)
	sta Standard.Main.TempAdd0L
	tya						;Y divided by 16 = tile row
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	lda (Standard.Main.TempAdd0L),y			;Y is the current tile row
	pha
	iny
	lda (Standard.Main.TempAdd0L),y
	pha
	iny
	lda (Standard.Main.TempAdd0L),y
	tax
	pla
	tay
	pla
	rts


;***********************************************************
;Retrieval of row of two types

Game.Main.AI.RetrieveRowOfTwoTypes.SkewY:
;This retrieves a tile type for enemy coordinates + a certain value for Y coordinates.
;Expected: Height in A.
;Warning: Destroys ZTempVar1

	clc
	adc Game.AI.YH
	sta Standard.Main.ZTempVar1

	lda Game.AI.XL
	tax

	lda Game.AI.XH
	ldy Standard.Main.ZTempVar1
	jmp Game.Main.LevelDecode.RetrieveRowOfTwoTypes

Game.Main.AI.RetrieveRowOfTwoTypes:
	lda Game.AI.XL
	tax
	lda Game.AI.XH
	pha
	lda Game.AI.YH
	tay
	pla

Game.Main.LevelDecode.RetrieveRowOfTwoTypes:
;XH in A, XL in X, Y in Y
;Returns left type in A, next to the right in X.

	and #1
	ora #6
	sta Standard.Main.TempAdd0H			;Get high byte depending on X High
	txa
	and #$F0					;Get low byte (data row in $600-$700)
	sta Standard.Main.TempAdd0L
	tya						;Y divided by 16 = tile row
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	lda (Standard.Main.TempAdd0L),y			;Y is the current tile row
	pha
	clc
	lda Standard.Main.TempAdd0L
	adc #$10
	sta Standard.Main.TempAdd0L
	lda Standard.Main.TempAdd0H
	adc #0
	and #1
	ora #6
	sta Standard.Main.TempAdd0H
	lda (Standard.Main.TempAdd0L),y
	tax
	pla
	rts
;***********************************************************
;Retrieval of row of three types


Game.Main.AI.RetrieveRowOfThreeTypes.SkewY:
;This retrieves a tile type for enemy coordinates + a certain value for Y coordinates.
;Expected: Height in A.
;Warning: Destroys ZTempVar1

	clc
	adc Game.AI.YH
	sta Standard.Main.ZTempVar1

	lda Game.AI.XL
	tax

	lda Game.AI.XH
	ldy Standard.Main.ZTempVar1
	jmp Game.Main.LevelDecode.RetrieveRowOfThreeTypes

Game.Main.AI.RetrieveRowOfThreeTypes:
	lda Game.AI.XL
	tax
	lda Game.AI.XH
	pha
	lda Game.AI.YH
	tay
	pla

Game.Main.LevelDecode.RetrieveRowOfThreeTypes:

	and #1
	ora #6
	sta Standard.Main.TempAdd0H			;Get high byte depending on X High
	txa
	and #$F0					;Get low byte (data row in $600-$700)
	sta Standard.Main.TempAdd0L
	tya						;Y divided by 16 = tile row
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	lda (Standard.Main.TempAdd0L),y			;Y is the current tile row
	pha						;Save first type
	clc
	lda Standard.Main.TempAdd0L
	adc #$10
	sta Standard.Main.TempAdd0L
	lda Standard.Main.TempAdd0H
	adc #0
	and #1
	ora #6
	sta Standard.Main.TempAdd0H
	lda (Standard.Main.TempAdd0L),y
	pha						;Save second type

	clc
	lda Standard.Main.TempAdd0L
	adc #$10
	sta Standard.Main.TempAdd0L
	lda Standard.Main.TempAdd0H
	adc #0
	and #1
	ora #6
	sta Standard.Main.TempAdd0H
	lda (Standard.Main.TempAdd0L),y
	tay						;Third type in Y
	pla						;Second type in X
	tax
	pla						;First type in A
	rts
