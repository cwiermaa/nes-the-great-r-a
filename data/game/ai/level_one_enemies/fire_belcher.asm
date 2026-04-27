.DEFINE FireBelcher.BreathFireCounter AIRAM.16

Game.AI.FireBelcher:
	bne ++

	lda #1
	sta AIRAM.VelocityX.w,y
	jsr Game.AI.Universal.LaunchTowardPlayerX

++
	lda FireBelcher.BreathFireCounter.w,y
	beq +
	
;*****************************************	
;Fire breathing code
	cmp #50
	bne +++
	jsr Game.AI.Universal.InvertVelocityX
	jsr Game.AI.FaceOtherDirection
+++	
	ldx #2
											;If not breathing fire, do normal things.
	sec
	lda FireBelcher.BreathFireCounter.w,y
	sbc #1
	sta FireBelcher.BreathFireCounter.w,y
	bne +++
	ldx #1
+++
	txa
	jsr Game.AI.Animate
	
	lda Standard.LoopCount
	and #3
	bne +++++
	lda AIRAM.ActionStatus.w,y
	AI.GenerateSpontaneous() 7,0,2,$80,8
+++++
	ldy Game.AIRAM.Current
	
	ldx #16
	lda #16
	jsr Game.AI.StandardDamage
	ldx #24
	lda #16
	jsr Game.AI.StandardDamageFromTouch
	jsr Game.AI.StandardCheckForDeath
	jmp Game.Main.HandleAI.Return
	
;*****************************************	
+

	ldx #16
	lda #16
	jsr Game.AI.StandardDamage
	bne ++
	
	lda #1
	jsr Game.AI.Animate

++
	lda #17
	ldx #17
	jsr Game.AI.CheckNotAtLedge
	beq ++
	lda #14
	ldx #17
	jsr Game.AI.DisplaceAndCollideX
	bne ++
	jmp +
++	;If not at ledge, keep moving. Otherwise, reverse direction.
	lda #50
	sta FireBelcher.BreathFireCounter.w,y
	jmp ++
+
	;jsr Game.AI.Universal.DisplaceX
++
	
	lda #16
	ldx #16
	jsr Game.AI.StandardDamageFromTouch
	
	jsr Game.AI.StandardCheckForDeath
	jmp Game.Main.HandleAI.Return
