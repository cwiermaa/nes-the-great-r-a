Game.AI.StandaloneItem:
	bne +
	lda #1
	jsr Game.AI.Animate
	lda #4
	sta Game.AI.VelocityXH
	lda #7
	sta Game.AI.VelocityYH
	lda #$00
	sta Game.AI.VelocityXL
	sta Game.AI.VelocityYL
	
	jsr Game.AI.Universal.DisplaceX
	jsr Game.AI.Universal.DisplaceY
	ldy Game.AIRAM.Current
	lda AIRAM.ObjectNumber.w,y
	tax
	jsr Game.AI.Item.GetItem
	tay
	lda #0
	ldx #0
	jsr Game.AI.Weapon.Instantiate
	ldy Game.AIRAM.Current
+
	lda #8
	ldx #8
	jsr Game.AI.CollideWithPlayer
	beq +
	jsr Game.AI.DestroyEnemy
+
	jmp Game.Main.HandleAI.Return