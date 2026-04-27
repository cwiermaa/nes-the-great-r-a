;******************************************************************
;MACROS

.MACRO AI.GenerateSpontaneous() ARGS SpontaneousID, XOffset, YOffset, Direction, IncludedWidth
	
.IF \5 != 0

	lda #\5
	sta Standard.Main.ZTempVar6

	lda #\2
	ldy #\1 + \4
	ldx #\3
	jsr Game.AI.Weapon.Instantiate.IncludeWidth

.ELSE

	lda #\2
	ldy #\1 + \4
	ldx #\3
	jsr Game.AI.Weapon.Instantiate
.ENDIF

.ENDM
