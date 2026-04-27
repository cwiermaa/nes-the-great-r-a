.DEFINE Game.NMI.Debug.CCurrent $F4
.DEFINE Game.NMI.Debug.CPrevious $F5
.DEFINE Game.NMI.Debug.CTrigger $F6

Game.Main.ModeDebug:
	lda #$00
	sta $4015
	lda #$00
	sta $2000
	sta $2001
	Standard.SetMain() Game.Main.ModeDebug2
	Standard.SetNMI() Game.NMI.ModeDebug
	lda #$03
	sta Standard.Main.TempAdd0H
	lda #$00
	sta Standard.Main.TempAdd0L
	jsr Standard.ClearNameTables
	jsr Game.Main.ModeDebug.LoadRAMContents
	lda #$88
	sta $2000
	jmp Standard.MainReturn

Game.Main.ModeDebug2:
	Standard.Main.Read.Controller()			;169

	lda Standard.Hardware.ControlTrigger
	and #$08
	beq +
	sec
	lda Standard.Main.TempAdd0L
	sbc #8
	sta Standard.Main.TempAdd0L
	lda Standard.Main.TempAdd0H
	sbc #0
	sta Standard.Main.TempAdd0H
	lda #$00
	sta $2000
	sta $2001
	jsr Standard.ClearNameTables
	jsr Game.Main.ModeDebug.LoadRAMContents
	lda #$88
	sta $2000
+
	lda Standard.Hardware.ControlTrigger
	and #$04
	beq +
	
	clc
	lda Standard.Main.TempAdd0L
	adc #8
	sta Standard.Main.TempAdd0L
	lda Standard.Main.TempAdd0H
	adc #0
	sta Standard.Main.TempAdd0H
	lda #$00
	sta $2000
	sta $2001
	jsr Standard.ClearNameTables
	jsr Game.Main.ModeDebug.LoadRAMContents
	lda #$88
	sta $2000
+	
	lda Standard.Hardware.ControlTrigger
	and #$10
	beq +
	jmp RESET
+
	jmp Standard.MainReturn
	
Game.NMI.ModeDebug:
	Standard.NMI.Save.AXY()
	lda #$00
	sta $2005
	sta $2005
	lda #$08
	sta $2001
	inc Standard.VBLCount
	Standard.NMI.Restore.AXY()
	rti

Game.Main.ModeDebug.LoadRAMContents:
	lda #$20
	sta $2006
	lda #$61
	sta $2006
	
	lda Standard.Main.TempAdd0H
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #1
	sta $2007
	
	lda Standard.Main.TempAdd0H
	and #$0F
	clc
	adc #1
	sta $2007
	
	lda Standard.Main.TempAdd0L
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #1
	sta $2007
	
	lda Standard.Main.TempAdd0L
	and #$0F
	clc
	adc #1
	sta $2007
	
	lda #$20
	sta $2006
	lda #$81
	sta $2006
	
	ldy #0
-
	lda (Standard.Main.TempAdd0L),y
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #1
	sta $2007
	
	lda (Standard.Main.TempAdd0L),y
	and #$0F
	clc
	adc #1
	sta $2007
	
	lda #$00
	sta $2007
	sta $2007
	iny
	cpy #$80
	bne -
	rts
	
Game.NMI.ModeDebug.ReadController:
	lda Game.NMI.Debug.CCurrent				;3
	sta Game.NMI.Debug.CPrevious				;6

	ldx #1												;8
	stx $4016.w											;12
	dex													;14
	stx $4016.w											;18

	ldy #8												;20
-
	lda $4016											;4
	lsr a												;6
	rol Game.NMI.Debug.CCurrent				;11
	dey													;13
	bne -												;16 * 8 - 1 = 127
														;147
	lda Game.NMI.Debug.CCurrent				;150
	and Game.NMI.Debug.CPrevious				;153
	eor Game.NMI.Debug.CCurrent				;156
	sta Game.NMI.Debug.CTrigger				;159 Gives us a 1 for each button that is NEWLY pressed.
	rts
	
Game.NMI.ModeDebug.HijackMain:
	lda #$00
	sta $4015
	lda #$03
	sta Standard.Main.TempAdd0H
	lda #$00
	sta Standard.Main.TempAdd0L
	
	Standard.SetNMI() Game.NMI.ModeDebug.HijackMain2
	
Game.NMI.ModeDebug.HijackMain2:
	lda #$00
	sta $2006
	sta $2005
	sta $2005
	sta $2006
	lda #$08
	sta $2001

	pla
	pla
	pla
	
	Standard.Main.Read.Controller()			;169
	lda Standard.Hardware.ControlTrigger
	and #$08
	beq +
	sec
	lda Standard.Main.TempAdd0L
	sbc #8
	sta Standard.Main.TempAdd0L
	lda Standard.Main.TempAdd0H
	sbc #0
	sta Standard.Main.TempAdd0H
	lda #$00
	sta $2001
	jsr Standard.ClearNameTables
	jsr Game.Main.ModeDebug.LoadRAMContents
+
	lda Standard.Hardware.ControlTrigger
	and #$04
	beq +
	
	clc
	lda Standard.Main.TempAdd0L
	adc #8
	sta Standard.Main.TempAdd0L
	lda Standard.Main.TempAdd0H
	adc #0
	sta Standard.Main.TempAdd0H
	lda #$00
	sta $2001
	jsr Standard.ClearNameTables
	jsr Game.Main.ModeDebug.LoadRAMContents
+
-
	jmp -
	