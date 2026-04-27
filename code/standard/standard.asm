.incdir "code/standard/system"
.include "system_code.asm"
.incdir "code/standard/sound"
.include "sound.asm"

Standard.ClearNameTables:
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	ldx #8
	ldy #0
-
	sta $2007
	iny
	bne -
	dex
	bne -
	rts

Standard.InitSound:
	lda #$00
	ldx #$70
	tay
-
	sta $500.w,y
	iny
	dex
	bne -

	sta $4003
	sta $4007

	Standard.CopyPointer() Sound.Song.HandleMusicReturn0, Sound.Song.Square1.UniqueAddL
	Standard.CopyPointer() Sound.Song.HandleMusicReturn1, Sound.Song.Square2.UniqueAddL
	Standard.CopyPointer() Sound.Song.HandleMusicReturn2, Sound.Song.Triangle.UniqueAddL
	Standard.CopyPointer() Sound.Song.HandleMusicReturn4, Sound.Song.Noise.UniqueAddL

	Standard.CopyPointer() Sound.Songs.Level1.VE0, Sound.Song.Square1.VolumeEnvelopeL
	Standard.CopyPointer() Sound.Songs.Level1.VE0, Sound.Song.Square2.VolumeEnvelopeL


	lda #$FF
	sta Sound.$4003Old
	sta Sound.$4007Old
	sta Sound.SFX.$4003Old
	sta Sound.SFX.$4007Old
	sta Sound.Song.Square1.CurrentNote
	sta Sound.Song.Square2.CurrentNote
	sta Sound.Song.Triangle.CurrentNote

	lda #$40
	sta Sound.Song.Square1.DutyCycle
	sta Sound.Song.Square2.DutyCycle

	lda #Music.C + Music.O3
	sta Sound.Song.Square1.ReferenceNote
	sta Sound.Song.Square2.ReferenceNote
	sta Sound.Song.Triangle.ReferenceNote

	lda #1
	sta Sound.Song.Square1.TicksLess
	sta Sound.Song.Square2.TicksLess


	lda #$01
	sta Sound.Song.Triangle.ConstantLength
	lda #4
	sta Sound.Song.Triangle.TicksLengthDifference

	lda #$30
	sta Sound.$4004
	sta Sound.$4000
	sta Sound.SFX.$4004
	sta Sound.SFX.$4000

	lda #$08
	sta Sound.$4005
	sta Sound.$4001
	sta Sound.SFX.$4005
	sta Sound.SFX.$4001
	lda #$FF
	sta Sound.$4008
	sta Sound.SFX.$4008

	lda #$A0
	sta Sound.Song.Tempo
	rts
	
Standard.LoadCHR:
;Parameters: X (0 = $8000-$9FFF, 1 = $A000-$BFFF)
	cpx #1
	beq +
	lda #$00
	sta Standard.Main.TempAdd2L
	lda #$80
	sta Standard.Main.TempAdd2H
	jmp ++
+
	lda #$00
	sta Standard.Main.TempAdd2L
	lda #$A0
	sta Standard.Main.TempAdd2H
++
	lda #$00
	sta $2006
	sta $2006
	
	ldx #32
	ldy #0
-
	lda (Standard.Main.TempAdd2L),y
	sta $2007
	iny
	bne -
	inc Standard.Main.TempAdd2H
	dex
	bne -
	
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	rts

Standard.Bankswitch.Table:
  .db $00, $01, $02, $03, $04, $05, $06
  .db $07, $08, $09, $0A, $0B, $0C, $0D, $0E
	
Standard.Bankswitch:
;Expected: X = Bank to switch to
	lda Standard.Bankswitch.Table.w,x
	sta Standard.Bankswitch.Table.w,x
	rts
	
Standard.LoadCHRFromBank:
;Expected: Current Bank in A, Destination Bank in Y, (0 for $8000, 1 for $A000) in X
	pha
	txa
	pha
	tya
	tax
	jsr Standard.Bankswitch
	pla
	tax
	jsr Standard.LoadCHR
	pla
	tax
	jsr Standard.Bankswitch
	rts