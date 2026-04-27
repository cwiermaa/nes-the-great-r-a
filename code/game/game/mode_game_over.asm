Game.NMI.ModeDie:
	Standard.NMI.Save.AXY()
	lda #$00
	sta $2005
	sta $2005
	lda #$08
	sta $2001
	inc Standard.VBLCount
	Standard.NMI.Restore.AXY()
	rti
	
Game.Main.ModeDie:
	lda #$00
	sta $4015
	
	lda Game.Player.Lives
	bne +
	
	lda #$00
	sta $2000
	sta $2001
	Standard.SetMain() Game.Main.ModeGameOver
	Standard.SetNMI() Game.NMI.ModeDie
	lda #180
	sta Standard.Main.ZTempVar1
	jsr Standard.ClearNameTables
	jsr Game.Main.ModeGameOver.LoadGameOverText
	lda #$88
	sta $2000
	jmp Standard.MainReturn
+
	dec Game.Player.Lives
	lda #$00
	sta $2000
	sta $2001
	
	lda #180
	sta Standard.Main.ZTempVar1

	Standard.SetMain() Game.Main.ModeDie2
	Standard.SetNMI() Game.NMI.ModeDie
	
	jsr Standard.ClearNameTables

	lda Game.Player.Lives
	sta Standard.Main.Convert.Hex0
	jsr Standard.Main.HexToDecimal.8

	lda #$21
	sta $2006
	lda #$CB
	sta $2006

	lda #$19
	sta $2007
	lda #$16
	sta $2007
	lda #$23
	sta $2007
	lda #$12
	sta $2007
	lda #$20
	sta $2007

	lda #$00
	sta $2007
	lda Standard.Main.Convert.DecTens
	clc
	adc #1
	sta $2007
	lda Standard.Main.Convert.DecOnes
	adc #1
	sta $2007

	lda #$88
	sta $2000
	jmp Standard.MainReturn
	
Game.Main.ModeDie2:
	dec Standard.Main.ZTempVar1
	bne +

	lda #100
	sta Game.Player.Health
	lda #20
	sta Game.Player.Ammo
	lda #$00
	sta Game.Player.PowerUp
	jsr Game.Main.Player.ConvertInfoToDecimal
	Standard.SetNMI() Game.NMI.EmptyHandler					;And NMI pointer
	Standard.CopyPointer() Game.LevelData.Level1, Standard.Main.TempAdd0L
	jsr Game.Main.LevelInit
+
	jmp Standard.MainReturn

Game.Main.ModeGameOver:
	dec Standard.Main.ZTempVar1
	bne +
	
	jsr Game.Main.InitPlayerValues
	Standard.SetNMI() Game.NMI.EmptyHandler					;And NMI pointer
	Standard.CopyPointer() Game.LevelData.Level1, Standard.Main.TempAdd0L
	jsr Game.Main.LevelInit
+
	jmp Standard.MainReturn
	
Game.Main.ModeGameOver.LoadGameOverText:

	lda #$21
	sta $2006
	lda #$C9
	sta $2006
	
	ldx #9
	ldy #0
-
	lda Game.Main.ModeGameOver.GameOverText.w,y
	sta $2007
	iny
	dex
	bne -
	rts
	
Game.Main.ModeGameOver.GameOverText:
	.db $14, $0E, $1A, $12, $00, $1C, $23, $12, $1F