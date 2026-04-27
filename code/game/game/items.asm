Game.Main.Item.Spawn:
;Function: Given an item ID, X, and Y coordinates, this routine attempts to spawn the specified item at the
;specified coordinates, provided that there are available item slots.
;Expected: Item ID in ZTempVarF, Y Coordinate in A, X CoordinateL in X, X CoordinateH in Y
;Warning: Destroys ZTempVarF, ZTempVarE, ZTempVarD, and ZTempVarC.

	sta Standard.Main.ZTempVarE
	stx Standard.Main.ZTempVarD
	sty Standard.Main.ZTempVarC


	lda Game.Items.Slots.Available
	bne +
	lda #$00						;Returns False if spawn was unsuccessful.
	rts
+
	dec Game.Items.Slots.Available

	ldx #0
	lda Game.Items.Slots
	and Game.Main.Item.Spawn.SlotTable.w,x
	bne +

	ldy #0
	jmp Game.Items.Slots.SpawnInSlot
+
	inx
	
	lda Game.Items.Slots
	and Game.Main.Item.Spawn.SlotTable.w,x
	bne +

	ldy #1
	jmp Game.Items.Slots.SpawnInSlot
+
	inx
	
	lda Game.Items.Slots
	and Game.Main.Item.Spawn.SlotTable.w,x
	bne +

	ldy #2
	jmp Game.Items.Slots.SpawnInSlot
+
	inx
	
	lda Game.Items.Slots
	and Game.Main.Item.Spawn.SlotTable.w,x
	bne +

	ldy #3
	jmp Game.Items.Slots.SpawnInSlot
+
	inx
	
	lda Game.Items.Slots
	and Game.Main.Item.Spawn.SlotTable.w,x
	bne +

	ldy #4
	jmp Game.Items.Slots.SpawnInSlot
+
	inx
	
	lda Game.Items.Slots
	and Game.Main.Item.Spawn.SlotTable.w,x
	bne +

	ldy #5
	jmp Game.Items.Slots.SpawnInSlot
+
	inx
	
	lda Game.Items.Slots
	and Game.Main.Item.Spawn.SlotTable.w,x
	bne +

	ldy #6
	jmp Game.Items.Slots.SpawnInSlot
+
								;If we're here, slot 7 must be open.
	ldy #7
	inx
	
Game.Items.Slots.SpawnInSlot:

	lda Game.Items.Slots				;Officially put item in Slot
	ora Game.Main.Item.Spawn.SlotTable.w,x
	sta Game.Items.Slots

	lda Standard.Main.ZTempVarF				;Store arguments passed in in Item Slot.
	sta Game.Items.ItemID.w,y
	lda Standard.Main.ZTempVarE
	sta Game.Items.ItemY.w,y
	lda Standard.Main.ZTempVarD
	sta Game.Items.ItemXL.w,y
	lda Standard.Main.ZTempVarC
	sta Game.Items.ItemXH.w,y
	
	lda #$00
	sta Game.Spontaneous.ObjectYP,y
	sta Game.Spontaneous.ObjectXP,y
	sta Game.Spontaneous.ObjectVar0,y

	lda #$FF						;Returns non-zero if spawn was successful.
	rts

Game.Main.Item.Spawn.SlotTable:
	.db $80, $40, $20, $10, $08, $04, $02, $01

Game.Main.Item.Spawn.SlotTable.Inverted:
	.db $7F, $BF, $DF, $EF, $F7, $FB, $FD, $FE

;**********************************************************
	
Game.Main.Items.Handle:
	lda Game.Items.Slots				;A quick way to see if none are active.
	bne +
	rts
+
	jsr Game.Main.Items.ValidateLocations
	
	lda #0
	sta Game.AIRAM.Current
-
	ldy Game.AIRAM.Current
	lda Game.Items.ItemID,y
	and #$7F
	tax
	lda Game.Main.Item.HandlersL.w,x
	sta Standard.Main.TempAdd0L
	lda Game.Main.Item.HandlersH.w,x
	sta Standard.Main.TempAdd0H

	jmp (Standard.Main.TempAdd0L)

Game.Main.ItemReturn:
	clc 
	lda Game.AIRAM.Current
	adc #1
	sta Game.AIRAM.Current
	cmp #Spontaneous.Slots
	bne -
	rts


Game.Main.Item.Destroy:
;Function: Given in item number in ZTempVarF and the location of Item RAM in AIRAMPointerL/H, the item
;Is deactivated.
;Expected: Nothing really. Come to this from an item handler to make that item deactivate itself.

	ldx Game.AIRAM.Current
	lda Game.Main.Item.Spawn.SlotTable.Inverted.w,x
	and Game.Items.Slots
	sta Game.Items.Slots
	lda #0
	sta Game.Items.ItemID.w,x
	inc Game.Items.Slots.Available
	rts

Game.Main.Items.ValidateLocations:
	sec
	lda Game.ScreenXL
	sbc #$60
	sta Standard.Main.ZTempVar1
	lda Game.ScreenXH
	sbc #0
	bpl +
	lda #0
	sta Standard.Main.ZTempVar1
+
	sta Standard.Main.ZTempVar2
	
	clc
	lda Game.ScreenXL
	adc #$60
	sta Standard.Main.ZTempVar3
	lda Game.ScreenXH
	adc #1
	sta Standard.Main.ZTempVar4
	
	
	ldy #0
	sty Game.AIRAM.Current
-
	lda Game.Items.ItemID,y
	beq ++
	sec
	lda Game.Items.ItemXL.w,y
	sbc Standard.Main.ZTempVar1
	lda Game.Items.ItemXH.w,y
	sbc Standard.Main.ZTempVar2
	bcs +
	jsr Game.Main.Item.Destroy
	jmp ++
+
	lda Standard.Main.ZTempVar3
	sbc Game.Items.ItemXL.w,y
	lda Standard.Main.ZTempVar4
	sbc Game.Items.ItemXH.w,y
	bcs ++
	jsr Game.Main.Item.Destroy
	
++
	iny
	sty Game.AIRAM.Current
	cpy #Spontaneous.Slots
	bne -
	rts
