
;Game.NMI.PPUUpdates:
	.incdir "code/game/ppu_updates"
	.include "ppu_updates.asm"
	.incdir ""

Game.NMI.APUUpdates:
	lda Sound.Song.Status
	and #Sound.Song.Status.StopPlaying
	bne +
	jsr Sound.Song.HandleMusic
	jsr Sound.UpdateRegs
	rts
+
	lda #$00
	sta Sound.$4015
	jsr Sound.Song.HandleMusicReturn4SaveBank
	jsr Sound.UpdateRegs
	rts

Game.NMI.Mode0:
	Standard.NMI.Save.AXY()


	jmp (Game.PPUUpdates.UpdateAddL)
Game.NMI.PPUReturn:

	jsr Game.NMI.APUUpdates

	lda Standard.$2000
	and #$FE
	ora Game.Scroll.ScrollXH
	tay

	ldx Game.Scroll.ScrollXL
	
	lda Standard.$2001
	beq +
-
	bit $2002
	bvs -

-
	bit $2002
	bvc -

	
+
	sty $2000.w

	stx $2005.w

	sty Standard.$2000.w

	lda $2002

	inc Standard.VBLCount

	Standard.NMI.Restore.AXY()
	rti

Game.NMI.Mode0.APUOnly:
	Standard.NMI.Save.AXY()
	jsr Game.NMI.APUUpdates
	Standard.NMI.Restore.AXY()
	rti

Game.NMI.EmptyHandler:
	pha
	lda Standard.$2001
	sta $2001
	lda Standard.$2000
	sta $2000
	inc Standard.VBLCount
	pla
	rti
	
	
Game.Main.LevelInit:
;Function: Given the address of complete level data grouping, the level is fully initialized, including sound, AI, event, ;etc. (See Data/Levels for more details).
;Expected: Address of complete level data list in Standard.Main.TempAdd0L/H, level bank in X

	lda Standard.CurrentBank.w
	pha
	txa
	pha
	
	lda #$00
	sta Standard.$2001                  ;Clear virtual PPU register
	lda Standard.VBLCount                        ;Wait for NMI; it will shut off the screen
-
	cmp Standard.VBLCount
	beq -
   
    pla
	tax
	stx Standard.CurrentBank.w
	jsr Standard.Bankswitch
	
	lda #$00
	sta $2000
	sta Standard.$2000 
	
	lda Standard.CurrentBank.w
	ldy #1
	ldx #0
	jsr Standard.LoadCHRFromBank
										;If the high byte of Square1 music track is $FF, it means to loop same song.
										;LevelInit causes a noticeable delay. We need to continue playing music without
										;slow down. Set NMI to keep doing only APU updates.
	ldy #24
	lda (Standard.Main.TempAdd0L),y
	cmp #$FF
	bne +
	Standard.SetNMI() Game.NMI.Mode0.APUOnly
	lda #$80
	sta $2000
	sta Standard.$2000 
	jmp +++++
+
	lda #$00
	sta $4015
	
+++++

	jsr Standard.ClearNameTables
	jsr Game.StatusBarDraw

	ldx #$1A								;Clear out AI RAM and Active/Dead arrays.
	lda #0
-
	sta $200.w,x
	inx
	bne -
	
	ldx #0
	ldy #$3A
-											;Clear out Item RAM
	sta $577.w,x
	inx
	dey
	bne -
	
	lda #8
	sta Game.Items.Slots.Available
	
	ldx #63
	ldy #4
	lda #$FF
-
	sta Game.ObjectDraw.OAMPage.Y.w,y
	iny
	iny
	iny
	iny
	dex
	bne -
	
	ldx #0
	lda #0
-
	sta $400.w,x
	inx
	bne -


	lda #3									;Force kill all active bullets.
	sta Game.Player.BulletsActive			;Set active bullets to 2, deactivation decreases bullets active variable.
	jsr Game.Main.Player.DisplaceBullet0.Deactivate
	jsr Game.Main.Player.DisplaceBullet1.Deactivate
	jsr Game.Main.Player.DisplaceBullet2.Deactivate
	
	ldy #0									;Load level information
	lda (Standard.Main.TempAdd0L),y
	sta Game.LevelAddressL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.LevelAddressH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectMap.PointerL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectMap.PointerH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectMapL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ObjectMapH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.EventL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.EventH
	iny
	lda (Standard.Main.TempAdd0L),y					;Palette pointer. Loaded later.
	sta Standard.Main.TempAdd1L
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Standard.Main.TempAdd1H
	iny
	lda (Standard.Main.TempAdd0L),y					;Palette pointer. Loaded later.
	sta Game.ItemAddL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ItemAddH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.Player.XL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.Player.XH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.Player.YH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ScreenXL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.ScreenXH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.Camera.LeftBoundL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.Camera.LeftBoundH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.Camera.RightBoundL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.Camera.RightBoundH
	iny
	lda (Standard.Main.TempAdd0L),y
	pha
	iny
	lda (Standard.Main.TempAdd0L),y
	pha
	iny
	lda (Standard.Main.TempAdd0L),y
	pha
	iny
	iny
	lda (Standard.Main.TempAdd0L),y					;If this byte is $FF, we are playing
	cmp #$FF										;The same song and not beginning a new one.
	bne +
	jmp ++
+
	pha
	tya
	pha
	jsr Standard.InitSound
	pla
	tay
	pla
	sta Sound.Song.Square1.MusicAddH
	dey
	lda (Standard.Main.TempAdd0L),y
	sta Sound.Song.Square1.MusicAddL
	iny
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Sound.Song.Square2.MusicAddL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Sound.Song.Square2.MusicAddH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Sound.Song.Triangle.MusicAddL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Sound.Song.Triangle.MusicAddH
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Sound.Song.Noise.MusicAddL
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Sound.Song.Noise.MusicAddH
++
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Game.Level.ID
	

	lda $2002											;Wait for the next Vblank to load palette.
-
	lda $2002
	bpl -
	
	lda #$3F
	sta $2006
	lda #$00
	sta $2006
	ldy #0
	ldx #32
-
	lda (Standard.Main.TempAdd1L),y
	sta $2007
	iny
	dex
	bne -
	
	lda #$00
	sta Game.NMI.Palette.Low
	
	lda #64
	sta Game.InitCounter

	lda #$00									;Start at scroll $0000, load the first 2 screens worth of level.
	sta Game.Scroll.ScrollXL
	sta Game.Scroll.ScrollXH

-
	clc
	lda Game.ScreenXL
	adc #8
	sta Game.ScreenXL
	lda Game.ScreenXH
	adc #0
	and #$3F
	sta Game.ScreenXH

	ldx #0
	ldy #8
	jsr Game.Scroll.ScrollRight

	ldx Game.Scroll.ScrollXL
	lda Game.Scroll.ScrollXH
	eor #1
	jsr Game.Scroll.PPUCalculate

	ldx Game.ScreenXL
	ldy Game.ScreenXH
	iny
	jsr Game.Main.LevelDecode.RetrieveColumn
	clc
	lda Game.ScreenXL
	adc #$80
	tax
	lda Game.ScreenXH
	adc #1
	and #$3F
	tay
	jsr Game.Main.LevelDecode.RetrieveColumnOfTypes
	jsr Game.NMI.UpdateBG
	dec Game.InitCounter
	bne -

	pla									;Start loading AI data from specified point in level.
	sta Game.InitCounter
	pla
	tax
	pla
	tay
	lda Game.ScreenXL
	pha
	lda Game.ScreenXH
	pha
	stx Game.ScreenXH
	sty Game.ScreenXL

	lda Game.ScreenXL					;Before this was a problem. The CheckPoint routine for
	sta Standard.Main.ZTempVar1				;Spawning objects assumes screen coords are in ZTempVar1
	lda Game.ScreenXH					;And ZTempVar2. Before, mystery data was in both of these
	sta Standard.Main.ZTempVar2				;Variables.
-
	jsr Game.Main.HandleAI.SpawnObjects.CheckPoint
	clc
	lda Game.ScreenXL
	adc #$10
	sta Game.ScreenXL
	sta Standard.Main.ZTempVar1
	lda Game.ScreenXH
	adc #0
	sta Game.ScreenXH
	sta Standard.Main.ZTempVar2
	tay
	lda (Game.ObjectMap.PointerL),y
	tay

	dec Game.InitCounter
	bne -

	pla
	sta Game.ScreenXH
	pla
	sta Game.ScreenXL

	Standard.CopyPointer() Game.NMI.SkipUpdate, Game.PPUUpdates.UpdateAddL	;Set PPU updates pointer.
	Standard.SetMain() Game.Main.Mode0
	Standard.SetNMI() Game.NMI.Mode0
	
	lda #$7E
	sta Game.Player.NegVelocityXHCap
	lda #$FF
	sta Game.Player.NegVelocityXLCap
	lda #$81
	sta Game.Player.PosVelocityXHCap
	lda #$00
	sta Game.Player.PosVelocityXLCap
	
	lda #$00
	sta Game.Player.VelocityXL
	sta Game.Player.VelocityXH
	sta Game.Player.VelocityYL
	sta Game.Player.VelocityYH
	sta Game.Player.ActionStatus
	sta Standard.Hardware.ControlCurrent
	sta Standard.Hardware.ControlPrevious
	sta Standard.Hardware.ControlTrigger
	sta Game.Player.Damage
	sta Game.Player.Invulnerable
	sta Game.Player.HitOnLeft
	sta Game.Player.ArmShooting
	sta Game.Player.DeathCounter
	sta Game.Player.ExternalVelocityXH
	sta Game.Player.ExternalVelocityYH
	sta Game.Event.Flags
		
	lda $2002											;Wait for the next Vblank to load palette.
-
	lda $2002
	bpl -
	
	lda #$1E
	sta Standard.$2001
	sta $2001

	lda #>Game.ObjectDraw.OAMPage
	sta $4014
	
	bit $2002
	
	lda #$88
	sta Standard.$2000
	sta $2000
	
	lda #$00
	sta Game.Camera.Status
	pla
	sta Standard.CurrentBank
	tax
	jsr Standard.Bankswitch
	rts

Game.Main.Mode0:
;Approximately 23,500 cycles to work with
	ldx #0
	jsr Standard.Bankswitch

	Game.PPUUpdates.Updates.Lock()

	clc													;Declare validity zone for enemy activity
	lda Game.ScreenXL									;Only for certain enemies.
	adc #$40
	sta Game.ValidBorderRL
	lda Game.ScreenXH
	adc #1
	sta Game.ValidBorderRH
	
	sec
	lda Game.ScreenXL
	sbc #$40
	sta Game.ValidBorderLL
	lda Game.ScreenXH
	sbc #0
	sta Game.ValidBorderLH
	cmp #$FF
	bne +
	lda #$00
	sta Game.ValidBorderLL								;Valid Border needs to be beyond the starting point
	sta Game.ValidBorderLH								;Of the level.
+
	
	jsr Game.Main.HandleCharacter						;2700 cycles
	
	lda #0
	sta Game.Player.ExternalVelocityXH
	
	jsr Game.Main.HandleAI

	jsr Game.Main.HandleScrolling						;3550 cycles

	
	jsr Game.Animation.HandleStandardAnimation
	jsr Game.Main.Items.Handle							;Items have lower priority in animation
	jsr Game.Main.DrawSprites

	
	lda #$00
	sta Game.ObjectDraw.GraphicsStack.Index
	sta Game.ObjectDraw.NumOfObjects
	sta Game.Animation.AnimationStack.w+0
	sta Game.Animation.AnimationStack.w+7
	sta Game.Animation.AnimationStack.w+14
	sta Game.Animation.AnimationStack.w+21
	sta Game.Animation.AnimationStack.w+28
	sta Game.Animation.AnimationStack.w+35
	sta Game.Animation.AnimationStack.w+42
	sta Game.Animation.AnimationStack.w+49
	Game.PPUUpdates.Updates.Unlock()

	inc Standard.LoopCount

	jmp (Game.EventL)

Game.Main.InitPlayerValues:

	lda #3
	sta Game.Player.PowerUp
	lda #10
	sta Game.Player.Ammo
	lda #100
	sta Game.Player.Health
	sta Game.Player.MaxHealth
	lda #3
	sta Game.Player.Lives
	
	lda #$00
	sta Game.Player.ScoreL
	sta Game.Player.ScoreM
	sta Game.Player.ScoreH
	jsr Game.Main.Player.DestroyAllBullets
	rts
;********** Camera Handler ***************
;Constants
.DEFINE Game.Camera.OnScreenLeftBound 104
.DEFINE Game.Camera.OnScreenRightBound 136

.DEFINE Game.Camera.TempScreenXL Standard.Main.ZTempVar1
.DEFINE Game.Camera.TempScreenXH Standard.Main.ZTempVar2
.DEFINE Game.Camera.Distance Standard.Main.ZTempVar3
.DEFINE Game.Camera.ScrollIncrement Standard.Main.ZTempVar4
.DEFINE Game.Camera.TempLeftBoundH Standard.Main.ZTempVar5

Game.Main.HandleScrolling:
;Time: 1240, 3490 - 3550 cycles

	jsr Game.Main.ScrollOver								;2253 to 2313 cycles

	clc
	lda Game.Player.ExternalVelocityXH
	adc Game.Player.VelocityXH								;If velocity is positive
	bpl +													;player is moving right, decode column on the right.
	sec														;9
	lda Game.ScreenXL										;12
	sbc #$70												;14
	tax														;16
	lda Game.ScreenXH										;19
	sbc #0													;21
	and #$3F												;23
	tay														;25
	jsr Game.Main.LevelDecode.RetrieveColumnOfTypes			;1237
															;3490 - 3550 cycles
	rts
+
	clc
	lda Game.ScreenXL
	adc #$80
	tax
	lda Game.ScreenXH
	adc #1
	and #$3F
	tay
	jsr Game.Main.LevelDecode.RetrieveColumnOfTypes
	rts

Game.Main.ScrollOver:
;Based on the player's coords, input, and permission from other code, the screen will scroll accordingly.
;Time: 7, or 2253 to 2313 cycles

	lda Game.Camera.Status						;3
	and #Game.Camera.Status.Locked				;5
	beq ++										;7
;Do nothing
	rts
++
;Here is regular scrolling.
;If (ScreenX + LeftBound) > PlayerX Then
; ScrollLeft()
; UpdateColumn(ScreenX)
;ElseIf (ScreenX + RightBount) < PlayerX Then
; ScrollRight()
; UpdateColumn(ScreenX + 256)
;End If
;Exit
					;First we check if we are beyond the on screen left bound
					;If (ScreenX + LeftBound) > PlayerX Then

	clc				;ScreenX + #OnScreenLeftBound	;10
	lda Game.Camera.ScreenXL						;13
	adc #Game.Camera.OnScreenLeftBound				;15
	sta Game.Camera.TempScreenXL					;18
	lda Game.Camera.ScreenXH						;21
	adc #0											;23
	and #$3F										;25
	sta Game.Camera.TempScreenXH					;28

	lda Game.Camera.PlayerXH						;31
	cmp Game.Camera.TempScreenXH					;34
	bcc Game.Main.ScrollLeft						;36
	bne ++											;38
	lda Game.Camera.PlayerXL						;42
	cmp Game.Camera.TempScreenXL					;45
	bcc Game.Main.ScrollLeft						;47

++
;Check for right status
	clc				;ScreenX + #OnScreenLeftBound	;41
	lda Game.Camera.ScreenXL						;44
	adc #Game.Camera.OnScreenRightBound				;46
	sta Game.Camera.TempScreenXL					;49
	lda Game.Camera.ScreenXH						;52
	adc #0											;54
	and #$3F										;56
	sta Game.Camera.TempScreenXH					;59

	cmp Game.Camera.PlayerXH						;62
	bcs +											;64
	jmp Game.Main.ScrollRight						;67
+
	bne ++											;67
	lda Game.Camera.TempScreenXL					;70
	cmp Game.Camera.PlayerXL						;73
	bcs ++											;75
	jmp Game.Main.ScrollRight						;78
++
													;68/76
	rts

Game.Main.ScrollLeft:	
						;TempScreenX = ScreenX + OnScreenLeftBound
									;37/48
	sec								;39/50
	lda Game.Camera.TempScreenXL	;42/53
	sbc Game.Camera.PlayerXL		;45/56
	sta Game.Camera.Distance		;48/59

	lda Game.Camera.Distance		;51/62
	cmp #8							;53/64
	bcc +							;55/66
	lda #8							;57/68
	sta Game.Camera.Distance		;60/71
+
									;56/60/67/71
;If (ScreenX - Distance) <= Screen.LeftBound Then
;	ScreenX = Screen.LeftBound
;	Screen.Locked = Screen.LeftBoundLock
;Else
;	ScreenX = ScreenX - Distance
;End If

	sec								;58/62/69/73
	lda Game.ScreenXL				;61/65/72/76
	sbc Game.Camera.Distance		;64/68/75/79
	sta Game.Camera.TempScreenXL	;67/71/78/82
	lda Game.ScreenXH				;70/74/81/85
	sbc #0							;72/76/83/87
	eor #$C0						;Unsign it	74/78/85/89
	sta Game.Camera.TempScreenXH	;77/81/88/92

									;Ditching all but smallest and largest cycle counts
	lda Game.Camera.LeftBoundH		;80/95
	eor #$C0						;82/97
	sta Game.Camera.TempLeftBoundH	;85/100

	lda Game.Camera.TempScreenXH	;88/103
   	cmp Game.Camera.TempLeftBoundH	;91/106
   	bcc +++							;93/108
   	bne ++							;95/110
   	lda Game.Camera.TempScreenXL	;98/113
   	cmp Game.Camera.LeftBoundL		;101/116
   	bcc +++							;103/118
	beq +++							;105/120
++
									;96/105/111/120
-
	sec								;98/107/113/122
	lda Game.ScreenXL				;101/110/116/125
	sbc Game.Camera.Distance		;104/113/119/128
	sta Game.ScreenXL				;107/116/122/131
	lda Game.ScreenXH				;110/119/125/134
	sbc #0							;112/121/127/136
	and #$3F						;114/123/129/138
	sta Game.ScreenXH				;117/126/132/141

	ldx #0							;119/128/134/143
	ldy Game.Camera.Distance		;122/131/137/146
	jsr Game.Scroll.ScrollLeft		;49 cycles + 12 for JSR/RTS = 61 cycles
									;183/192/198/207

	ldx Game.Scroll.ScrollXL		;186/195/201/210
	lda Game.Scroll.ScrollXH		;189/198/204/213
	jsr Game.Scroll.PPUCalculate	;34 cycles + 12 for JSR/RTS = 46 cycles
									;235/244/250/259

	ldx Game.ScreenXL				;238/247/253/262
	ldy Game.ScreenXH				;241/250/256/265
	jsr Game.Main.LevelDecode.RetrieveColumn	;2000 cycles + 12 cycles for JSR/RTS = 2012
									;2253/2262/2268/2277
									;Ditching middle values
									;2253/2277
									
									;131 + 2155 = 2286
									;158 + 2155 = 2313
									
									;2253/2277/2286/2313
									;Ditching middle values
									;Total = 2253 - 2313 cycles
	rts

+++
									;94/104/106/109/119/121
									;Ditching middle values
									;94/121
	sec								;96/123
	lda Game.ScreenXL				;99/126
	sbc Game.Camera.LeftBoundL		;102/129
	sta Game.Camera.Distance		;105/132

	lda Game.Camera.Status			;108/135
	and #Game.Camera.Status.LeftLock	;110/137
	asl a							;112/139
	asl a							;114/141
	sta Standard.Main.ZTempVar6		;117/144
	lda Game.Camera.Status			;120/147
	and #$F7						;122/149
	ora Standard.Main.ZTempVar6		;125/152
	sta Game.Camera.Status			;128/155
	jmp -							;131/158

Game.Main.ScrollRight:
									;Same as above, give about 20 or 30 cycles.
	lda Game.Camera.PlayerXL
	sbc Game.Camera.TempScreenXL
	sta Game.Camera.Distance

	lda Game.Camera.Distance
	cmp #8
	bcc +
	lda #8
	sta Game.Camera.Distance
+


;If (ScreenX + Distance) >= Screen.RightBound Then
;	ScreenX = Screen.RightBound
;	Screen.Locked = Screen.RightBoundLock
;Else
;	ScreenX = ScreenX + Distance
;End If

	clc
	lda Game.Camera.ScreenXL
	adc Game.Camera.Distance
	sta Game.Camera.TempScreenXL
	lda Game.Camera.ScreenXH
	adc #0
	and #$3F
	sta Game.Camera.TempScreenXH

	lda Game.Camera.RightBoundH
   	cmp Game.Camera.TempScreenXH
   	bcc +++
   	bne ++
   	lda Game.Camera.RightBoundL
   	cmp Game.Camera.TempScreenXL
   	bcc +++
	beq +++

++
-
	clc
	lda Game.ScreenXL
	adc Game.Camera.Distance
	sta Game.ScreenXL
	lda Game.ScreenXH
	adc #0
	and #$3F
	sta Game.ScreenXH

	ldx #0
	ldy Game.Camera.Distance
	jsr Game.Scroll.ScrollRight

	ldx Game.Scroll.ScrollXL
	lda Game.Scroll.ScrollXH
	eor #1
	jsr Game.Scroll.PPUCalculate

	ldx Game.ScreenXL
	ldy Game.ScreenXH
	iny
	jsr Game.Main.LevelDecode.RetrieveColumn


	rts

+++
	sec
	lda Game.Camera.RightBoundL
	sbc Game.Camera.ScreenXL
	sta Game.Camera.Distance

	lda Game.Camera.Status
	and #Game.Camera.Status.RightLock
	asl a
	asl a
	asl a
	sta Standard.Main.ZTempVar6
	lda Game.Camera.Status
	and #$F7
	ora Standard.Main.ZTempVar6
	sta Game.Camera.Status
	jmp -

;********* Test Scrap Code **********
;Checks if A is Greater than B   
;	lda BH
;   	cmp AH
;   	bcc IfTrue
;   	bne +
;   	lda BL
;   	cmp AL
;   	bcc IfTrue
;+
;	rts


;*********** / Camera Handling Code *******************

;**************************************
Game.Main.DrawSprites:



	jsr Game.ObjectDraw.DrawObjects

	rts

Game.Main.Level1.Event:
	lda Game.Player.XH
	cmp #$00
	bcc +
	clc
	lda Game.Player.XL
	adc #13
	cmp #$50
	bcc +
	lda Standard.Hardware.ControlCurrent
	and #$08
	beq +
	
	Standard.CopyPointer() Game.LevelData.Level2, Standard.Main.TempAdd0L
	jsr Game.Main.LevelInit
+
	jsr Game.Main.Level1.PaletteGlow
	jmp Standard.MainReturn

Game.Main.Level2.Event:
	lda Game.Event.Flags
	cmp #1
	bne +
	lda Game.Camera.Status
	eor #Game.Camera.Status.Locked
	sta Game.Camera.Status
	lda #2
	sta Game.Event.Flags
	jmp Standard.MainReturn
+
	lda Game.Player.XH
	cmp #2
	bcc +
	clc
	lda Game.Player.XL
	adc #13
	cmp #$50
	bcc +
	Standard.CopyPointer() Game.LevelData.Level2, Standard.Main.TempAdd0L
	jsr Game.Main.LevelInit
+
	lda Game.Camera.ScreenXH
	cmp #1
	bne +
	lda Game.Camera.Status
	ora #Game.Camera.Status.Locked
	sta Game.Camera.Status
	jsr Game.Main.Boss.PaletteGlow
	jmp Standard.MainReturn
+
	jsr Game.Main.Level1.PaletteGlow
	jmp Standard.MainReturn

Game.Main.Level3.Event:
	lda Game.Event.Flags
	cmp #1
	bne +
	jsr Game.Main.PlayWinningSong
	lda #2
	sta Game.Event.Flags
	jmp Standard.MainReturn
+
	lda Game.Camera.ScreenXH
	cmp #1
	bne +
	lda Game.Camera.Status
	;ora #Game.Camera.Status.Locked
	sta Game.Camera.Status
	jsr Game.Main.Boss.PaletteGlow
	jmp Standard.MainReturn
+
	jsr Game.Main.Level1.PaletteGlow
	jmp Standard.MainReturn
		
	
Game.Main.Boss.PaletteGlow:
	lda Standard.LoopCount
	and #$38
	lsr a
	lsr a
	lsr a
	tax
	
	lda #$3F
	sta Game.NMI.Palette.1
	lda Game.Data.Level1Part2.GlowPalette.w,x
	sta Game.NMI.Palette.2
	lda #$30
	sta Game.NMI.Palette.3
	
	lda #29
	sta Game.NMI.Palette.Low
	rts
	
Game.Main.Level1.PaletteGlow:
	lda Standard.LoopCount
	and #$38
	lsr a
	lsr a
	lsr a
	tax
	beq +
	lda #0
-
	clc
	adc #3
	dex
	bne -
+
	tax
	lda Game.LevelData.Level1.GlowPalette.w,x
	sta Game.NMI.Palette.1
	lda Game.LevelData.Level1.GlowPalette.w+1,x
	sta Game.NMI.Palette.2
	lda Game.LevelData.Level1.GlowPalette.w+2,x
	sta Game.NMI.Palette.3
	
	lda #9
	sta Game.NMI.Palette.Low
	rts
	
Game.Main.Pause:
	lda Standard.$2000
	and #$F7
	sta Standard.$2000
	lda #1
	sta Game.ObjectDraw.NumOfObjects
	lda #2
	sta Game.ObjectDraw.GraphicsStack.Type
	lda #>Game.SpriteMaps.PauseLogo
	sta Game.ObjectDraw.GraphicsStack.MapH
	lda #<Game.SpriteMaps.PauseLogo
	sta Game.ObjectDraw.GraphicsStack.MapL

	Standard.Main.Read.Controller()
	lda Standard.Hardware.ControlTrigger
	and #$10
	beq +
	lda Standard.$2000
	ora #8
	sta Standard.$2000
	Standard.SetMain() Game.Main.Mode0
	lda #4
	sta Sound.SFX.SoundEffect
	lda Sound.Song.Status
	eor #Sound.Song.Status.StopPlaying
	sta Sound.Song.Status
+
	jsr Game.Main.DrawSprites
	jmp Standard.MainReturn

Game.StatusBarDraw:					;Sample routine; probably not using.
	lda #$20
	sta $2006
	lda #$41
	sta $2006

	ldx #6
	ldy #0
-
	lda StatusBar.Health.w,y
	sta $2007
	iny	
	dex
	bne -


	lda #$20
	sta $2006
	lda #$48
	sta $2006

	ldx #5
	ldy #0
-
	lda StatusBar.Lives.w,y
	sta $2007
	iny	
	dex
	bne -


	lda #$20
	sta $2006
	lda #$53
	sta $2006

	ldx #4
	ldy #0
-
	lda StatusBar.Ammo.w,y
	sta $2007
	iny
	dex
	bne -

	lda #$20
	sta $2006
	lda #$59
	sta $2006

	ldx #5
	ldy #0
-
	lda StatusBar.Score.w,y
	sta $2007
	iny	
	dex
	bne -


	lda #23
	sta $300
	lda #$2F
	sta $301
	lda #$00
	sta $302
	lda #$C8
	sta $303
	
	lda #$00
	sta Standard.Main.Convert.DecOnes
	sta Standard.Main.Convert.DecTens
	sta Standard.Main.Convert.DecHundreds
	sta Standard.Main.Convert.DecThousands
	sta Standard.Main.Convert.DecTenThousands
	sta Standard.Main.Convert.DecHundredThousands
	sta Standard.Main.Convert.DecMillions
	sta Standard.Main.Convert.DecTenMillions
	rts
	
Game.Main.PlayWinningSong:
	jsr Standard.InitSound
	lda #>Sound.Songs.Winning.Square1
	sta Sound.Song.Square1.MusicAddH
	lda #<Sound.Songs.Winning.Square1
	sta Sound.Song.Square1.MusicAddL
	lda #<Sound.Songs.Winning.Square2
	sta Sound.Song.Square2.MusicAddL
	lda #>Sound.Songs.Winning.Square2
	sta Sound.Song.Square2.MusicAddH
	lda #<Sound.Songs.Winning.Triangle
	sta Sound.Song.Triangle.MusicAddL
	lda #>Sound.Songs.Winning.Triangle
	sta Sound.Song.Triangle.MusicAddH
	lda #<Sound.Songs.Winning.Noise
	sta Sound.Song.Noise.MusicAddL
	lda #>Sound.Songs.Winning.Noise
	sta Sound.Song.Noise.MusicAddH
	rts
	
.incdir "code/game/game"