.DEFINE FireBird.Counter 16

Game.AI.FireBird:
	bne +

	lda #$0F
	sta Game.AI.VelocityYH
	clc
	lda Game.AI.YH
	adc #20
	sta AIRAM.EndingY,y
	sec
	sbc #56
	sta AIRAM.StartingY,y
	jsr Game.AI.FacePlayer
	jsr Game.AI.FaceOtherDirection
+
	jsr Game.AI.RiseToStartAndFallToEnd
	beq +
	jsr Game.AI.Universal.InvertVelocityY
+
	
	ldy Game.AIRAM.Current
	lda AIRAM.16.w,y
	beq +
	sec
	sbc #1
	sta AIRAM.16.w,y
	jmp ++
+
	lda #40
	sta AIRAM.16.w,y
	ldy #3
	lda #0
	ldx #0
	jsr Game.AI.Weapon.Instantiate
	
++
	ldx #16
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
	ldx #16
	jsr Game.AI.StandardDamageFromTouch
	jmp Game.Main.HandleAI.Return