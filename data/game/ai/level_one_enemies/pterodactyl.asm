Game.AI.Pterodactyl:
	bne +

	lda #$81
	sta AIRAM.VelocityX.w,y
	jsr Game.AI.Universal.LaunchTowardPlayerX
	
+
	ldx #1
	lda Game.Player.YH
	clc
	adc #10
	sec
	sbc Game.AI.YH
	bpl +
	lda #$0F
	sta Game.AI.VelocityYH
	jmp ++
+
	bne +
	ldx #0
+
	stx Game.AI.VelocityYH
++
	ldx #6
	lda #16
	jsr Game.AI.StandardDamage
	bne ++
	
	lda #1
	jsr Game.AI.Animate

++
	jsr Game.AI.Universal.DisplaceX
	jsr Game.AI.Universal.DisplaceY
	jsr Game.AI.StandardCheckForDeath
	
	lda #16
	ldx #6
	jsr Game.AI.StandardDamageFromTouch
	
	lda Standard.LoopCount
	and #$1F
	bne +
	ldy #8
	lda #0
	ldx #8
	jsr Game.AI.Weapon.Instantiate
+
	jmp Game.Main.HandleAI.Return