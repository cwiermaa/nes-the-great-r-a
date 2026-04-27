Game.AI.BouncingBall:
	bne +
	lda #2
	sta Game.AI.VelocityYH
+	
	ldx #16
	lda #16
	jsr Game.AI.StandardDamage
	bne +
	lda Game.AI.VelocityXH
	bne +++
	lda Game.AI.VelocityXL
	bne +++
	lda #1
	jsr Game.AI.Animate
	jmp ++
+++
	lda #2
	jsr Game.AI.Animate
	jmp ++
+
	and #$10
	bne +
	clc
	lda Game.AI.VelocityXL
	adc #$10
	sta Game.AI.VelocityXL
	lda Game.AI.VelocityXH
	adc #0
	and #$0F
	sta Game.AI.VelocityXH
	jmp ++
+
	sec
	lda Game.AI.VelocityXL
	sbc #$10
	sta Game.AI.VelocityXL
	lda Game.AI.VelocityXH
	sbc #0
	and #$0F
	sta Game.AI.VelocityXH
++
	lda #15
	ldx #15
	jsr Game.AI.DisplaceAndCollideY
	lda #15
	ldx #15
	jsr Game.AI.DisplaceAndCollideX
	beq +
	jsr Game.AI.Universal.InvertVelocityX
+
	lda #14
	ldx #8
	jsr Game.Main.AI.RetrieveSingleType.SkewXY
	cmp #4
	bne +
	lda Game.Event.Flags
	ora #1
	sta Game.Event.Flags
	jmp ++
+
	lda Game.Event.Flags
	and #$FE
	sta Game.Event.Flags
++
	jsr Game.AI.Universal.CheckFellOffScreen
	beq +
	lda #0
	sta Game.AI.VelocityYH
+
	jmp Game.Main.HandleAI.Return