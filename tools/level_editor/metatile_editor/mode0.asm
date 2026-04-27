Game.NMI.Mode0:
	pha
	txa
	pha
	tya
	pha

	jsr Game.NMI.Mode0.PPUUpdates
	jsr Game.NMI.Mode0.APUUpdates

	inc Game.VBLCount

	pla
	tay
	pla
	tax
	pla
	rti


Game.Main.Mode0:
	jsr Game.Main.Mode0.HandleCharacter

	jsr Game.Main.Mode0.DrawSprites

	jmp (Game.Main.Mode0.EventL)
	jmp LoopReturn


Game.NMI.Mode0.PPUUpdates:
	jsr NMI.Palette.Update
	lda #3
	sta $4014

	lda #$00
	sta $2005
	sta $2006
	sta $2006
	sta $2005
	rts
Game.NMI.Mode0.APUUpdates:
	rts


;********************************************
Game.Main.Mode0.HandleCharacter:
	lda Game.ControlNew
	sta Game.ControlOld

	ldx #1
	stx $4016.w
	dex
	stx $4016.w
	stx Game.ControlNew
	ldx #8
-
	lda $4016
	lsr a
	rol Game.ControlNew
	dex
	bne -

;Trigger = New AND Old EOR New
	lda Game.ControlNew
	and Game.ControlOld
	eor Game.ControlNew
	sta Game.ControlTrigger

	lda Game.ControlTrigger
	and #$20
	beq +

	jsr Game.ChangeModes
+

	lda Game.ControlTrigger
	and #$10
	beq +
	ldx #$10
	ldy #0
-
	lda $30,y
	sta $6D00.w,y
	iny
	dex
	bne -
+

	ldx Game.Mode
	lda Game.ModesTableL.w,x
	sta Game.TempAdd0L
	lda Game.ModesTableH.w,x
	sta Game.TempAdd0H

	jmp (Game.TempAdd0L)
ControlReturn:
	rts


Game.ModesTableL:
	.db <Mode0Control, <Mode1Control, <Mode2Control, <Mode3Control, <Mode4Control

Game.ModesTableH:
	.db >Mode0Control, >Mode1Control, >Mode2Control, >Mode3Control, >Mode4Control

Mode0Control:
;Select current 1x1 tile
	lda Game.ControlTrigger
	and #1
	beq +
	inc Game.Current1x1
	jmp ++
+
	lda Game.ControlTrigger
	and #2
	beq +
	dec Game.Current1x1
	jmp ++
+
	lda Game.ControlTrigger
	and #4
	beq +
	clc
	lda Game.Current1x1
	adc #$10
	sta Game.Current1x1
	jmp ++
+
	lda Game.ControlTrigger
	and #8
	beq +
	sec
	lda Game.Current1x1
	sbc #$10
	sta Game.Current1x1
++
+
	jmp ControlReturn
Mode1Control:
;Select current index in 2x2 tile and lay down tile
	lda Game.ControlTrigger
	and #1
	beq +
	clc
	lda Game.CurrentIn2x2
	adc #1
	and #$03
	sta Game.CurrentIn2x2
	jmp ++
+
	lda Game.ControlTrigger
	and #2
	beq +
	sec
	lda Game.CurrentIn2x2
	sbc #1
	and #3
	sta Game.CurrentIn2x2
	jmp ++
+
	lda Game.ControlTrigger
	and #4
	beq +
	lda Game.CurrentIn2x2
	eor #2
	sta Game.CurrentIn2x2
	jmp ++
+
	lda Game.ControlTrigger
	and #8
	beq +
	lda Game.CurrentIn2x2
	eor #2
	sta Game.CurrentIn2x2
++
+
	lda Game.ControlTrigger
	and #$80
	beq +
	clc
	lda Game.CurrentIn2x2
	adc #>Game.2x2TL
	sta Game.TempAdd0H
	lda #$00
	sta Game.TempAdd0L
	ldy Game.Current2x2
	lda Game.Current1x1
	sta (Game.TempAdd0L),y
+
	lda Game.ControlTrigger
	and #$40
	beq +
	clc
	ldy Game.Current2x2
	clc
	lda Game.2x2TileTypes.w,y
	adc #1
	and #$07					;Assumes only 8 different tile types
	sta Game.2x2TileTypes.w,y
+
	jmp ControlReturn
Mode2Control:
;Select current index in 8x2 tile and lay down tile

	lda Game.ControlTrigger
	and #1
	beq +
	clc
	lda Game.CurrentIn8x2
	adc #1
	and #$03
	sta Game.CurrentIn8x2
	jmp ++
+
	lda Game.ControlTrigger
	and #2
	beq +
	sec
	lda Game.CurrentIn8x2
	sbc #1
	and #3
	sta Game.CurrentIn8x2
	jmp ++
+
++
	lda Game.ControlTrigger
	and #$80
	beq +
	clc
	lda Game.CurrentIn8x2
	adc #>Game.8x2TL
	sta Game.TempAdd0H
	lda #$00
	sta Game.TempAdd0L
	ldy Game.Current8x2
	lda Game.Current2x2
	sta (Game.TempAdd0L),y
+
	lda Game.ControlTrigger
	and #$40
	bne +
	jmp ++
+

	lda Game.CurrentIn8x2
	bne +
	clc
	ldy Game.Current8x2
	lda Game.8x2Attributes.w,y
	tax
	adc #1
	sta Game.8x2Attributes.w,y
	txa
	and #$FC
	sta Game.TempAdd0L
	lda Game.8x2Attributes.w,y
	and #$03
	ora Game.TempAdd0L
	sta Game.8x2Attributes.w,y
	jmp ++

+
	lda Game.CurrentIn8x2
	cmp #1
	bne +
	clc
	ldy Game.Current8x2
	lda Game.8x2Attributes.w,y
	tax
	adc #4
	sta Game.8x2Attributes.w,y
	txa
	and #$F3
	sta Game.TempAdd0L
	lda Game.8x2Attributes.w,y
	and #$0C
	ora Game.TempAdd0L
	sta Game.8x2Attributes.w,y
	jmp ++
+
	lda Game.CurrentIn8x2
	cmp #2
	bne +
	clc
	ldy Game.Current8x2
	lda Game.8x2Attributes.w,y
	tax
	adc #$10
	sta Game.8x2Attributes.w,y
	txa
	and #$CF
	sta Game.TempAdd0L
	lda Game.8x2Attributes.w,y
	and #$30
	ora Game.TempAdd0L
	sta Game.8x2Attributes.w,y
	jmp ++

+
	lda Game.CurrentIn8x2
	cmp #3
	bne +
	clc
	ldy Game.Current8x2
	lda Game.8x2Attributes.w,y
	tax
	adc #$40
	sta Game.8x2Attributes.w,y
	txa
	and #$3F
	sta Game.TempAdd0L
	lda Game.8x2Attributes.w,y
	and #$C0
	ora Game.TempAdd0L
	sta Game.8x2Attributes.w,y

++
	jmp ControlReturn
Mode3Control:
	lda Game.ControlTrigger
	and #3
	beq +
	lda Game.DigitSelect
	eor #1
	sta Game.DigitSelect
+
	lda Game.ControlTrigger
	and #4
	beq ++
	lda Game.DigitSelect
	beq +
	sec
	lda Game.Current2x2
	sbc #$10
	sta Game.Current2x2
	jmp ++
+
	sec
	lda Game.Current2x2
	sbc #1
	sta Game.Current2x2

++
	lda Game.ControlTrigger
	and #8
	beq ++
	lda Game.DigitSelect
	beq +
	clc
	lda Game.Current2x2
	adc #$10
	sta Game.Current2x2
	jmp ++
+
	clc
	lda Game.Current2x2
	adc #1
	sta Game.Current2x2

++
	jmp ControlReturn
Mode4Control:
	lda Game.ControlTrigger
	and #3
	beq +
	lda Game.DigitSelect
	eor #1
	sta Game.DigitSelect
+
	lda Game.ControlTrigger
	and #4
	beq ++
	lda Game.DigitSelect
	beq +
	sec
	lda Game.Current8x2
	sbc #$10
	sta Game.Current8x2
	jmp ++
+
	sec
	lda Game.Current8x2
	sbc #1
	sta Game.Current8x2

++
	lda Game.ControlTrigger
	and #8
	beq ++
	lda Game.DigitSelect
	beq +
	clc
	lda Game.Current8x2
	adc #$10
	sta Game.Current8x2
	jmp ++
+
	clc
	lda Game.Current8x2
	adc #1
	sta Game.Current8x2

++
	jmp ControlReturn

Game.ChangeModes:
	inc Game.Mode
	lda Game.Mode
	cmp #Game.NumberOfModes
	bcc +
	lda #$00
	sta Game.Mode
+
	rts
;*********************************
Game.Main.Mode0.EventTest:
	jmp LoopReturn


LoadCHR:
	lda #$00
	sta $2006
	sta $2006
	sta $20
	tay
	lda #$80
	sta $21
	ldx #32
-
	lda ($20),y
	sta $2007
	iny
	bne -
	inc $21
	dex
	bne -
	rts

NMI.Palette.Update:
	lda #$3F
	sta $2006
	lda #$00
	sta $2006

	lda $30
	sta $2007
	lda $31
	sta $2007
	lda $32
	sta $2007
	lda $33
	sta $2007
	lda $34
	sta $2007
	lda $35
	sta $2007
	lda $36
	sta $2007
	lda $37
	sta $2007
	lda $38
	sta $2007
	lda $39
	sta $2007
	lda $3A
	sta $2007
	lda $3B
	sta $2007
	lda $3C
	sta $2007
	lda $3D
	sta $2007
	lda $3E
	sta $2007
	lda $3F
	sta $2007

	lda $30
	sta $2007
	lda $31
	sta $2007
	lda $32
	sta $2007
	lda $33
	sta $2007
	lda $34
	sta $2007
	lda $35
	sta $2007
	lda $36
	sta $2007
	lda $37
	sta $2007
	lda $38
	sta $2007
	lda $39
	sta $2007
	lda $3A
	sta $2007
	lda $3B
	sta $2007
	lda $3C
	sta $2007
	lda $3D
	sta $2007
	lda $3E
	sta $2007
	lda $3F
	sta $2007
	rts

Game.Main.Mode0.DrawSprites:

;Load current 2x2 metatile
	ldy Game.Current2x2
	lda Game.2x2TL.w,y
	sta $305
	lda Game.2x2TR.w,y
	sta $309
	lda Game.2x2BL.w,y
	sta $30D
	lda Game.2x2BR.w,y
	sta $311

	lda #$C0
	sta $304
	sta $308
	lda #$C8
	sta $30C
	sta $310

	lda #$20
	sta $307
	sta $30F
	lda #$28
	sta $30B
	sta $313

;Load current 8x2 metatile

	lda #$B0
	sta $304+$10
	sta $308+$10
	sta $304+$20
	sta $308+$20
	sta $304+$30
	sta $308+$30
	sta $304+$40
	sta $308+$40
	lda #$B8
	sta $30C+$10
	sta $310+$10
	sta $30C+$20
	sta $310+$20
	sta $30C+$30
	sta $310+$30
	sta $30C+$40
	sta $310+$40

	lda #$A0
	sta $307+$10
	sta $30F+$10
	lda #$A8
	sta $30B+$10
	sta $313+$10

	lda #$B0
	sta $307+$20
	sta $30F+$20
	lda #$B8
	sta $30B+$20
	sta $313+$20

	lda #$C0
	sta $307+$30
	sta $30F+$30
	lda #$C8
	sta $30B+$30
	sta $313+$30

	lda #$D0
	sta $307+$40
	sta $30F+$40
	lda #$D8
	sta $30B+$40
	sta $313+$40

	ldx Game.Current8x2
	ldy Game.8x2TL.w,x

	lda Game.2x2TL.w,y
	sta $305+$10
	lda Game.2x2TR.w,y
	sta $309+$10
	lda Game.2x2BL.w,y
	sta $30D+$10
	lda Game.2x2BR.w,y
	sta $311+$10

	ldx Game.Current8x2
	ldy Game.8x2TR.w,x

	lda Game.2x2TL.w,y
	sta $305+$20
	lda Game.2x2TR.w,y
	sta $309+$20
	lda Game.2x2BL.w,y
	sta $30D+$20
	lda Game.2x2BR.w,y
	sta $311+$20

	ldx Game.Current8x2
	ldy Game.8x2BL.w,x

	lda Game.2x2TL.w,y
	sta $305+$30
	lda Game.2x2TR.w,y
	sta $309+$30
	lda Game.2x2BL.w,y
	sta $30D+$30
	lda Game.2x2BR.w,y
	sta $311+$30

	ldx Game.Current8x2
	ldy Game.8x2BR.w,x

	lda Game.2x2TL.w,y
	sta $305+$40
	lda Game.2x2TR.w,y
	sta $309+$40
	lda Game.2x2BL.w,y
	sta $30D+$40
	lda Game.2x2BR.w,y
	sta $311+$40

	ldx Game.Current8x2
	ldy Game.8x2Attributes.w,x

	tya
	and #$03
	sta $306.w+$10
	sta $30A.w+$10
	sta $30E.w+$10
	sta $312.w+$10

	tya
	lsr a
	lsr a
	tay
	and #$03
	sta $306.w+$20
	sta $30A.w+$20
	sta $30E.w+$20
	sta $312.w+$20

	tya
	lsr a
	lsr a
	tay
	and #$03
	sta $306.w+$30
	sta $30A.w+$30
	sta $30E.w+$30
	sta $312.w+$30

	tya
	lsr a
	lsr a
	tay
	and #$03
	sta $306.w+$40
	sta $30A.w+$40
	sta $30E.w+$40
	sta $312.w+$40

;Load current 2x2 and 8x2 ID in sprites
;$354 - 2x2 digit 1
;$358 - 2x2 digit 2
;$35C - 8x2 digit 1
;$360 - 8x2 digit 2
;$364 - 1x1 cursor
;$368 - 2x2 cursor
;$36C - 8x2 cursor
;$370 - 1x1 digit 1
;$374 - 1x1 digit 2

	lda #$D8
	sta $354
	sta $358
	sta $35C
	sta $360

	lda #$20
	sta $357
	lda #$28
	sta $35B
	lda #$A0
	sta $35F
	lda #$A8
	sta $363

	lda Game.Current2x2
	tay
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	tax
	inx
	stx $355.w
	tya
	and #$0F
	tax
	inx
	stx $359.w

	lda Game.Current8x2
	tay
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	tax
	inx
	stx $35D.w
	tya
	and #$0F
	tax
	inx
	stx $361.w


	lda #$40
	sta $370
	sta $374
	lda #$A0
	sta $373
	lda #$A8
	sta $377

	lda Game.Current1x1
	tay
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	tax
	inx
	stx $371.w
	tya
	and #$0F
	tax
	inx
	stx $375.w
;Load current cursors

	lda Game.Current1x1
	and #$0F
	asl a
	asl a
	asl a
	sta $367
	lda Game.Current1x1
	and #$F0
	lsr a
	clc
	adc #7
	sta $364
	lda #$11
	sta $365


	lda Game.CurrentIn2x2
	and #$01
	asl a
	asl a
	asl a
	asl a
	clc
	adc #$1E
	sta $36B
	lda Game.CurrentIn2x2
	and #$02
	asl a
	asl a
	clc
	adc #$C0
	sta $368
	lda #$11
	sta $369


	lda Game.CurrentIn8x2
	and #$03
	asl a
	asl a
	asl a
	asl a
	clc
	adc #$A4
	sta $36F
	lda #$A8
	sta $36C
	lda #$13
	sta $36D

;Highlight cursor depending on which one is selected.
;$354 - 2x2 digit 1
;$358 - 2x2 digit 2
;$35C - 8x2 digit 1
;$360 - 8x2 digit 2
;$364 - 1x1 cursor
;$368 - 2x2 cursor
;$36C - 8x2 cursor
;$370 - 1x1 digit 1
;$374 - 1x1 digit 2

;$356 - 2x2 digit 1
;$35A - 2x2 digit 2
;$35E - 8x2 digit 1
;$362 - 8x2 digit 2
;$366 - 1x1 cursor
;$36A - 2x2 cursor
;$36E - 8x2 cursor
;$372 - 1x1 digit 1
;$376 - 1x1 digit 2

	lda Game.Mode
	bne +
				;Highlight current 1x1 ID and cursor
	lda #$01
	sta $366
	sta $372
	sta $376
				;Grey out 2x2/8x2 cursor and numbers
	lda #$00
	sta $356
	sta $35A
	sta $35E
	sta $362
	sta $36A
	sta $36E
	jmp ++
		
+

	lda Game.Mode
	cmp #1
	bne +
				;Highlight current 1x1 ID and cursor
	lda #$01
	sta $36A
				;Grey out 2x2/8x2 cursor and numbers
	lda #$00
	sta $356
	sta $35A
	sta $35E
	sta $362
	sta $366
	sta $36E
	sta $372
	sta $376
	jmp ++

+
	lda Game.Mode
	cmp #2
	bne +
				;Highlight current 1x1 ID and cursor
	lda #$01
	sta $36E
				;Grey out 2x2/8x2 cursor and numbers
	lda #$00
	sta $356
	sta $35A
	sta $35E
	sta $362
	sta $366
	sta $36A
	sta $372
	sta $376
	jmp ++
+
	lda Game.Mode
	cmp #3
	bne +
				;Highlight current 1x1 ID and cursor
	lda #$01
	sta $356
	sta $35A
				;Grey out 2x2/8x2 cursor and numbers
	lda #$00
	sta $35E
	sta $362
	sta $366
	sta $36A
	sta $36E
	sta $372
	sta $376
	jmp ++
+
	lda Game.Mode
	cmp #4
	bne +
				;Highlight current 1x1 ID and cursor
	lda #$01
	sta $35E
	sta $362
				;Grey out 2x2/8x2 cursor and numbers
	lda #$00
	sta $356
	sta $35A
	sta $366
	sta $36A
	sta $36E
	sta $372
	sta $376
	jmp ++
+
++
	ldy Game.Current2x2
	clc
	lda Game.2x2TileTypes.w,y
	adc #1
	sta $379
	lda #$D8
	sta $378
	lda #64
	sta $37B
	rts