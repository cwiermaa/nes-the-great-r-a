Game.Main.HandleCharacter:
;Function: Given all variables belonging to the "Player" class, communication between the physical player and the in-game ;player is handled (See "Player.txt" for all information).
;Expected: Nothing.
;Warnings: Assume that all registers and temp vars are destroyed.


	lda Game.Player.DeathCounter
	beq +
	dec Game.Player.DeathCounter
	bne ++
	Standard.SetMain() Game.Main.ModeDie
++
	sec
	lda #Game.Player.DeathCounter.InitialValue
	sbc Game.Player.DeathCounter
	cmp #1
	bne +++
	ldx #9
	stx Sound.SFX.SoundEffect.w
+++
	asl a
	sta Standard.Main.ZTempVar1
	jsr Game.Main.Player.Dying.ProduceOrbs
	
	rts
+
	jsr Game.Main.Player.Invincible
	jsr Game.Main.Player.TakeDamage
	jsr Game.Main.Player.ValidateStats
	
	lda Game.Player.PowerUp
	and #$7F
	beq +
	tax
	lda Game.SpriteMaps.PowerUpsL.w,x
	tay
	lda Game.SpriteMaps.PowerUpsH.w,x
	ldx #2
	jsr Game.ObjectDraw.PushObject
+
	lda Game.Player.YH						;3
	cmp #$E0
	bcc +

	lda #Game.Player.DeathCounter.InitialValue
	sta Game.Player.DeathCounter
+	
	lda Game.Player.Health
	bne +									;10
	lda #Game.Player.DeathCounter.InitialValue
	sta Game.Player.DeathCounter

+
	Standard.Main.Read.Controller()			;169




	lda Game.Player.ActionStatus			;198
	and #Game.Player.ActionStatus.OnGround	;200
	beq +									;202
	lda Standard.Hardware.ControlCurrent	;205
	and #4									;207
	beq +									;209
	jmp Game.Main.HandleCharacter.Ducked	;212

+



	lda Game.Player.ActionStatus			;219/226
	and #Game.Player.ActionStatus.Ducking.Inverted		;222/229
	sta Game.Player.ActionStatus			;225/232
	jsr Game.Main.Player.DecellerateX		;374

	lda Standard.Hardware.ControlCurrent	;377
	and #$03								;379
	beq ++									;381
	and #$02								;383
	beq +									;385
	jsr Game.Main.Left						;500
	jmp ++									;503
+
	jsr Game.Main.Right						;500
++
	jsr Game.Main.Player.CheckUnderWater
	jsr Game.Main.Player.CheckPoison
	jsr Game.Main.Player.DisplaceX
	jsr Game.Main.Player.CollideX
	jsr Game.Main.Player.KeepOnScreen

	jsr Game.Main.Gravity
	jsr Game.Main.Jump
	jsr Game.Main.Swim

	jsr Game.Main.Player.DisplaceY
	jsr Game.Main.Player.CollideY
	
											;203/210
	lda Game.Player.YH						;206/213
	sta Game.Player.TopBorder				;209/216
	clc										;211/218
	adc #32									;213/220	If standing, height is 32.
	sta Game.Player.BottomBorder			;216/223
	
	clc										;179
	lda Game.Player.XL						;182
	adc #11									;184 Player collides with a box at coordinates, width 11.
	sta Game.Player.RightBorderL			;187
	lda Game.Player.XH						;190
	adc #0									;192
	sta Game.Player.RightBorderH			;195
											;About 930 + 500 = 1430
	jsr Game.Main.Player.Shoot
	jsr Game.Main.Player.ConvertInfoToDecimal

;********* Game.Animation crap ****************
;Don't time until the player animation routine is actually called.
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.Jumping
	beq +
	
	lda #4
	sta Game.Animation.AnimationStack.Player.AnimationCurrent
	lda #<Game.Animations.Player.Jumping
	sta Game.Animation.AnimationStack.Player.AnimationL
	lda #>Game.Animations.Player.Jumping
	sta Game.Animation.AnimationStack.Player.AnimationH
	jmp ++
+
	lda Game.Player.VelocityXH
	bne +
	lda Game.Player.VelocityXL
	bne +

	lda #1
	sta Game.Animation.AnimationStack.Player.AnimationCurrent
	lda #<Game.Animations.Player.Standing
	sta Game.Animation.AnimationStack.Player.AnimationL
	lda #>Game.Animations.Player.Standing
	sta Game.Animation.AnimationStack.Player.AnimationH

	jmp ++
+

	lda Standard.Hardware.ControlCurrent	;11
	and #$40							;13
	beq +								;15
	
	lda #8
	sta Game.Animation.AnimationStack.Player.AnimationCurrent
	lda #<Game.Animations.Player.Running
	sta Game.Animation.AnimationStack.Player.AnimationL
	lda #>Game.Animations.Player.Running
	sta Game.Animation.AnimationStack.Player.AnimationH
	jmp ++
+
	lda #2
	sta Game.Animation.AnimationStack.Player.AnimationCurrent
	lda #<Game.Animations.Player.Walking
	sta Game.Animation.AnimationStack.Player.AnimationL
	lda #>Game.Animations.Player.Walking
	sta Game.Animation.AnimationStack.Player.AnimationH
++
	jsr Game.Animation.AnimatePlayer				;220 cycles

	lda Game.Player.ArmShooting
	beq +
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.FacingLeft
	bne ++
	clc
	lda Game.Player.XL
	adc #16
	sta Game.Player.ArmXL
	lda Game.Player.XH
	adc #0
	sta Game.Player.ArmXH
	clc
	lda Game.Player.YH
	adc #10
	sta Game.Player.ArmY
	ldy #Game.Player.ArmXL - Game.Player.Bullet0
	lda #$E0
	jsr Game.ObjectDraw.PushSingle.Player.0
	dec Game.Player.ArmShooting
	jmp +
++
	
	lda Game.Player.XL
	sta Game.Player.ArmXL
	lda Game.Player.XH
	sta Game.Player.ArmXH
	clc
	lda Game.Player.YH
	adc #10
	sta Game.Player.ArmY
	ldy #Game.Player.ArmXL - Game.Player.Bullet0
	lda #$E0
	jsr Game.ObjectDraw.PushSingle.Player.0.Flipped
	dec Game.Player.ArmShooting	
+
;******** /Game.Animation crap ****************

;Check for pause
Game.Main.HandleCharacter.CheckPause:
	lda Standard.Hardware.ControlTrigger
	and #$10
	beq +
	lda #Sound.Song.Status.StopPlaying
	sta Sound.Song.Status
	lda #2
	sta Sound.SFX.SoundEffect

	Standard.SetMain() Game.Main.Pause
+
													;Approximately 2700 cycles
	rts

;***************************************

Game.Main.Gravity:
;Time: 8 to 44 cycles
;Function: Given the (first) 8 action status flags of the player as well as the Y velocity, gravity's pull is performed.
;Expected: Nothing.
;Warnings: Destroys A.

	lda Game.Player.ActionStatus					;3
	and #Game.Player.ActionStatus.OnGround			;5
	bne +											;7
	lda Game.Player.ActionStatus					;10
	and #Game.Player.ActionStatus.UnderWater		;12
	bne ++											;14
	clc												;16
	lda Game.Player.VelocityYL						;19
	adc #$23										;21
	sta Game.Player.VelocityYL						;24
	lda Game.Player.VelocityYH						;27
	adc #0											;29
	sta Game.Player.VelocityYH						;32
	eor #$80										;34
	cmp #$88										;36
	bcc +											;38
	lda #$08										;40
	sta Game.Player.VelocityYH						;43
+
													;8/39/43 cycles
	rts

++
													;15
	clc												;17
	lda Game.Player.VelocityYL						;20
	adc #14											;22
	sta Game.Player.VelocityYL						;25
	lda Game.Player.VelocityYH						;28
	adc #0											;30
	sta Game.Player.VelocityYH						;33
	eor #$80										;35
	cmp #$88										;37
	bcc +											;39
	lda #$08										;41
	sta Game.Player.VelocityYH						;44
+
													;40/44 cycles
	rts
Game.Main.Jump:
;Total time: 8 to 58 cycles, 47 average.
;Function: Given the (first) 8 status flags of the player as well as the Y Velocity, the logic behind jumping is performed
;(See "Physics.txt" for details).
;Expected: Nothing.
;Warnings: Destroys A.

	lda Game.Player.ActionStatus					;3
	and #Game.Player.ActionStatus.UnderWater		;5
	bne +											;7
	lda Game.Player.ActionStatus					;10
	and #Game.Player.ActionStatus.Jumping			;12
	bne ++											;14
	lda Game.Player.ActionStatus					;17
	and #Game.Player.ActionStatus.OnGround			;19
	beq +											;21
	lda Standard.Hardware.ControlTrigger			;24
	and #$80										;26
	beq +											;28
	lda #3											;36
	jsr Sound.SFX.RequestNew
	lda Game.Player.PowerUp
	cmp #$84										;If the power up is the jump booster and is active.
	bne +++
	lda Game.Player.Ammo
	cmp #5
	bcc ++++
	sec
	lda Game.Player.Ammo
	sbc #5
	sta Game.Player.Ammo
	lda #$FB										;42
	sta Game.Player.VelocityYH						;45
	lda #$00										;47
	sta Game.Player.VelocityYL						;50
	lda Game.Player.ActionStatus					;53
	ora #Game.Player.ActionStatus.Jumping			;55
	sta Game.Player.ActionStatus					;58
	rts
++++
	lda Game.Player.PowerUp
	and #$7F
	sta Game.Player.PowerUp
+++
	lda #$FC										;42
	sta Game.Player.VelocityYH						;45
	lda #$60										;47
	sta Game.Player.VelocityYL						;50
	lda Game.Player.ActionStatus					;53
	ora #Game.Player.ActionStatus.Jumping			;55
	sta Game.Player.ActionStatus					;58

+
													;8/22/58
	rts
++
;If in Jumping status, see where player lets go of A.

													;15
	lda Standard.Hardware.ControlCurrent			;18
	and #$80										;20
	bne +											;22
	lda Game.Player.VelocityYH						;25
	eor #$80										;27
	cmp #$7F										;29
	bcs ++											;31
	lda #$FF										;33
	sta Game.Player.VelocityYH						;36
	lda #$00										;38
	sta Game.Player.VelocityYL						;41
++
	lda Game.Player.ActionStatus					;35/44
	and #Game.Player.ActionStatus.Jumping.Inverted	;37/46
	sta Game.Player.ActionStatus					;40/49
	rts
+
	lda Game.Player.VelocityYH						;26
	bmi +											;28
	lda Game.Player.ActionStatus					;31
	and #Game.Player.ActionStatus.Jumping.Inverted	;33
	sta Game.Player.ActionStatus					;36

+
	rts


Game.Main.Swim:
;Time: 7 to 25 cycles.
;Function: Given the (first) 8 action status flags of the player, if the player is proven to be underwater, the logic behind ;the player swimming is performed (See "Physics.txt" for details).
;Expected: Nothing.
;Warnings: Destroys A.

	lda Game.Player.ActionStatus					;3
	and #Game.Player.ActionStatus.UnderWater		;5
	bne +											;7
	rts
+
	lda Standard.Hardware.ControlTrigger			;11
	and #$80										;13
	beq +											;15
	lda #$FE										;17
	sta Game.Player.VelocityYH						;20
	lda #0											;22
	sta Game.Player.VelocityYL						;25
+
													;16/25 cycles
	rts
;************* Collision detection ************************
;Collision points for the player:
;Top: 1,0, 12,0
;Bottom: 1,31, 12,31
;Left: 0,1, 0, 17, 0,30
;Right: 13,1, 13,17, 13,30

Game.Main.Player.CollideX:
;Time: 114 to 220 cycles
;Function: Given the player's X and Y coordinates, collision detection for whichever direction the player is moving in is ;performed. Depending on which tile type the player collides with, different things occur (See "Player.txt" for details).
;Expected: Nothing.
;Warning: Destroys A, X, and Y.

	lda Game.Player.XH			;If this works, this is pretty atrocious. Okay, so this eliminates	3
	cmp #$3F					;The possibility of 64 screens, and makes it 63. It also should		5
	bne +						;Fix the problem of collision detection on level wrap-around.		7
							;This happens when the player collides with something on screen 64
							;When still on screen 1, but the engine still reads garbage level
							;data for screen 64. Bad things happen when the player jumps against
							;The left-most boundary of the screen, basically.
	rts
+
	lda Game.Player.VelocityXH				;11
	clc
	adc Game.Player.ExternalVelocityXH
	bmi Game.Main.Player.Collide.Left		;13

;Right

	ldy Game.Player.YH						;16
	iny										;18

	clc										;20
	lda Game.Player.XL						;23
	adc #13									;25
	tax										;27
	lda Game.Player.XH						;30
	adc #0									;32
	jsr Game.Main.LevelDecode.RetrieveColumnOfTwoTypes	;47 cycles + 12 for JSR/RTS, 59 cycles
											;91
	cmp #1									;93
	beq +									;95
	cpx #1									;97
	beq +									;99

	clc										;101
	lda Game.Player.YH						;104
	adc #30									;106
	tay										;108
	clc										;110
	lda Game.Player.XL						;113
	adc #13									;115
	tax										;117
	lda Game.Player.XH						;120
	adc #0									;122
	jsr Game.Main.LevelDecode.RetrieveSingleType	;31 cycles + 12 for JSR/RTS, 43 cycles
											;165
	cmp #1									;167
	beq +									;169
	rts
+											;96/100/170
											;Cutting out middle value
	lda Game.Player.XL						;99/173
	and #$F0								;101/175
	ora #3									;103/177
	sta Game.Player.XL						;106/180
	lda #$F8
	sta Game.Player.XLL
	
	lda #0
	sta Game.Player.VelocityXL				;111/185
	sta Game.Player.VelocityXH				;114/188
	rts

Game.Main.Player.Collide.Left:

	ldy Game.Player.YH
	iny

	ldx Game.Player.XL
	lda Game.Player.XH
	jsr Game.Main.LevelDecode.RetrieveColumnOfTwoTypes
	cmp #1
	beq +
	cpx #1
	beq +

	clc
	lda Game.Player.YH
	adc #30
	tay
	ldx Game.Player.XL
	lda Game.Player.XH
	jsr Game.Main.LevelDecode.RetrieveSingleType
	cmp #1
	beq +
	rts
+
	clc
	lda Game.Player.XL
	and #$F0
	adc #$0F
	sta Game.Player.XL
	lda Game.Player.XH
	adc #0
	sta Game.Player.XH
	lda #$00
	sta Game.Player.XLL


	lda #0
	sta Game.Player.VelocityXL
	sta Game.Player.VelocityXH
	
	rts

Game.Main.Player.CollideY:
;Time: 104 to 200 cycles
;Function: Given the player's X and Y coordinates, collision detection for whichever direction the player is moving in is ;performed. Depending on which tile type the player collides with, different things occur (See "Player.txt" for details).
;Expected: Nothing.
;Warning: Destroys A, X, and Y.

	lda Game.Player.VelocityYH				;3
	bmi +++									;5

;Down
	clc										;7
	lda Game.Player.YH						;10
	adc #31									;12
	tay										;14
	clc										;16
	lda Game.Player.XL						;19
	adc #1									;21
	tax										;23
	lda Game.Player.XH						;26
	adc #0									;28
	jsr Game.Main.LevelDecode.RetrieveSingleType		;43 + 28 = 71 cycles
	cmp #1									;73
	beq +									;75

	clc										;77
	lda Game.Player.YH						;80
	adc #31									;82
	tay										;84
	clc										;86
	lda Game.Player.XL						;89
	adc #12									;91
	tax										;93
	lda Game.Player.XH						;96
	adc #0									;98
	jsr Game.Main.LevelDecode.RetrieveSingleType		;43 + 98 = 141 cycles
	cmp #1									;143
	beq +									;145

	lda Game.Player.ActionStatus			;148
	and #Game.Player.ActionStatus.OnGround.Inverted		;150
	sta Game.Player.ActionStatus			;153
	rts
+
											;76/146 cycles
	lda Game.Player.YH						;3
	and #$F0								;5
	ora #1									;7
	sta Game.Player.YH						;10
	lda #0
	sta Game.Player.YL
	lda Game.Player.ActionStatus			;13
	ora #Game.Player.ActionStatus.OnGround	;15
	and #Game.Player.ActionStatus.Jumping.Inverted	;17
	sta Game.Player.ActionStatus			;20

	lda #0									;22
	sta Game.Player.VelocityYH				;25
	sta Game.Player.VelocityYL				;28
											;104/174 cycles
	rts

;Top
+++
	sec											;If the player is either at coordinate 0 or below while jumping
	lda Game.Player.YH							;We know they're hitting the top of the screen. Collide with
	sbc #1										;Status bar.
	and #$F0
	cmp #$F0
	bne +
	
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.Jumping.Inverted
	sta Game.Player.ActionStatus
	
	lda #1
	sta Game.Player.YH
	lda #0
	sta Game.Player.YL
	sta Game.Player.VelocityYH
	sta Game.Player.VelocityYL
	rts
+
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.OnGround.Inverted
	sta Game.Player.ActionStatus

	ldy Game.Player.YH
	clc
	lda Game.Player.XL
	adc #1
	tax
	lda Game.Player.XH
	adc #0
	jsr Game.Main.LevelDecode.RetrieveSingleType
	cmp #1
	beq +

	ldy Game.Player.YH
	clc
	lda Game.Player.XL
	adc #12
	tax
	lda Game.Player.XH
	adc #0
	jsr Game.Main.LevelDecode.RetrieveSingleType
	cmp #1
	beq +
	rts
+
	lda Game.Player.YH
	and #$F0
	clc
	adc #$10
	sta Game.Player.YH

	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.Jumping.Inverted
	sta Game.Player.ActionStatus

	lda #0
	sta Game.Player.VelocityYH
	sta Game.Player.VelocityYL
	rts


Game.Main.Player.CheckUnderWater:
;Time: 79 cycles
;Function: Given the player's X and Y coordinates, whether or not the player's feet are in water is determined.
;Expected: Nothing
;Warnings: Destroys A, X, and Y.

	clc									;2
	lda Game.Player.YH					;5
	adc #30								;7
	tay									;9
	clc									;11
	lda Game.Player.XL					;14
	adc #1								;16
	tax									;18
	lda Game.Player.XH					;21
	adc #0								;23
	jsr Game.Main.LevelDecode.RetrieveSingleType	;43 + 23 = 66 cycles
	
	cmp #2								;68
	beq ++								;70
	cmp #3
	beq +
	lda Game.Player.ActionStatus							;73
	and #Game.Player.ActionStatus.UnderWater.Inverted		;75
	and #Game.Player.ActionStatus.UnderPoison.Inverted
	sta Game.Player.ActionStatus							;78
	rts
+
	lda Game.Player.ActionStatus
	ora #Game.Player.ActionStatus.UnderPoison
	sta Game.Player.ActionStatus
++
	lda Game.Player.ActionStatus				;74
	ora #Game.Player.ActionStatus.UnderWater	;76
	sta Game.Player.ActionStatus				;79
	rts
	
Game.Main.Player.CheckPoison:
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.UnderPoison
	beq +
	clc
	lda Game.Player.Damage
	adc #5
	sta Game.Player.Damage
+
	rts
;************* /Collision detection ************************

Game.Main.Player.DisplaceY:
;Time: 27 to 50 cycles
;Function: Given the player's current velocity and (first) 8 flags of action status as well as the player's Y Coordinate, 
;the player will be displaced horizontally appropriately.
;Expected: Nothing.
;Warning: Destroys Standard.Main.ZTempVar1 and Standard.Main.ZTempVar2 as well as A, X, and Y.

;Add External velocity
	ldx #0
	clc
	lda Game.Player.ExternalVelocityYH
	bpl +
	ldx #$FF
+
	adc Game.Player.YL
	sta Game.Player.YL
	txa
	adc Game.Player.YH
	sta Game.Player.YH

	lda Game.Player.ActionStatus					;3
	and #Game.Player.ActionStatus.UnderWater		;5
	bne +											;7
	clc												;9
	lda Game.Player.YL								;12
	adc Game.Player.VelocityYL						;15
	sta Game.Player.YL								;18
	lda Game.Player.YH								;21
	adc Game.Player.VelocityYH						;24
	sta Game.Player.YH								;27
	rts
+
	lda Game.Player.VelocityYL						;11
	sta Standard.Main.ZTempVar1						;14
	lda Game.Player.VelocityYH						;17
	asl a											;19
	lda Game.Player.VelocityYH						;22
	ror a											;24
	ror Standard.Main.ZTempVar1						;29
	sta Standard.Main.ZTempVar2						;32

	clc												;34
	lda Game.Player.YL								;37
	adc Standard.Main.ZTempVar1						;40
	sta Game.Player.YL								;41
	lda Game.Player.YH								;44
	adc Standard.Main.ZTempVar2						;47
	sta Game.Player.YH								;50
	rts

Game.Main.Player.DisplaceX:
;Time: 39 to 65 cycles
;Function: Given the player's current velocity and (first) 8 flags of action status as well as the player's X Coordinate, 
;the player will be displaced horizontally appropriately.
;Expected: Nothing.
;Warning: Destroys Standard.Main.ZTempVar1 and Standard.Main.ZTempVar2 as well as A, X, and Y.

;Add External velocity
	ldx #0
	clc
	lda Game.Player.ExternalVelocityXH
	bpl +
	ldx #$FF
+
	adc Game.Player.XL
	sta Game.Player.XL
	txa
	adc Game.Player.XH
	sta Game.Player.XH

	lda Game.Player.ActionStatus					;3
	and #Game.Player.ActionStatus.UnderWater		;5
	bne ++											;7
	clc										;9
	lda Game.Player.XLL						;12
	adc Game.Player.VelocityXL				;15
	sta Game.Player.XLL						;18
	lda Game.Player.VelocityXH				;21
	bmi +									;23
	adc Game.Player.XL						;26
	sta Game.Player.XL						;29
	lda Game.Player.XH						;32
	adc #0									;34
	and #$3F								;36
	sta Game.Player.XH						;39
	rts
+
	adc Game.Player.XL						;27
	sta Game.Player.XL						;30
	lda Game.Player.XH						;33
	adc #$FF								;35
	and #$3F								;37
	sta Game.Player.XH						;40
	rts
++

	lda Game.Player.VelocityXL				;11
	sta Standard.Main.ZTempVar1				;14
	lda Game.Player.VelocityXH				;17
	asl a									;19
	lda Game.Player.VelocityXH				;22
	ror a									;24
	ror Standard.Main.ZTempVar1				;29
	sta Standard.Main.ZTempVar2				;32

	clc										;34
	lda Game.Player.XLL						;37
	adc Standard.Main.ZTempVar1				;40
	sta Game.Player.XLL						;43
	lda Standard.Main.ZTempVar2				;46
	bmi +									;48
	adc Game.Player.XL						;51
	sta Game.Player.XL						;54
	lda Game.Player.XH						;57
	adc #0									;59
	and #$3F								;61
	sta Game.Player.XH						;64
	rts
+
	adc Game.Player.XL						;52
	sta Game.Player.XL						;55
	lda Game.Player.XH						;58
	adc #$FF								;60
	and #$3F								;62
	sta Game.Player.XH						;65
	rts

Game.Main.Left:
;Time: 60 - 114 cycles
;Function: Given the (first) 8 status flags of the players action and current X Velocity, the player will accelerate to the ;appropriate speed depending on whether or not the player is holding the run button or not, etc. (See "Physics.txt" for ;details. This is for when the left button is pressed.
;Expected: Nothing.
;Warning: Destroys ZTempVar1 as well as A, X, and Y.

	lda Game.Player.ActionStatus			;3
	and #Game.Player.ActionStatus.OnGround + Game.Player.ActionStatus.UnderWater	;5
	bne +							;7
	sec								;9
	lda Game.Player.VelocityXL		;12
	sbc #4							;14
	sta Game.Player.VelocityXL		;17
	lda Game.Player.VelocityXH		;20
	sbc #0							;22
	sta Game.Player.VelocityXH		;25
	jmp ++++						;28
+

	lda Standard.Hardware.ControlCurrent	;11
	and #$40							;13
	beq +								;15
	lda Game.Player.PowerUp				;If the player currently is using the speed-boosting power up
	cmp #$83							;Increase the velocity caps.
	bne +++++
	lda Standard.LoopCount
	and #$1F
	bne ++++++
	dec Game.Player.Ammo
++++++
	lda #$7E							;17
	sta Game.Player.NegVelocityXHCap	;20
	lda #$00							;22
	sta Game.Player.NegVelocityXLCap	;25
	jmp +++
+++++
	lda #$7E							;17
	sta Game.Player.NegVelocityXHCap	;20
	lda #$B0							;22
	sta Game.Player.NegVelocityXLCap	;25
	jmp +++								;28
+
	lda Game.Player.NegVelocityXLCap	;19
	cmp #$FF							;21
	beq +++								;23
	clc									;25
	lda Game.Player.NegVelocityXLCap	;28
	adc #10								;30
	sta Game.Player.NegVelocityXLCap	;33

	lda Game.Player.NegVelocityXLCap	;36
	cmp #$80							;38
	bcs +++								;40
	lda #$FF							;42
	sta Game.Player.NegVelocityXLCap	;45
+++
										;24/29/41
										;Discarding middle value
	lda #$7E							;26/43
	sta Game.Player.NegVelocityXHCap	;29/46

	sec									;31/48
	lda Game.Player.VelocityXL			;34/51
	sbc #8								;36/53
	sta Game.Player.VelocityXL			;39/56
	lda Game.Player.VelocityXH			;42/59
	sbc #0								;44/61
	sta Game.Player.VelocityXH			;47/64
++++
										;28/47/64
										;Discarding middle value
	lda Game.Player.ActionStatus		;31/67
	ora #Game.Player.ActionStatus.FacingLeft	;33/70
	sta Game.Player.ActionStatus		;37/73

	lda Game.Player.VelocityXH			;40/76
	eor #$80							;42/78
	sta Standard.Main.ZTempVar1			;45/81

	lda Standard.Main.ZTempVar1			;48/84
	cmp Game.Player.NegVelocityXHCap	;51/87
	bcc +								;53/89
	bne ++								;55/91
	lda Game.Player.VelocityXL			;58/94
	cmp Game.Player.NegVelocityXLCap	;61/97
	bcc +								;63/99
	jmp ++								;66/102
+
										;54/64/90/100
	lda Game.Player.NegVelocityXHCap	;57/67/93/103
	eor #$80							;59/69/95/105
	sta Game.Player.VelocityXH			;62/72/98/108
	lda Game.Player.NegVelocityXLCap	;65/75/101/111
	sta Game.Player.VelocityXL			;68/78/104/114
++
	rts

Game.Main.Right:
;Time: 60 - 114 cycles
;Function: Given the (first) 8 status flags of the players action and current X Velocity, the player will accelerate to the ;appropriate speed depending on whether or not the player is holding the run button or not, etc. (See "Physics.txt" for ;details. This is for when the right button is pressed.
;Expected: Nothing.
;Warning: Destroys ZTempVar1 as well as A, X, and Y.

	lda Game.Player.ActionStatus						;3
	and #Game.Player.ActionStatus.OnGround + Game.Player.ActionStatus.UnderWater	;5
	bne +							;7
	clc								;9
	lda Game.Player.VelocityXL		;12
	adc #4							;14
	sta Game.Player.VelocityXL		;17
	lda Game.Player.VelocityXH		;20
	adc #0							;22
	sta Game.Player.VelocityXH		;25
	jmp ++++						;28
+

	lda Standard.Hardware.ControlCurrent	;11
	and #$40							;13
	beq +								;15
	lda Game.Player.PowerUp				;If the player currently is using the speed-boosting power up
	cmp #$83							;Increase the velocity caps.
	bne +++++
	lda Standard.LoopCount
	and #$1F
	bne ++++++
	dec Game.Player.Ammo
++++++
	lda #$81							;17
	sta Game.Player.PosVelocityXHCap	;20
	lda #$FF							;22
	sta Game.Player.PosVelocityXLCap	;25
	jmp +++
+++++
	lda #$81							;17
	sta Game.Player.PosVelocityXHCap	;20
	lda #$50							;22
	sta Game.Player.PosVelocityXLCap	;25
	jmp +++								;28
+
	lda Game.Player.PosVelocityXLCap
	beq +++
	sec
	lda Game.Player.PosVelocityXLCap
	sbc #10
	sta Game.Player.PosVelocityXLCap

	lda #$80
	cmp Game.Player.PosVelocityXLCap
	bcs +++
	lda #0
	sta Game.Player.PosVelocityXLCap
+++
	lda #$81
	sta Game.Player.PosVelocityXHCap
	clc
	lda Game.Player.VelocityXL
	adc #8
	sta Game.Player.VelocityXL
	lda Game.Player.VelocityXH
	adc #0
	sta Game.Player.VelocityXH

++++
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.FacingLeft.Inverted
	sta Game.Player.ActionStatus

	lda Game.Player.VelocityXH
	eor #$80
	sta Standard.Main.ZTempVar1

	lda Game.Player.PosVelocityXHCap
	cmp Standard.Main.ZTempVar1
	bcc +
	bne ++
	lda Game.Player.PosVelocityXLCap
	cmp Game.Player.VelocityXL
	bcc +
	jmp ++
+
	lda Game.Player.PosVelocityXHCap
	eor #$80
	sta Game.Player.VelocityXH
	lda Game.Player.PosVelocityXLCap
	sta Game.Player.VelocityXL
++

	rts

Game.Main.Player.DecellerateX:
;Time: approximately 130 cycles
;Function: Given the player's X Velocity and Control Status of the current and previous frame, the player will decellerate ;appropriately depending on whether or not they are switching directions, in air, etc.
;Expected: Nothing
;Warning: Destroys Standard.Main.ZTempVar1 and Standard.Main.ZTempVar2 as well as A, X, and Y.

	lda Game.Player.ActionStatus				;3
	and #Game.Player.ActionStatus.OnGround		;5
	bne +										;7
	jmp ++										;10
+
	lda Standard.Hardware.ControlCurrent		;11
	and #3										;13
	beq +++										;15
	cmp #3										;17
	beq +++										;19
	cmp #2										;21
	bne +										;23
;Decellerate right
	lda Game.Player.VelocityXH					;26
	eor #$80									;28
	sta Standard.Main.ZTempVar1					;31
	lda #$80									;33
	cmp Standard.Main.ZTempVar1					;36
	bcc +++										;38
	beq +++										;40
	jmp ++										;43

+
;Decellerate left
	lda Game.Player.VelocityXH					;11
	eor #$80									;13
	cmp #$80									;15
	bcc +++										;17
	jmp ++										;20


+++
;Decellerate still (left and right, or neither).
												;16/18/20/39/41
												;Discarding middle values
	lda Game.Player.VelocityXL					;19/44
	sta Standard.Main.ZTempVar2					;22/47
	lda Game.Player.VelocityXH					;25/50
	sta Standard.Main.ZTempVar1					;28/53

	tax											;30/55
	asl a					;Keep sign bit		;32/57
	ror Standard.Main.ZTempVar1					;37/62
	ror Standard.Main.ZTempVar2					;42/67
	txa											;44/69
	asl a										;46/71
	ror Standard.Main.ZTempVar1					;51/76
	ror Standard.Main.ZTempVar2					;56/81
	txa											;58/83
	asl a										;60/85
	ror Standard.Main.ZTempVar1					;65/90
	ror Standard.Main.ZTempVar2					;70/95

	sec											;72/97
	lda Game.Player.VelocityXL					;75/100
	sbc Standard.Main.ZTempVar2					;78/103
	sta Game.Player.VelocityXL					;81/106
	lda Game.Player.VelocityXH					;84/109
	sbc Standard.Main.ZTempVar1					;87/112
	sta Game.Player.VelocityXH					;90/115


	lda Game.Player.VelocityXH					;93/118
	bne ++										;95/120
	lda Game.Player.VelocityXL					;98/123
	cmp #$07									;100/125
	beq +										;102/127
	bcs ++										;104/129
+
	lda #0										;106/131
	sta Game.Player.VelocityXL					;109/134
	sta Game.Player.VelocityXH					;112/137
++
												
	rts

Game.Main.Player.KeepOnScreen:
;Time: 50 - 100 cycles
;Function: Given the player's X coordinates and the screen's X coordinates, this routine forces the player to stay on screen ;by making the edges of the screen solid.
;Expected: Nothing.
;Warning: Destroys Standard.Main.ZTempVar1 and Standard.Main.ZTempVar2 as well as A, X, and Y.


	sec									;2
	lda Game.Player.XL					;5
	sbc Game.Camera.ScreenXL			;8
	sta Standard.Main.ZTempVar1			;11
	lda Game.Player.XH					;14
	sbc Game.Camera.ScreenXH			;17
	bpl +								;19
-
	lda Game.Camera.ScreenXH			;22/28
	sta Game.Player.XH					;25/31
	lda Game.Camera.ScreenXL			;28/34
	sta Game.Player.XL					;31/37
	lda #0								;33/39
	sta Game.Player.VelocityXL			;36/42
	sta Game.Player.VelocityXH			;39/45
	rts
+
	cmp #$3F							;22
	beq -								;24

	clc									;26
	lda Game.Player.XL					;29
	adc #13								;31
	sta Standard.Main.ZTempVar1			;34
	lda Game.Player.XH					;37
	adc #0								;39
	sta Standard.Main.ZTempVar2			;42
	dec Standard.Main.ZTempVar2			;47

	sec									;49
	lda Standard.Main.ZTempVar1			;52
	sbc Game.Camera.ScreenXL			;55
	sta Standard.Main.ZTempVar1			;58
	lda Standard.Main.ZTempVar2			;61
	sbc Game.Camera.ScreenXH			;64
	bmi +								;66
	sec									;68
	lda Game.ScreenXL					;71
	sbc #15								;73
	tay									;75
	lda Game.ScreenXH					;78
	sbc #0								;80
	tax									;82
	inx									;84
	stx Game.Player.XH					;87
	sty Game.Player.XL					;90
	lda #0								;92
	sta Game.Player.VelocityXL			;95
	sta Game.Player.VelocityXH			;98
+
	rts

Game.Main.Down:
	rts

Game.Main.AKey:
	rts


Game.Main.Player.ConvertInfoToDecimal:

	lda Game.Player.Ammo				;3
	sta Standard.Main.Convert.Hex0		;6
	jsr Standard.Main.HexToDecimal.8	;136

	lda Standard.Main.Convert.DecTens	;139
	clc									;141
	adc #1								;143
	sta Game.NMI.BG.Ammo0				;146
	lda Standard.Main.Convert.DecOnes	;149
	adc #1								;151
	sta Game.NMI.BG.Ammo1				;154

	lda Game.Player.Lives				;157
	sta Standard.Main.Convert.Hex0		;160
	jsr Standard.Main.HexToDecimal.8	;290


	lda Standard.Main.Convert.DecTens	;293
	clc									;295
	adc #1								;297
	sta Game.NMI.BG.Lives0				;300
	lda Standard.Main.Convert.DecOnes	;303
	adc #1								;305
	sta Game.NMI.BG.Lives1				;308

	lda Game.Player.Health				;311
	sta Standard.Main.Convert.Hex0		;314
	jsr Standard.Main.HexToDecimal.8	;444


	clc										;446
	lda Standard.Main.Convert.DecHundreds	;449
	adc #1									;451
	sta Game.NMI.BG.Health0					;454
	lda Standard.Main.Convert.DecTens		;457
	adc #1									;459
	sta Game.NMI.BG.Health1					;462
	lda Standard.Main.Convert.DecOnes		;465
	adc #1									;467
	sta Game.NMI.BG.Health2					;470

	jsr Game.Main.Player.ConvertInfoToDecimal.Score ;950
	rts

Game.Main.Player.Invincible:
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.Invincible
	beq +
	lda #$80
	sta Game.Player.Damage
	sta Game.Player.Invulnerable
+
	rts
	
Game.Main.Player.TakeDamage:
	lda Game.Player.Damage
	bne +
	rts
+
	and #$80
	beq ++
	sta Game.Player.Damage				;Make sure the Damage variable retains its status as #$80.
	dec Game.Player.Invulnerable
	bne +
	lda #$00
	sta Game.Player.Damage
+
	rts
++
	sec
	lda Game.Player.Health
	sbc Game.Player.Damage
	sta Game.Player.Health
	bcs +
	lda #$00
	sta Game.Player.Health
+
	lda #$80
	sta Game.Player.Damage
	lda #50
	sta Game.Player.Invulnerable
	lda #11
	sta Sound.SFX.SoundEffect
	
	lda Game.Player.ActionStatus
	and #Game.Player.ActionStatus.UnderPoison
	beq +
	rts
+
	lda Game.Player.HitOnLeft
	bne +
	lda #$FE
	sta Game.Player.VelocityXH
	lda #$80
	sta Game.Player.VelocityXL
	rts
+
	lda #$01
	sta Game.Player.VelocityXH
	lda #$80
	sta Game.Player.VelocityXL
	rts

Game.Main.AddScore:
;Expected: Score Low in A, Score High in X
	clc
	adc Game.Player.ScoreL
	sta Game.Player.ScoreL
	txa
	adc Game.Player.ScoreM
	sta Game.Player.ScoreM
	lda Game.Player.ScoreH
	adc #0
	sta Game.Player.ScoreH
	
;Make sure score doesn't exceed 999999
	sec
	lda Game.Player.ScoreL
	sbc #$3F
	lda Game.Player.ScoreM
	sbc #$42
	lda Game.Player.ScoreH
	sbc #$0F
	bmi +
	lda #$0F
	sta Game.Player.ScoreH
	lda #$42
	sta Game.Player.ScoreM
	lda #$3F
	sta Game.Player.ScoreL
+
	rts

Game.Main.Player.ValidateStats:
	lda #99
	cmp Game.Player.Ammo
	bcs +
	sta Game.Player.Ammo
+

	lda #99
	cmp Game.Player.Lives
	bcs +
	sta Game.Player.Lives
+
	lda Game.Player.MaxHealth
	cmp Game.Player.Health
	bcs +
	sta Game.Player.Health
+
	rts

Game.Main.Player.Dying.ProduceOrbs:
	clc
	lda Game.Player.XL
	adc Standard.Main.ZTempVar1
	sta Game.Player.ArmXL
	lda Game.Player.XH
	adc #0
	sta Game.Player.ArmXH
	clc
	lda Game.Player.YH
	adc Standard.Main.ZTempVar1
	sta Game.Player.ArmY
	bcs +
	ldy #Game.Player.ArmXL - Game.Player.Bullet0
	lda #$EB
	jsr Game.ObjectDraw.PushSingle.Player.0
	
+	
	clc
	lda Game.Player.XL
	adc Standard.Main.ZTempVar1
	sta Game.Player.ArmXL
	lda Game.Player.XH
	adc #0
	sta Game.Player.ArmXH
	sec
	lda Game.Player.YH
	sbc Standard.Main.ZTempVar1
	sta Game.Player.ArmY
	bcc +
	ldy #Game.Player.ArmXL - Game.Player.Bullet0
	lda #$EB
	jsr Game.ObjectDraw.PushSingle.Player.0
	
+	
	sec
	lda Game.Player.XL
	sbc Standard.Main.ZTempVar1
	sta Game.Player.ArmXL
	lda Game.Player.XH
	sbc #0
	sta Game.Player.ArmXH
	clc
	lda Game.Player.YH
	adc Standard.Main.ZTempVar1
	sta Game.Player.ArmY
	bcs +
	ldy #Game.Player.ArmXL - Game.Player.Bullet0
	lda #$EB
	jsr Game.ObjectDraw.PushSingle.Player.0
	
+	
	sec
	lda Game.Player.XL
	sbc Standard.Main.ZTempVar1
	sta Game.Player.ArmXL
	lda Game.Player.XH
	sbc #0
	sta Game.Player.ArmXH
	sec
	lda Game.Player.YH
	sbc Standard.Main.ZTempVar1
	sta Game.Player.ArmY
	bcc +
	ldy #Game.Player.ArmXL - Game.Player.Bullet0
	lda #$EB
	jsr Game.ObjectDraw.PushSingle.Player.0
+
	rts

Game.Main.AddHealth:
;Function: Given a health amount in A, add given amount to player's health, respecting health limit.

	clc
	adc Game.Player.Health
	sta Game.Player.Health
	rts
	
	.include "shoot.asm"
	.include "player_duck.asm"
	.include "items.asm"
	.include "mode_game_over.asm"