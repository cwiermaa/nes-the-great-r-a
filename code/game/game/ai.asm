Game.Main.HandleAI:


	jsr Game.Main.HandleAI.ValidateActivity
	jsr Game.Main.HandleAI.SpawnObjects

	lda #>Game.Animation.AnimationStack
	sta Game.Animation.AnimationStack.CurrentH
	lda #<Game.Animation.AnimationStack
	sta Game.Animation.AnimationStack.CurrentL

	ldy #0
	sty Game.AIRAM.Current
-
	ldy Game.AIRAM.Current
	lda AIRAM.ObjectID.w,y
	beq Game.Main.HandleAI.Skip								;If the AI is empty, don't bother.
	tax
	lda Game.AI.PointersL.w,x
	sta Standard.Main.TempAdd0L
	lda Game.AI.PointersH.w,x
	sta Standard.Main.TempAdd0H

	jsr Game.AI.Universal.DecompressCrunchedValues
	jsr Game.AI.CheckOutOfRange.VoidActivity				;Void activity if not in range
	
	ldy Game.AIRAM.Current									;Check if hatched
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Hatched
	bne ++													;If hatched, go to normal enemy AI with a non-0 value

	jsr Game.AI.Hatch										;Otherwise, do normal hatching
	lda #$00												;Provide enemy with 0 value if they need further initializing
++
	jmp (Standard.Main.TempAdd0L)
Game.Main.HandleAI.Return:
	jsr Game.AI.Universal.CompressCrunchedValues

Game.Main.HandleAI.Skip:
	clc
	lda Game.Animation.AnimationStack.CurrentL
	adc #7
	sta Game.Animation.AnimationStack.CurrentL
	
	inc Game.AIRAM.Current
	lda Game.AIRAM.Current
	cmp #AIRAM.Slots
	bne -
	rts


Game.Main.HandleAI.SpawnObjects:
;ZTempVar1 = BorderL
;ZTempVar2 = BorderH

	sec
	lda Game.ScreenXL
	sbc #$50
	and #$F0
	sta Standard.Main.ZTempVar1
	lda Game.ScreenXH
	sbc #0
	and #$3F
	cmp #$3F
	beq +
	sta Standard.Main.ZTempVar2
	tay
	lda (Game.ObjectMap.PointerL),y
	tay
	jsr Game.Main.HandleAI.SpawnObjects.CheckPoint
+
	clc
	lda Game.ScreenXL
	adc #$50
	and #$F0
	sta Standard.Main.ZTempVar1
	lda Game.ScreenXH
	adc #1
	and #$3F
	sta Standard.Main.ZTempVar2
	tay
	lda (Game.ObjectMap.PointerL),y
	tay
	jsr Game.Main.HandleAI.SpawnObjects.CheckPoint
	rts

Game.Main.HandleAI.SpawnObjects.CheckPoint:
;ZTempVar3 = ObjectMap Pointer
;
	lda (Game.ObjectMapL),y
	iny
	tax
-
	beq +++
	lda (Game.ObjectMapL),y
	and #$F0
	cmp Standard.Main.ZTempVar1
	bne +
	sty Standard.Main.ZTempVar3
	inc Standard.Main.ZTempVar2
	tya
	sec
	sbc Standard.Main.ZTempVar2
	lsr a
	tay
	sta Standard.Main.ZTempVar4
	lsr a
	lsr a
	lsr a
	tax

	tya
	and #7
	tay

	lda Game.ObjectStates.Dead.w,x
	and Game.Main.HandleAI.StatusBits,y
	sta Standard.Main.ZTempVar1
	lda Game.ObjectStates.Active.w,x
	and Game.Main.HandleAI.StatusBits,y
	ora Standard.Main.ZTempVar1
	bne +++
	jsr Game.Main.HandleAI.Activate
	rts
+
	iny
	iny
	dex
	jmp -	

+++	
	rts

Game.Main.HandleAI.ValidateActivity:
	.include "ai_validation.asm"

;Function: Given the X coordinates of each active object and the coordinates of the screen, it will be determined if an ;object falls out of range. If so, it will be deactivated.

								;First, we check if ObjectX - (ScreenXL - $70) is positive.
								;If so, object is left alone. If not, object is deactivated.
								;Then if (ScreenXL + $180) - ObjectX is positive leave object

								;alone. Else, deactivate it.


Game.Main.HandleAI.Deactivate:
;Expected: Game.AIRAM.Current in Y

	lda AIRAM.ObjectNumber.w,y
	and #7
	tax
	lda AIRAM.ObjectNumber.w,y
	lsr a
	lsr a
	lsr a
	tay

	lda Game.ObjectStates.Active.w,y			;Unset Activity bit
	and Game.Main.HandleAI.StatusBits.Inverted.w,x
	sta Game.ObjectStates.Active.w,y

	lda #0
	ldy Game.AIRAM.Current
	
	sta AIRAM.0.w,y
	sta AIRAM.1.w,y
	sta AIRAM.2.w,y
	sta AIRAM.3.w,y
	sta AIRAM.4.w,y
	sta AIRAM.5.w,y
	sta AIRAM.6.w,y
	sta AIRAM.7.w,y
	sta AIRAM.8.w,y
	sta AIRAM.9.w,y
	sta AIRAM.10.w,y
	sta AIRAM.11.w,y
	sta AIRAM.12.w,y
	sta AIRAM.13.w,y
	sta AIRAM.14.w,y
	sta AIRAM.15.w,y
	sta AIRAM.16.w,y
	sta AIRAM.17.w,y
	sta AIRAM.18.w,y
	sta AIRAM.19.w,y
	sta AIRAM.20.w,y
	sta AIRAM.21.w,y

	dec Game.ObjectsActive				;Decrease ObjectsActive byte by 1
	rts

Game.Main.HandleAI.Activate:
	lda Game.ObjectsActive				;If all 8 objects are active, do not spawn any more.
	cmp #8
	bne +
	rts
+
	lda Game.ObjectStates.Active.w,x			;Set the activity bit of the current object
	ora Game.Main.HandleAI.StatusBits,y
	sta Game.ObjectStates.Active.w,x

	inc Game.ObjectsActive				;Increase the number of active objects by 1.

	ldx #0
	stx Game.AIRAM.Current
-
	ldx Game.AIRAM.Current
	lda AIRAM.ObjectID.w,x					;See if slot 0 is open.
	beq +
	inc Game.AIRAM.Current
	lda Game.AIRAM.Current
	cmp #AIRAM.Slots
	bne -
	rts
+
	ldy Standard.Main.ZTempVar3
	lda (Game.ObjectMapL),y
	and #$0F
	asl a
	asl a
	asl a
	asl a
	sta AIRAM.YH.w,x
	lda (Game.ObjectMapL),y
	and #$F0
	sta AIRAM.XL.w,x
	iny
	lda (Game.ObjectMapL),y
	sta AIRAM.ObjectID.w,x
	lda Standard.Main.ZTempVar2
	sec
	sbc #1
	sta AIRAM.XH.w,x
	lda Standard.Main.ZTempVar4
	sta AIRAM.ObjectNumber.w,x

	rts
+

Game.Main.HandleAI.StatusBits:
	.db $80,$40,$20,$10,$08,$04,$02,$01


Game.Main.HandleAI.StatusBits.Inverted:
	.db $7F,$BF,$DF,$EF,$F7,$FB,$FD,$FE