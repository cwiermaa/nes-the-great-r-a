.DEFINE LavaBall.StartingY AIRAM.16
.DEFINE LavaBall.WaitCount AIRAM.17

Game.AI.LavaBall:
	bne +

	ldy Game.AIRAM.Current
	lda Game.AI.YH
	sta LavaBall.StartingY.w,y
+

	lda LavaBall.WaitCount.w,y
	beq +
	sec
	sbc #1
	sta LavaBall.WaitCount.w,y
	and #3
	bne ++
	sec
	lda Game.AI.VelocityYL
	sbc #$10
	sta Game.AI.VelocityYL
	jmp ++
+
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Jumping
	bne +
	jsr Game.AI.Universal.Gravity.Weight0
	
	lda LavaBall.StartingY.w,y
	cmp Game.AI.YH
	bcs ++++
	lda AIRAM.ActionStatus.w,y
	ora #AI.ActionStatus.Jumping
	sta AIRAM.ActionStatus.w,y
	lda #$00
	sta AIRAM.WeightIndex.w,y
	sta Game.AI.VelocityYH
	lda #$80
	sta Game.AI.VelocityYL
	lda #30
	sta LavaBall.WaitCount.w,y
	jmp ++++
+
	jsr Game.AI.Universal.Jump0
	beq +++
	lda #$00
	sta AIRAM.WeightIndex.w,y
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Jumping.Inverted
	sta AIRAM.ActionStatus.w,y

+++
	lda #1
	jsr Game.AI.Animate
	jmp ++
++++

	lda #2
	jsr Game.AI.Animate
	jmp ++
++
	jsr Game.AI.Universal.DisplaceY
	
	lda #13
	ldx #16
	jsr Game.AI.StandardDamageFromTouch
	jmp Game.Main.HandleAI.Return