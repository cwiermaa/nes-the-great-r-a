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
	lda AIRAM.ObjectID,y
	beq ++
	sec
	lda AIRAM.XL.w,y
	sbc Standard.Main.ZTempVar1
	lda AIRAM.XH.w,y
	sbc Standard.Main.ZTempVar2
	bcs +
	jsr Game.Main.HandleAI.Deactivate
	jmp ++
+
	lda Standard.Main.ZTempVar3
	sbc AIRAM.XL.w,y
	lda Standard.Main.ZTempVar4
	sbc AIRAM.XH.w,y
	bcs ++
	jsr Game.Main.HandleAI.Deactivate
	
++
	iny
	sty Game.AIRAM.Current
	cpy #AIRAM.Slots
	bne -
	rts
