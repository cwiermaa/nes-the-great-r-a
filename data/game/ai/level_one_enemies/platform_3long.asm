.DEFINE Platform3Long.Active AIRAM.17

Game.AI.Platform3Long:
	bne +

	lda #$00
	sta Game.AI.VelocityXH
+
	ldx #8
	lda #24
	jsr Game.AI.Universal.CheckJumpedOn
	beq ++

	lda #1
	sta Game.Player.ExternalVelocityXH
	
	lda #$00
	sta Game.Player.VelocityYL
	sta Game.Player.VelocityYH
	
	lda Game.Player.YH
	and #$F0
	clc
	adc #2
	sta Game.Player.YH
	
	lda Game.Player.ActionStatus
	ora #Game.Player.ActionStatus.OnGround
	sta Game.Player.ActionStatus
	
	lda #1
	sta Game.AI.VelocityXH
	jmp +++
++
+++
	lda #1
	jsr Game.AI.Animate
	jsr Game.AI.Universal.DisplaceX
	
	lda Game.AI.VelocityXH
	beq +

	jsr Game.AI.CheckNearOutOfRange
	beq ++
	ldy Game.AIRAM.Current
	jsr Game.Main.HandleAI.Deactivate
+	
	
++
	
	jmp Game.Main.HandleAI.Return