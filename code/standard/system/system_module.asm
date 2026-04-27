;All of the following are members of the "Standard" class.
;Macro names follow the following format:
;Standard.CodeArea.Category.SubCategory.Subcategory2... .RegistersDestroyed.I or R
;RegistersDestroyed are listed in order of A X Y. If A and Y are destroyed, it will say AY. If X and A, it will say AX, etc.
;I stands for Immediate, R stands for Routine. I is used to save 12 cycles from a JSR/RTS, R reuses the routine at the cost
;of 12 cycles for JSR/RTS.
;Constant names may not have a code area defined.

;***********************************************
.MACRO Standard.NMI.Save.AXY()
	sta Standard.NMI.AHolder
	stx Standard.NMI.XHolder
	sty Standard.NMI.YHolder
.ENDM

.MACRO Standard.NMI.Restore.AXY()
	lda Standard.NMI.AHolder
	ldx Standard.NMI.XHolder
	ldy Standard.NMI.YHolder
.ENDM
;***********************************************
.MACRO Standard.Clear.RAM.All()
;Clears all of 2k RAM

	ldx #0
	lda #0
-
	sta $0,x
	sta $100,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	dex
	bne -
.ENDM

.MACRO Standard.Clear.RAM() ARGS Start, Length
;Clears up to 256 bytes of RAM given a starting position
	ldx #Length
	lda #$00
-
	sta Start,x
	dex
	bne -
.ENDM
;*********************************************
.MACRO Standard.Main.Read.Controller()
	lda Standard.Hardware.ControlCurrent				;3
	sta Standard.Hardware.ControlPrevious				;6

	ldx #1												;8
	stx $4016.w											;12
	dex													;14
	stx $4016.w											;18

	ldy #8												;20
-
	lda $4016											;4
	lsr a												;6
	rol Standard.Hardware.ControlCurrent				;11
	dey													;13
	bne -												;16 * 8 - 1 = 127
														;147
	lda Standard.Hardware.ControlCurrent				;150
	and Standard.Hardware.ControlPrevious				;153
	eor Standard.Hardware.ControlCurrent				;156
	sta Standard.Hardware.ControlTrigger				;159 Gives us a 1 for each button that is NEWLY pressed.
														;And wasn't pressed last frame.
.ENDM

.MACRO Standard.RetrieveReciprocal.X()
	lda Standard.Main.QuickDivide.LowBytes.w,x
	ldy Standard.Main.QuickDivide.HighBytes.w,x

.ENDM

.MACRO Standard.RetrieveReciprocal.Y()
	lda Standard.Main.QuickDivide.LowBytes.w,y
	ldx Standard.Main.QuickDivide.HighBytes.w,y
.ENDM
;*******************************************
.MACRO Standard.Main.Byte.Cap() ARGS Byte, Cap
;Function: Given an address of a RAM variable and a Cap value, this macro makes sure that the value of that variable
;never exceeds the value of "Cap".

	php
	lda #Cap
	cmp Byte.w
	bcs Standard.Main.Byte.Cap.p\@
	sta Byte
Standard.Main.Byte.Cap.p\@:
	plp
.ENDM

.MACRO Standard.Main.Byte.CapNegative() ARGS Byte, Cap
;Function: Given an address of a RAM variable and a Cap value, this macro makes sure that the value of that variable
;never is LESS than the value of "Cap".

	php
	lda #Cap
	cmp Byte
	bcc Standard.Main.Byte.CapNegative.p\@
	sta Byte
Standard.Main.Byte.CapNegative.p\@:
	plp
.ENDM