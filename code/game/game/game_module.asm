
;*******************************************************
.MACRO Game.Main.AI.CollideWithSinglePointBullet()
;This is the standard macro for bullets in terms of collision detection. Most bullets are small enough where we only
;Care about checking collision on one single pixel point. This macro is generally not directly accessed. A macro exists
;For each bullet that calls this macro with the standard information for each bullet. The user (well, you), can use
;Those macros specifying only the powerup ID and the potential damage amount. This macro also assumes bullet termination
;On hit.


;Syntax: BulletYH, BulletXH, BulletXM, Return Address High and Low, PowerUp, Potential Damage.

	ldy Game.AIRAM.Current
	lda \1
	cmp AIRAM.YH.w,y			;Is the top border of the enemy below the bullet?
	bcc ++
	lda \2
	cmp AIRAM.XH.w,y			;Is the left border of the enemy right of bullet? 
	bcc ++							;If BXH < EXH, BX is < EX, no collision.
	bne +							;If BXH != EXH AND BX !< EX, BX > EX. Possible col.
	lda \3							;If BXH = EXH, compare BXM and EXM.
									;If BXM < EXM, BX is < EX, no collision.
	cmp AIRAM.XL.w,y
	bcc ++
+
	pla							;Pull Height from stack.
	tax
	clc
	adc AIRAM.YH.w,y
	cmp \1
	bcc +++							;Push X back onto stack, and return.
	pla							;Pull value from stack, but put it back.
	pha
	clc
	adc AIRAM.XL.w,y
	pha
	lda AIRAM.XH.w,y
	adc #0
	cmp \2
	bcc ++++						;If EXWH < BXWH, EXW < BXW, no collision.
								;If EXWH != BXWH AND EXW !< BXW, EXW > BXW. Collision.
	beq +

	pla							;Remove value from stack.
	pla
	ldx #\5
	lda #1
	jmp \4

+
	
	pla
	cmp \3
	bcc +++							;Push X back onto stack, and return.
	pla							;Remove value from stack.
	ldx #\5
	lda #1
	jmp \4

++
	lda #0
	jmp \4
++++
	pla
+++
	txa
	pha
	lda #0
	jmp \4

.ENDM

;In the bottom macros, pass in the following: PowerUp ID, Potential Damage, Return Address.

.MACRO Game.Main.AI.CollideWithSinglePointBullet.0()
	Game.Main.AI.CollideWithSinglePointBullet() Game.Player.Bullet0.YH, Game.Player.Bullet0.XH, Game.Player.Bullet0.XM, \3, \1, \2

.ENDM

.MACRO Game.Main.AI.CollideWithSinglePointBullet.1()
	Game.Main.AI.CollideWithSinglePointBullet() Game.Player.Bullet1.YH, Game.Player.Bullet1.XH, Game.Player.Bullet1.XM, \3, \1, \2

.ENDM


.MACRO Game.Main.AI.CollideWithSinglePointBullet.2()
	Game.Main.AI.CollideWithSinglePointBullet() Game.Player.Bullet2.YH, Game.Player.Bullet2.XH, Game.Player.Bullet2.XM, \3, \1, \2

.ENDM