.DEFINE FireTremor.StartingY AIRAM.16
.DEFINE FireTremor.EndingY AIRAM.17
.DEFINE FireTremor.Counter AIRAM.18
.DEFINE FireTremor.BulletVelocityL AIRAM.19
.DEFINE FireTremor.BulletVelocityH AIRAM.20

Game.AI.FireTremor:
	bne +

	inc Game.AI.YH
	lda #1
	sta Game.AI.VelocityYH
	
	lda Game.AI.YH
	sta FireTremor.StartingY.w,y
	clc
	adc #$10
	sta FireTremor.EndingY.w,y

+

;*******************************************************

	lda FireTremor.Counter.w,y
	beq +
	sec
	sbc #1
	sta FireTremor.Counter.w,y
	
	ldx #16
	lda #16
	jsr Game.AI.StandardDamage
	bne ++++
	
	lda #2
	jsr Game.AI.Animate
	
	jmp ++++
;**********************************************************
;For moving up and down
+
	lda Game.AI.VelocityYH
	cmp #1
	beq +
	lda Game.AI.YH
	cmp FireTremor.StartingY.w,y
	bne ++
	
	lda #47
	sta FireTremor.Counter.w,y
	
	ldy #2
	lda #$FC
	ldx #8
	jsr Game.AI.Weapon.Instantiate
	ldy #$82
	lda #$FC
	ldx #8
	jsr Game.AI.Weapon.Instantiate
	
	jsr Game.AI.Universal.InvertVelocityY
	jmp ++
	
+
	lda Game.AI.YH
	cmp FireTremor.EndingY.w,y
	bne ++
	jsr Game.AI.Universal.InvertVelocityY
	
++
	

;*******************************************************
	ldx #16
	lda #16
	jsr Game.AI.StandardDamage
	bne +++
	
	lda #1
	jsr Game.AI.Animate

+++
	jsr Game.AI.Universal.DisplaceY
++++
	
	jsr Game.AI.StandardCheckForDeath
	
	lda #16
	ldx #16
	jsr Game.AI.StandardDamageFromTouch
	jmp Game.Main.HandleAI.Return