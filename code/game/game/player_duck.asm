Game.Main.HandleCharacter.Ducked:

	lda Standard.Hardware.ControlTrigger
	and #4
	beq +
	lda #0
	sta Game.Player.ArmShooting
+
	lda Game.Player.ActionStatus
	ora #Game.Player.ActionStatus.Ducking
	sta Game.Player.ActionStatus

	jsr Game.Main.Player.DecellerateX.Ducked

	lda Standard.Hardware.ControlCurrent
	and #$03
	beq ++
	and #$02
	beq +
	lda Game.Player.ActionStatus
	ora #Game.Player.ActionStatus.FacingLeft
	sta Game.Player.ActionStatus
	jmp ++
+
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.FacingLeft.Inverted
	sta Game.Player.ActionStatus
++
	jsr Game.Main.Player.CheckUnderWater
	jsr Game.Main.Player.DisplaceX
	jsr Game.Main.Player.CollideX		;.Ducked
	jsr Game.Main.Player.KeepOnScreen

	jsr Game.Main.Gravity

	jsr Game.Main.Player.DisplaceY
	jsr Game.Main.Player.CollideY		;.Ducked

	clc
	lda Game.Player.YH
	adc #16
	sta Game.Player.TopBorder
	adc #16
	sta Game.Player.BottomBorder
	
	clc										;179
	lda Game.Player.XL						;182
	adc #11									;184 Player collides with a box at coordinates, width 11.
	sta Game.Player.RightBorderL			;187
	lda Game.Player.XH						;190
	adc #0									;192
	sta Game.Player.RightBorderH			;195

	jsr Game.Main.Player.Shoot
	jsr Game.Main.Player.ConvertInfoToDecimal

	lda #4
	sta Game.Animation.AnimationStack.Player.AnimationCurrent
	lda #<Game.Animations.Player.Crouching
	sta Game.Animation.AnimationStack.Player.AnimationL
	lda #>Game.Animations.Player.Crouching
	sta Game.Animation.AnimationStack.Player.AnimationH

	jsr Game.Animation.AnimatePlayer
	
	lda Game.Player.ArmShooting
	beq +
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.FacingLeft
	bne ++
	clc
	lda Game.Player.XL
	adc #16
	sta Game.Player.ArmXL
	lda Game.Player.XH
	adc #0
	sta Game.Player.ArmXH
	clc
	lda Game.Player.YH
	adc #24
	sta Game.Player.ArmY
	ldy #Game.Player.ArmXL - Game.Player.Bullet0
	lda #$E0
	jsr Game.ObjectDraw.PushSingle.Player.0
	dec Game.Player.ArmShooting
	jmp +
++
	
	lda Game.Player.XL
	sta Game.Player.ArmXL
	lda Game.Player.XH
	sta Game.Player.ArmXH
	clc
	lda Game.Player.YH
	adc #24
	sta Game.Player.ArmY
	ldy #Game.Player.ArmXL - Game.Player.Bullet0
	lda #$E0
	jsr Game.ObjectDraw.PushSingle.Player.0.Flipped
	dec Game.Player.ArmShooting
+
	jmp Game.Main.HandleCharacter.CheckPause

;*******************************************************
Game.Main.Player.DecellerateX.Ducked:

	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.OnGround
	bne +
	rts
+


+++
	lda Game.Player.VelocityXL
	sta Standard.Main.ZTempVar2
	lda Game.Player.VelocityXH
	sta Standard.Main.ZTempVar1

	tax
	asl a					;Keep sign bit
	ror Standard.Main.ZTempVar1
	ror Standard.Main.ZTempVar2
	txa
	asl a
	ror Standard.Main.ZTempVar1
	ror Standard.Main.ZTempVar2
	txa
	asl a
	ror Standard.Main.ZTempVar1
	ror Standard.Main.ZTempVar2

	sec
	lda Game.Player.VelocityXL
	sbc Standard.Main.ZTempVar2
	sta Game.Player.VelocityXL
	lda Game.Player.VelocityXH
	sbc Standard.Main.ZTempVar1
	sta Game.Player.VelocityXH


	lda Game.Player.VelocityXH
	bne ++
	lda Game.Player.VelocityXL
	cmp #$07
	beq +
	bcs ++
+
	lda #0
	sta Game.Player.VelocityXL
	sta Game.Player.VelocityXH
++
	rts
