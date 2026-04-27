.DEFINE Lavasaur.FireBallCounter AIRAM.16
.DEFINE Lavasaur.AcidCounter AIRAM.17
.DEFINE Lavasaur.Action AIRAM.18
.DEFINE Lavasaur.Weight AIRAM.19

Game.AI.LavaBlob:
	lda Game.Camera.Status
	and #Game.Camera.Status.Locked
	bne +
	lda #2
	jsr Game.AI.Animate
	lda #$FF
	sta Lavasaur.Action.w,y
	jmp Game.Main.HandleAI.Return
+
	
	ldy Game.AIRAM.Current
	lda Lavasaur.Action.w,y
	cmp #$FF
	bne ++
	
	lda #$0F
	sta Game.AI.VelocityXH
	
	lda #0
	sta Lavasaur.Action.w,y
	
	
++

	jsr Game.AI.CheckFacingPlayer
	beq +++
	lda Lavasaur.FireBallCounter.w,y
	bne ++
	ldy #$86
	lda #0
	ldx #8
	jsr Game.AI.Weapon.Instantiate
	lda #60
	sta Lavasaur.FireBallCounter.w,y
++
	sec
	sbc #1
	sta Lavasaur.FireBallCounter.w,y
+++
	lda Lavasaur.AcidCounter.w,y
	bne ++
	
	lda #10
	sta Standard.Main.ZTempVar6
	ldy #9
	lda #2
	ldx #8
	jsr Game.AI.Weapon.Instantiate.IncludeWidth
	lda #40
	sta Lavasaur.AcidCounter.w,y
++
	sec
	sbc #1
	sta Lavasaur.AcidCounter.w,y
	
	lda Lavasaur.Action.w,y
	cmp #4
	beq +++
	ldx #17
	lda #31
	jsr Game.AI.DisplaceAndCollideX
	beq ++
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Jumping
	bne ++
	jsr Lavasaur.Action.ReactToEdge
	clc
	lda Lavasaur.Action.w,y
	adc #1
	sta Lavasaur.Action.w,y
	jmp ++
	
+++
	jsr Game.AI.Universal.DisplaceX
	lda #33
	ldx #17
	jsr Game.AI.CheckNotAtLedge
	bne ++
	jsr Lavasaur.Action4
++
	lda Lavasaur.Weight.w,y
	tay
	ldx #31
	lda #17
	jsr Game.AI.Universal.Jump0.AndFallWithCollision
	
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

	ldy Game.AIRAM.Current
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Dying
	beq +
	clc
	lda Game.AI.YH
	adc #8
	sta Game.AI.YH
	lda #14
	sta AIRAM.ObjectID.w,y
	lda Sound.Song.Status
	eor #Sound.Song.Status.StopPlaying
	sta Sound.Song.Status
	lda #1
	sta Game.Event.Flags
	lda #0
	sta AIRAM.ActionStatus.w,y
+
	jmp Game.Main.HandleAI.Return

Lavasaur.Action.ReactToEdge:
	lda Lavasaur.Action.w,y
	beq Lavasaur.Action0
	cmp #1
	beq Lavasaur.Action1
	cmp #2
	beq Lavasaur.Action2
	cmp #3
	beq Lavasaur.Action3
	rts
	
Lavasaur.Action0:
	jsr Game.AI.FaceOtherDirection
	jsr Game.AI.Universal.InvertVelocityX
	sec
	lda #20							;Lavasaur's Health
	sbc AIRAM.Health.w,y
	asl a
	asl a
	asl a
	and #$F0
	tax
	lda Game.AI.VelocityXH
	and #8
	bne +
	stx Game.AI.VelocityXL
	rts
+
	sec
	stx Standard.Main.ZTempVar0
	lda #0
	sbc Standard.Main.ZTempVar0
	sta Game.AI.VelocityXL
	rts
	
Lavasaur.Action1:
	lda AIRAM.ActionStatus.w,y
	ora #AI.ActionStatus.Jumping
	sta AIRAM.ActionStatus.w,y
	lda #0
	sta AIRAM.WeightIndex.w,y
	lda #1
	sta Lavasaur.Weight.w,y
	rts
	
Lavasaur.Action2:
	lda AIRAM.ActionStatus.w,y
	ora #AI.ActionStatus.Jumping
	sta AIRAM.ActionStatus.w,y
	lda #0
	sta AIRAM.WeightIndex.w,y
	lda #1
	sta Lavasaur.Weight.w,y
	rts
	
Lavasaur.Action3:
	jsr Game.AI.FaceOtherDirection
	jsr Game.AI.Universal.InvertVelocityX
	rts
	

Lavasaur.Action4:	
	lda AIRAM.ActionStatus.w,y
	ora #AI.ActionStatus.Jumping
	sta AIRAM.ActionStatus.w,y
	lda #0
	sta AIRAM.WeightIndex.w,y
	lda #0
	sta Lavasaur.Weight.w,y
	lda #0
	sta Lavasaur.Action.w,y
	rts
	