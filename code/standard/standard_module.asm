.incdir "code/standard/system"
.include "system_module.asm"
.incdir "code/standard/sound"
.include "sound_module.asm"


;MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Initialize
.MACRO Standard.Initialize()
;Performs necessary startup functions on reset.
	cld
	sei
	ldx #$FF
	txs
	
	lda #$00
	sta $2000
	sta $2001
	sta Standard.$2001
	
	lda $2002											;Wait for the next Vblank to load palette.
-
	lda $2002
	bpl -
-
	lda $2002
	bpl -

	Standard.SetNMI() Game.NMI.EmptyHandler
	
	ldx #1
	jsr Standard.Bankswitch
	ldx #1
	jsr Standard.LoadCHR
	ldx #6
	stx Standard.CurrentBank.w
	jsr Standard.Bankswitch
	lda $2002
	lda #$80
	sta Standard.$2000
	sta $2000

.ENDM

;MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM CopyPointer
.MACRO Standard.CopyPointer() ARGS Pointer, TempAddL
;Given a pointer and the address of a 16-bit variable,
;the address of the given pointer is copied to the
;16-bit variable.

	lda #<\1
	sta \2
	lda #>\1
	sta \2 +1
.ENDM

;MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM SetMain
.MACRO Standard.SetMain() ARGS MainLoopPointer
;Given the address of another mode's main loop, the main
;loop is assigned that new address.

	Standard.CopyPointer() \1, Standard.MainL
.ENDM

;MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM SetNMI
.MACRO Standard.SetNMI() ARGS NMILoopPointer
;Given the address of another mode's NMI routine, the
;NMI routine is assigned that new address.

	Standard.CopyPointer() \1, Standard.NMIL
.ENDM