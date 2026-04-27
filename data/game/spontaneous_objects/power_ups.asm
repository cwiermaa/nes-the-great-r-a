
;*******************************************************************************
Game.Main.Player.DisplaceBullet.PointersL:
	.db <Game.Main.Player.DisplaceStandard
	.db <Game.Main.Player.DisplaceShotgun
	.db <Game.Main.Player.BoostHealth
	.db <Game.Main.Player.DisplaceStandard			;Running Power Up
	.db <Game.Main.Player.DisplaceStandard			;Jumping Power Up
	
Game.Main.Player.DisplaceBullet.PointersH:
	.db >Game.Main.Player.DisplaceStandard
	.db >Game.Main.Player.DisplaceShotgun
	.db >Game.Main.Player.BoostHealth
	.db >Game.Main.Player.DisplaceStandard
	.db >Game.Main.Player.DisplaceStandard
	
;*******************************************************************************
;* Potential Damage and Effect Type
;****************************************************************************

Game.Main.Player.Bullets.Collidable:
;This table indicates whether or not a power-up is something that can
;collide with enemies. For example, the standard gun shootes bullets that
;Collide with enemies, but the invincibility power-up does not collide with
;enemies. For each power up, in order, list a 0 or non-0 value indicating
;Whether or not it should be collidable.

	.db 1
	.db 1
	.db 0
	.db 1
	.db 1
	
Game.Main.Player.Bullets.Damage:
;Indicates potential damage for power-ups.

	.db 1
	.db 2
	.db 0
	.db 1
	.db 1
	
Game.Main.Player.Bullets.AmmoRequired:

	.db 0
	.db 1
	.db 5
	.db 0
	.db 0

Game.Main.Player.Bullets.SoundEffects:
	.db 1
	.db 13
	.db 0
	.db 1
	.db 1
	
;****************************************************************************
;* Bullet Displacement Code
;****************************************************************************

;The routines that follow determine how bullets are displaced each frame.
;Currently, only single point bullets are supported. Otherwise, power ups are non-collidable.
;The following routines must determine the X and Y displacement values
;As well as the tile for a given bullet. They must be stored into the
;Temp variables as follows:

;ZTempVar0 - X Displacement Low
;ZTempVar1 - X Displacement High (4 bits; 3 value, 1 sign)
;ZTempVar2 - Y Displacement Low and High (LLLLHHHH)
;ZTempVar3 - Tile ID

;After these values are determined for the given frame, we jump to
;Game.Main.Player.DisplaceBullet.DetermineBullet.
;This will take the generic code and determine which bullet to apply it to.
;Otherwise, for consumables, or power-ups that don't move, we can either
;Go to Game.Main.Player.DeactivateBullet.DetermineBullet to deactivate
;The current instance of the power-up, or we can go to
;Game.Main.Player.DisplaceBullet.DetermineReturn
;To return and process the other power-ups.

;Note: X Must have the value it contained when the routine began before
;It jumps to the determine bullet routine. This helps the determine bullet
;Routine route it to the specific bullet. Also, the displacement routine
;Automatically flips bullets should they be shot in the other direction.
;Assume that the bullet is shot when facing right.

Game.Main.Player.DisplaceStandard:
	stx Standard.Main.ZTempVar0
	jsr Game.Main.Player.CollideBullet.DetermineCollision
	cmp #1
	bne +
	ldx Standard.Main.ZTempVar0
	jmp Game.Main.Player.DeactivateBullet.DetermineBullet
+
	ldx Standard.Main.ZTempVar0
	lda #$80
	sta Standard.Main.ZTempVar0
	lda #$03
	sta Standard.Main.ZTempVar1
	lda #$00
	sta Standard.Main.ZTempVar2
	lda #$EB
	sta Standard.Main.ZTempVar3

	jmp Game.Main.Player.DisplaceBullet.DetermineBullet


Game.Main.Player.DisplaceShotgun:
	lda #$80
	sta Standard.Main.ZTempVar0
	lda #$03
	sta Standard.Main.ZTempVar1
	lda #$00
	sta Standard.Main.ZTempVar2
	lda #$EF
	sta Standard.Main.ZTempVar3
	jmp Game.Main.Player.DisplaceBullet.DetermineBullet

Game.Main.Player.BoostHealth:
	clc
	lda Game.Player.Health
	adc #5
	sta Game.Player.Health
	jmp Game.Main.Player.DeactivateBullet.DetermineBullet

	
;****************************************************************************
