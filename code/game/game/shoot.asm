Game.Main.Player.Shoot:
;************ Shooting *********************
	lda Game.Player.Ammo
	bne +
	lda Game.Player.PowerUp
	and #$7F
	sta Game.Player.PowerUp
+
	lda Standard.Hardware.ControlTrigger		;If select was pressed	1433
	and #$20								;1435
	beq +									;1437
	lda Game.Player.Ammo
	beq +
	lda Game.Player.PowerUp			;Toggle between PowerUp selected and regular gun.	1440
	and #$7F
	bne ++
	sta Game.Player.PowerUp
	jmp +
++
	lda Game.Player.PowerUp
	eor #Game.Player.PowerUp.Mode			;1442
	sta Game.Player.PowerUp					;1445
	lda #14
	jsr Sound.SFX.RequestNew
+
	lda Game.Player.PowerUp
	and #$7F
	tax
	lda Game.Player.Ammo
	cmp Game.Main.Player.Bullets.AmmoRequired.w,x	
											;If the player has not enough ammo, automatically default to the regular
	bcs +						;gun.		;1450
	lda Game.Player.PowerUp					;1453
	and #$7F								;1455
	sta Game.Player.PowerUp					;1458
+
	lda Game.Player.PowerUpMessage
	and #Game.Player.PowerUpMessage.InstantiateNew
	beq +
	lda Game.Player.PowerUpMessage
	and #Game.Player.PowerUpMessage.InstantiateNew.Inverted
	sta Game.Player.PowerUpMessage
	jmp +++
+
	lda Standard.Hardware.ControlTrigger		;If B was newly pressed, the player is shooting. 1461
	and #$40								;1463
	beq ++									;1465
+++
	ldx #0									;1467
	lda Game.Player.PowerUp			;Are we using the standard gun? Or do we have a PowerUp selected?	1470
	and #Game.Player.PowerUp.Mode		;0 = standard, 1 = power up	1472
	beq +									;1474
	sec
	lda Game.Player.PowerUp
	and #$7F
	tax
	lda Game.Player.Ammo
	sbc Game.Main.Player.Bullets.AmmoRequired.w,x
	sta Game.Player.Ammo
	lda Game.Player.PowerUp					;1477
	and #Game.Player.PowerUp.ID				;1479
	tax										;1481
+
	jsr Game.Main.Player.SpawnBullet		;Don't time; will be redone
	lda #Game.Player.ArmShooting.InitialValue
	sta Game.Player.ArmShooting
++

	jsr Game.Main.Player.DisplaceBullets	;Don't time; will be redone
	rts
;*********** /Shooting *********************
Game.Main.Player.DestroyAllBullets:
	ldx #$16
	lda #$00
-
	sta Game.Player.Bullet0.w,x
	dex
	bne -
	lda #$00
	sta Game.Player.PowerUpMessage
	rts
Game.Main.Player.SpawnBullet:
;Function: Given the location of the player as well as the number of bullets currently active,
;Attempt to create a bullet given the powerup ID in X.
;Expected: Power-Up ID in X.

	lda Game.Player.BulletsActive
	cmp #3
	bne +
	rts						;Cannot spawn bullets, as all are active.

+
	
	lda Game.Main.Player.Bullets.SoundEffects.w,x
	jsr Sound.SFX.RequestNew

	ldy #$09
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.Ducking
	beq +
	ldy #$17
+
	sty Standard.Main.ZTempVar1

	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.FacingLeft
	beq +

	lda #$FF
	sta Standard.Main.ZTempVar2
	lda #$FC
	sta Standard.Main.ZTempVar3
	jmp ++
+
	lda #0
	sta Standard.Main.ZTempVar2
	lda #20
	sta Standard.Main.ZTempVar3
++

	inc Game.Player.BulletsActive

	lda Game.Player.Bullet0.Status		;Is bullet 0 open?
	and #Game.Player.Bullet.Active
	bne +						;If not, move to next bullet

	stx Game.Player.Bullet0.ID


	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.FacingLeft
	beq ++
	lda #Game.Player.Bullet.Direction
++
	ora #Game.Player.Bullet.Active		;Here we set the status for this bullet to "Active"
	sta Game.Player.Bullet0.Status

		;Create locations for player bullets

	clc
	lda Game.Player.XL
	adc Standard.Main.ZTempVar3
	sta Game.Player.Bullet0.XM
	lda Game.Player.XH
	adc Standard.Main.ZTempVar2
	sta Game.Player.Bullet0.XH
	clc
	lda Game.Player.YH
	adc Standard.Main.ZTempVar1
	sta Game.Player.Bullet0.YH

	lda Game.Main.Player.DisplaceBullet.PointersL.w,x
	sta Game.Player.Bullet0.DisplaceL
	lda Game.Main.Player.DisplaceBullet.PointersH.w,x
	sta Game.Player.Bullet0.DisplaceH
	rts

+
	lda Game.Player.Bullet1.Status		;Is bullet 1 open?
	and #Game.Player.Bullet.Active
	bne +						;If not, move to next bullet

	stx Game.Player.Bullet1.ID

	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.FacingLeft
	beq ++
	lda #Game.Player.Bullet.Direction
++
	ora #Game.Player.Bullet.Active		;Here we set the status for this bullet to "Active"
	sta Game.Player.Bullet1.Status

		;Create locations for player bullets

	clc
	lda Game.Player.XL
	adc Standard.Main.ZTempVar3
	sta Game.Player.Bullet1.XM
	lda Game.Player.XH
	adc Standard.Main.ZTempVar2
	sta Game.Player.Bullet1.XH
	clc
	lda Game.Player.YH
	adc Standard.Main.ZTempVar1
	sta Game.Player.Bullet1.YH
	
	lda Game.Main.Player.DisplaceBullet.PointersL.w,x
	sta Game.Player.Bullet1.DisplaceL
	lda Game.Main.Player.DisplaceBullet.PointersH.w,x
	sta Game.Player.Bullet1.DisplaceH
	rts
+							;If we're here, bullet 0 and 1 aren't open. Since we've checked
							;to see if all 3 are active, if 0 and 1 aren't open, that means
							;2 HAS to be open. No check necessary.

	stx Game.Player.Bullet2.ID


	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.FacingLeft
	beq ++
	lda #Game.Player.Bullet.Direction
++
	ora #Game.Player.Bullet.Active		;Here we set the status for this bullet to "Active"
	sta Game.Player.Bullet2.Status

		;Create locations for player bullets

	clc
	lda Game.Player.XL
	adc Standard.Main.ZTempVar3
	sta Game.Player.Bullet2.XM
	lda Game.Player.XH
	adc Standard.Main.ZTempVar2
	sta Game.Player.Bullet2.XH
	clc
	lda Game.Player.YH
	adc Standard.Main.ZTempVar1
	sta Game.Player.Bullet2.YH
	
	lda Game.Main.Player.DisplaceBullet.PointersL.w,x
	sta Game.Player.Bullet2.DisplaceL
	lda Game.Main.Player.DisplaceBullet.PointersH.w,x
	sta Game.Player.Bullet2.DisplaceH
	rts


Game.Main.Player.DisplaceBullets:
.DEFINE Game.Main.Screen.Activity.LeftBoundL Standard.Main.ZTempVar4
.DEFINE Game.Main.Screen.Activity.LeftBoundH Standard.Main.ZTempVar5
.DEFINE Game.Main.Screen.Activity.RightBoundL Standard.Main.ZTempVar6
.DEFINE Game.Main.Screen.Activity.RightBoundH Standard.Main.ZTempVar7

;Function: Given the activity status and power-up ID of each bullet, the routines that handle the displacement of each
;Bullet are called.
;Warning: DO NOT USE ZTempVar4 - ZTempVar7 for temp var purposes within this routine! They must be reserved for validation
;purposes!

;********** For validation purposes *********
	sec
	lda Game.ScreenXL
	sbc #50
	sta Game.Main.Screen.Activity.LeftBoundL
	lda Game.ScreenXH
	sbc #0
	cmp #$FF
	bne +
	lda #$00
	sta Game.Main.Screen.Activity.LeftBoundL
+
	sta Game.Main.Screen.Activity.LeftBoundH

	clc
	lda Game.ScreenXL
	adc #50
	sta Game.Main.Screen.Activity.RightBoundL
	lda Game.ScreenXH
	adc #1
	sta Game.Main.Screen.Activity.RightBoundH

;********** For validation purposes *********


	lda Game.Player.Bullet0.Status
	and #Game.Player.Bullet.Active
	beq +

	ldx #0
	jmp (Game.Player.Bullet0.DisplaceL)

Game.Main.Player.DisplaceBullets.Return0:
+
	lda Game.Player.Bullet1.Status
	and #Game.Player.Bullet.Active
	beq +
	
	ldx #1
	jmp (Game.Player.Bullet1.DisplaceL)

Game.Main.Player.DisplaceBullets.Return1:
+
	lda Game.Player.Bullet2.Status
	and #Game.Player.Bullet.Active
	beq +

	ldx #2
	jmp (Game.Player.Bullet2.DisplaceL)
Game.Main.Player.DisplaceBullets.Return2:
+
	rts

	
Game.Main.Player.CollideBullet.DetermineCollision:
	cpx #0
	bne +
	ldy Game.Player.Bullet0.YH
	ldx Game.Player.Bullet0.XM
	lda Game.Player.Bullet0.XH
	jsr Game.Main.LevelDecode.RetrieveSingleType
	rts
+
	cpx #1
	bne +
	ldy Game.Player.Bullet1.YH
	ldx Game.Player.Bullet1.XM
	lda Game.Player.Bullet1.XH
	jsr Game.Main.LevelDecode.RetrieveSingleType
	rts
+
	ldy Game.Player.Bullet2.YH
	ldx Game.Player.Bullet2.XM
	lda Game.Player.Bullet2.XH
	jsr Game.Main.LevelDecode.RetrieveSingleType
	rts
	
Game.Main.Player.DisplaceBullet.DetermineBullet:
;Expected: Bullet Number in X.
;Routes to appropriate displacement routine for the bullet.

	cpx #0
	bne +
	jmp Game.Main.Player.DisplaceBullet0.DisplaceCollidable
+
	cpx #1
	bne +
	jmp Game.Main.Player.DisplaceBullet1.DisplaceCollidable
+
	jmp Game.Main.Player.DisplaceBullet2.DisplaceCollidable

Game.Main.Player.DeactivateBullet.DetermineBullet:

	cpx #0
	bne +
	jmp Game.Main.Player.DisplaceBullet0.Deactivate
+
	cpx #1
	bne +
	jmp Game.Main.Player.DisplaceBullet1.Deactivate
+
	jmp Game.Main.Player.DisplaceBullet2.Deactivate

Game.Main.Player.DisplaceBullet.DetermineReturn:
	cpx #0
	bne +
	jmp Game.Main.Player.DisplaceBullets.Return0
+
	cpx #1
	bne +
	jmp Game.Main.Player.DisplaceBullets.Return1
+
	jmp Game.Main.Player.DisplaceBullets.Return2

Game.Main.Player.DisplaceBullet0.DisplaceCollidable:

	lda Game.Player.Bullet0.Status
	and #Game.Player.Bullet.Direction				;1 for Left, 0 for right
	bne +

	lda Standard.Main.ZTempVar0
	ldx Standard.Main.ZTempVar1
	ldy Standard.Main.ZTempVar2
	jmp ++

+
	lda Standard.Main.ZTempVar0
	eor #$FF
	clc
	adc #1
	pha
	lda Standard.Main.ZTempVar1
	eor #$FF
	adc #0
	tax
	pla
	ldy Standard.Main.ZTempVar2
++
	jsr Game.Main.Player.DisplaceBullet0.PhysicallyDisplace

	jsr Game.Main.Player.DisplaceBullet0.ValidateLocation
	beq +
	jsr Game.Main.Player.DisplaceBullet0.Deactivate
	rts
+
	lda Standard.Main.ZTempVar3
	ldy #Game.Player.Bullet0.XM - Game.Player.Bullet0
	jsr Game.ObjectDraw.PushSingle.Player.0
	jmp Game.Main.Player.DisplaceBullets.Return0

Game.Main.Player.DisplaceBullet1.DisplaceCollidable:

	lda Game.Player.Bullet1.Status
	and #Game.Player.Bullet.Direction				;1 for Left, 0 for right
	bne +

	lda Standard.Main.ZTempVar0
	ldx Standard.Main.ZTempVar1
	ldy Standard.Main.ZTempVar2
	jmp ++

+
	lda Standard.Main.ZTempVar0
	eor #$FF
	clc
	adc #1
	pha
	lda Standard.Main.ZTempVar1
	eor #$FF
	adc #0
	tax
	pla
	ldy Standard.Main.ZTempVar2
++
	jsr Game.Main.Player.DisplaceBullet1.PhysicallyDisplace

	jsr Game.Main.Player.DisplaceBullet1.ValidateLocation
	beq +
	jsr Game.Main.Player.DisplaceBullet1.Deactivate
	rts
+
	lda Standard.Main.ZTempVar3
	ldy #Game.Player.Bullet1.XM - Game.Player.Bullet0
	jsr Game.ObjectDraw.PushSingle.Player.0
	jmp Game.Main.Player.DisplaceBullets.Return1

Game.Main.Player.DisplaceBullet2.DisplaceCollidable:

	lda Game.Player.Bullet2.Status
	and #Game.Player.Bullet.Direction				;1 for Left, 0 for right
	bne +

	lda Standard.Main.ZTempVar0
	ldx Standard.Main.ZTempVar1
	ldy Standard.Main.ZTempVar2
	jmp ++

+
	lda Standard.Main.ZTempVar0
	eor #$FF
	clc
	adc #1
	pha
	lda Standard.Main.ZTempVar1
	eor #$FF
	adc #0
	tax
	pla
	ldy Standard.Main.ZTempVar2
++
	jsr Game.Main.Player.DisplaceBullet2.PhysicallyDisplace

	jsr Game.Main.Player.DisplaceBullet2.ValidateLocation
	beq +
	jsr Game.Main.Player.DisplaceBullet2.Deactivate
	rts
+

	lda Standard.Main.ZTempVar3
	ldy #Game.Player.Bullet2.XM - Game.Player.Bullet0
	jsr Game.ObjectDraw.PushSingle.Player.0
	jmp Game.Main.Player.DisplaceBullets.Return2


;*****************************************
Game.Main.Player.DisplaceBullet0.ValidateLocation:
;Function: Given the location of a bullet, it's location is validated. If bullet is out of range,
;The routine will return a non-zero value in A.

;Sample values: Bullet XL - $90, Bullet XH - $01, Left L - $FE, Left H - $00, Right L - $30, Right H - $02

	lda Game.Player.Bullet0.YH
	and #$F0
	cmp #$F0
	beq +

	lda Game.Player.Bullet0.XH
	cmp Game.Main.Screen.Activity.LeftBoundH
	bcc +							;If Carry is clear, that means we are in fact out of range.
	bne ++							;If they are not equal, Bullet0 is beyond than Left Bound
	lda Game.Player.Bullet0.XM
	cmp Game.Main.Screen.Activity.LeftBoundL
	bcc +							;If low part is less than left bound's low part, out of
	lda #0							;range is true. Otherwise, the bullet has to be in range.
	rts

+
	lda #1
	rts
++

	lda Game.Main.Screen.Activity.RightBoundH		;If the bullet is beyond the right bound, well then there
	cmp Game.Player.Bullet0.XH			;You go. Return out of range truth.
	bcc +
	bne ++
	lda Game.Main.Screen.Activity.RightBoundL
	cmp Game.Player.Bullet0.XM
	bcc +

++
	lda #0
	rts
+
	lda #1
	rts

Game.Main.Player.DisplaceBullet1.ValidateLocation:
;Function: Given the location of a bullet, it's location is validated. If bullet is out of range,
;The routine will return a non-zero value in A.

;Sample values: Bullet XL - $90, Bullet XH - $01, Left L - $FE, Left H - $00, Right L - $30, Right H - $02


	lda Game.Player.Bullet1.YH
	and #$F0
	cmp #$F0
	beq +

	lda Game.Player.Bullet1.XH
	cmp Game.Main.Screen.Activity.LeftBoundH
	bcc +							;If Carry is clear, that means we are in fact out of range.
	bne ++							;If they are not equal, Bullet0 is beyond than Left Bound
	lda Game.Player.Bullet1.XM
	cmp Game.Main.Screen.Activity.LeftBoundL
	bcc +							;If low part is less than left bound's low part, out of
	lda #0							;range is true. Otherwise, the bullet has to be in range.
	rts

+
	lda #1
	rts
++

	lda Game.Main.Screen.Activity.RightBoundH		;If the bullet is beyond the right bound, well then there
	cmp Game.Player.Bullet1.XH			;You go. Return out of range truth.
	bcc +
	bne ++
	lda Game.Main.Screen.Activity.RightBoundL
	cmp Game.Player.Bullet1.XM
	bcc +

++
	lda #0
	rts
+
	lda #1
	rts

Game.Main.Player.DisplaceBullet2.ValidateLocation:
;Function: Given the location of a bullet, it's location is validated. If bullet is out of range,
;The routine will return a non-zero value in A.

;Sample values: Bullet XL - $90, Bullet XH - $01, Left L - $FE, Left H - $00, Right L - $30, Right H - $02

	lda Game.Player.Bullet2.YH
	and #$F0
	cmp #$F0
	beq +

	lda Game.Player.Bullet2.XH
	cmp Game.Main.Screen.Activity.LeftBoundH
	bcc +							;If Carry is clear, that means we are in fact out of range.
	bne ++							;If they are not equal, Bullet0 is beyond than Left Bound
	lda Game.Player.Bullet2.XM
	cmp Game.Main.Screen.Activity.LeftBoundL
	bcc +							;If low part is less than left bound's low part, out of
	lda #0							;range is true. Otherwise, the bullet has to be in range.
	rts

+
	lda #1
	rts
++

	lda Game.Main.Screen.Activity.RightBoundH		;If the bullet is beyond the right bound, well then there
	cmp Game.Player.Bullet2.XH			;You go. Return out of range truth.
	bcc +
	bne ++
	lda Game.Main.Screen.Activity.RightBoundL
	cmp Game.Player.Bullet2.XM
	bcc +

++
	lda #0
	rts
+
	lda #1
	rts


Game.Main.Player.DisplaceBullet0.Deactivate:
	lda #$00
	sta Game.Player.Bullet0
	sta Game.Player.Bullet0 + 1
	sta Game.Player.Bullet0 + 2
	sta Game.Player.Bullet0 + 3
	sta Game.Player.Bullet0 + 4
	sta Game.Player.Bullet0 + 5
	sta Game.Player.Bullet0 + 6
	dec Game.Player.BulletsActive
	rts

Game.Main.Player.DisplaceBullet1.Deactivate:
	lda #$00
	sta Game.Player.Bullet1
	sta Game.Player.Bullet1 + 1
	sta Game.Player.Bullet1 + 2
	sta Game.Player.Bullet1 + 3
	sta Game.Player.Bullet1 + 4
	sta Game.Player.Bullet1 + 5
	sta Game.Player.Bullet1 + 6
	dec Game.Player.BulletsActive
	rts

Game.Main.Player.DisplaceBullet2.Deactivate:
	lda #$00
	sta Game.Player.Bullet2
	sta Game.Player.Bullet2 + 1
	sta Game.Player.Bullet2 + 2
	sta Game.Player.Bullet2 + 3
	sta Game.Player.Bullet2 + 4
	sta Game.Player.Bullet2 + 5
	sta Game.Player.Bullet2 + 6
	dec Game.Player.BulletsActive
	rts


Game.Main.Player.DisplaceBullet0.PhysicallyDisplace:
;Function: Universal routine for physically moving bullets given low and high values for X and Y.
;XL comes in A, XM comes in X, YL comes in upper for bits of Y, YH comes in lower 4 bits of Y. Pay close attention
;To the thing about Y! It's clever, too.

	clc
	adc Game.Player.Bullet0.XL
	sta Game.Player.Bullet0.XL
	txa
	and #$08
	bne +
	lda Game.Player.Bullets.Directions
	and #$FE
	sta Game.Player.Bullets.Directions
	txa
	adc Game.Player.Bullet0.XM
	sta Game.Player.Bullet0.XM
	lda Game.Player.Bullet0.XH
	adc #0
	sta Game.Player.Bullet0.XH
	jmp ++
+
	lda Game.Player.Bullets.Directions
	ora #1
	sta Game.Player.Bullets.Directions
	txa
	adc Game.Player.Bullet0.XM
	sta Game.Player.Bullet0.XM
	lda Game.Player.Bullet0.XH
	adc #$FF
	sta Game.Player.Bullet0.XH
++
	clc
	tya
	and #$08					;Check negativity bit
	bne +
	tya
	and #$F0
	adc Game.Player.Bullet0.YL
	sta Game.Player.Bullet0.YL
	tya
	and #$0F
	adc Game.Player.Bullet0.YH
	sta Game.Player.Bullet0.YH
	rts
+
	tya
	and #$F0
	adc Game.Player.Bullet0.YL
	sta Game.Player.Bullet0.YL
	tya
	and #$0F
	ora #$F0
	adc Game.Player.Bullet0.YH
	sta Game.Player.Bullet0.YH
	rts

Game.Main.Player.DisplaceBullet1.PhysicallyDisplace:
	clc
	adc Game.Player.Bullet1.XL
	sta Game.Player.Bullet1.XL
	txa
	and #$08
	bne +
	lda Game.Player.Bullets.Directions
	and #$FD
	sta Game.Player.Bullets.Directions
	txa
	adc Game.Player.Bullet1.XM
	sta Game.Player.Bullet1.XM
	lda Game.Player.Bullet1.XH
	adc #0
	sta Game.Player.Bullet1.XH
	jmp ++
+
	lda Game.Player.Bullets.Directions
	ora #2
	sta Game.Player.Bullets.Directions
	txa
	adc Game.Player.Bullet1.XM
	sta Game.Player.Bullet1.XM
	lda Game.Player.Bullet1.XH
	adc #$FF
	sta Game.Player.Bullet1.XH
++
	clc
	tya
	and #$08					;Check negativity bit
	bne +
	tya
	and #$F0
	adc Game.Player.Bullet1.YL
	sta Game.Player.Bullet1.YL
	tya
	and #$0F
	adc Game.Player.Bullet1.YH
	sta Game.Player.Bullet1.YH
	rts
+
	tya
	and #$F0
	adc Game.Player.Bullet1.YL
	sta Game.Player.Bullet1.YL
	tya
	and #$0F
	ora #$F0
	adc Game.Player.Bullet1.YH
	sta Game.Player.Bullet1.YH
	rts

Game.Main.Player.DisplaceBullet2.PhysicallyDisplace:
	clc
	adc Game.Player.Bullet2.XL
	sta Game.Player.Bullet2.XL
	txa
	and #$08
	bne +
	lda Game.Player.Bullets.Directions
	and #$FB
	sta Game.Player.Bullets.Directions
	txa
	adc Game.Player.Bullet2.XM
	sta Game.Player.Bullet2.XM
	lda Game.Player.Bullet2.XH
	adc #0
	sta Game.Player.Bullet2.XH
	jmp ++
+
	lda Game.Player.Bullets.Directions
	ora #4
	sta Game.Player.Bullets.Directions
	txa
	adc Game.Player.Bullet2.XM
	sta Game.Player.Bullet2.XM
	lda Game.Player.Bullet2.XH
	adc #$FF
	sta Game.Player.Bullet2.XH
++
	clc
	tya
	and #$08					;Check negativity bit
	bne +
	tya
	and #$F0
	adc Game.Player.Bullet2.YL
	sta Game.Player.Bullet2.YL
	tya
	and #$0F
	adc Game.Player.Bullet2.YH
	sta Game.Player.Bullet2.YH
	rts
+
	tya
	and #$F0
	adc Game.Player.Bullet2.YL
	sta Game.Player.Bullet2.YL
	tya
	and #$0F
	ora #$F0
	adc Game.Player.Bullet2.YH
	sta Game.Player.Bullet2.YH
	rts

;********************************************************************************
Game.Main.AI.CollideWithBullets:
;Expected: Address of coordinates in AIRAM.PointerL and AIRAM.PointerH. Also, width and height in A and X.
;Height in X, Width in A.
;Returns: Confirmation of collision in A, Bullet ID in X, Universal damage amount in Y.

	pha
	txa
	pha

	lda Game.Player.Bullet0.Status
	and #Game.Player.Bullet.Active
	beq +
	ldx Game.Player.Bullet0.ID
	lda Game.Main.Player.Bullets.Collidable.w,x
	beq +

	jmp Game.Main.Player.CollideWithBullet0.Standard
	
Game.Main.AI.CollideWithBullets.Return0:
	bne ++
+
	lda Game.Player.Bullet1.Status
	and #Game.Player.Bullet.Active
	beq +
	ldx Game.Player.Bullet1.ID

	lda Game.Main.Player.Bullets.Collidable.w,x
	beq +

	jmp Game.Main.Player.CollideWithBullet1.Standard
	
Game.Main.AI.CollideWithBullets.Return1:
	bne ++
+
	lda Game.Player.Bullet2.Status
	and #Game.Player.Bullet.Active
	beq +
	ldx Game.Player.Bullet2.ID

	lda Game.Main.Player.Bullets.Collidable.w,x
	beq +

	jmp Game.Main.Player.CollideWithBullet2.Standard
	
Game.Main.AI.CollideWithBullets.Return2:
	bne ++
+
	pla					;If we branch to this lable, the check for collision was not necessary.
	pla					;In this case, we need to pull the values we pushed back into nothingness.
	lda #0					;No collision
++
	rts

;*******************************************************************************
Game.Main.Player.CollideWithBullet0.SinglePoint:
Game.Main.Player.CollideWithBullet0.Standard:

	Game.Main.AI.CollideWithSinglePointBullet.0() 0, 1, Game.Main.Player.CollideWithBullet0.Standard.Return
Game.Main.Player.CollideWithBullet0.Standard.Return:
	beq +
	lda Game.Player.Bullet0.ID
	pha
	jsr Game.Main.Player.DisplaceBullet0.Deactivate
	pla
	tax
	ldy Game.Main.Player.Bullets.Damage.w,x
	ldx #0
	lda #1
+
	jmp Game.Main.AI.CollideWithBullets.Return0

;************
Game.Main.Player.CollideWithBullet1.Standard:

Game.Main.Player.CollideWithBullet1.SinglePoint:
	Game.Main.AI.CollideWithSinglePointBullet.1() 0, 1, Game.Main.Player.CollideWithBullet1.Standard.Return

Game.Main.Player.CollideWithBullet1.Standard.Return:

	beq +
	lda Game.Player.Bullet1.ID
	pha
	jsr Game.Main.Player.DisplaceBullet1.Deactivate
	pla
	tax
	ldy Game.Main.Player.Bullets.Damage.w,x
	ldx #1
	lda #1
+
	jmp Game.Main.AI.CollideWithBullets.Return1

;***********
Game.Main.Player.CollideWithBullet2.Standard:

Game.Main.Player.CollideWithBullet2.SinglePoint:
	Game.Main.AI.CollideWithSinglePointBullet.2() 0, 1, Game.Main.Player.CollideWithBullet2.Standard.Return

Game.Main.Player.CollideWithBullet2.Standard.Return:

	beq +
	lda Game.Player.Bullet2.ID
	pha
	jsr Game.Main.Player.DisplaceBullet2.Deactivate
	pla
	tax
	ldy Game.Main.Player.Bullets.Damage.w,x
	ldx #2
	lda #1
+
	jmp Game.Main.AI.CollideWithBullets.Return2

