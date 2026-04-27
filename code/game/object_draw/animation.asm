Game.Animation.HandleStandardAnimation:

	lda #0
	sta Game.AIRAM.Current

	ldx #0
	stx Standard.Main.ZTempVar5
-
	ldx Standard.Main.ZTempVar5
	lda Game.Animation.AnimationStack.w,x
	sta Standard.Main.ZTempVar6
	and #$C0					;Bit 7 declares if there is an animation to be handled, bit 6
	bne +						;declares if the animation must be handled from the very beginning.

	inc Game.AIRAM.Current
	clc
	lda Standard.Main.ZTempVar5
	adc #7
	sta Standard.Main.ZTempVar5
	cmp #56
	bne -
	rts

+
	sta Standard.Main.ZTempVar4			;Here we do something that helps us a lot. We've added animation
	txa						;Previous and Current status bytes. With these, we can decide
	clc						;Automatically when an animation needs to start from scratch much
	adc #6						;Like we figure out when a button is newly pressed with Control
	tax						;Trigger. This saves us a lot of grief in AI code.
	lda Game.Animation.AnimationStack.w,x		;Previous
	sta Standard.Main.ZTempVar2			;ZTempVar2 = Previous
	dex						;Move to Current
	lda Game.Animation.AnimationStack.w,x		;Current
	pha						;Push Current
	and Standard.Main.ZTempVar2			;AND Previous
	eor Game.Animation.AnimationStack.w,x		;EOR Current
	sta Standard.Main.ZTempVar3			;ZTempVar 3 = Current AND Previous EOR Current
	inx						;Move to previous
	pla						;Pull Current
	sta Game.Animation.AnimationStack.w,x		;Store Current over Previous
	txa						;X = X - 7
	sec
	sbc #6
	tax
	lda Standard.Main.ZTempVar3			;If ZTempVar3 is not 0, then new animation has occured.
	bne ++

	lda Standard.Main.ZTempVar4
	and #$40					;Check to see if the animation must be started from scratch
	beq +
++
	inx
	lda #$00
	sta Game.Animation.AnimationStack.w,x		;Clear frame counter
	inx
	sta Game.Animation.AnimationStack.w,x		;Clear Index
	dex						;Return to frame counter
	dex						;Return to command byte
+

	inx						;This is the most important part of the animation routine; the
	lda Game.Animation.AnimationStack.w,x		;frame counter. Check to see if we're done counting frames.
	beq +

	sec						;Probably not, so subtract one from the counter, and move on.
	sbc #1
	sta Game.Animation.AnimationStack.w,x

	jsr Game.Animation.DrawCurrentlyDisplayed
	inc Game.AIRAM.Current
	clc
	lda Standard.Main.ZTempVar5
	adc #7
	sta Standard.Main.ZTempVar5
	cmp #56
	bne -
	rts
+

	inx						;Here we get the index of the current animation, then
	lda Game.Animation.AnimationStack.w,x		;we increase it by 1, storing it back into RAM.
	tay
	
	inx						;We also get the address of the current animation
	lda Game.Animation.AnimationStack.w,x
	sta Standard.Main.TempAdd0L
	inx
	lda Game.Animation.AnimationStack.w,x
	sta Standard.Main.TempAdd0H

	dex						;Return to Animation Add L
	dex						;Return to index
	dex						;Return to frame counter

	lda (Standard.Main.TempAdd0L),y			;If we need to loop, we must do so
	cmp #$FF
	bne +
	iny						;Get next value, which will be loop offset
	lda (Standard.Main.TempAdd0L),y
	tay						;Put that in Y, get the first value, which will be frame count
	lda (Standard.Main.TempAdd0L),y
+
	sta Game.Animation.AnimationStack.w,x		;Store A in frame counter
	iny
	lda (Standard.Main.TempAdd0L),y			;Get low add of sprite map
	pha						;Save low address
	iny
	lda (Standard.Main.TempAdd0L),y			;Get high add of sprite map
	sta Standard.Main.ZTempVar7			;Save high address
	iny						;Move to next segment of animation array
	inx
	tya
	sta Game.Animation.AnimationStack.w,x

	pla						;Pull low address into Y
	tay
	lda Standard.Main.ZTempVar6
	and #1						;Take the type, which is in the lowest bit of ZTempVar6
	tax						;Put it in X
	lda Standard.Main.ZTempVar7			;Put the high address in A.
	jsr Game.ObjectDraw.PushObject

	inc Game.AIRAM.Current
	clc
	lda Standard.Main.ZTempVar5
	adc #7
	sta Standard.Main.ZTempVar5
	cmp #56
	beq +
	jmp -
+
	rts

Game.Animation.DrawCurrentlyDisplayed:

	inx
	lda Game.Animation.AnimationStack.w,x
	tay
	dey
	dey
	inx						;We also get the address of the current animation
	lda Game.Animation.AnimationStack.w,x
	sta Standard.Main.TempAdd0L
	inx
	lda Game.Animation.AnimationStack.w,x
	sta Standard.Main.TempAdd0H

	lda (Standard.Main.TempAdd0L),y
	pha
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Standard.Main.ZTempVar7

	pla						;Pull low address into Y
	tay
	lda Standard.Main.ZTempVar6
	and #1						;Take the type, which is in the lowest bit of ZTempVar6
	tax						;Put it in X
	lda Standard.Main.ZTempVar7			;Put the high address in A.

	jsr Game.ObjectDraw.PushObject
	rts


Game.Animation.AnimatePlayer:
;Time: 149 to 209 cycles

	lda Game.Animation.AnimationStack.Player.AnimationL				;4
	sta Standard.Main.TempAdd0L										;7
	lda Game.Animation.AnimationStack.Player.AnimationH				;11
	sta Standard.Main.TempAdd0H										;14

	lda Game.Animation.AnimationStack.Player.AnimationCurrent		;18
	and Game.Animation.AnimationStack.Player.AnimationPrevious		;22
	eor Game.Animation.AnimationStack.Player.AnimationCurrent		;26
	bne ++															;28

	lda Game.Animation.AnimationStack.Player.Command				;32
	and #$40					;This tells us if we need to start the animation from index 0	34
	beq +						;If not, skip to frame counting		36
++
	lda #$00														;31/38
	sta Game.Animation.AnimationStack.Player.Index					;35/42
	sta Game.Animation.AnimationStack.Player.FrameCounter			;39/46
	lda Game.Animation.AnimationStack.Player.Command				;43/50
	and #$BF														;45/52
	sta Game.Animation.AnimationStack.Player.Command				;49/56
+
																	;37/49/56
																	;Discarding middle value
	lda Game.Animation.AnimationStack.Player.FrameCounter	;Count frames. If done, move on. If not,  41/60
	beq +													;stay on the Current sprite map. 43/62
	dec Game.Animation.AnimationStack.Player.FrameCounter			;48/67
	jmp ++															;51/70


+
	ldy Game.Animation.AnimationStack.Player.Index					;48/67
	lda (Standard.Main.TempAdd0L),y									;53/72
	cmp #$FF														;55/74
	bne +															;57/76
	iny																;59/78
	lda (Standard.Main.TempAdd0L),y									;64/83
	tay																;66/85
	lda (Standard.Main.TempAdd0L),y									;71/90
+
	sta Game.Animation.AnimationStack.Player.FrameCounter			;62/94
	tya																;64/96
	clc																;66/98
	adc #3															;68/100
	sta Game.Animation.AnimationStack.Player.Index					;72/104
++
	lda Game.Player.Invulnerable									;If the player is invulnerable
	beq +															;Flash the animation on and off.
	lda Standard.LoopCount
	and #1
	beq +
	jmp ++++
+
	ldx Game.ObjectDraw.GraphicsStack.Index							;54/108
	lda Game.Player.ActionStatus		;This is basically always gonna be true, so we can just hard code it. 58/112
	and #Game.Player.ActionStatus.FacingLeft						;62/116
	lsr a															;64/118
	lsr a															;66/120
	lsr a															;68/122
	sta Game.ObjectDraw.GraphicsStack.Type.w,x						;72/126
	ldy Game.Animation.AnimationStack.Player.Index					;76/130
	dey																;78/132
	dey																;80/134
	lda (Standard.Main.TempAdd0L),y									;85/139
	sta Game.ObjectDraw.GraphicsStack.MapL.w,x						;89/143
	iny																;91/145
	lda (Standard.Main.TempAdd0L),y									;96/150
	sta Game.ObjectDraw.GraphicsStack.MapH.w,x						;100/154
	lda Game.Player.XL												;104/158
	sta Game.ObjectDraw.GraphicsStack.XL.w,x						;108/162
	lda Game.Player.XH												;112/166
	sta Game.ObjectDraw.GraphicsStack.XH.w,x						;116/170
	lda Game.Player.YH												;120/174
	sec																;122/176
	sbc #1															;124/178
	sta Game.ObjectDraw.GraphicsStack.Y.w,x							;128/182

	clc																;130/184
	lda Game.ObjectDraw.GraphicsStack.Index							;134/188
	adc #6															;136/192
	sta Game.ObjectDraw.GraphicsStack.Index							;140/196
	inc Game.ObjectDraw.NumOfObjects								;145/201

++++
	lda Game.Animation.AnimationStack.Player.AnimationCurrent		;149/205
	sta Game.Animation.AnimationStack.Player.AnimationPrevious		;153/209
	rts