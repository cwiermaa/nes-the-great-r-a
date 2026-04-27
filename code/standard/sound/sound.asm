Sound.UpdateRegs:
	lda Sound.$4015
	ora Sound.SFX.$4015
	sta $4015

	lda Sound.SFX.$4015		;Check if Square 1 is used by SFX
	and #1
	beq ++

	lda Sound.SFX.$4000
	sta $4000
	lda Sound.SFX.$4001
	sta $4001
	lda Sound.SFX.$4002
	sta $4002
	lda Sound.SFX.$4003
	cmp Sound.$4003Old
	beq +
	sta $4003
+
	sta Sound.$4003Old
	jmp +++
++
	lda Sound.$4000
	sta $4000
	lda Sound.$4001
	sta $4001
	lda Sound.$4002
	sta $4002
	lda Sound.$4003
	cmp Sound.$4003Old
	beq +
	sta $4003
+
	sta Sound.$4003Old
+++
;**********************************************************

	lda Sound.SFX.$4015		;Check if Square 2 is used by SFX
	and #2
	beq ++

	lda Sound.SFX.$4004
	sta $4004
	lda Sound.SFX.$4005
	sta $4005
	lda Sound.SFX.$4006
	sta $4006
	lda Sound.SFX.$4007
	cmp Sound.$4007Old
	beq +
	sta $4007
+
	sta Sound.$4007Old
	jmp +++
++
	lda Sound.$4004
	sta $4004
	lda Sound.$4005
	sta $4005
	lda Sound.$4006
	sta $4006
	lda Sound.$4007
	cmp Sound.$4007Old
	beq +
	sta $4007
+
	sta Sound.$4007Old
+++
;*********************************************************

	lda Sound.SFX.$4015		;Check if Triangle is used by SFX
	and #4
	beq ++

	lda Sound.SFX.$4008
	sta $4008
	lda Sound.SFX.$400A
	sta $400A
	lda Sound.SFX.$400B
	sta $400B

	jmp +++
++
	lda Sound.$4008
	sta $4008

	lda Sound.$400A
	sta $400A

	lda Sound.$400B
	sta $400B

+++
;*********************************************************

	lda Sound.SFX.$4015		;Check if Noise is used by SFX
	and #8
	beq ++

	lda Sound.SFX.$400C
	sta $400C
	lda Sound.SFX.$400D
	sta $400D
	lda Sound.SFX.$400E
	sta $400E
	lda Sound.SFX.$400F
	sta $400F
	rts
++
	lda Sound.$400C
	sta $400C
	lda Sound.$400D
	sta $400D
	lda Sound.$400E
	sta $400E
	lda Sound.$400F
	sta $400F
	rts

Sound.Song.HandleMusic:
	lda Standard.CurrentBank
	pha
	ldx #6
	stx Standard.CurrentBank.w
	jsr Standard.Bankswitch
	clc
	lda Sound.Song.TempoCount
	adc Sound.Song.Tempo
	sta Sound.Song.TempoCount
	bcc +
	jsr Sound.Song.Square1.ReadMusic
	jmp (Sound.Song.Square1.UniqueAddL)
Sound.Song.HandleMusicReturn0:
	jsr Sound.Song.Square2.ReadMusic
	jmp (Sound.Song.Square2.UniqueAddL)
Sound.Song.HandleMusicReturn1:
	jsr Sound.Song.Triangle.ReadMusic
	jmp (Sound.Song.Triangle.UniqueAddL)
Sound.Song.HandleMusicReturn2:
	jsr Sound.Song.Noise.ReadMusic
	jmp (Sound.Song.Noise.SampleAddressL)
Sound.Song.HandleMusicReturn3:
	jmp (Sound.Song.Noise.UniqueAddL)
Sound.Song.HandleMusicReturn4SaveBank:
	lda Standard.CurrentBank
	pha
	ldx #6
	stx Standard.CurrentBank.w
	jsr Standard.Bankswitch
Sound.Song.HandleMusicReturn4:
+
	lda Sound.SFX.SoundEffect
	cmp Sound.SFX.SoundEffectOld
	beq +
	jsr Sound.SFX.RestoreDefaults
+
	lda Sound.SFX.SoundEffect
	sta Sound.SFX.SoundEffectOld

	beq Sound.Song.HandleMusicReturn5
	tax
	lda Sound.SFX.SFXTableL.w,x
	sta Standard.NMI.TempAdd0L
	lda Sound.SFX.SFXTableH.w,x
	sta Standard.NMI.TempAdd0H
	ldy Sound.SFX.Var1.w
	ldx #$FF
	stx Sound.SFX.Var1.w
	tya
	jmp (Standard.NMI.TempAdd0L)
Sound.Song.HandleMusicReturn5:
	pla
	sta Standard.CurrentBank.w
	tax
	jsr Standard.Bankswitch
	rts

;************************ Square 1 *******************************
;----------------------------------------------------------------------


Sound.Song.Square1.ReadMusic:
;*** Get current pitch ********
	ldy Sound.Song.Square1.CurrentNote			;Check if channel is supposed to be silent
	cpy #$FF
	bne +
	lda Sound.$4015						;Shut off channel
	and #$FE
	sta Sound.$4015
	jmp ++							;Count until next note.
+
	lda Sound.Song.NotesTableL.w,y				;If channel isn't silent, copy a note over
	sta Sound.$4002
	lda Sound.Song.NotesTableH.w,y
	sta Sound.$4003

	lda Sound.$4015						;Make sure channel is enabled.
	ora #1
	sta Sound.$4015
++
;*** Check and Read *******
	lda Sound.Song.Square1.TicksRemaining			;See if note counter is at 0
	beq ++							;If so, go ahead

	dec Sound.Song.Square1.TicksRemaining

;****								;If not a new note, handle volume envelope
	lda Sound.Song.Square1.VolumeEnvelopeL			;Point to volume envelope
	sta Standard.NMI.TempAdd0L
	lda Sound.Song.Square1.VolumeEnvelopeH
	sta Standard.NMI.TempAdd0H
	ldy Sound.Song.Square1.VolumeEnvelopeIndex		;Load VE index
	bne +							;If not 0, go to +
	iny							;If 0, make it 1
	sty Sound.Song.Square1.VolumeEnvelopeIndex.w
+
-
	lda (Standard.NMI.TempAdd0L),y				;Load entry
	cmp #$10						;Check if it's $10
	beq +							;if it is, go to +
	sta Standard.NMI.ZTempVar1				;If entry isn't $10, it's a volume entry
	lda Sound.$4000						;Take $4000
	and #$30						;Keep high 4 bits
	ora Standard.NMI.ZTempVar1				;Replace low 4
	ora Sound.Song.Square1.DutyCycle
	sta Sound.$4000						;Store it
	inc Sound.Song.Square1.VolumeEnvelopeIndex		;Increase index
	rts							;Return
+
	ldy #0							;If we're here, this means the envelope looped
	lda (Standard.NMI.TempAdd0L),y				;Load first entry of envelope, make it the VE index
	sta Sound.Song.Square1.VolumeEnvelopeIndex
	tay
	jmp -							;Go and load first intry
;****

++
	lda #0
	sta Standard.NMI.ZTempVar1
	lda Sound.Song.Square1.CurrentNote
	cmp #$FF
	beq +
	lda Sound.Song.Square1.TicksLess
	beq +
	sec
	sbc #1
	sta Sound.Song.Square1.TicksRemaining
	lda Sound.$4015
	and #$FE
	sta Sound.$4015
	lda #$FF
	sta Sound.Song.Square1.CurrentNote
	jmp +++

+
	lda #<Sound.Song.Square1.Return				;This is for general purpose music routines
	sta Sound.ReturnL					;Which jump to Sound.ReturnL after finished
	lda #>Sound.Song.Square1.Return
	sta Sound.ReturnH

	lda #<Sound.Song.Square1.MusicAddL			;This is also for the general purpose music routines.
	sta Sound.RAMBlockL					;They access everything indirectly (except for channel
	lda #>Sound.Song.Square1.MusicAddL			;specific stuff
	sta Sound.RAMBlockH

	lda Sound.Song.Square1.MusicAddL			;We must access music data indirectly, too
	sta Standard.NMI.TempAdd0L
	lda Sound.Song.Square1.MusicAddH
	sta Standard.NMI.TempAdd0H

	ldy #0							;The address of the music data is incremented manually
								;Only aided internally by indirect Y
								;At the end, we manually increment this address

-
	ldy Standard.NMI.ZTempVar1				;Load current index
	lda (Standard.NMI.TempAdd0L),y				;Load current byte in song
	cmp #$AF						;If $AF or less, it's a straight up music note
	bcc +
	sec							;Otherwise, it's a command
	sbc #$B0						;Subtract $B0
	tax							;put it in X
	lda Sound.Song.CommandsL.w,x				;Use it as an index for a jump table
	sta Standard.NMI.TempAdd1L
	lda Sound.Song.CommandsH.w,x
	sta Standard.NMI.TempAdd1H
	iny							;Move onto next byte (could be an argument)
	sty Standard.NMI.ZTempVar1				;Will access using indirect Y with ZTempVar1 as Y
	jmp (Standard.NMI.TempAdd1L)				;Jump to wherever the jump table says.
Sound.Song.Square1.Return:
	cpx #$FE
	beq +++++
	jmp -							;Is ignored. Loop otherwise until standard note/time combo
								;Is read.
+
	inc Standard.NMI.ZTempVar1
	tay							;Save note/time combo
	lsr a							;Get high 4 bits in the low
	lsr a
	lsr a
	lsr a
	tax							;Use it as index
	sec
	lda Sound.Song.TempoTicks.w,x				;Get current tempo ticks
	sbc Sound.Song.Square1.TicksLess
	sta Sound.Song.Square1.TicksRemaining			;Set number of ticks remaining
	tya							;Now find relative note/silence/prolong
	and #$0F						;Use 4 low bits as index
	cmp #$0E						;Check for Silence
	bne +	
	clc
	lda Sound.Song.Square1.TicksRemaining
	adc Sound.Song.Square1.TicksLess
	sta Sound.Song.Square1.TicksRemaining
	lda Sound.$4015
	and #$FE
	sta Sound.$4015
	lda #$FF
	sta Sound.Song.Square1.CurrentNote
	jmp +++
+
	cmp #$0F						;Check for Note prolonging
	bne +
	jmp ++							;Keep same pitch and volume envelope index.
+	
	clc
	adc Sound.Song.Square1.ReferenceNote			;Regular note
	tay
	ldx Sound.Song.Square1.CurrentNote
	sta Sound.Song.Square1.CurrentNote
	lda Sound.Song.NotesTableL.w,y
	sta Sound.$4002
	lda Sound.Song.NotesTableH.w,y
	sta Sound.$4003
	cpx #$FF
	bne +
	stx Sound.$4003Old.w					;Force $4003 update to happen
+
	lda Sound.$4015
	ora #1
	sta Sound.$4015

+++
	lda #$00
	sta Sound.Song.Square1.VolumeEnvelopeIndex
-	
++
	clc							;Add ZTempVar1 (temporary music index) to MusicAddL/H.
	lda Sound.Song.Square1.MusicAddL
	adc Standard.NMI.ZTempVar1
	sta Sound.Song.Square1.MusicAddL
	lda Sound.Song.Square1.MusicAddH
	adc #0
	sta Sound.Song.Square1.MusicAddH
	rts

;*****

+++++
	lda Standard.NMI.ZTempVar3
	sta Sound.Song.Square1.TicksRemaining

	lda Sound.Song.Square1.CurrentNote			;Check if channel is supposed to be silent
	cmp #$FF
	bne +
	sta Sound.$4003Old					;Force $4003 update to happen
+
	ldy Standard.NMI.ZTempVar2				;Note
	cpy #$FF
	bne +
	lda #0
	sta Sound.Song.Square1.VolumeEnvelopeIndex		;Here if playing silence
	lda Sound.$4015						;Shut off channel
	and #$FE
	sta Sound.$4015
	lda #$FF
	sta Sound.Song.Square1.CurrentNote
	jmp -							;Count until next note.
+
	cpy #$FE						;For note prolonging
	beq +
	lda #0
	sta Sound.Song.Square1.VolumeEnvelopeIndex
	sty Sound.Song.Square1.CurrentNote.w
+
	ldx Sound.Song.Square1.CurrentNote.w
	lda Sound.Song.NotesTableL.w,x				;If channel isn't silent, copy a note over
	sta Sound.$4002
	lda Sound.Song.NotesTableH.w,x
	sta Sound.$4003

	lda Sound.$4015						;Make sure channel is enabled.
	ora #1
	sta Sound.$4015

	jmp -
;************************ / Square 1 *******************************
;----------------------------------------------------------------------


;************************ Square 2 *******************************
;-----------------------------------------------------------------
Sound.Song.Square2.ReadMusic:
;*** Get current pitch ********
	ldy Sound.Song.Square2.CurrentNote			;Check if channel is supposed to be silent
	cpy #$FF
	bne +
	lda Sound.$4015						;Shut off channel
	and #$FD
	sta Sound.$4015
	jmp ++							;Count until next note.
+
	lda Sound.Song.NotesTableL.w,y				;If channel isn't silent, copy a note over
	sta Sound.$4006
	lda Sound.Song.NotesTableH.w,y
	sta Sound.$4007

	lda Sound.$4015						;Make sure channel is enabled.
	ora #2
	sta Sound.$4015
++
--
;*** Check and Read ******
	lda Sound.Song.Square2.TicksRemaining			;See if note counter is at 0
	beq ++							;If so, go ahead

	dec Sound.Song.Square2.TicksRemaining

;****								;If not a new note, handle volume envelope
	lda Sound.Song.Square2.VolumeEnvelopeL			;Point to volume envelope
	sta Standard.NMI.TempAdd0L
	lda Sound.Song.Square2.VolumeEnvelopeH
	sta Standard.NMI.TempAdd0H
	ldy Sound.Song.Square2.VolumeEnvelopeIndex		;Load VE index
	bne +							;If not 0, go to +
	iny							;If 0, make it 1
	sty Sound.Song.Square2.VolumeEnvelopeIndex.w
+
-
	lda (Standard.NMI.TempAdd0L),y				;Load entry
	cmp #$10						;Check if it's $10
	beq +							;if it is, go to +
	sta Standard.NMI.ZTempVar1				;If entry isn't $10, it's a volume entry
	lda Sound.$4004						;Take $4000
	and #$30						;Keep high 4 bits
	ora Standard.NMI.ZTempVar1				;Replace low 4
	ora Sound.Song.Square2.DutyCycle
	sta Sound.$4004						;Store it
	inc Sound.Song.Square2.VolumeEnvelopeIndex		;Increase index
	rts							;Return
+
	ldy #0							;If we're here, this means the envelope looped
	lda (Standard.NMI.TempAdd0L),y				;Load first entry of envelope, make it the VE index
	sta Sound.Song.Square2.VolumeEnvelopeIndex
	tay
	jmp -							;Go and load first intry
;****
++
	lda #0
	sta Standard.NMI.ZTempVar1
	lda Sound.Song.Square2.CurrentNote
	cmp #$FF
	beq +
	lda Sound.Song.Square2.TicksLess
	beq +
	sec
	sbc #1
	sta Sound.Song.Square2.TicksRemaining
	lda Sound.$4015
	and #$FD
	sta Sound.$4015
	lda #$FF
	sta Sound.Song.Square2.CurrentNote
	jmp +++
	
+
	lda #<Sound.Song.Square2.Return				;This is for general purpose music routines
	sta Sound.ReturnL					;Which jump to Sound.ReturnL after finished
	lda #>Sound.Song.Square2.Return
	sta Sound.ReturnH

	lda #<Sound.Song.Square2.MusicAddL			;This is also for the general purpose music routines.
	sta Sound.RAMBlockL					;They access everything indirectly (except for channel
	lda #>Sound.Song.Square2.MusicAddL			;specific stuff
	sta Sound.RAMBlockH

	lda Sound.Song.Square2.MusicAddL			;We must access music data indirectly, too
	sta Standard.NMI.TempAdd0L
	lda Sound.Song.Square2.MusicAddH
	sta Standard.NMI.TempAdd0H

	ldy #0							;The address of the music data is incremented manually															;Only aided internally by indirect Y
								;At the end, we manually increment this address

-
	ldy Standard.NMI.ZTempVar1				;Load current index
	lda (Standard.NMI.TempAdd0L),y				;Load current byte in song
	cmp #$AF						;If $AF or less, it's a straight up music note
	bcc +
	sec							;Otherwise, it's a command
	sbc #$B0						;Subtract $B0
	tax							;put it in X
	lda Sound.Song.CommandsL.w,x				;Use it as an index for a jump table
	sta Standard.NMI.TempAdd1L
	lda Sound.Song.CommandsH.w,x
	sta Standard.NMI.TempAdd1H
	iny							;Move onto next byte (could be an argument)
	sty Standard.NMI.ZTempVar1				;Will access using indirect Y with ZTempVar1 as Y
	jmp (Standard.NMI.TempAdd1L)				;Jump to wherever the jump table says.
Sound.Song.Square2.Return:
	cpx #$FE
	beq +++++
	jmp -							;Is ignored. Loop otherwise until standard note/time combo
								;Is read.
+
	inc Standard.NMI.ZTempVar1
	tay							;Save note/time combo
	lsr a							;Get high 4 bits in the low
	lsr a
	lsr a
	lsr a
	tax							;Use it as index
	sec
	lda Sound.Song.TempoTicks.w,x				;Get current tempo ticks
	sbc Sound.Song.Square2.TicksLess
	sta Sound.Song.Square2.TicksRemaining			;Set number of ticks remaining
	tya							;Now find relative note/silence/prolong
	and #$0F						;Use 4 low bits as index
	cmp #$0E						;Check for Silence
	bne +
	clc
	lda Sound.Song.Square2.TicksRemaining
	adc Sound.Song.Square2.TicksLess
	sta Sound.Song.Square2.TicksRemaining
	lda Sound.$4015
	and #$FD
	sta Sound.$4015
	lda #$FF
	sta Sound.Song.Square2.CurrentNote
	jmp +++
+
	cmp #$0F						;Check for Note prolonging
	bne +
	jmp ++							;Keep same pitch and volume envelope index.
+	
	clc
	adc Sound.Song.Square2.ReferenceNote			;Regular note
	tay
	ldx Sound.Song.Square2.CurrentNote
	sta Sound.Song.Square2.CurrentNote
	lda Sound.Song.NotesTableL.w,y
	sta Sound.$4006
	lda Sound.Song.NotesTableH.w,y
	sta Sound.$4007
	cpx #$FF
	bne +
	stx Sound.$4007Old.w					;Force $4003 update to happen
+
	lda Sound.$4015
	ora #2
	sta Sound.$4015

+++
	lda #$00
	sta Sound.Song.Square2.VolumeEnvelopeIndex
-	
++
	clc							;Add ZTempVar1 (temporary music index) to MusicAddL/H.
	lda Sound.Song.Square2.MusicAddL
	adc Standard.NMI.ZTempVar1
	sta Sound.Song.Square2.MusicAddL
	lda Sound.Song.Square2.MusicAddH
	adc #0
	sta Sound.Song.Square2.MusicAddH
	rts

;*****

+++++
	lda Standard.NMI.ZTempVar3
	sta Sound.Song.Square2.TicksRemaining

	lda Sound.Song.Square2.CurrentNote			;Check if channel is supposed to be silent
	cmp #$FF
	bne +
	sta Sound.$4007Old					;Force $4003 update to happen
+
	ldy Standard.NMI.ZTempVar2				;Note
	cpy #$FF
	bne +
	lda #0
	sta Sound.Song.Square2.VolumeEnvelopeIndex		;Here if playing silence
	lda Sound.$4015						;Shut off channel
	and #$FD
	sta Sound.$4015
	lda #$FF
	sta Sound.Song.Square2.CurrentNote
	jmp -							;Count until next note.
+
	cpy #$FE						;For note prolonging
	beq +
	lda #0
	sta Sound.Song.Square2.VolumeEnvelopeIndex
	sty Sound.Song.Square2.CurrentNote.w
+
	ldx Sound.Song.Square2.CurrentNote.w
	lda Sound.Song.NotesTableL.w,x				;If channel isn't silent, copy a note over
	sta Sound.$4006
	lda Sound.Song.NotesTableH.w,x
	sta Sound.$4007

	lda Sound.$4015						;Make sure channel is enabled.
	ora #2
	sta Sound.$4015

	jmp -

;******************** /Square 2 *******************************
;-------------------------------------------------------------


;******************* Triangle ****************************
;---------------------------------------------------------
Sound.Song.Triangle.ReadMusic:
	ldy Sound.Song.Triangle.CurrentNote			;Check if channel is supposed to be silent
	cpy #$FF
	bne +
	lda Sound.$4015						;Shut off channel
	and #$FB
	sta Sound.$4015
	jmp ++							;Count until next note.
+
	lda Sound.Song.NotesTableL.w,y				;If channel isn't silent, copy a note over
	sta Sound.$400A
	lda Sound.Song.NotesTableH.w,y
	sta Sound.$400B

	lda Sound.$4015						;Make sure channel is enabled.
	ora #4
	sta Sound.$4015
++
;*** Check and Read *******
	lda Sound.Song.Triangle.Length
	bne +

	lda Sound.$4015						;Silence channel
	and #$FB
	sta Sound.$4015
	lda #$FF
	sta Sound.Song.Triangle.CurrentNote			;Officially mark channel as silent
								;Length must be either less or greater than Ticks Remaining

+
	lda Sound.Song.Triangle.TicksRemaining			;See if note counter is at 0
	beq ++							;If so, go ahead

	dec Sound.Song.Triangle.TicksRemaining
	dec Sound.Song.Triangle.Length


;****								;If not a x
	rts							;Return
;****

++

	lda #<Sound.Song.Triangle.Return				;This is for general purpose music routines
	sta Sound.ReturnL					;Which jump to Sound.ReturnL after finished
	lda #>Sound.Song.Triangle.Return
	sta Sound.ReturnH

	lda #<Sound.Song.Triangle.MusicAddL			;This is also for the general purpose music routines.
	sta Sound.RAMBlockL					;They access everything indirectly (except for channel
	lda #>Sound.Song.Triangle.MusicAddL			;specific stuff
	sta Sound.RAMBlockH

	lda Sound.Song.Triangle.MusicAddL			;We must access music data indirectly, too
	sta Standard.NMI.TempAdd0L
	lda Sound.Song.Triangle.MusicAddH
	sta Standard.NMI.TempAdd0H

	ldy #0							;The address of the music data is incremented manually
	sty Standard.NMI.ZTempVar1				;Only aided internally by indirect Y
								;At the end, we manually increment this address

-
	ldy Standard.NMI.ZTempVar1				;Load current index
	lda (Standard.NMI.TempAdd0L),y				;Load current byte in song
	cmp #$AF						;If $AF or less, it's a straight up music note
	bcc +
	sec							;Otherwise, it's a command
	sbc #$B0						;Subtract $B0
	tax							;put it in X
	lda Sound.Song.CommandsL.w,x				;Use it as an index for a jump table
	sta Standard.NMI.TempAdd1L
	lda Sound.Song.CommandsH.w,x
	sta Standard.NMI.TempAdd1H
	iny							;Move onto next byte (could be an argument)
	sty Standard.NMI.ZTempVar1				;Will access using indirect Y with ZTempVar1 as Y
	jmp (Standard.NMI.TempAdd1L)				;Jump to wherever the jump table says.
Sound.Song.Triangle.Return:
	cpx #$FE
	bne ++
	jmp +++++
++
	jmp -							;Is ignored. Loop otherwise until standard note/time combo
								;Is read.
+
	inc Standard.NMI.ZTempVar1
	tay							;Save note/time combo
	lsr a							;Get high 4 bits in the low
	lsr a
	lsr a
	lsr a
	tax							;Use it as index
	lda Sound.Song.TempoTicks.w,x				;Get current tempo ticks
	sta Sound.Song.Triangle.TicksRemaining			;Set number of ticks remaining
-
	tya							;Now find relative note/silence/prolong
	and #$0F						;Use 4 low bits as index
	cmp #$0E						;Check for Silence
	bne +
	lda Sound.$4015
	and #$FB
	sta Sound.$4015
	lda #$FF
	sta Sound.Song.Triangle.CurrentNote
	jmp +++
+
	cmp #$0F						;Check for Note prolonging
	bne +								;In Triangle music, we prolong pitch
								;Backwards. So we put the prolonging byte
								;Before the actual note

	ldy Standard.NMI.ZTempVar1				;Load current index
	lda (Standard.NMI.TempAdd0L),y				;Load current byte in song
	inc Standard.NMI.ZTempVar1
	tay
	lsr a
	lsr a
	lsr a
	lsr a
	tax
	lda Sound.Song.TempoTicks.w,x
	clc
	adc Sound.Song.Triangle.TicksRemaining
	sta Sound.Song.Triangle.TicksRemaining

	jmp -
+	
	clc
	adc Sound.Song.Triangle.ReferenceNote			;Regular note
	tay
	sta Sound.Song.Triangle.CurrentNote
	lda Sound.Song.NotesTableL.w,y
	sta Sound.$400A
	lda Sound.Song.NotesTableH.w,y
	sta Sound.$400B

	lda Sound.$4015
	ora #4
	sta Sound.$4015

+++
-	
++
	lda Sound.Song.Triangle.ConstantLength
	beq +
	lda Sound.Song.Triangle.TicksLengthDifference
	sta Sound.Song.Triangle.Length
	jmp ++
+
	sec
	lda Sound.Song.Triangle.TicksRemaining
	sbc Sound.Song.Triangle.TicksLengthDifference
	sta Sound.Song.Triangle.Length
++
	clc							;Add ZTempVar1 (temporary music index) to MusicAddL/H.
	lda Sound.Song.Triangle.MusicAddL
	adc Standard.NMI.ZTempVar1
	sta Sound.Song.Triangle.MusicAddL
	lda Sound.Song.Triangle.MusicAddH
	adc #0
	sta Sound.Song.Triangle.MusicAddH
	rts

;*****

+++++
	lda Standard.NMI.ZTempVar3
	sta Sound.Song.Triangle.TicksRemaining

	ldy Standard.NMI.ZTempVar2				;Note
	cpy #$FF
	bne +

	lda Sound.$4015						;Shut off channel
	and #$FB
	sta Sound.$4015
	lda #$FF
	sta Sound.Song.Triangle.CurrentNote
	jmp -							;Count until next note.
+
	cpy #$FE						;For note prolonging
	beq +
	sty Sound.Song.Triangle.CurrentNote.w
+
	ldx Sound.Song.Triangle.CurrentNote.w
	lda Sound.Song.NotesTableL.w,x				;If channel isn't silent, copy a note over
	sta Sound.$400A
	lda Sound.Song.NotesTableH.w,x
	sta Sound.$400B

	lda Sound.$4015						;Make sure channel is enabled.
	ora #4
	sta Sound.$4015
	jmp -

;*******************/Triangle ****************************
;---------------------------------------------------------


;******************* Drum ****************************
;-----------------------------------------------------
Sound.Song.Noise.ReadMusic:
	lda Sound.Song.Noise.TicksRemaining
	beq +

	dec Sound.Song.Noise.TicksRemaining
	rts
+
	

	lda #<Sound.Song.Noise.Return				;This is for general purpose music routines
	sta Sound.ReturnL					;Which jump to Sound.ReturnL after finished
	lda #>Sound.Song.Noise.Return
	sta Sound.ReturnH

	lda #<Sound.Song.Noise.MusicAddL			;This is also for the general purpose music routines.
	sta Sound.RAMBlockL					;They access everything indirectly (except for channel
	lda #>Sound.Song.Noise.MusicAddL			;specific stuff
	sta Sound.RAMBlockH

	lda Sound.Song.Noise.MusicAddL			;We must access music data indirectly, too
	sta Standard.NMI.TempAdd0L
	lda Sound.Song.Noise.MusicAddH
	sta Standard.NMI.TempAdd0H

	ldy #0							;The address of the music data is incremented manually
	sty Standard.NMI.ZTempVar1				;Only aided internally by indirect Y
								;At the end, we manually increment this address

-
	ldy Standard.NMI.ZTempVar1				;Load current index
	lda (Standard.NMI.TempAdd0L),y				;Load current byte in song
	cmp #$AF						;If $AF or less, it's a straight up music note
	bcc +
	sec							;Otherwise, it's a command
	sbc #$B0						;Subtract $B0
	tax							;put it in X
	lda Sound.Song.CommandsL.w,x				;Use it as an index for a jump table
	sta Standard.NMI.TempAdd1L
	lda Sound.Song.CommandsH.w,x
	sta Standard.NMI.TempAdd1H
	iny							;Move onto next byte (could be an argument)
	sty Standard.NMI.ZTempVar1				;Will access using indirect Y with ZTempVar1 as Y
	jmp (Standard.NMI.TempAdd1L)				;Jump to wherever the jump table says.
Sound.Song.Noise.Return:	
	cpx #$FE
	bne ++
	jmp +++++
++
	jmp -

+	
	inc Standard.NMI.ZTempVar1
	tay							;Save note/time combo
	lsr a							;Get high 4 bits in the low
	lsr a
	lsr a
	lsr a
	tax							;Use it as index
	lda Sound.Song.TempoTicks.w,x				;Get current tempo ticks
	sta Sound.Song.Noise.TicksRemaining			;Set number of ticks remaining
-
	tya							;Now find relative note/silence/prolong
	and #$0F						;Use 4 low bits as index
	cmp #$0E						;Check for Silence
	bne +
	lda #$00
	sta Sound.Song.Noise.CurrentNote
	jmp ++
+
	clc
	adc Sound.Song.Noise.ReferenceNote			;Regular note
	tay
	sta Sound.Song.Noise.CurrentNote
-
++	
	clc							;Add ZTempVar1 (temporary music index) to MusicAddL/H.
	lda Sound.Song.Noise.MusicAddL
	adc Standard.NMI.ZTempVar1
	sta Sound.Song.Noise.MusicAddL
	lda Sound.Song.Noise.MusicAddH
	adc #0
	sta Sound.Song.Noise.MusicAddH

	ldy Sound.Song.Noise.CurrentNote
	lda Sound.Song.DrumsL.w,y
	sta Sound.Song.Noise.SampleAddressL
	lda Sound.Song.DrumsH.w,y
	sta Sound.Song.Noise.SampleAddressH

	lda #$00
	sta Sound.Song.Noise.Sample.Var1			;New note indication
	rts

+++++
	lda Standard.NMI.ZTempVar3
	sta Sound.Song.Noise.TicksRemaining

	ldy Standard.NMI.ZTempVar2				;Note
	cpy #$FF
	bne +

	lda #$00
	sta Sound.Song.Noise.CurrentNote
	jmp -							;Count until next note.
+
	cpy #$FE						;For note prolonging
	beq +
	sty Sound.Song.Noise.CurrentNote.w
+
	jmp -

;*******************/Drum ****************************
;-----------------------------------------------------

;Drums are data. Review Sound Data folder contents for drums.


;****************
;The following code is general purpose. Before coming, one must store the starting address of the current track's RAM block 
;in Sound.RAMBlockL/H. Then they also must store the return address in Sound.ReturnL.

;These are the tempo ticks for dotted whole, whole, dotted half, half, dotted quarter, quarter, dotted eighth, eighth,
;triple-it, sixteenth, and thirty second notes. In that order.

Sound.Song.TempoTicks:
	.db 143, 95, 71, 47, 35, 23, 17, 11, 7, 5, 2

Sound.Song.CommandsL:
	.db <Sound.Song.SetReferenceNote, <Sound.Song.SetVolumeEnvelope, <Sound.Song.SetDutyCycle
	.db <Sound.Song.SetTempo, <Sound.Song.SetPC, <Sound.Song.Down4Octaves
	.db <Sound.Song.Down3Octaves, <Sound.Song.Down2Octaves, <Sound.Song.Down1Octave
	.db <Sound.Song.Up1Octave, <Sound.Song.Up2Octaves, <Sound.Song.Up3Octaves, <Sound.Song.Up4Octaves
	.db <Sound.Song.SetUniqueRoutine, <Sound.Song.SetTriangleRelativeTicks, <Sound.Song.SetTriangleTicks
	.db <Sound.Song.Loop1, <Sound.Song.Loop2, <Sound.Song.Loop3, <Sound.Song.PlayLiteral
	.db <Sound.Song.Sq1SetTicksLess, <Sound.Song.Sq2SetTicksLess

Sound.Song.CommandsH:
	.db >Sound.Song.SetReferenceNote, >Sound.Song.SetVolumeEnvelope, >Sound.Song.SetDutyCycle
	.db >Sound.Song.SetTempo, >Sound.Song.SetPC, >Sound.Song.Down4Octaves
	.db >Sound.Song.Down3Octaves, >Sound.Song.Down2Octaves, >Sound.Song.Down1Octave
	.db >Sound.Song.Up1Octave, >Sound.Song.Up2Octaves, >Sound.Song.Up3Octaves, >Sound.Song.Up4Octaves
	.db >Sound.Song.SetUniqueRoutine, >Sound.Song.SetTriangleRelativeTicks, >Sound.Song.SetTriangleTicks
	.db >Sound.Song.Loop1, >Sound.Song.Loop2, >Sound.Song.Loop3, >Sound.Song.PlayLiteral
	.db >Sound.Song.Sq1SetTicksLess, >Sound.Song.Sq2SetTicksLess

Sound.Song.SetReferenceNote:
	lda (Standard.NMI.TempAdd0L),y
	ldy #7
	sta (Sound.RAMBlockL),y
	inc Standard.NMI.ZTempVar1
	ldx #0
	jmp (Sound.ReturnL)

Sound.Song.SetVolumeEnvelope:
	lda (Standard.NMI.TempAdd0L),y
	tax
	iny
	sty Standard.NMI.ZTempVar1

	ldy #11
	lda Sound.Songs.VolumeEnvelopesL.w,x
	sta (Sound.RAMBlockL),y
	iny
	lda Sound.Songs.VolumeEnvelopesH.w,x
	sta (Sound.RAMBlockL),y
	iny
	lda #$00
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)
Sound.Song.SetDutyCycle:
	lda (Standard.NMI.TempAdd0L),y
	iny
	sty Standard.NMI.ZTempVar1
	ldy #8
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)
Sound.Song.SetTempo:
	lda (Standard.NMI.TempAdd0L),y
	inc Standard.NMI.ZTempVar1
	sta Sound.Song.Tempo
	
	ldx #0
	stx Sound.Song.TempoCount.w
	jmp (Sound.ReturnL)

Sound.Song.SetPC:
	iny
	lda (Standard.NMI.TempAdd0L),y
	tax
	dey
	lda (Standard.NMI.TempAdd0L),y

	ldy #0
	sty Standard.NMI.ZTempVar1
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0L
	txa
	iny
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0H

	ldx #0
	jmp (Sound.ReturnL)

Sound.Song.Down4Octaves:

	sec
	ldy #7
	lda (Sound.RAMBlockL),y
	sbc #48
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)
Sound.Song.Down3Octaves:

	sec
	ldy #7
	lda (Sound.RAMBlockL),y
	sbc #36
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)
Sound.Song.Down2Octaves:
	sec
	ldy #7
	lda (Sound.RAMBlockL),y
	sbc #24
	sta (Sound.RAMBlockL),y
	ldx #0

	jmp (Sound.ReturnL)
Sound.Song.Down1Octave:
	sec
	ldy #7
	lda (Sound.RAMBlockL),y
	sbc #12
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)
Sound.Song.Up1Octave:
	clc
	ldy #7
	lda (Sound.RAMBlockL),y
	adc #12
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)

Sound.Song.Up2Octaves:
	clc
	ldy #7
	lda (Sound.RAMBlockL),y
	adc #24
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)
Sound.Song.Up3Octaves:
	clc
	ldy #7
	lda (Sound.RAMBlockL),y
	adc #36
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)
Sound.Song.Up4Octaves:
	clc
	ldy #7
	lda (Sound.RAMBlockL),y
	adc #48
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)
Sound.Song.SetUniqueRoutine:
	iny
	lda (Standard.NMI.TempAdd0L),y
	tax
	dey
	lda (Standard.NMI.TempAdd0L),y
	iny
	iny
	sty Standard.NMI.ZTempVar1

	ldy #9
	sta (Sound.RAMBlockL),y
	iny
	txa
	sta (Sound.RAMBlockL),y
	ldx #0
	jmp (Sound.ReturnL)

Sound.Song.SetTriangleRelativeTicks:
	lda #$00
	sta Sound.Song.Triangle.ConstantLength
	lda (Standard.NMI.TempAdd0L),y
	sta Sound.Song.Triangle.TicksLengthDifference
	inc Standard.NMI.ZTempVar1
	jmp (Sound.ReturnL)

Sound.Song.SetTriangleTicks:
	lda #$01
	sta Sound.Song.Triangle.ConstantLength
	lda (Standard.NMI.TempAdd0L),y
	sta Sound.Song.Triangle.TicksLengthDifference
	inc Standard.NMI.ZTempVar1
	jmp (Sound.ReturnL)

Sound.Song.Loop1:
	tya
	tax
	ldy #2
	lda (Sound.RAMBlockL),y				;If bit 8 is set, looping is taking place
	bmi +
	
	txa						;If bit 8 is clear, looping is to begin
	tay
	iny
	iny
	lda (Standard.NMI.TempAdd0L),y
	sta Standard.NMI.ZTempVar2
	dey
	lda (Standard.NMI.TempAdd0L),y
	tax
	dey
	lda (Standard.NMI.TempAdd0L),y

	ldy #0
	sty Standard.NMI.ZTempVar1
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0L
	txa
	iny
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0H
	ldy #2
	lda Standard.NMI.ZTempVar2
	ora #$80
	sta (Sound.RAMBlockL),y

	ldx #0
	jmp (Sound.ReturnL)
		
+
	sec						;Decrease loop by one
	sbc #1
	sta (Sound.RAMBlockL),y
	and #$7F					;If low 7 bits aren't 0
	bne +						;Go to +
	sta (Sound.RAMBlockL),y				;Store 0 into Counter, and free self from loop
	txa						;If they are, skip this instruction
	clc
	adc #3
	sta Standard.NMI.ZTempVar1
	ldx #0
	jmp (Sound.ReturnL)
+
	txa
	tay
	iny
	lda (Standard.NMI.TempAdd0L),y
	tax
	dey
	lda (Standard.NMI.TempAdd0L),y

	ldy #0
	sty Standard.NMI.ZTempVar1
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0L
	txa
	iny
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0H

	ldx #0
	jmp (Sound.ReturnL)

Sound.Song.Loop2:

	tya
	tax
	ldy #3
	lda (Sound.RAMBlockL),y				;If bit 8 is set, looping is taking place
	bmi +
	
	txa						;If bit 8 is clear, looping is to begin
	tay
	iny
	iny
	lda (Standard.NMI.TempAdd0L),y
	sta Standard.NMI.ZTempVar2
	dey
	lda (Standard.NMI.TempAdd0L),y
	tax
	dey
	lda (Standard.NMI.TempAdd0L),y

	ldy #0
	sty Standard.NMI.ZTempVar1
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0L
	txa
	iny
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0H
	ldy #3
	lda Standard.NMI.ZTempVar2
	ora #$80
	sta (Sound.RAMBlockL),y

	ldx #0
	jmp (Sound.ReturnL)
		
+
	sec						;Decrease loop by one
	sbc #1
	sta (Sound.RAMBlockL),y
	and #$7F					;If low 7 bits aren't 0
	bne +						;Go to +
	sta (Sound.RAMBlockL),y				;Store 0 into Counter, and free self from loop
	txa						;If they are, skip this instruction
	clc
	adc #3
	sta Standard.NMI.ZTempVar1
	ldx #0
	jmp (Sound.ReturnL)
+
	txa
	tay
	iny
	lda (Standard.NMI.TempAdd0L),y
	tax
	dey
	lda (Standard.NMI.TempAdd0L),y

	ldy #0
	sty Standard.NMI.ZTempVar1
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0L
	txa
	iny
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0H

	ldx #0
	jmp (Sound.ReturnL)

Sound.Song.Loop3:
	tya
	tax
	ldy #4
	lda (Sound.RAMBlockL),y				;If bit 8 is set, looping is taking place
	bmi +
	
	txa						;If bit 8 is clear, looping is to begin
	tay
	iny
	iny
	lda (Standard.NMI.TempAdd0L),y
	sta Standard.NMI.ZTempVar2
	dey
	lda (Standard.NMI.TempAdd0L),y
	tax
	dey
	lda (Standard.NMI.TempAdd0L),y

	ldy #0
	sty Standard.NMI.ZTempVar1
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0L
	txa
	iny
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0H
	ldy #4
	lda Standard.NMI.ZTempVar2
	ora #$80
	sta (Sound.RAMBlockL),y

	ldx #0
	jmp (Sound.ReturnL)
		
+
	sec						;Decrease loop by one
	sbc #1
	sta (Sound.RAMBlockL),y
	and #$7F					;If low 7 bits aren't 0
	bne +						;Go to +
	sta (Sound.RAMBlockL),y				;Store 0 into Counter, and free self from loop
	txa						;If they are, skip this instruction
	clc
	adc #3
	sta Standard.NMI.ZTempVar1
	ldx #0
	jmp (Sound.ReturnL)
+
	txa
	tay
	iny
	lda (Standard.NMI.TempAdd0L),y
	tax
	dey
	lda (Standard.NMI.TempAdd0L),y

	ldy #0
	sty Standard.NMI.ZTempVar1
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0L
	txa
	iny
	sta (Sound.RAMBlockL),y
	sta Standard.NMI.TempAdd0H

	ldx #0
	jmp (Sound.ReturnL)
Sound.Song.PlayLiteral:
	lda (Standard.NMI.TempAdd0L),y
	sta Standard.NMI.ZTempVar2				;Note
	iny
	lda (Standard.NMI.TempAdd0L),y
	sta Standard.NMI.ZTempVar3				;Time
	iny
	sty Standard.NMI.ZTempVar1

	ldx #$FE
	jmp (Sound.ReturnL)


Sound.Song.Sq1SetTicksLess:
	lda (Standard.NMI.TempAdd0L),y
	sta Sound.Song.Square1.TicksLess
	inc Standard.NMI.ZTempVar1
	ldx #0
	jmp (Sound.ReturnL)

Sound.Song.Sq2SetTicksLess:
	lda (Standard.NMI.TempAdd0L),y
	sta Sound.Song.Square2.TicksLess
	inc Standard.NMI.ZTempVar1
	ldx #0
	jmp (Sound.ReturnL)

Sound.SFX.RequestNew:
;Function: Given a sound effect in A, the routine will decide if it should allow that sound effect to take place.
	pha
	lda Sound.SFX.SoundEffect
	beq +
	cmp #1
	beq +
	cmp #3
	beq +
	pla
	rts
+
	pla
	sta Sound.SFX.SoundEffect
	rts