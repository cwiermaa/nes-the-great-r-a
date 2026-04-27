;Contents
;Section_000 - Intelligent Object Routine Pointers
;Section_001 - Common non-physics related AI routines

.incdir "data/game/ai"
.include "ai_macros.asm"
.include "enemy_scores.asm"
.incdir "data/game/ai/level_one_enemies"
.include "level1_enemies.asm"
.include "dying_explosion.asm"

.DEFINE AI.ObjectID 0
.DEFINE AI.ObjectNumber 1
.DEFINE AI.Y 2
.DEFINE AI.XL 3
.DEFINE AI.XH 4
.DEFINE AI.PrecisionYX 5
.DEFINE AIRAM.PrecisionYX AIRAM.5
.DEFINE AI.VelocityY 6
.DEFINE AIRAM.VelocityY AIRAM.6
.DEFINE AI.VelocityX 7
.DEFINE AIRAM.VelocityX AIRAM.7

.DEFINE AI.Health 8
.DEFINE AIRAM.Health AIRAM.8

.DEFINE AI.WeaponY 9
.DEFINE AIRAM.WeaponY AIRAM.9
.DEFINE AI.WeaponXL 10
.DEFINE AIRAM.WeaponXL AIRAM.10
.DEFINE AI.WeaponXH 11
.DEFINE AIRAM.WeaponXH AIRAM.11
.DEFINE AI.WeaponYP 12
.DEFINE AIRAM.WeaponYP AIRAM.12
.DEFINE AI.WeaponXP 13
.DEFINE AIRAM.WeaponXP AIRAM.13

.DEFINE AI.StartingY 9
.DEFINE AIRAM.StartingY AIRAM.9
.DEFINE AI.EndingY 10
.DEFINE AIRAM.EndingY AIRAM.10

.DEFINE AI.WeightIndex 14
.DEFINE AIRAM.WeightIndex AIRAM.14
.DEFINE AI.JumpIndex 15
.DEFINE AIRAM.JumpIndex AIRAM.15

.DEFINE AI.ActionStatus 21
.DEFINE AIRAM.ActionStatus AIRAM.21

.DEFINE AI.ActionStatus.Hatched 1
.DEFINE AI.ActionStatus.Dying 2
.DEFINE AI.ActionStatus.Jumping 4
.DEFINE AI.ActionStatus.Jumping.Inverted $FB
.DEFINE AI.ActionStatus.FacingRight 8
.DEFINE AI.ActionStatus.FacingRight.Inverted $F7
.DEFINE AI.ActionStatus.JumpedOn.Permission 16
.DEFINE AI.ActionStatus.JumpedOn.Permission.Inverted $EF

;Use only if needed
.DEFINE AI.ActionStatus.CollideUp 16
.DEFINE AI.ActionStatus.CollideDown 32
.DEFINE AI.ActionStatus.CollideLeft 64
.DEFINE AI.ActionStatus.CollideRight 128

;*********************************************************************************
;Section_000: Intelligent Object Pointers

Game.AI.PointersL:
	.db <Game.AI.Nothing, <Game.AI.LavaBall, <Game.AI.FireBelcher, <Game.AI.BouncingBall
	.db <Game.AI.FireTremor, <Game.AI.FireBird, <Game.AI.Geyser, <Game.AI.FireBott
	.db <Game.AI.MarsRexBlue, <Game.AI.Pterodactyl, <Game.AI.LavaBlob, <Game.AI.DyingExplosion
	.db <Game.AI.Platform3Long, <Game.AI.StandaloneItem, <Game.AI.DyingExplosionBoss
	
Game.AI.PointersH:
	.db >Game.AI.Nothing, >Game.AI.LavaBall, >Game.AI.FireBelcher, >Game.AI.BouncingBall
	.db >Game.AI.FireTremor, >Game.AI.FireBird, >Game.AI.Geyser, >Game.AI.FireBott
	.db >Game.AI.MarsRexBlue, >Game.AI.Pterodactyl, >Game.AI.LavaBlob, >Game.AI.DyingExplosion
	.db >Game.AI.Platform3Long, >Game.AI.StandaloneItem, >Game.AI.DyingExplosionBoss


;*********************************************************************************
;Section_001: Common Non-Physics-Related AI Routines

Game.AI.DestroyEnemy:

	ldy Game.AIRAM.Current
	lda AIRAM.ObjectNumber,y
	and #7
	tax
	lda AIRAM.ObjectNumber,y
	lsr a
	lsr a
	lsr a
	tay

	lda Game.ObjectStates.Dead.w,y			;Unset Activity bit
	ora Game.Main.HandleAI.StatusBits.w,x
	sta Game.ObjectStates.Dead.w,y

	ldy Game.AIRAM.Current
	jsr Game.Main.HandleAI.Deactivate
	
	rts

Game.AI.TakeDamage:

	ldy Game.AIRAM.Current
	sec
	sbc AIRAM.Health,y
	eor #$FF
	tax
	inx
	txa
	sta AIRAM.Health,y
	beq +
	bcs +
	lda #0
	rts
+
	lda #AI.ActionStatus.Dying
	rts
	
Game.AI.StandardDamage:
;Standard routine for handling enemy damage.
;Will set a flag if the enemy is shot to death
;Will also set the current animation to emptiness (for one frame).
;Skip animation if a non-zero value is returned.

	jsr Game.Main.AI.CollideWithBullets
	beq +
	cpx #0
	bne ++
	lda Game.Player.Bullets.Directions
	and #1
	jmp +++
++
	cpx #1
	bne ++
	lda Game.Player.Bullets.Directions
	and #2
	jmp +++
++
	lda Game.Player.Bullets.Directions
	and #4
+++
	pha
	tya
	jsr Game.AI.TakeDamage
	ldy Game.AIRAM.Current
	ora AIRAM.ActionStatus.w,y
	sta AIRAM.ActionStatus.w,y
	ldy #0
	lda #0
	sta (Game.Animation.AnimationStack.CurrentL),y
	pla
	beq ++
	lda #$10
++
	ora #1
	pha
	
	lda #10											;36
	jsr Sound.SFX.RequestNew
	pla
+
	rts

Game.AI.StandardCheckForDeath:
;Standard routine for checking for enemy death. Nothing expected.
;Will destroy enemy and add score if called and enemy is dying.

	ldy Game.AIRAM.Current
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.Dying
	beq +
	jsr Game.AI.AddScore
	lda #11
	sta AIRAM.ObjectID.w,y
	lda #0
	sta AIRAM.ActionStatus.w,y
	jsr Game.AI.GenerateDrop
	lda #$FF
	rts
+
	lda #$00
	rts

Game.AI.GenerateDrop:
;Function: Given a random 16-bit number, if the high is in $F0-$FF, an item will be dropped.
;Currently works only with score power ups.
	jsr Standard.Main.Random.16
	lda Standard.Main.Random.Random0
	and #$00
	cmp #$00
	bcc +++
	cmp #$00
	beq ++++
	clc
	ldy #0
	lda Standard.Main.Random.Random1
	rol a
-
	bcc ++
	rol a
	iny
	jmp -
++
	clc
	tya
	adc #Spontaneous.ItemOffset
	tay
	lda #0
	ldx #0
	jsr Game.AI.Weapon.Instantiate
+++
	ldy Game.AIRAM.Current
	rts
++++
;For non-score power-ups
	
	AI.GenerateSpontaneous() 22,0,0,0,0
	rts

Game.AI.StandardDamageFromTouch:
	jsr Game.AI.CollideWithPlayer
	beq +
	ldy Game.AIRAM.Current
	lda AIRAM.ObjectID.w,y
	tax
	clc
	lda Game.Player.Damage
	adc Game.AI.DamageTable.w,x
	sta Game.Player.Damage
+
	rts
	
Game.AI.Animate:
;Function: Given an animation ID and an object ID, hook up the correct animation.
;Expected: Animation ID in A.

	jsr Game.AI.Animate.GetHighAndLow
	tya
	
	ldy #5
	sta (Game.Animation.AnimationStack.CurrentL),y
	lda Standard.Main.ZTempVar0
	ldy #3
	sta (Game.Animation.AnimationStack.CurrentL),y
	lda Standard.Main.ZTempVar1
	ldy #4
	sta (Game.Animation.AnimationStack.CurrentL),y
	ldy Game.AIRAM.Current
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.FacingRight
	beq +
	lda #1
+
	ldy #0
	ora #$80
	sta (Game.Animation.AnimationStack.CurrentL),y
	ldy Game.AIRAM.Current
	rts

Game.AI.Animate.GetHighAndLow:
	pha								;First get object ID into X.
	ldy Game.AIRAM.Current
	lda AIRAM.ObjectID.w,y
	tax
	pla
	tay
	
	cmp #1
	bne +
	lda Game.Animations.1L.w,x
	sta Standard.Main.ZTempVar0
	lda Game.Animations.1H.w,x
	sta Standard.Main.ZTempVar1
	rts
+
	cmp #2
	bne +
	lda Game.Animations.2L.w,x
	sta Standard.Main.ZTempVar0
	lda Game.Animations.2H.w,x
	sta Standard.Main.ZTempVar1
	rts
+
	cmp #4
	bne +
	lda Game.Animations.3L.w,x
	sta Standard.Main.ZTempVar0
	lda Game.Animations.3H.w,x
	sta Standard.Main.ZTempVar1
	rts
+
	cmp #8
	bne +
	lda Game.Animations.4L.w,x
	sta Standard.Main.ZTempVar0
	lda Game.Animations.4H.w,x
	sta Standard.Main.ZTempVar1
	rts
+
	cmp #16
	bne +
	lda Game.Animations.5L.w,x
	sta Standard.Main.ZTempVar0
	lda Game.Animations.5H.w,x
	sta Standard.Main.ZTempVar1
	rts
+
	cmp #32
	bne +
	lda Game.Animations.6L.w,x
	sta Standard.Main.ZTempVar0
	lda Game.Animations.6H.w,x
	sta Standard.Main.ZTempVar1
	rts
+
	cmp #64
	bne +
	lda Game.Animations.7L.w,x
	sta Standard.Main.ZTempVar0
	lda Game.Animations.7H.w,x
	sta Standard.Main.ZTempVar1
	rts
+
	lda Game.Animations.8L.w,x
	sta Standard.Main.ZTempVar0
	lda Game.Animations.8H.w,x
	sta Standard.Main.ZTempVar1
	rts


	
Game.AI.AddScore:
	ldy Game.AIRAM.Current
	lda AIRAM.ObjectID.w,y
	asl a
	tay
	lda Game.AI.EnemyScores.w,y
	tax
	lda Game.AI.EnemyScores.w+1,y
	jsr Game.Main.AddScore
	ldy Game.AIRAM.Current
	rts
	
Game.AI.Weapon.Instantiate:
;Function: Given an X offset in A, and a Y offset in X, a bullet will be instantiated
;using the enemy's coordinates as a reference point.
;Expected: X offset in A, Y offset in X, bullet ID in Y.
	pha
	lda #$00
	sta Standard.Main.ZTempVar6
	pla
	
Game.AI.Weapon.Instantiate.IncludeWidth:
;Function: Instantiates weapon, with the caller specifying a width value to affect
;The placement of the bullet in ZTempVar6.

	sta Standard.Main.ZTempVar0
	stx Standard.Main.ZTempVar1
	sty Standard.Main.ZTempVarF

+++
	ldy #$FF
	and #$80
	bne +
	ldy #$00
+
	sty Standard.Main.ZTempVar2
	
	clc
	lda Game.AI.YH
	adc Standard.Main.ZTempVar1
	sta Standard.Main.ZTempVar3
	
	ldy Game.AIRAM.Current
	lda AIRAM.ActionStatus.w,y
	and #AI.ActionStatus.FacingRight		;If facing right, go to +
	bne +
	lda Standard.Main.ZTempVarF
	eor #$80
	sta Standard.Main.ZTempVarF
	sec
	lda Game.AI.XL
	sbc Standard.Main.ZTempVar0
	sta Standard.Main.ZTempVar4
	lda Game.AI.XH
	sbc Standard.Main.ZTempVar2
	sta Standard.Main.ZTempVar5
	jmp ++
	
+	
	clc
	lda Game.AI.XL
	adc Standard.Main.ZTempVar0
	sta Standard.Main.ZTempVar4
	lda Game.AI.XH
	adc Standard.Main.ZTempVar2
	sta Standard.Main.ZTempVar5
	clc
	lda Standard.Main.ZTempVar4
	adc Standard.Main.ZTempVar6
	sta Standard.Main.ZTempVar4
	lda Standard.Main.ZTempVar5
	adc #0
	sta Standard.Main.ZTempVar5
++
	lda Standard.Main.ZTempVar3
	ldx Standard.Main.ZTempVar4
	ldy Standard.Main.ZTempVar5
	jsr Game.Main.Item.Spawn
	ldy Game.AIRAM.Current
	rts


	
Game.AI.AddToPlayerDamage:
	clc
	adc Game.Player.Damage
	sta Game.Player.Damage
	rts
	
Game.AI.Item.GetItem:
;Function: Given the object number in X, we will look up the spontaneous item associated with it
;Returns: Item ID in A

	lda Game.ItemAddL
	sta Standard.Main.TempAdd3L
	lda Game.ItemAddH
	sta Standard.Main.TempAdd3H
	
	stx Standard.Main.ZTempVar6
	ldy #0
-
	lda (Standard.Main.TempAdd3L),y
	cmp Standard.Main.ZTempVar6
	beq +
	iny
	iny
	bne -
+
	iny
	lda (Standard.Main.TempAdd3L),y
	rts