Game.AI.TemplateEnemy:
	bne +
	;Initializing values
	
+

	ldx #16
	lda #16
	jsr Game.AI.StandardDamage
	bne ++
	
	lda #1
	jsr Game.AI.Animate

++
	jsr Game.AI.Universal.DisplaceX
	jsr Game.AI.Universal.DisplaceY
	jsr Game.AI.StandardCheckForDeath
	
	lda #16
	ldx #16
	jsr Game.AI.StandardDamageFromTouch
	jmp Game.Main.HandleAI.Return