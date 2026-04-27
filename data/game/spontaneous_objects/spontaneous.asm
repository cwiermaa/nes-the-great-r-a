;Contents
;Section_000 - Spontaneous Object Pointers
;Section_001 - Spontaneous Enemy Drops
;Section_002 - Spontaneous Enemy Projectiles
;Section_003 - Common Routines for Spontaneous Objects

.include "power_ups.asm"

.DEFINE Spontaneous.ID Spontaneous.0
.DEFINE Spontaneous.Y Spontaneous.1
.DEFINE Spontaneous.XL Spontaneous.2
.DEFINE Spontaneous.XH Spontaneous.3
.DEFINE Spontaneous.YP Spontaneous.4
.DEFINE Spontaneous.XP Spontaneous.5
.DEFINE Spontaneous.Var0 Spontaneous.6

.DEFINE Spontaneous.ItemOffset 11


;*****************************************************************
;Section_000: Spontaneous Object Pointers

Game.Main.Item.HandlersL:
	.db <Game.Item.Nothing, <Game.Item.Health
	.db <Game.Spontaneous.FireBall.Tossed
	.db <Game.Spontaneous.FireBall.DiagonalDown
	.db <Game.Spontaneous.Rock.HitWall
	.db <Game.Spontaneous.Rock.HitWall2					;5
	.db <Game.Spontaneous.FireBall.Standard
	.db <Game.Spontaneous.FireBall.Brief
	.db <Game.Spontaneous.FireBall.Dropped
	.db <Game.Spontaneous.AcidDrop
	.db <Game.Spontaneous.Geyser						;10
	.db <Game.Spontaneous.Item.Bar1
	.db <Game.Spontaneous.Item.Bar2
	.db <Game.Spontaneous.Item.Bar3
	.db <Game.Spontaneous.Item.Seven1
	.db <Game.Spontaneous.Item.Seven2
	.db <Game.Spontaneous.Item.Seven3
	.db <Game.Spontaneous.Item.Diamond1
	.db <Game.Spontaneous.Item.Diamond2
	.db <Game.Spontaneous.Item.Diamond3
	.db <Game.Spontaneous.Item.Ammo
	.db <Game.Spontaneous.Item.ExtraLife
	.db <Game.Spontaneous.Item.Shotgun
	
Game.Main.Item.HandlersH:
	.db >Game.Item.Nothing, >Game.Item.Health
	.db >Game.Spontaneous.FireBall.Tossed
	.db >Game.Spontaneous.FireBall.DiagonalDown
	.db >Game.Spontaneous.Rock.HitWall
	.db >Game.Spontaneous.Rock.HitWall2
	.db >Game.Spontaneous.FireBall.Standard
	.db >Game.Spontaneous.FireBall.Brief
	.db >Game.Spontaneous.FireBall.Dropped
	.db >Game.Spontaneous.AcidDrop
	.db >Game.Spontaneous.Geyser
	.db >Game.Spontaneous.Item.Bar1
	.db >Game.Spontaneous.Item.Bar2
	.db >Game.Spontaneous.Item.Bar3
	.db >Game.Spontaneous.Item.Seven1
	.db >Game.Spontaneous.Item.Seven2
	.db >Game.Spontaneous.Item.Seven3
	.db >Game.Spontaneous.Item.Diamond1
	.db >Game.Spontaneous.Item.Diamond2
	.db >Game.Spontaneous.Item.Diamond3
	.db >Game.Spontaneous.Item.Ammo
	.db >Game.Spontaneous.Item.ExtraLife
	.db >Game.Spontaneous.Item.Shotgun
	
Game.Item.Nothing:
	jmp Game.Main.ItemReturn

;*************************************************************************	
;Section_001: Enemy Drops

Game.Item.Health:

	lda #$DD
	jsr Game.Item.CollideAndDisplay
	beq +
	lda #7
	sta Sound.SFX.SoundEffect
	lda #15
	jsr Game.Main.AddHealth
	jsr Game.Main.Item.Destroy
+
	jmp Game.Main.ItemReturn

Game.Spontaneous.Item.Ammo:

	lda #$DE
	jsr Game.Item.CollideAndDisplay
	beq +
	lda #7
	sta Sound.SFX.SoundEffect
	clc
	lda #10
	adc Game.Player.Ammo
	sta Game.Player.Ammo
	jsr Game.Main.Item.Destroy
+
	jmp Game.Main.ItemReturn
	
Game.Spontaneous.Item.ExtraLife:

	lda #$DC
	jsr Game.Item.CollideAndDisplay
	beq +
	clc
	lda Game.Player.Lives
	adc #1
	sta Game.Player.Lives
	lda #5
	sta Sound.SFX.SoundEffect
	jsr Game.Main.Item.Destroy
+
	jmp Game.Main.ItemReturn

Game.Spontaneous.Item.Shotgun:
	lda #1
	ldx #$EF
	jmp Game.Item.StandardPowerUp
	
Game.Spontaneous.Item.Bar1:
Game.Spontaneous.Item.Bar2:
Game.Spontaneous.Item.Bar3:
Game.Spontaneous.Item.Seven1:
Game.Spontaneous.Item.Seven2:
Game.Spontaneous.Item.Seven3:
Game.Spontaneous.Item.Diamond1:
Game.Spontaneous.Item.Diamond2:
Game.Spontaneous.Item.Diamond3:

Game.Spontaneous.Item.ScorePowerUp:
;Function: Same routine for all score power ups, use look up tables with IDs to determine tiles and score amounts.

	lda Spontaneous.ID.w,y
	and #$7F
	sec
	sbc #Spontaneous.ItemOffset
	sta Spontaneous.Var0.w,y
	ora #$F0
	
	jsr Game.Item.CollideAndDisplay
	
	beq +
	ldy Game.AIRAM.Current
	lda Spontaneous.Var0.w,y
	tay
	lda Game.Spontaneous.Item.ScorePowerUp.ScoresH.w,y
	tax
	lda Game.Spontaneous.Item.ScorePowerUp.ScoresL.w,y
	jsr Game.Main.AddScore
	jsr Game.Main.Item.Destroy
	lda #8
	sta Sound.SFX.SoundEffect
+
	jmp Game.Main.ItemReturn

Game.Spontaneous.Item.ScorePowerUp.ScoresL:
	.db $64, $FA, $F4
	.db $E8, $C4, $88
	.db $10, $A8, $50
	
Game.Spontaneous.Item.ScorePowerUp.ScoresH:
	.db $00, $00, $01
	.db $03, $09, $13
	.db $27, $61, $C3

;******************************************************************************************
;Section_002: Spontaneous Enemy Weapons

Game.Spontaneous.Geyser:

	lda #8
	jsr Game.AI.Weapon.CollideWithPlayer
	beq +
	sec
	lda Game.Player.VelocityYL
	sbc #$70
	sta Game.Player.VelocityYL
	lda Game.Player.VelocityYH
	sbc #0
	sta Game.Player.VelocityYH
	
+
	lda #$0C
	jsr Game.ObjectDraw.PushSingle.0
	
	lda #$00
	ldx #$FC
	jsr Game.Spontaneous.AddToY
	
	ldx #3
	jsr Game.Spontaneous.StandardCount
	
	jmp Game.Main.ItemReturn
	
Game.Spontaneous.FireBall.Tossed:
	jsr Game.Spontaneous.IncreaseCounter
	
	lda #$00
	sta Standard.Main.ZTempVar1
	
	ldy Game.AIRAM.Current
	lda Game.Spontaneous.ObjectVar0.w,y
	
	jsr Game.Spontaneous.Multiply.32
	
	clc
	lda Standard.Main.ZTempVar0
	adc #$80
	sta Standard.Main.ZTempVar0
	lda Standard.Main.ZTempVar1
	adc #$FE
	tax
	lda Standard.Main.ZTempVar0
	jsr Game.Spontaneous.AddToY
	
	lda #$60
	ldx #$FF
	jsr Game.Spontaneous.AddToX
	
	jsr Game.Spontaneous.Weapon.DestroyOnSolid
	bne +
	
	lda #$EF
	jsr Game.ObjectDraw.PushSingle.1
	
	ldx #8
	lda #8
	ldy #10
	jsr Game.Spontaneous.Weapon.StandardCollision
+
	jmp Game.Main.ItemReturn
	
Game.Spontaneous.FireBall.DiagonalDown:
	lda #$00
	ldx #$02
	jsr Game.Spontaneous.AddToY
	
	lda #$00
	ldx #$FE
	jsr Game.Spontaneous.AddToX
	
	lda #$EF
	jsr Game.ObjectDraw.PushSingle.1
	
	ldx #8
	lda #8
	ldy #10
	jsr Game.Spontaneous.Weapon.StandardCollision
	jmp Game.Main.ItemReturn

Game.Spontaneous.FireBall.Dropped:
	lda #$00
	ldx #$04
	jsr Game.Spontaneous.AddToY
	
	lda #$EF
	jsr Game.ObjectDraw.PushSingle.1
	
	ldx #8
	lda #8
	ldy #10
	jsr Game.Spontaneous.Weapon.StandardCollision
	jsr Game.Spontaneous.Weapon.DestroyOnSolid
	jmp Game.Main.ItemReturn
	
Game.Spontaneous.FireBall.Standard:
	lda #$00
	ldx #$FD
	jsr Game.Spontaneous.AddToX
	
	lda #$EF
	jsr Game.ObjectDraw.PushSingle.1
	
	ldx #8
	lda #8
	ldy #10
	jsr Game.Spontaneous.Weapon.StandardCollision
	jsr Game.Spontaneous.Weapon.DestroyOnSolid
	jmp Game.Main.ItemReturn

Game.Spontaneous.FireBall.Brief:

	lda #$00
	ldx #$F8
	jsr Game.Spontaneous.AddToX
	
	lda #$EF
	jsr Game.ObjectDraw.PushSingle.1
	
	ldx #8
	lda #8
	ldy #10
	jsr Game.Spontaneous.Weapon.StandardCollision
	
	ldx #3
	jsr Game.Spontaneous.StandardCount
	jmp Game.Main.ItemReturn

Game.Spontaneous.AcidDrop:
	ldy Game.AIRAM.Current
	lda Game.Spontaneous.ObjectVar0.w,y
	bne ++
	
	lda #$00
	ldx #$03
	jsr Game.Spontaneous.AddToY
	
	lda #$05
	jsr Game.ObjectDraw.PushSingle.3
	
	ldx #8
	lda #8
	ldy #10
	jsr Game.Spontaneous.Weapon.StandardCollision
	lda #3
	ldx #3
	jsr Game.Spontaneous.Weapon.CheckOnSolid.Offset
	beq +
	ldy Game.AIRAM.Current
	lda #$F0
	sta Game.Spontaneous.ObjectVar0.w,y
	jmp Game.Main.ItemReturn
+
	jmp Game.Main.ItemReturn
++
	ldx #8
	lda #8
	ldy #10
	jsr Game.Spontaneous.Weapon.StandardCollision
	ldy Game.AIRAM.Current
	lda Game.Spontaneous.ObjectVar0.w,y
	sbc #1
	sta Game.Spontaneous.ObjectVar0.w,y
	bne +
	jsr Game.Main.Item.Destroy
+
	lda #$06
	jsr Game.ObjectDraw.PushSingle.3
	jmp Game.Main.ItemReturn
	
Game.Spontaneous.Rock.HitWall:
	
	lda #$00
	ldx #$FD
	jsr Game.Spontaneous.AddToX
	jsr Game.Spontaneous.Weapon.CheckOnSolid
	bne +
	
	lda #$E9
	jsr Game.ObjectDraw.PushSingle.1
	
	ldx #8
	lda #8
	ldy #10
	jsr Game.Spontaneous.Weapon.StandardCollision
	jmp Game.Main.ItemReturn
	
+
	lda #$00
	ldx #$04
	jsr Game.Spontaneous.AddToX
	
	lda #0
	sta Spontaneous.Var0.w,y
	lda Spontaneous.ID.w,y
	and #$80
	eor #$80
	ora #5
	sta Spontaneous.ID.w,y
	jmp Game.Main.ItemReturn
	
Game.Spontaneous.Rock.HitWall2:
	jsr Game.Spontaneous.IncreaseCounter
	
	lda #$00
	sta Standard.Main.ZTempVar1
	
	lda Spontaneous.Var0.w,y
	
	jsr Game.Spontaneous.Multiply.32
	
	ldx Standard.Main.ZTempVar1
	lda Standard.Main.ZTempVar0
	jsr Game.Spontaneous.AddToY
	
	lda #$D0
	ldx #$FF
	jsr Game.Spontaneous.AddToX
	
	jsr Game.Spontaneous.Weapon.DestroyOnSolid
	bne +
	
	lda #$E9
	jsr Game.ObjectDraw.PushSingle.1
	
	ldx #8
	lda #8
	ldy #10
	jsr Game.Spontaneous.Weapon.StandardCollision
+
	jmp Game.Main.ItemReturn

;*********************************************************************
;Section_003: Common Spontaneous Routines

Game.Item.CollideAndDisplay:
;Function: Given a tile ID in A, the item will be displayed flashing and collision will be checked for
;Assuming 8x8 size. Will return 0 if no collision.

	jsr Game.Spontaneous.FlashSingle

	ldy #1
	lda #8
	ldx #8
	jsr Game.AI.Weapon.CollideWithPlayer
	rts
	
Game.Spontaneous.FlashSingle:
;Function: Given a tile ID in A, the tile will be drawn at the object's coordinates
;flashing through all palettes.

	pha
	lda Standard.LoopCount
	and #12
	tax
	pla
	
	cpx #0
	bne +
	jsr Game.ObjectDraw.PushSingle.0
	rts
+
	cpx #4
	bne +
	jsr Game.ObjectDraw.PushSingle.1
	rts
+
	cpx #8
	bne +
	jsr Game.ObjectDraw.PushSingle.2
	rts
+
	jsr Game.ObjectDraw.PushSingle.3
	rts
Game.Spontaneous.StandardCount:
;Function: Given a standard 8-bit counter, we will decrease the value and
;terminate the spontaneous object if the counter reaches 0.
;Expected: Value of counter in X.
	ldy Game.AIRAM.Current
	lda Game.Spontaneous.ObjectVar0.w,y
	beq ++
	sec
	sbc #1
	sta Game.Spontaneous.ObjectVar0.w,y
	bne +
	jsr Game.Main.Item.Destroy
+
	rts
++
	txa
	sta Game.Spontaneous.ObjectVar0.w,y
	rts

Game.Spontaneous.IncreaseCounter:
	ldy Game.AIRAM.Current
	lda Game.Spontaneous.ObjectVar0.w,y
	clc
	adc #1
	sta Game.Spontaneous.ObjectVar0.w,y
	rts
	
Game.Spontaneous.DecreaseCounter:
	ldy Game.AIRAM.Current
	lda Game.Spontaneous.ObjectVar0.w,y
	sec
	sbc #1
	sta Game.Spontaneous.ObjectVar0.w,y
	rts
	
Game.Spontaneous.Weapon.DestroyOnSolid:
;Function: Checks if weapon is against a solid surface, and destroys it if it is.
;Expected: Nothing.
;Returns: True if destroyed, False if not.

	ldy Game.AIRAM.Current
	lda Game.Items.ItemY.w,y
	sta Standard.Main.ZTempVar0
	lda Game.Items.ItemXL.w,y
	tax
	lda Game.Items.ItemXH.w,y
	ldy Standard.Main.ZTempVar0
	jsr Game.Main.LevelDecode.RetrieveSingleType
	cmp #1
	bne +
	jsr Game.Main.Item.Destroy
	lda #$FF
	rts
+
	lda #$00
	rts
	
Game.Spontaneous.Weapon.CheckOnSolid:
	ldy Game.AIRAM.Current
	lda Game.Items.ItemY.w,y
	sta Standard.Main.ZTempVar0
	lda Game.Items.ItemXL.w,y
	tax
	lda Game.Items.ItemXH.w,y
	ldy Standard.Main.ZTempVar0
	jsr Game.Main.LevelDecode.RetrieveSingleType
	cmp #1
	bne +
	lda #$FF
	rts
+
	lda #$00
	rts

Game.Spontaneous.Weapon.CheckOnSolid.Offset:
;Function: Given the width and height of a spontaneous object as well
;As coordinates, determine whether or not collision occurs.
;Expected: Width in X, Height in A.
;Returns: 1 if collision exists, 0 if not.

	ldy Game.AIRAM.Current
	clc
	adc Game.Items.ItemY.w,y
	sta Standard.Main.ZTempVar0
	txa
	clc
	adc Game.Items.ItemXL.w,y
	tax
	lda Game.Items.ItemXH.w,y
	adc #0
	ldy Standard.Main.ZTempVar0
	jsr Game.Main.LevelDecode.RetrieveSingleType
	cmp #1
	bne +
	lda #$FF
	rts
+
	lda #$00
	rts
	rts
Game.Spontaneous.Weapon.StandardCollision:
	sta Standard.Main.ZTempVar0
	tya
	pha
	lda Standard.Main.ZTempVar0
	
	jsr Game.AI.Weapon.CollideWithPlayer
	beq +
	pla
	jsr Game.AI.AddToPlayerDamage
	rts
+
	pla
	rts
	
Game.Spontaneous.AddToX:
;Expected: VL in A, VH in X

	sta Standard.Main.ZTempVar0
	ldy Game.AIRAM.Current
	lda Game.Items.ItemID,y
	and #$80
	beq +
	clc
	lda Standard.Main.ZTempVar0
	eor #$FF
	adc #1
	sta Standard.Main.ZTempVar0
	txa
	eor #$FF
	adc #0
	tax
+
	lda Standard.Main.ZTempVar0
	clc
	adc Game.Spontaneous.ObjectXP.w,y
	sta Game.Spontaneous.ObjectXP.w,y
	txa
	adc Game.Items.ItemXL.w,y
	sta Game.Items.ItemXL.w,y
	ldy #$FF
	txa
	bmi +
	ldy #$00
+
	ldx Game.AIRAM.Current
	tya
	adc Game.Items.ItemXH.w,x
	sta Game.Items.ItemXH.w,x
	ldy Game.AIRAM.Current
	rts
	
Game.Spontaneous.AddToY:
;Expected: VL in A, VH in X

	clc
	ldy Game.AIRAM.Current
	adc Game.Spontaneous.ObjectYP.w,y
	sta Game.Spontaneous.ObjectYP.w,y
	txa
	adc Game.Items.ItemY.w,y
	sta Game.Items.ItemY.w,y
	
	and #$F8
	cmp #$F8
	bne +
	jsr Game.Main.Item.Destroy
+
	ldy Game.AIRAM.Current
	rts
	
Game.Spontaneous.Multiply.32:
	asl a
	rol Standard.Main.ZTempVar1
	
Game.Spontaneous.Multiply.16:
	asl a
	rol Standard.Main.ZTempVar1
	
Game.Spontaneous.Multiply.8:
	asl a
	rol Standard.Main.ZTempVar1
	
Game.Spontaneous.Multiply.4:
	asl a
	rol Standard.Main.ZTempVar1
	
Game.Spontaneous.Multiply.2:
	asl a
	rol Standard.Main.ZTempVar1
	sta Standard.Main.ZTempVar0
	rts
	
Game.Item.StandardPowerUp:
;Function: Given a power-up ID in A and a tile ID in X, the power-up will be displayed
;and given to the player when they collide with it.
;Expected: Power-Up ID in A, Tile ID in X

	pha
	txa
	jsr Game.Item.CollideAndDisplay
	beq +
	pla
	sta Game.Player.PowerUp
	lda #6
	jsr Sound.SFX.RequestNew
	jsr Game.Main.Item.Destroy
	jmp Game.Main.ItemReturn
+
	pla
	jmp Game.Main.ItemReturn