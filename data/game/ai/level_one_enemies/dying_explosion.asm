.DEFINE DyingExplosion.Counter AIRAM.16

Game.AI.DyingExplosion:
	bne +
	lda #15
	sta DyingExplosion.Counter.w,y
	lda #12
	sta Sound.SFX.SoundEffect
	jmp ++
+
	lda #1
	jsr Game.AI.Animate
	sec
	lda DyingExplosion.Counter.w,y
	sbc #1
	sta DyingExplosion.Counter.w,y
	bne +
	jsr Game.AI.DestroyEnemy
+
	jmp Game.Main.HandleAI.Return
	
Game.AI.DyingExplosionBoss:
	bne +
	lda #50
	sta DyingExplosion.Counter.w,y
	lda #15
	sta Sound.SFX.SoundEffect
	jmp ++
+
	lda #1
	jsr Game.AI.Animate
	sec
	lda DyingExplosion.Counter.w,y
	sbc #1
	sta DyingExplosion.Counter.w,y
	bne +
	jsr Game.AI.DestroyEnemy
+
	jmp Game.Main.HandleAI.Return
