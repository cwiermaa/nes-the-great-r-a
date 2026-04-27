;This is the standard AI physics routine library. Here we have collision detection,
;gravity, jumping, swimming, etc. routines that can be used for pretty much any enemy.
Game.AI.Universal.CheckJumpedOn:
;Expected: Height in X, Width in A
	pha
	lda AIRAM.ActionStatus.w,y				;
	and #AI.ActionStatus.JumpedOn.Permission
	bne +++
	pla
-
	lda Game.Player.BottomBorder
	cmp Game.AI.YH
	bcs +
	lda AIRAM.ActionStatus.w,y
	ora #AI.ActionStatus.JumpedOn.Permission
	sta AIRAM.ActionStatus.w,y
	lda #0
	rts
+
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.JumpedOn.Permission.Inverted
	sta AIRAM.ActionStatus.w,y
	lda #0
	rts
+++
	pla
	jsr Game.AI.CollideWithPlayerFeet
	beq -
	lda #1
	rts
	
Game.AI.Universal.CheckFellOffScreen:
	lda Game.AI.YH
	cmp #$E0
	bcc +
	lda #1
	rts
+
	lda #0
	rts
	
;****************************************************
Game.AI.Universal.Gravity.Weight0:
;Function: This routine does not calculate gravity, but it uses an index in a table to give
;The appropriate velocity for the current "frame". This makes things faster, but less
;reliable, I guess.
;Expected: Index in AIRAM containing gravity array index.

	lda AIRAM.WeightIndex.w,y
	tax

	lda Game.AI.GravityTable.Weight0.w,x
	cmp #$FF
	bne +
	dex
	lda Game.AI.GravityTable.Weight0.w,x
+
	pha
	and #$F0
	sta Game.AI.VelocityYL
	pla
	and #$0F
	sta Game.AI.VelocityYH
	inx
	txa
	sta AIRAM.WeightIndex.w,y

	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Jumping.Inverted
	sta AIRAM.ActionStatus.w,y
	rts

Game.AI.Universal.Jump0:
	lda AIRAM.WeightIndex.w,y
	tax

	lda Game.AI.JumpTable.Weight0.w,x
	cmp #$FF
	bne +
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Jumping.Inverted
	sta AIRAM.ActionStatus.w,y
	lda #$01
	rts
+
	pha
	and #$F0
	sta Game.AI.VelocityYL
	pla
	and #$0F
	sta Game.AI.VelocityYH
	inx
	txa
	sta AIRAM.WeightIndex.w,y
	
	lda AIRAM.ActionStatus.w,y
	ora #AI.ActionStatus.Jumping
	sta AIRAM.ActionStatus.w,y
	lda #$00
	rts

Game.AI.Universal.Jump1:
	lda AIRAM.WeightIndex.w,y
	tax

	lda Game.AI.JumpTable.Weight5.w,x
	cmp #$FF
	bne +
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Jumping.Inverted
	sta AIRAM.ActionStatus.w,y
	lda #$01
	rts
+
	pha
	and #$F0
	sta Game.AI.VelocityYL
	pla
	and #$0F
	sta Game.AI.VelocityYH
	inx
	txa
	sta AIRAM.WeightIndex.w,y
	
	lda AIRAM.ActionStatus.w,y
	ora #AI.ActionStatus.Jumping
	sta AIRAM.ActionStatus.w,y
	lda #$00
	rts

Game.AI.Universal.Jump0.AndFallWithCollision:
;Function: Given a width and height, the said enemy will jump and fall as well
;as respond to collision.
;Expected: Height in X, Width in A, Weight in Y.
	pha
	txa
	pha
	tya
	tax
	
	ldy Game.AIRAM.Current
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Jumping
	beq ++++
	
	txa
	bne +
	jsr Game.AI.Universal.Jump0
	beq +++
	jmp ++
+
	jsr Game.AI.Universal.Jump1
	beq +++
++
	lda #0
	sta AIRAM.WeightIndex.w,y
+++
	jmp +++++
++++
	jsr Game.AI.Universal.Gravity.Weight0
+++++
	pla
	tax
	pla
	jsr Game.AI.DisplaceAndCollideY
	beq +
	pha
	lda #0
	sta AIRAM.WeightIndex.w,y
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Jumping.Inverted
	sta AIRAM.ActionStatus.w,y
	pla
+
	rts
	
Game.AI.RiseToStartAndFallToEnd:
	lda Game.AI.VelocityYH
	and #8
	beq +
	jsr Game.AI.RiseToStart
	rts
+
	jsr Game.AI.FallToEnd
	rts
	
Game.AI.RiseToStart:
	ldy Game.AIRAM.Current
	lda AIRAM.StartingY.w,y
	cmp Game.AI.YH
	bcc +
	sta Game.AI.YH
	lda #$FF
	rts
+
	lda #$00
	rts
	
Game.AI.RiseToEnd:
	rts

Game.AI.FallToStart:
	rts
	
Game.AI.FallToEnd:
	ldy Game.AIRAM.Current
	lda Game.AI.YH
	cmp AIRAM.EndingY.w,y
	bcc +
	lda AIRAM.EndingY.w,y
	sta Game.AI.YH
	lda #$FF
	rts
+
	lda #$00
	rts


Game.AI.Universal.DisplaceX:
;Function: Given a velocity and enemy coordinate, the enemy is displaced horizontally.
;Note: Velocity IS SIGNED. the point of negativity is 8 whole pixels. That is read as -8 pixels.

	clc
	lda Game.AI.PrecisionX
	adc Game.AI.VelocityXL
	sta Game.AI.PrecisionX
	php
	lda Game.AI.VelocityXH
	cmp #8
	bcc +

	ora #$F0
	plp
	adc Game.AI.XL
	sta Game.AI.XL
	lda Game.AI.XH
	adc #$FF
	and #$3F
	sta Game.AI.XH
	rts
+
	plp
	adc Game.AI.XL
	sta Game.AI.XL
	lda Game.AI.XH
	adc #0
	and #$3F
	sta Game.AI.XH
	rts
Game.AI.Universal.DisplaceY:
;Function: Given a velocity and enemy coordinate, the enemy is displaced vertically.
;Note: Velocity IS SIGNED. the point of negativity is 8 whole pixels. That is read as -8 pixels.

	clc
	lda Game.AI.PrecisionY
	adc Game.AI.VelocityYL
	sta Game.AI.PrecisionY
	
	lda Game.AI.VelocityYH
	php
	cmp #8
	bcc +
	plp
	ora #$F0
	adc Game.AI.YH
	sta Game.AI.YH
	rts
+
	plp
	adc Game.AI.YH
	sta Game.AI.YH
	rts

Game.AI.FaceOtherDirection:
	
	ldy Game.AIRAM.Current
	lda AIRAM.ActionStatus.w,y
	eor #AI.ActionStatus.FacingRight
	sta AIRAM.ActionStatus.w,y
	rts

Game.AI.FacePlayer:
;Function: Given the player's coordinates and the enemy's coordinates,
;Set or clear the facing right flag of the ActionStatus variable appropriately.
;Expected: Nothing.
;Returns: 1 if Left of player, 0 if to right of player.

	lda Game.AI.XL
	sec
	sbc Game.Player.XL
	lda Game.AI.XH
	sbc Game.Player.XH
	bpl +
	ldy Game.AIRAM.Current
	lda AIRAM.ActionStatus.w,y
	ora #AI.ActionStatus.FacingRight
	sta AIRAM.ActionStatus.w,y
	lda #1
	rts
+
	ldy Game.AIRAM.Current
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.FacingRight.Inverted
	sta AIRAM.ActionStatus.w,y
	lda #0
	rts

Game.AI.CheckFacingPlayer:
;Function: Given the player's coordinates and enemy coordinates, check if the
;enemy is facing the player.
;Expected: Nothing.
;Returns: 0 if not facing player, $FF if facing player.

	lda Game.AI.XL
	sec
	sbc Game.Player.XL
	lda Game.AI.XH
	sbc Game.Player.XH
	bpl ++
	
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.FacingRight
	bne +
	rts
+
	lda #$FF
	rts
++
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.FacingRight
	bne +
	lda #$FF
	rts
+
	lda #0
	rts
	
Game.AI.Universal.LaunchTowardPlayerX:
;Function: Like the MoveTowardPlayer routine, this should make a velocity value
;Negative should the enemy be to the right of the player. However, this launches
;The enemy in the direction of the player, keeping the velocity negative if made
;negative, rather than just switching it back. Primarily called to initialize
;velocity values

	jsr Game.AI.Universal.DecompressCrunchedValues
	jsr Game.AI.FacePlayer
	bne +					;If to the left of player, go to +
	jsr Game.AI.Universal.InvertVelocityX
	jsr Game.AI.Universal.CompressCrunchedValues
+
	ldy Game.AIRAM.Current
	rts
	
Game.AI.Universal.MoveTowardPlayerX:
;Function: Given a positive velocity, determine whether or not the enemy
;Is to the right or left of the player, and alter the velocity accordingly
;To move in the player's direction.
;If the intent is to move away from player, velocity should be negative.
;Expected: Velocity values in appropriate variables.
	jsr Game.AI.FacePlayer
	bne +					;If to the left of player, go to +
	jsr Game.AI.Universal.InvertVelocityX
	jsr Game.AI.Universal.DisplaceX
	jsr Game.AI.Universal.InvertVelocityX
	rts
+
	jsr Game.AI.Universal.DisplaceX
	rts
	
Game.AI.Universal.InvertVelocityX:
;Function: Inverts current X velocity.

	lda Game.AI.VelocityXL
	eor #$F0
	sta Game.AI.VelocityXL
	lda Game.AI.VelocityXH
	eor #$0F
	sta Game.AI.VelocityXH
	clc
	lda Game.AI.VelocityXL
	adc #$10
	sta Game.AI.VelocityXL
	lda Game.AI.VelocityXH
	adc #0
	and #$0F
	sta Game.AI.VelocityXH
	rts
	
Game.AI.Universal.InvertVelocityY:
	lda Game.AI.VelocityYL
	eor #$F0
	sta Game.AI.VelocityYL
	lda Game.AI.VelocityYH
	eor #$0F
	sta Game.AI.VelocityYH
	clc
	lda Game.AI.VelocityYL
	adc #$10
	sta Game.AI.VelocityYL
	lda Game.AI.VelocityYH
	adc #0
	and #$0F
	sta Game.AI.VelocityYH
	rts
;****************************************************
;Game.AI.Universal.Collide.RetrieveSingleType:
;Function: Given a coordinate, the tile type under those coordinates is retrieved

;NOTE: Currently is using the player's type retrieval routines.

	;rts
;Game.AI.Universal.Collide.RetrieveColumnOfTwoTypes:
;Function: Given a coordinate, the tile types at the coordinates specified AND 16 pixels down from that are retrieved.

;NOTE: Currently is using the player's type retrieval routines.

	;rts
;******************************************************

Game.AI.Universal.CollideSolid.RejectLeft:
;Pixel to reject to = X - (X + Width AND #$0F + 1)
;Function: Given enemy coordinates, the coordinates are modified to be pushed one metatile to the left
;Expected: Enemy width - 1 in A
;Warning: Destroys ZTempVar1

	clc
	adc Game.AI.XL
	and #$0F
	clc
	adc #1
	sta Standard.Main.ZTempVar1
	
	sec
	lda Game.AI.XL
	sbc Standard.Main.ZTempVar1
	sta Game.AI.XL
	lda Game.AI.XH
	sbc #0
	sta Game.AI.XH
	lda #$00
	sta Game.AI.PrecisionX
	rts
Game.AI.Universal.CollideSolid.RejectRight:
;Function: Given enemy coordinates, the coordinates are modified to be pushed one metatile to the right.

	lda #$00
	sta Game.AI.PrecisionX
	lda Game.AI.XL
	and #$F0
	clc
	adc #$10
	sta Game.AI.XL
	lda Game.AI.XH
	adc #0
	sta Game.AI.XH
	rts
Game.AI.Universal.CollideSolid.RejectUp:
;To Reject Up: Y - (Y + Height AND #$0F + 1)
;Function: Given enemy coordinates, the coordinates are modified to be pushed one metatile up, and one extra pixel to
;not interfere with the retrieval of 3 tile types on the left/right edges of the enemy.
;Expected: Enemy height - 1 in A
 
	clc
	adc Game.AI.YH
	and #$0F
	clc
	adc #1
	sta Standard.Main.ZTempVar1
	
	sec
	lda Game.AI.YH
	sbc Standard.Main.ZTempVar1
	sta Game.AI.YH
	lda #$00
	sta Game.AI.PrecisionY
	rts
Game.AI.Universal.CollideSolid.RejectDown:
;Function: Given enemy coordinates, the coordinates are modified to be pushed one metatile down. Also add one to not
;interfere with left and right collisions.

	lda Game.AI.YH
	and #$F0
	clc
	adc #$10
	sta Game.AI.YH
	lda #$00
	sta Game.AI.PrecisionY
	rts
;****************************************************

Game.AI.Universal.DecompressCrunchedValues:
;Function: Each enemy has a required byte set aside for velocity. This byte is 4 bits significant, and 4 bits precision,
;So 4 bits represent a whole pixel value and the other 4 represent x/16 of a pixel. This routine takes those 4 high bits,
;puts them in their own byte, and leaves the other 4 in another byte. So we can work with the value as if it were 16-bit.

	ldy Game.AIRAM.Current
	
	lda AIRAM.7.w,y
	tax								;9
	and #$0F						;11
	sta Game.AI.VelocityXH			;14
	txa								;16
	and #$F0						;18
	sta Game.AI.VelocityXL			;21
	
	lda AIRAM.6.w,y
	tax								;30
	and #$0F						;32
	sta Game.AI.VelocityYH			;35
	txa								;37
	and #$F0						;39
	sta Game.AI.VelocityYL			;42

	lda AIRAM.5.w,y
	tax								;51
	and #$F0						;53
	sta Game.AI.PrecisionY			;56
	txa								;58
	asl a							;60
	asl a							;62
	asl a							;64
	asl a							;66
	sta Game.AI.PrecisionX			;69
	
	lda AIRAM.XL.w,y
	sta Game.AI.XL
	lda AIRAM.XH.w,y
	sta Game.AI.XH
	lda AIRAM.YH.w,y
	sta Game.AI.YH
	rts
	
Game.AI.Universal.CompressCrunchedValues:
;Function: Re-crunches velocity and precision bits back into the appropriate one-byte sections.

	ldy Game.AIRAM.Current
	lda Game.AI.VelocityXL
	ora Game.AI.VelocityXH
	sta AIRAM.7.w,y
	lda Game.AI.VelocityYL
	ora Game.AI.VelocityYH
	sta AIRAM.6.w,y


	lda Game.AI.PrecisionX
	lsr a
	lsr a
	lsr a
	lsr a
	ora Game.AI.PrecisionY
	sta AIRAM.5.w,y
	
	lda Game.AI.XL
	sta AIRAM.XL.w,y
	lda Game.AI.XH
	sta AIRAM.XH.w,y
	lda Game.AI.YH
	sta AIRAM.YH.w,y
	rts

;**********************************

Game.AI.CollideWithPlayer:
;Function: Given enemy and player coordinates, establish collision status assuming the player is 32x16 pixels (standing,
;for example).
;Expected: Enemy height in X, width in A.
;Returns: Confirmation of collision with player in A.

	pha
	txa
	pha

	lda Game.Player.BottomBorder
	cmp Game.AI.YH		;Is the top border of the enemy below Player.bottom?
	bcc ++
	lda Game.Player.RightBorderH
	cmp Game.AI.XH		;Is the left border of the enemy right of Player.right? 
	bcc ++							;If PXHW < EXH, PXW is < EX, no collision.
	bne +							;If PXHW != EXH AND PXHW !< EXH, PX > EX. Possible col.
	lda Game.Player.RightBorderL	;If PXHW = EXH, compare PXMW and EXM.
									;If PXMW < EXM, PXW is < EX, no collision.
	cmp Game.AI.XL
	bcc ++
+
	pla							;Pull Height from stack.
	clc
	adc Game.AI.YH
	cmp Game.Player.TopBorder
	bcc +++							;Push X back onto stack, and return.
	pla							;Pull value from stack, but put it back.
	clc
	adc Game.AI.XL
	pha
	lda Game.AI.XH
	adc #0
	cmp Game.Player.XH
	bcc +++						;If EXWH < PXH, EXW < PX, no collision.
								;If EXWH != PXH AND EXWH !< PXH, EXW > PX. Collision.
	beq +

	pla							;Remove value from stack.
	sec
	lda Game.AI.XL
	sbc Game.Player.XL
	lda Game.AI.XH
	sbc Game.Player.XH
	sta Game.Player.HitOnLeft
	
	lda #1
	rts

+
	
	pla
	cmp Game.Player.XL
	bcc ++++						;Push X back onto stack, and return.

	sec
	lda Game.AI.XL
	sbc Game.Player.XL
	lda Game.AI.XH
	sbc Game.Player.XH
	sta Game.Player.HitOnLeft
	lda #1
	rts

++
	pla
	pla
	lda #0
	rts

+++
	pla
++++
	lda #0
	rts

Game.AI.CollideWithPlayerFeet:
;Function: Given enemy and player feet coordinates, establish collision status assuming the player is 16 pixels wide.
;Expected: Enemy height in X, width in A.
;Returns: Confirmation of collision with player feet in A.

	pha
	txa
	pha

	lda Game.Player.BottomBorder
	cmp Game.AI.YH					;Is the top border of the enemy below Player.bottom?
	bcc ++							;If so, no collision.
	lda Game.Player.RightBorderH
	cmp Game.AI.XH					;Is the left border of the enemy right of Player.right? 
	bcc ++							;If PXHW < EXH, PXW is < EX, no collision.
	bne +							;If PXHW != EXH AND PXHW !< EXH, PX > EX. Possible col.
	lda Game.Player.RightBorderL	;If PXHW = EXH, compare PXMW and EXM.
									;If PXMW < EXM, PXW is < EX, no collision.
	cmp Game.AI.XL
	bcc ++
+
	pla							;Pull enemy height from stack.
	clc
	adc Game.AI.YH
	cmp Game.Player.BottomBorder	;Compare to bottom border, because we are just using flat base line of player.
	bcc +++							;Push X back onto stack, and return.
	pla								;Pull value from stack, but put it back.
	clc
	adc Game.AI.XL
	pha
	lda Game.AI.XH
	adc #0
	cmp Game.Player.XH
	bcc +++						;If EXWH < PXH, EXW < PX, no collision.
								;If EXWH != PXH AND EXWH !< PXH, EXW > PX. Collision.
	beq +

	pla							;Remove value from stack.
	
	lda #1
	rts

+
	
	pla
	cmp Game.Player.XL
	bcc ++++						;Push X back onto stack, and return.

	lda #1
	rts

++
	pla
	pla
	lda #0
	rts

+++
	pla
++++
	lda #0
	rts
	
Game.AI.Weapon.CollideWithPlayer:
;Function: Given enemy bullet and player coordinates, establish collision status assuming the player is 16x16 pixels ;(ducking, for example).
;Expected: Height in A, Width in X.

	pha
	txa
	pha

	ldy Game.AIRAM.Current
;We assume Y is pointing to YH

;Y = 0
	lda Game.Player.BottomBorder
	cmp Game.Items.ItemY.w,y			;Is the top border of the enemy below Player.bottom?
	bcc ++

;Y = 2
	lda Game.Player.RightBorderH
	cmp Game.Items.ItemXH.w,y			;Is the left border of the enemy right of Player.right? 
	bcc ++							;If PXHW < EXH, PXW is < EX, no collision.
	bne +							;If PXHW != EXH AND PXHW !< EXH, PX > EX. Possible col.
	lda Game.Player.RightBorderL			;If PXHW = EXH, compare PXMW and EXM.
;Y = 1
								;If PXMW < EXM, PXW is < EX, no collision.
	cmp Game.Items.ItemXL.w,y
	bcc ++
	jmp +++++
+
+++++
	pla							;Pull Height from stack.
	clc
;Y = 0
	adc Game.Items.ItemY.w,y
	cmp Game.Player.TopBorder
	bcc +++							;Push X back onto stack, and return.
	pla							;Pull value from stack, but put it back.
	clc
;Y = 1
	adc Game.Items.ItemXL.w,y
	pha
;Y = 2
	lda Game.Items.ItemXH.w,y
	adc #0
	cmp Game.Player.XH
	bcc +++						;If EXWH < PXH, EXW < PX, no collision.
								;If EXWH != PXH AND EXWH !< PXH, EXW > PX. Collision.
	beq +

	sec
	lda Game.Items.ItemXL.w,y
	sbc Game.Player.XL
	lda Game.Items.ItemXH.w,y
	sbc Game.Player.XH
	sta Game.Player.HitOnLeft
	pla							;Remove value from stack.
	lda #1
	rts

+
	
	pla
	cmp Game.Player.XL
	bcc ++++						;Push X back onto stack, and return.

	sec
	lda Game.Items.ItemXL.w,y
	sbc Game.Player.XL
	lda Game.Items.ItemXH.w,y
	sbc Game.Player.XH
	sta Game.Player.HitOnLeft
	lda #1
	rts

++
	pla
	pla
	lda #0
	rts

+++
	pla
++++
	lda #0
	rts

;******************************************************
Game.AI.CheckOutOfRange:
;Checks if the enemy's top-left is in the universal "danger zone".
;Returns a 0 if not, returns a 1 if in the left, returns a 2 if in the right.

	lda Game.AI.XH
	cmp Game.ValidBorderLH				;9
	bcs +								;12
	lda #1
	rts
+
	bne +								;14
	lda Game.AI.XL
	cmp Game.ValidBorderLL				;23
	bcs +								;26
	lda #1
	rts
+
	lda Game.ValidBorderRH				;31
	cmp Game.AI.XH
	bcs +								;38
	lda #2
	rts
+
	bne +								;40
	lda Game.ValidBorderRL				;45
	cmp Game.AI.XL
	bcs +								;52
	lda #2
	rts
+
	lda #0								;54
	rts
	
Game.AI.CheckNearOutOfRange:
;Checks if the enemy's top-left is near the universal "danger zone".
;Returns a 0 if not, returns a 1 if in the left, returns a 2 if in the right.

	clc
	lda Game.ValidBorderLL
	adc #$20
	sta Standard.Main.ZTempVar4
	lda Game.ValidBorderLH
	adc #0
	sta Standard.Main.ZTempVar5
	sec
	lda Game.ValidBorderRL
	sbc #$20
	sta Standard.Main.ZTempVar6
	lda Game.ValidBorderRH
	sbc #0
	sta Standard.Main.ZTempVar7
	
	lda Game.AI.XH
	cmp Standard.Main.ZTempVar5				;9
	bcs +								;12
	lda #1
	rts
+
	bne +								;14
	lda Game.AI.XL
	cmp Standard.Main.ZTempVar4				;23
	bcs +								;26
	lda #1
	rts
+
	lda Standard.Main.ZTempVar7				;31
	cmp Game.AI.XH
	bcs +								;38
	lda #2
	rts
+
	bne +								;40
	lda Standard.Main.ZTempVar6				;45
	cmp Game.AI.XL
	bcs +								;52
	lda #2
	rts
+
	lda #0								;54
	rts

Game.AI.CheckOutOfRange.VoidActivity:
	jsr Game.AI.CheckOutOfRange
	beq +
	pla
	pla
	ldy #0
	lda #$00
	sta (Game.Animation.AnimationStack.CurrentL),y
	jmp Game.Main.HandleAI.Return
+
	rts

Game.AI.Hatch:

	ldy Game.AIRAM.Current
	lda #AI.ActionStatus.Hatched
	sta AIRAM.21.w,y
	
	lda #$00
	ldy #7
-
	sta (Game.Animation.AnimationStack.CurrentL),y
	dey
	bne -
	
	ldy #0
	lda #$C0
	sta (Game.Animation.AnimationStack.CurrentL),y
	
	ldy Game.AIRAM.Current
	lda AIRAM.ObjectID.w,y
	tax
	lda Game.AI.EnemyHealth.w,x
	sta AIRAM.Health.w,y
	
	lda #$00
	sta Game.AI.VelocityXH
	sta Game.AI.VelocityYH
	sta Game.AI.VelocityXL
	sta Game.AI.VelocityYL

	rts

Game.AI.CheckNotAtLedge:
;Function: Given enemy width and height plus one, return true or false
;Depending on whether or not the enemy is standing at the edge of a platform.
;Expected: Height in A, Width in X.

	pha
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.FacingRight
	beq ++
	pla
	jsr Game.Main.AI.RetrieveSingleType.SkewXY
	cmp #1
	bne +
	ldy Game.AIRAM.Current
	lda #$FF
	rts
+
	ldy Game.AIRAM.Current
	lda #0
	rts
++
	pla
	jsr Game.Main.AI.RetrieveSingleType.SkewY
	cmp #1
	bne +
	ldy Game.AIRAM.Current
	lda #$FF
	rts
+
	ldy Game.AIRAM.Current
	lda #0
	rts

;*************************************************************************
Game.AI.DisplaceAndCollideX:
;Function: Given a height in A, and a width in X, and a velocity,
;The function will displace the said enemy, rejecting them either right or left
;depending on the direction of movement, and return a 1 if rejected left,
;or a 2 if rejected right.

	pha								;height
	txa								;Height
	pha								;Width
	jsr Game.AI.Universal.DisplaceX
	pla								;Width
	tax								;Width
	pla								;Height
	tay								;Height
	
	pha								;Height
	txa								;Width
	pha								;Width
	
	lda Game.AI.VelocityXH
	and #8
	bne ++
	tya
	jsr Game.AI.Collide.Right
	beq +
	pla								;Width
	jsr Game.AI.Universal.CollideSolid.RejectLeft
	pla								;Height
	ldy Game.AIRAM.Current
	lda #1
	rts
+
	pla
	pla
	ldy Game.AIRAM.Current
	lda #0
	rts
	
++
	pla
	pla
	tya
	jsr Game.AI.Collide.Left
	beq +
	jsr Game.AI.Universal.CollideSolid.RejectRight
	ldy Game.AIRAM.Current
	lda #2
	rts
+
	ldy Game.AIRAM.Current
	lda #0
	rts

Game.AI.DisplaceAndCollideY:
;Function: Given a height in X, and a width in A, and a velocity,
;The function will displace the said enemy, rejecting them either down or up
;depending on the direction of movement, and return a 1 if rejected up,
;or a 2 if rejected down.

	pha								;Width
	txa								;Height
	pha								;Height
	jsr Game.AI.Universal.DisplaceY
	pla								;Height
	tax								;Height
	pla								;Width
	tay								;Width
	
	pha								;Width
	txa								;Height
	pha								;Height
	
	lda Game.AI.VelocityYH
	and #8
	bne ++
	tya
	jsr Game.AI.Collide.Down
	beq +
	pla
	jsr Game.AI.Universal.CollideSolid.RejectUp
	pla
	ldy Game.AIRAM.Current
	lda #1
	rts
+
	pla
	pla
	ldy Game.AIRAM.Current
	lda #0
	rts
	
++
	pla
	pla
	tya
	jsr Game.AI.Collide.Up
	beq +
	jsr Game.AI.Universal.CollideSolid.RejectDown
	ldy Game.AIRAM.Current
	lda #2
	rts
+
	ldy Game.AIRAM.Current
	lda #0
	rts
;************************************
;Below are all standard collision routines
;Checking for collision among all borders.

Game.AI.Collide.Up:
;Expected: Width in A
	pha
	and #$30
	bne ++
	jsr Game.Main.AI.RetrieveSingleType
	cmp #1
	bne +++
+
	pla
	lda #$FF
	rts
++
	cmp #$10
	bne +
	jsr Game.Main.AI.RetrieveRowOfTwoTypes
	cmp #1
	beq +
	txa
	cmp #1
	bne +++
+
	pla
	lda #$FF
	rts
++
	jsr Game.Main.AI.RetrieveRowOfThreeTypes
	cmp #1
	beq +
	txa
	cmp #1
	beq +
	tya
	cmp #1
	bne +++
+
	pla
	lda #$FF
	rts
	
+++
	pla
	pha
	and #$0F
	beq +
	pla
	pha
	jsr Game.Main.AI.RetrieveSingleType.SkewX
	cmp #1
	bne +
	pla
	lda #$FF
	rts
+
	pla
	lda #$00
	rts

Game.AI.Collide.Down:
;Expected: Width in A, Height in X
	tay		;Y = Width
	pha		;S = Width
	txa		;A = Height
	pha		;S = Height, Width
	tya		;A = Width
	
	and #$30
	bne ++
	pla
	pha
	jsr Game.Main.AI.RetrieveSingleType.SkewY
	cmp #1
	bne +++
+
	pla
	pla
	lda #$FF
	rts
++
	cmp #$10
	bne +
	pla
	pha
	jsr Game.Main.AI.RetrieveRowOfTwoTypes.SkewY
	cmp #1
	beq +
	txa
	cmp #1
	bne +++
+
	pla
	pla
	lda #$FF
	rts
++
	pla
	pha
	jsr Game.Main.AI.RetrieveRowOfThreeTypes.SkewY
	cmp #1
	beq +
	txa
	cmp #1
	beq +
	tya
	cmp #1
	bne +++
+
	pla
	pla
	lda #$FF
	rts
	
+++
	pla
	tay
	pla
	tax
	pha
	tya
	pha
	txa
	and #$0F
	beq +
	pla
	tay
	pla
	tax
	pha
	tya
	pha
	jsr Game.Main.AI.RetrieveSingleType.SkewXY
	cmp #1
	bne +
	pla
	pla
	lda #$FF
	rts
+
	pla
	pla
	lda #$00
	rts

Game.AI.Collide.Left:
;Expected: Height in A
	pha
	and #$30
	bne ++
	jsr Game.Main.AI.RetrieveSingleType
	cmp #1
	bne +++
+
	pla
	lda #$FF
	rts
++
	cmp #$10
	bne +
	jsr Game.Main.AI.RetrieveColumnOfTwoTypes
	cmp #1
	beq +
	txa
	cmp #1
	bne +++
+
	pla
	lda #$FF
	rts
++
	jsr Game.Main.AI.RetrieveColumnOfThreeTypes
	cmp #1
	beq +
	txa
	cmp #1
	beq +
	tya
	cmp #1
	bne +++
+
	pla
	lda #$FF
	rts
	
+++
	pla
	pha
	and #$0F
	beq +
	pla
	pha
	jsr Game.Main.AI.RetrieveSingleType.SkewY
	cmp #1
	bne +
	pla
	lda #$FF
	rts
+
	pla
	lda #$00
	rts
	
Game.AI.Collide.Right:
;Expected: Height in A, Width in X
	tay		;Y = Height
	pha		;S = Height
	txa		;A = Width
	pha		;S = Width, Height
	tya		;A = Height
	
	and #$30
	bne ++
	pla
	pha
	jsr Game.Main.AI.RetrieveSingleType.SkewX
	cmp #1
	bne +++
+
	pla
	pla
	lda #$FF
	rts
++
	cmp #$10
	bne +
	pla
	pha
	jsr Game.Main.AI.RetrieveColumnOfTwoTypes.SkewX
	cmp #1
	beq +
	txa
	cmp #1
	bne +++
+
	pla
	pla
	lda #$FF
	rts
++
	pla
	pha
	jsr Game.Main.AI.RetrieveColumnOfThreeTypes.SkewX
	cmp #1
	beq +
	txa
	cmp #1
	beq +
	tya
	cmp #1
	bne +++
+
	pla
	pla
	lda #$FF
	rts
	
+++
	pla
	tay
	pla
	tax
	pha
	tya
	pha
	txa
	and #$0F
	beq +
	pla
	tax
	pla
	tay
	pha
	txa
	pha
	tya
	jsr Game.Main.AI.RetrieveSingleType.SkewXY
	cmp #1
	bne +
	pla
	pla
	lda #$FF
	rts
+
	pla
	pla
	lda #$00
	rts
;*************************************************************************

;******************************************************
;************ Gravity Tables *****************
;Each value is 8-bit, using 4 significant bits and 4 precision bits. The tables are arranged
;So that the LS bits are the high 4, and the MS bits are the low 4.

Game.AI.GravityTable.Weight0:
	.db $00, $10, $10, $20, $30, $40, $60, $90, $C0, $11, $51, $A1, $02, $72, $03, $FF

Game.AI.JumpTable.Weight0:
	.db $09, $09, $09, $09, $0A, $0A, $0A, $0A, $0B, $0B, $0B, $0C, $0C, $0C,
	.db $8D, $CD, $FD, $0E, $5E, $AE, $EE, $4F, $5F, $6F, $6F, $6F, $EF, $FF
	
Game.AI.JumpTable.Weight5:
	.db $0B, $0C, $8D, $5E, $AE, $EE, $4F, $6F, $9F, $BF, $CF, $DF, $EF, $EF, $FF