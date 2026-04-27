.DEFINE MarsRex.Counter AIRAM.16
.DEFINE Rex.MarsRexBlue 8

Game.AI.MarsRexBlue:
Game.AI.FireBott:
	bne ++
	
	lda #1
	sta AIRAM.VelocityX.w,y
	jsr Game.AI.Universal.LaunchTowardPlayerX
++
	ldx #17
	lda #33
	jsr Game.AI.CheckNotAtLedge
	beq ++
	ldx #17
	lda #30
	jsr Game.AI.DisplaceAndCollideX
	beq +
++
	jsr Game.AI.Universal.InvertVelocityX
	jsr Game.AI.FaceOtherDirection
+
;If facing player, check counter. If counter is 0, shoot a bullet. Otherwise, decrease counter.
	jsr Game.AI.CheckFacingPlayer
	beq +++
	lda MarsRex.Counter.w,y
	bne ++
	ldy #$86
	lda #0
	ldx #8
	jsr Game.AI.Weapon.Instantiate
	ldx #60
	lda AIRAM.ObjectID.w,y
	cmp #Rex.MarsRexBlue
	bne +
	ldx #30
+
	txa
	sta MarsRex.Counter.w,y
++
	sec
	sbc #1
	sta MarsRex.Counter.w,y
+++
	
	ldx #32
	lda #16
	jsr Game.AI.StandardDamage
	bne +
	lda #1
	jsr Game.AI.Animate
+
	ldx #32
	lda #16
	jsr Game.AI.StandardDamageFromTouch
	jsr Game.AI.StandardCheckForDeath
	jmp Game.Main.HandleAI.Return

	