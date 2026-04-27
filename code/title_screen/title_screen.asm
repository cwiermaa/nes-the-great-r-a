TitleScreen.Mode0:
	jsr Standard.ClearNameTables

	lda #$80
	sta Standard.$2000
	
	lda Standard.VBLCount
-
	cmp Standard.VBLCount
	beq -
	
	lda #$3F
	sta $2006
	lda #$00
	sta $2006
	
	ldx #0
	ldy #32
-
	lda TitleScreen.Mode0.Palette.w,x
	sta $2007
	inx
	dey
	bne -
	
	ldx #0
	lda #$FF
-
	sta $300.w,x
	inx
	bne -
	
	lda #$23
	sta $2006
	lda #$A0
	sta $2006
	ldx #32
	lda #$5C
-
	sta $2007
	dex
	bne -
	
	lda #>TitleScreen.Mode0.RABlock
	sta Standard.Main.TempAdd0H
	lda #<TitleScreen.Mode0.RABlock
	sta Standard.Main.TempAdd0L
	jsr Cutscene.DrawBlock
	
	lda #>TitleScreen.Mode0.MarsBlock
	sta Standard.Main.TempAdd0H
	lda #<TitleScreen.Mode0.MarsBlock
	sta Standard.Main.TempAdd0L
	jsr Cutscene.DrawBlock
	
	lda #>TitleScreen.Mode0.Attributes
	sta Standard.Main.TempAdd0H
	lda #<TitleScreen.Mode0.Attributes
	sta Standard.Main.TempAdd0L
	jsr Cutscene.LoadAttributeData
	
	lda #>TitleScreen.Mode0.Stars
	sta Standard.Main.TempAdd0H
	lda #<TitleScreen.Mode0.Stars
	sta Standard.Main.TempAdd0L
	jsr Cutscene.DrawBG.Literal
	
	lda #>TitleScreen.Mode0.PressStart
	sta Standard.Main.TempAdd0H
	lda #<TitleScreen.Mode0.PressStart
	sta Standard.Main.TempAdd0L
	jsr Cutscene.DrawBG.Literal
	
	lda #6
	ldy #1
	ldx #1
	jsr Standard.LoadCHRFromBank
	
	lda #$01
	sta Game.NMI.Palette.Low
	lda #$03
	sta Game.NMI.Palette.1
	lda #$13
	sta Game.NMI.Palette.2
	lda #$33
	sta Game.NMI.Palette.3
	
	lda #$1E
	sta Standard.$2001
	Standard.SetNMI() TitleScreen.Mode1.NMI
	Standard.SetMain() TitleScreen.Mode1

	jsr Standard.InitSound

	Standard.CopyPointer() Sound.Songs.TitleScreen.Square1, Sound.Song.Square1.MusicAddL
	Standard.CopyPointer() Sound.Songs.TitleScreen.Square2, Sound.Song.Square2.MusicAddL
	Standard.CopyPointer() Sound.Songs.TitleScreen.Triangle, Sound.Song.Triangle.MusicAddL
	Standard.CopyPointer() Sound.Songs.TitleScreen.Noise, Sound.Song.Noise.MusicAddL
	jmp Standard.MainReturn
	
TitleScreen.Mode1:
	Standard.Main.Read.Controller()
	jsr TitleScreen.Mode1.CyclePalette
	
	lda Standard.Hardware.ControlTrigger
	and #$10
	beq +
	lda Standard.VBLCount
	sta Standard.Main.Random.Index0
	eor #$FF
	sta Standard.Main.Random.Index1
	jsr Game.Main.InitPlayerValues
	Sound.SilenceAll()
	Standard.CopyPointer() Game.LevelData.Level1, Standard.Main.TempAdd0L
	ldx #0
	jsr Game.Main.LevelInit
+
	lda Standard.Hardware.ControlTrigger
	and #$80
	beq +
	lda #12
	sta TitleScreen.Main.Counter0
	lda #0
	sta TitleScreen.Main.Counter1
	Standard.SetMain() TitleScreen.Mode2
+
	jmp Standard.MainReturn
	
TitleScreen.Mode2:
	lda TitleScreen.Main.Counter0
	bne +
	lda #$01
	sta Game.NMI.Palette.Low
	lda #0
	sta TitleScreen.Main.Counter0
	Standard.SetMain() TitleScreen.Mode3
	Standard.SetNMI() TitleScreen.Mode3.NMI
	jmp ++
	
+
	lda Standard.VBLCount
	and #$01
	bne ++
	ldx TitleScreen.Main.Counter1
	lda TitleScreen.Mode2.PaletteLow.w,x
	sta Game.NMI.Palette.Low
	lda TitleScreen.Mode2.PaletteColor1.w,x
	sta Game.NMI.Palette.1
	lda TitleScreen.Mode2.PaletteColor2.w,x
	sta Game.NMI.Palette.2
	lda TitleScreen.Mode2.PaletteColor3.w,x
	sta Game.NMI.Palette.3
	
	dec TitleScreen.Main.Counter0
	inc TitleScreen.Main.Counter1
++
	jmp Standard.MainReturn
	
TitleScreen.Mode3:
	lda TitleScreen.Main.Counter0
	cmp #8
	bcc ++++
	cmp #9
	bcs +++
	lda Standard.VBLCount
	and #$03
	bne +++
	ldx TitleScreen.Main.Counter3
	cpx #10
	beq ++
	lda TitleScreen.Mode3.PaletteLow.w,x
	sta Game.NMI.Palette.Low
	lda TitleScreen.Mode3.PaletteColor1.w,x
	sta Game.NMI.Palette.1
	lda TitleScreen.Mode3.PaletteColor2.w,x
	sta Game.NMI.Palette.2
	lda TitleScreen.Mode3.PaletteColor3.w,x
	sta Game.NMI.Palette.3
	inc TitleScreen.Main.Counter3
	jmp ++++
++
	lda TitleScreen.Main.Counter0
	cmp #9
	bcs +++
	ldy #>TitleScreen.Mode3.Text
	ldx #<TitleScreen.Mode3.Text
	jsr Cutscene.WriteText.Init
	inc TitleScreen.Main.Counter0
	lda #0
	sta TitleScreen.Main.Counter3
	jmp ++++
+++
	lda TitleScreen.Main.Counter0
	cmp #12
	bne ++++
	
	lda Standard.VBLCount
	and #$03
	bne ++++
	ldx TitleScreen.Main.Counter3
	cpx #10
	beq ++++
	lda TitleScreen.Mode3.PaletteLow2.w,x
	sta Game.NMI.Palette.Low
	lda TitleScreen.Mode3.PaletteColor12.w,x
	sta Game.NMI.Palette.1
	lda TitleScreen.Mode3.PaletteColor22.w,x
	sta Game.NMI.Palette.2
	lda TitleScreen.Mode3.PaletteColor32.w,x
	sta Game.NMI.Palette.3
	inc TitleScreen.Main.Counter3
++++
-
	bit $2002
	bvs -
-
	bit $2002
	bvc -

	lda #$00
	sta $2005
	sta $2005
+
	jmp Standard.MainReturn
	
TitleScreen.Mode1.CyclePalette:
	lda Standard.VBLCount
	and #$18
	lsr a
	lsr a
	lsr a
	tax
	
	lda TitleScreen.Mode1.PaletteColor1.w,x
	sta Game.NMI.Palette.1
	lda TitleScreen.Mode1.PaletteColor2.w,x
	sta Game.NMI.Palette.2
	lda TitleScreen.Mode1.PaletteColor3.w,x
	sta Game.NMI.Palette.3
	rts

TitleScreen.Mode1.NMI:
	pha
	lda Standard.$2001
	sta $2001
	lda Standard.$2000
	sta $2000
	lda #3
	sta $4014
	
	lda #$3F
	sta $2006
	lda Game.NMI.Palette.Low
	sta $2006.w
	
	lda Game.NMI.Palette.1
	sta $2007
	lda Game.NMI.Palette.2
	sta $2007
	lda Game.NMI.Palette.3
	sta $2007
	
	lda #$00
	sta $2006
	sta $2006
	lda #$00
	sta $2005
	lda #$00
	sta $2005

	jsr Game.NMI.APUUpdates
	inc Standard.VBLCount
	pla
	rti

TitleScreen.Mode3.NMI:
	pha
	lda Standard.$2001
	sta $2001
	lda Standard.$2000
	sta $2000
	
	lda TitleScreen.Main.Counter0
	bne +
	
	inc TitleScreen.Main.Counter0
	lda #$20
	sta $2006
	sta Standard.Main.TempAdd0H
	lda #$EA
	sta $2006
	sta Standard.Main.TempAdd0L
	lda #$00
	sta TitleScreen.Main.Counter2
	sta TitleScreen.Main.Counter1
	ldx #11
	ldy #11
-
	sta $2007
	dex
	bne -
	clc
	lda Standard.Main.TempAdd0L
	adc #$20
	sta Standard.Main.TempAdd0L
	lda Standard.Main.TempAdd0H
	adc #0
	sta Standard.Main.TempAdd0H
	sta $2006
	lda Standard.Main.TempAdd0L
	sta $2006
	ldx #11
	lda #0
	dey
	bne -
	
	lda #$25
	sta $2006
	lda #$8D
	sta $2006
	lda #$55
	sta $2007
	
	lda #$25
	sta $2006
	lda #$F2
	sta $2006
	lda #$54
	sta $2007
	jmp ++
+
	cmp #1
	bne +
	inc TitleScreen.Main.Counter0
	lda #$22
	sta $2006
	lda #$AA
	sta $2006
	ldx #12
	lda #$00
-
	sta $2007
	dex
	bne -
	jmp ++
+
	cmp #2
	bne +
	inc TitleScreen.Main.Counter0
	
	lda #$23
	sta $2006
	lda #$60
	sta $2006
	ldx #$60
	lda #$00
-
	sta $2007
	dex
	bne -
	jmp ++
+
	cmp #3
	bne +
	inc TitleScreen.Main.Counter0
	lda #$23
	sta $2006
	lda #$C0
	sta $2006
	ldx #$40
	lda #$00
-
	sta $2007
	dex
	bne -
	jmp ++
+
	cmp #4
	bne +
	inc TitleScreen.Main.Counter0
	
	lda #>TitleScreen.Mode3.Stars
	sta Standard.Main.TempAdd0H
	lda #<TitleScreen.Mode3.Stars
	sta Standard.Main.TempAdd0L
	jsr Cutscene.DrawBG.Literal
	
	jmp ++
+
	cmp #5
	bne +
	
	inc TitleScreen.Main.Counter0
	lda #$27
	sta $2006
	lda #$C0
	sta $2006
	ldx #$40
	lda #$00
-
	sta $2007
	dex
	bne -
	lda #$00
	sta TitleScreen.Main.Counter1
	sta TitleScreen.Main.Counter2
	jmp ++
+
	cmp #6
	bne +
	lda #$22
	sta $2006
	lda #$C0
	sta $2006
	lda #$5C
	ldx #$20
-
	sta $2007
	dex
	bne -
	
	lda #$26
	sta $2006
	lda #$C0
	sta $2006
	lda #$5C
	ldx #$20
-
	sta $2007
	dex
	bne -
	
	lda #$23
	sta $2006
	lda #$E0
	sta $2006
	ldx #$10	
	lda #$F0
-
	sta $2007
	dex
	bne -
		
	lda #$27
	sta $2006
	lda #$E0
	sta $2006
	ldx #$10	
	lda #$F0
-
	sta $2007
	dex
	bne -
	
	lda #$11
	sta Game.NMI.Palette.Low
	lda #$3F
	sta Game.NMI.Palette.2
	inc TitleScreen.Main.Counter0
	jmp ++
+
	cmp #7
	bne +
	inc TitleScreen.Main.Counter0
	lda #>TitleScreen.Mode3.SunBlock
	sta Standard.Main.TempAdd0H
	lda #<TitleScreen.Mode3.SunBlock
	sta Standard.Main.TempAdd0L
	jsr Cutscene.DrawBlock
	
	lda #>TitleScreen.Mode3.PlanetBlock
	sta Standard.Main.TempAdd0H
	lda #<TitleScreen.Mode3.PlanetBlock
	sta Standard.Main.TempAdd0L
	jsr Cutscene.DrawBlock
	
	lda #>TitleScreen.Mode3.PlanetBlock2
	sta Standard.Main.TempAdd0H
	lda #<TitleScreen.Mode3.PlanetBlock2
	sta Standard.Main.TempAdd0L
	jsr Cutscene.DrawBlock
	
	lda #$23
	sta $2006
	lda #$D5
	sta $2006
	lda #$55
	sta $2007
	
	lda #$23
	sta $2006
	lda #$DC
	sta $2006
	lda #$55
	sta $2007
	sta $2007
	sta $2007
	lda #$AA
	sta $2007
	lda #$AA
	sta $2007
	
	sec
	lda TitleScreen.Main.Counter1
	sbc #$20
	sta TitleScreen.Main.Counter1
	lda TitleScreen.Main.Counter2
	sbc #$70
	sta TitleScreen.Main.Counter2
	lda #0
	sta TitleScreen.Main.Counter3
	jmp ++
+
	cmp #8
	bne +
	lda #$AF
	sta $300
	lda #$00
	sta $302
	sta $303
	lda #$5C
	sta $301
	
	lda #3
	sta $4014
	jsr TitleScreen.Mode3.NMI.Scroll
	jmp ++
+
	cmp #9
	bne +

	jsr TitleScreen.Mode3.NMI.Scroll
	jsr Cutscene.WriteText
	beq +
	
	ldy #>TitleScreen.Mode3.Text2
	ldx #<TitleScreen.Mode3.Text2
	jsr Cutscene.WriteText.Init
	inc TitleScreen.Main.Counter0
	jmp ++
+
	cmp #10
	bne +	
	
	lda TitleScreen.Main.Counter2
	cmp #$28
	bcs ++++
	jsr TitleScreen.Mode3.NMI.DrawEyes
++++
	jsr TitleScreen.Mode3.NMI.Scroll
	
	jsr Cutscene.WriteText
	beq +
	inc TitleScreen.Main.Counter0
	jmp ++
+
	cmp #11
	bne +
	
	jsr TitleScreen.Mode3.NMI.Scroll
	
	lda TitleScreen.Main.Counter2
	cmp #8
	bne +
	inc TitleScreen.Main.Counter0
	jmp ++
+
	cmp #12
	bne +
	jsr TitleScreen.Mode3.NMI.DrawEyes
	jsr TitleScreen.Mode3.NMI.Scroll
	jmp ++
+
++
	
	lda #$3F
	sta $2006
	lda Game.NMI.Palette.Low
	sta $2006.w
	
	lda Game.NMI.Palette.1
	sta $2007
	lda Game.NMI.Palette.2
	sta $2007
	lda Game.NMI.Palette.3
	sta $2007
	
	lda #$00
	sta $2006
	sta $2006
	lda TitleScreen.Main.Counter2
	sta $2005
	lda #$00
	sta $2005

	jsr Game.NMI.APUUpdates
	inc Standard.VBLCount
	pla
	rti
	
TitleScreen.Mode3.NMI.Scroll:
	sec
	lda TitleScreen.Main.Counter1
	sbc #$20
	sta TitleScreen.Main.Counter1
	lda TitleScreen.Main.Counter2
	sbc #0
	sta TitleScreen.Main.Counter2
	rts

TitleScreen.Mode3.NMI.DrawEyes:
	lda #$AF
	sta $300
	lda #$00
	sta $302
	sta $303
	lda #$5C
	sta $301
	
	ldx #32
	ldy #0
-
	lda TitleScreen.Mode3.Eyes.w,y
	sta $304.w,y
	iny
	dex
	bne -
	
	lda #3
	sta $4014
	rts