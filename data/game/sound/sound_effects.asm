Sound.Song.DrumsL:
	.db <Sound.Song.Drums.Silence, <Sound.Song.Drums.Kick
Sound.Song.DrumsH:
	.db >Sound.Song.Drums.Silence, >Sound.Song.Drums.Kick

Sound.SFX.SFXTableL:
	.db <Sound.SFX.Silence, <Sound.SFX.Shoot, <Sound.SFX.Pause, <Sound.SFX.Jump, <Sound.SFX.Unpause
	.db <Sound.SFX.ExtraLife, <Sound.SFX.PowerUp, <Sound.SFX.AmmoHealth, <Sound.SFX.Score
	.db <Sound.SFX.Die, <Sound.SFX.EnemyHit, <Sound.SFX.PlayerHit, <Sound.SFX.EnemyDie
	.db <Sound.SFX.Shotgun, <Sound.SFX.Equip, <Sound.SFX.BossDie
	
Sound.SFX.SFXTableH:
	.db >Sound.SFX.Silence, >Sound.SFX.Shoot, >Sound.SFX.Pause, >Sound.SFX.Jump, >Sound.SFX.Unpause
	.db >Sound.SFX.ExtraLife, >Sound.SFX.PowerUp, >Sound.SFX.AmmoHealth, >Sound.SFX.Score
	.db >Sound.SFX.Die, >Sound.SFX.EnemyHit, >Sound.SFX.PlayerHit, >Sound.SFX.EnemyDie
	.db >Sound.SFX.Shotgun, >Sound.SFX.Equip, >Sound.SFX.BossDie
	
Sound.Song.Drums.Kick:
	lda #>Sound.SFX.HitPlayer.RawTable
	ldx #<Sound.SFX.HitPlayer.RawTable
	jmp Sound.Drum.Noise.StoreRawValuesWithCounter.AndKill

Sound.SFX.Silence:
	lda #0
	sta Sound.SFX.$4015
	jmp Sound.Song.HandleMusicReturn5

Sound.SFX.PlayerHit:
	lda #>Sound.SFX.HitPlayer.RawTable
	ldx #<Sound.SFX.HitPlayer.RawTable
	jmp Sound.SFX.Noise.StoreRawValuesWithCounter.AndKill
	
Sound.SFX.EnemyHit:
	lda #>Sound.SFX.HitEnemy.RawTable
	ldx #<Sound.SFX.HitEnemy.RawTable
	jmp Sound.SFX.Noise.StoreRawValuesWithCounter.AndKill
	
Sound.SFX.Shoot:
	lda #>Sound.SFX.Shoot.RawTable
	ldx #<Sound.SFX.Shoot.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill

Sound.SFX.Jump:
	lda #>Sound.SFX.Jump.RawTable
	ldx #<Sound.SFX.Jump.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill

Sound.SFX.Shotgun:
	lda #>Sound.SFX.Shotgun.RawTable
	ldx #<Sound.SFX.Shotgun.RawTable
	jmp Sound.SFX.Noise.StoreRawValuesWithCounter.AndKill

Sound.SFX.HitPlayer.RawTable:
	.db 0, $34, $09
	.db 0, $35, $0D
	.db 0, $36, $05
	.db 0, $36, $0E
	.db $FF
	
Sound.SFX.Shotgun.RawTable:
	.db 1, $36, $0E
	.db 1, $3E, $05
	.db 1, $3D, $06
	.db 1, $38, $08
	.db 1, $36, $0C
	.db $FF
	
Sound.SFX.Shoot.RawTable:
	.db 0, $78, $A0, $00
	.db 0, $78, $A8, $00
	.db 0, $77, $B0, $00
	.db 0, $77, $B8, $00
	.db 0, $76, $C0, $00
	.db $FF
	
Sound.SFX.Jump.RawTable:
	.db 1, $7A, $80, $01
	.db 1, $79, $78, $01
	.db 1, $77, $70, $01
	.db 1, $75, $68, $01
	.db 1, $74, $60, $01
	.db 0, $72, $58, $01
	.db $FF
	
	
Sound.SFX.HitEnemy.RawTable:
	.db 0, $39, $0D
	.db 0, $38, $0A
	.db 0, $37, $0E
	.db 0, $36, $09
	.db 0, $35, $03
	.db 0, $34, $01
	.db $FF

Sound.SFX.Equip.RawTable:
	.db 0, $7E, $81
	.db 0, $76, $85
	.db 0, $78, $8E
	.db $FF
	
Sound.SFX.Unpause:
Sound.SFX.Pause:
	ldy #>Sound.SFX.Pause.RawTable
	ldx #<Sound.SFX.Pause.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill.WithEcho
	
Sound.SFX.Pause.RawTable:
	.db 3, $B0, $50, $00
	.db 2, $B0, $60, $00
	.db 1, $B0, $70, $00
	.db $FF

Sound.SFX.Die:
	ldy #>Sound.SFX.Die.RawTable
	ldx #<Sound.SFX.Die.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill.WithEcho
	
Sound.SFX.ExtraLife:
	ldy #>Sound.SFX.ExtraLife.RawTable
	ldx #<Sound.SFX.ExtraLife.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill.WithEcho

Sound.SFX.EnemyDie:
	ldy #>Sound.SFX.EnemyDie.RawTable
	ldx #<Sound.SFX.EnemyDie.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill.WithEcho
	
Sound.SFX.BossDie:
	ldy #>Sound.SFX.BossDie.RawTable
	ldx #<Sound.SFX.BossDie.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill.WithEcho
	
Sound.SFX.PowerUp:
	ldy #>Sound.SFX.PowerUp.RawTable
	ldx #<Sound.SFX.PowerUp.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill.WithEcho

Sound.SFX.AmmoHealth:
	ldy #>Sound.SFX.Health.RawTable
	ldx #<Sound.SFX.Health.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill.WithEcho

Sound.SFX.Score:
	ldy #>Sound.SFX.Score.RawTable
	ldx #<Sound.SFX.Score.RawTable
	jmp Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill.WithEcho

Sound.SFX.Equip:
	lda #>Sound.SFX.Equip.RawTable
	ldx #<Sound.SFX.Equip.RawTable
	jmp Sound.SFX.Noise.StoreRawValuesWithCounter.AndKill
	
Sound.SFX.Die.RawTable:
	.db 5, $B0, $30, $00
	.db 4, $B0, $40, $00
	.db 3, $B0, $60, $00
	.db 3, $B0, $80, $00
	.db 2, $B0, $A0, $00
	.db $FF
	
Sound.SFX.ExtraLife.RawTable:
	.db 5, $B0, $70, $00
	.db 5, $B0, $64, $00
	.db 5, $B0, $4B, $00
	.db $FF

Sound.SFX.Score.RawTable:
	.db 4, $F0, $EF, $00
	.db 4, $F0, $9F, $00
	.db 4, $F0, $BD, $00
	.db 3, $F0, $EF, $00
	.db $FF
	
Sound.SFX.Health.RawTable:
	.db 4, $B0, $52, $01
	.db 4, $B0, $FD, $00
	.db $FF
	
Sound.SFX.EnemyDie.RawTable:
	
	.db 1,$B0, $00, $02
	.db 1,$B0, $00, $03
	.db 3,$B0, $80, $03
	.db $FF
	
Sound.SFX.BossDie.RawTable:
	.db 2, $B0, $60, $00
	.db 2, $B0, $A0, $00
	.db 2, $B0, $F0, $00
	.db 2, $B0, $50, $01
	.db 2, $B0, $00, $02
	.db 2, $B0, $A0, $02
	.db 2, $B0, $00, $02
	.db 2, $B0, $50, $01
	.db $FF
	
Sound.SFX.PowerUp.RawTable:
	.db 5, $F0, $EF, $00
	.db 5, $F0, $9F, $00
	.db $FF
	
	

Sound.SFX.KillSoundEffect:
	lda #0
	sta Sound.SFX.SoundEffect
	jsr Sound.SFX.RestoreDefaults
	jmp Sound.Song.HandleMusicReturn5

Sound.SFX.RestoreDefaults:

	lda Sound.$4015						;If music is not playing on channel 1, store $FF in $4003 Old so that
	and #1								;If a sound effect is made, the fact that music is silent will not
	bne +								;Prohibit $4003 from being updated. Same for $4007.
	lda #$FF
	sta Sound.$4003Old
+
	lda Sound.$4015
	and #2
	bne +
	lda #$FF
	sta Sound.$4007Old
+
	lda #$30
	sta Sound.SFX.$4000
	sta Sound.SFX.$4001
	lda #$08
	sta Sound.SFX.$4004
	sta Sound.SFX.$4005
	lda #$FF
	sta Sound.SFX.$4008

	lda #$00
	sta Sound.SFX.Var1
	sta Sound.SFX.$4015
	sta Sound.SFX.VarB
	lda #$FF
	sta Sound.SFX.VarC	
	rts

Sound.Drum.KillSoundEffect:
	jsr Sound.Drum.RestoreDefaults
	jmp Sound.Song.HandleMusicReturn3

Sound.Drum.RestoreDefaults:

	lda Sound.$4015						;If music is not playing on channel 1, store $FF in $4003 Old so that
	and #1								;If a sound effect is made, the fact that music is silent will not
	bne +								;Prohibit $4003 from being updated. Same for $4007.
	lda #$FF
	sta Sound.$4003Old
+
	lda Sound.$4015
	and #2
	bne +
	lda #$FF
	sta Sound.$4007Old
+
	lda #$30
	sta Sound.Song.Noise.Sample.$4000
	sta Sound.Song.Noise.Sample.$4001
	lda #$08
	sta Sound.Song.Noise.Sample.$4004
	sta Sound.Song.Noise.Sample.$4005
	lda #$FF
	sta Sound.Song.Noise.Sample.$4008

	lda #$00
	sta Sound.Song.Noise.Sample.Var1
	sta Sound.Song.Noise.Sample.$4015
	sta Sound.Song.Noise.Sample.VarB
	lda #$FF
	sta Sound.Song.Noise.Sample.VarC	
	rts

	
	
Sound.Song.Drums.Silence:

	jmp Sound.Song.HandleMusicReturn3
	
	
;**************************************************************************
;Section_ : Common Routines

Sound.SFX.ProcessCounterTable:
;Function: Given an address at which is located a table of counter values, with H in A and L in X,
;The routine will return the current index of that table.
;Expected: H in A, L in X.
;Warnings: VarB and VarC will be used.
	sta Standard.NMI.TempAdd1H
	stx Standard.NMI.TempAdd1L
	
	lda Sound.SFX.VarB
	beq +
	sec
	sbc #1
	sta Sound.SFX.VarB
	lda Sound.SFX.VarC
	rts
+
	inc Sound.SFX.VarC
	ldy Sound.SFX.VarC
	lda (Standard.NMI.TempAdd1L),y
	sta Sound.SFX.VarB
	tya
	rts
	
Sound.SFX.Square1.StoreRawValues:
;Function: Given values in A, X, and Y, those values will be copied to $4000, $4002, and $4003 respectively.
;Expected: $4000 value in A, $4002 value in X, $4003 value in Y.
	sta Sound.SFX.$4000
	stx Sound.SFX.$4002.w
	sty Sound.SFX.$4003.w
	lda Sound.SFX.$4015
	ora #1
	sta Sound.SFX.$4015
	rts

Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill
;Function: Jumps to Sound.SFX.Square1.StoreRawValuesWithCounter, and kills after it is done with the table.

	jsr Sound.SFX.Square1.StoreRawValuesWithCounter
	beq +
	jmp Sound.SFX.KillSoundEffect
+
	jmp Sound.Song.HandleMusicReturn5


Sound.SFX.Square1.StoreRawValuesWithCounter.AndKill.WithEcho:
;Function: Given a pointer to a table with raw values to store into sound registers, those values will
;be copied in order of $4000, $4002, and $4003 respectively. The first value will represent a duration
;for that current set of data. Upon reaching the end of the table, it will cycle through the beginning,
;playing the same sounds at decreasingly loud volumes to simulate an echo.
;Assumes starting volume of E, echoes 4 times.
;Expected: High in Y, Low in X
	cmp #0											;If not new, go to +
	bne +
	lda #$0E											;Else, initialize volume at #7
	sta Sound.SFX.VarA.w
+
	tya												;Y holds High
	jsr Sound.SFX.Square1.StoreRawValuesWithCounter	;Process sound
	beq ++											;Go to ++ if not at the end
	lda Sound.SFX.VarA.w							;Shift volume right
	lsr a
	bne +
	jmp Sound.SFX.KillSoundEffect					;Kill sound if it's over
+
	sta Sound.SFX.VarA.w							;Store shifted volume
	lda #$FF
	sta Sound.SFX.VarC.w							;Reset index
++
	lda Sound.SFX.VarA
	ora Sound.SFX.$4000.w
	sta Sound.SFX.$4000.w
	jmp Sound.Song.HandleMusicReturn5
	
Sound.SFX.Noise.StoreRawValuesWithCounter.AndKill
;Function: Jumps to Sound.SFX.Noise.StoreRawValuesWithCounter, and kills after it is done with the table.

	jsr Sound.SFX.Noise.StoreRawValuesWithCounter
	beq +
	jmp Sound.SFX.KillSoundEffect
+
	jmp Sound.Song.HandleMusicReturn5
	
Sound.SFX.Square1.StoreRawValuesWithCounter:
;Function: Given a pointer to a table, this routine will process the information in that table to store one
;collection of raw values for $4000, $4002, and $4003 for the amount of frames specified in the table, and
;automatically move on to the next value.
;Expected: Table H in A, Table L in X.
;Warnings: Uses VarB and VarC.

		
	sta Standard.NMI.TempAdd1H
	stx Standard.NMI.TempAdd1L
	
	lda Sound.SFX.VarB
	beq +
	sec
	sbc #1
	sta Sound.SFX.VarB
	lda #0
	rts
+
	inc Sound.SFX.VarC
	ldy Sound.SFX.VarC
	lda (Standard.NMI.TempAdd1L),y
	cmp #$FF
	bne +
	lda #$F0
	rts
+
	sta Sound.SFX.VarB
	
	iny
	lda (Standard.NMI.TempAdd1L),y
	beq +
	sta Sound.SFX.$4000
	iny
	lda (Standard.NMI.TempAdd1L),y
	sta Sound.SFX.$4002
	iny
	lda (Standard.NMI.TempAdd1L),y
	sta Sound.SFX.$4003
	sty Sound.SFX.VarC.w
	lda Sound.SFX.$4015
	ora #1
	sta Sound.SFX.$4015
	lda #0
	rts
+
	sty Sound.SFX.VarC.w
	lda Sound.SFX.$4015
	and #$FE
	sta Sound.SFX.$4015
	lda #0
	rts
	
Sound.SFX.Noise.StoreRawValuesWithCounter:
;Function: Given a pointer to a table, this routine will process the information in that table to store one
;collection of raw values for $400C, $400E, and $400F for the amount of frames specified in the table, and
;automatically move on to the next value.
;Expected: Table H in A, Table L in X.
;Warnings: Uses VarB and VarC.

		
	sta Standard.NMI.TempAdd1H
	stx Standard.NMI.TempAdd1L
	
	lda Sound.SFX.VarB
	beq +
	sec
	sbc #1
	sta Sound.SFX.VarB
	lda #0
	rts
+
	inc Sound.SFX.VarC
	ldy Sound.SFX.VarC
	lda (Standard.NMI.TempAdd1L),y
	cmp #$FF
	bne +
	lda #$F0
	rts
+
	sta Sound.SFX.VarB
	
	iny
	lda (Standard.NMI.TempAdd1L),y
	beq +
	sta Sound.SFX.$400C
	iny
	lda (Standard.NMI.TempAdd1L),y
	sta Sound.SFX.$400E
	lda #$FF
	sta Sound.SFX.$400F
	sty Sound.SFX.VarC.w
	lda Sound.SFX.$4015
	ora #8
	sta Sound.SFX.$4015
	lda #0
	rts
	
+
	sty Sound.SFX.VarC.w
	lda Sound.SFX.$4015
	and #$F7
	sta Sound.SFX.$4015
	lda #0
	rts
	
;***********************************************
;Common Functions for Drums
Sound.Drum.ProcessCounterTable:
;Function: Given an address at which is located a table of counter values, with H in A and L in X,
;The routine will return the current index of that table.
;Expected: H in A, L in X.
;Warnings: VarB and VarC will be used.
	sta Standard.NMI.TempAdd1H
	stx Standard.NMI.TempAdd1L
	
	lda Sound.Song.Noise.Sample.VarB
	beq +
	sec
	sbc #1
	sta Sound.Song.Noise.Sample.VarB
	lda Sound.Song.Noise.Sample.VarC
	rts
+
	inc Sound.Song.Noise.Sample.VarC
	ldy Sound.Song.Noise.Sample.VarC
	lda (Standard.NMI.TempAdd1L),y
	sta Sound.Song.Noise.Sample.VarB
	tya
	rts
	
Sound.Drum.Square1.StoreRawValues:
;Function: Given values in A, X, and Y, those values will be copied to $4000, $4002, and $4003 respectively.
;Expected: $4000 value in A, $4002 value in X, $4003 value in Y.
	sta Sound.Song.Noise.Sample.$4000
	stx Sound.Song.Noise.Sample.$4002.w
	sty Sound.Song.Noise.Sample.$4003.w
	lda Sound.Song.Noise.Sample.$4015
	ora #1
	sta Sound.Song.Noise.Sample.$4015
	rts

Sound.Drum.Square1.StoreRawValuesWithCounter.AndKill
;Function: Jumps to Sound.Drum.Square1.StoreRawValuesWithCounter, and kills after it is done with the table.

	jsr Sound.Drum.Square1.StoreRawValuesWithCounter
	beq +
	jmp Sound.Drum.KillSoundEffect
+
	jmp Sound.Song.HandleMusicReturn5


Sound.Drum.Square1.StoreRawValuesWithCounter.AndKill.WithEcho:
;Function: Given a pointer to a table with raw values to store into sound registers, those values will
;be copied in order of $4000, $4002, and $4003 respectively. The first value will represent a duration
;for that current set of data. Upon reaching the end of the table, it will cycle through the beginning,
;playing the same sounds at decreasingly loud volumes to simulate an echo.
;Assumes starting volume of E, echoes 4 times.
;Expected: High in Y, Low in X
	cmp #0											;If not new, go to +
	bne +
	lda #$0E											;Else, initialize volume at #7
	sta Sound.Song.Noise.Sample.VarA.w
+
	tya												;Y holds High
	jsr Sound.Drum.Square1.StoreRawValuesWithCounter	;Process sound
	beq ++											;Go to ++ if not at the end
	lda Sound.Song.Noise.Sample.VarA.w							;Shift volume right
	lsr a
	bne +
	jmp Sound.Drum.KillSoundEffect					;Kill sound if it's over
+
	sta Sound.Song.Noise.Sample.VarA.w							;Store shifted volume
	lda #$FF
	sta Sound.Song.Noise.Sample.VarC.w							;Reset index
++
	lda Sound.Song.Noise.Sample.VarA
	ora Sound.Song.Noise.Sample.$4000.w
	sta Sound.Song.Noise.Sample.$4000.w
	jmp Sound.Song.HandleMusicReturn5
	
Sound.Drum.Noise.StoreRawValuesWithCounter.AndKill
;Function: Jumps to Sound.Drum.Noise.StoreRawValuesWithCounter, and kills after it is done with the table.

	jsr Sound.Drum.Noise.StoreRawValuesWithCounter
	beq +
	jmp Sound.Drum.KillSoundEffect
+
	jmp Sound.Song.HandleMusicReturn5
	
Sound.Drum.Square1.StoreRawValuesWithCounter:
;Function: Given a pointer to a table, this routine will process the information in that table to store one
;collection of raw values for $4000, $4002, and $4003 for the amount of frames specified in the table, and
;automatically move on to the next value.
;Expected: Table H in A, Table L in X.
;Warnings: Uses VarB and VarC.

		
	sta Standard.NMI.TempAdd1H
	stx Standard.NMI.TempAdd1L
	
	lda Sound.Song.Noise.Sample.VarB
	beq +
	sec
	sbc #1
	sta Sound.Song.Noise.Sample.VarB
	lda #0
	rts
+
	inc Sound.Song.Noise.Sample.VarC
	ldy Sound.Song.Noise.Sample.VarC
	lda (Standard.NMI.TempAdd1L),y
	cmp #$FF
	bne +
	lda #$F0
	rts
+
	sta Sound.Song.Noise.Sample.VarB
	
	iny
	lda (Standard.NMI.TempAdd1L),y
	beq +
	sta Sound.Song.Noise.Sample.$4000
	iny
	lda (Standard.NMI.TempAdd1L),y
	sta Sound.Song.Noise.Sample.$4002
	iny
	lda (Standard.NMI.TempAdd1L),y
	sta Sound.Song.Noise.Sample.$4003
	sty Sound.Song.Noise.Sample.VarC.w
	lda Sound.Song.Noise.Sample.$4015
	ora #1
	sta Sound.Song.Noise.Sample.$4015
	lda #0
	rts
+
	sty Sound.Song.Noise.Sample.VarC.w
	lda Sound.Song.Noise.Sample.$4015
	and #$FE
	sta Sound.Song.Noise.Sample.$4015
	lda #0
	rts
	
Sound.Drum.Noise.StoreRawValuesWithCounter:
;Function: Given a pointer to a table, this routine will process the information in that table to store one
;collection of raw values for $400C, $400E, and $400F for the amount of frames specified in the table, and
;automatically move on to the next value.
;Expected: Table H in A, Table L in X.
;Warnings: Uses VarB and VarC.

		
	sta Standard.NMI.TempAdd1H
	stx Standard.NMI.TempAdd1L
	
	lda Sound.Song.Noise.Sample.VarB
	beq +
	sec
	sbc #1
	sta Sound.Song.Noise.Sample.VarB
	lda #0
	rts
+
	inc Sound.Song.Noise.Sample.VarC
	ldy Sound.Song.Noise.Sample.VarC
	lda (Standard.NMI.TempAdd1L),y
	cmp #$FF
	bne +
	lda #$F0
	rts
+
	sta Sound.Song.Noise.Sample.VarB
	
	iny
	lda (Standard.NMI.TempAdd1L),y
	beq +
	sta Sound.Song.Noise.Sample.$400C
	iny
	lda (Standard.NMI.TempAdd1L),y
	sta Sound.Song.Noise.Sample.$400E
	lda #$FF
	sta Sound.Song.Noise.Sample.$400F
	sty Sound.Song.Noise.Sample.VarC.w
	lda Sound.Song.Noise.Sample.$4015
	ora #8
	sta Sound.Song.Noise.Sample.$4015
	lda #0
	rts
	
+
	sty Sound.Song.Noise.Sample.VarC.w
	lda Sound.Song.Noise.Sample.$4015
	and #$F7
	sta Sound.Song.Noise.Sample.$4015
	lda #0
	rts