.DEFINE Geyser.Level1SwitchOff 3			;Enemy number that will be shut off on event switch 1
.DEFINE Geyser.Level1SwitchOn 2				;Enemy number that will be turned on with event switch 1

Game.AI.Geyser:

	lda Game.Level.ID
	cmp #0
	bne +
	jmp Game.AI.Geyser.Level1
+
Game.AI.Geyser.Shoot:
	lda Standard.VBLCount
	and #3
	bne +
	ldy #10
	lda #$FC
	ldx #0
	jsr Game.AI.Weapon.Instantiate
+
Game.AI.Geyser.NotShooting:
	lda #1
	jsr Game.AI.Animate

	jmp Game.Main.HandleAI.Return

Game.AI.Geyser.Level1:
	lda Game.Event.Flags
	and #1
	beq +
	lda AIRAM.1.w,y
	cmp #Geyser.Level1SwitchOff
	beq Game.AI.Geyser.NotShooting
	jmp Game.AI.Geyser.Shoot
+
	lda AIRAM.1.w,y
	cmp #Geyser.Level1SwitchOn
	beq Game.AI.Geyser.NotShooting
	jmp Game.AI.Geyser.Shoot