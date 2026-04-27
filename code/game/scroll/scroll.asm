Game.Scroll.ScrollLeft:
;Function: Scrolls left <= 255 pixels
;Expected: Scroll amount with whole pixel value in Y, and precision in X

	lda Standard.Main.ZTempVar1				;3
	pha										;6

	stx Standard.Main.ZTempVar1				;9
	sec										;11
	lda Game.Scroll.ScrollXPrecision		;14
	sbc Standard.Main.ZTempVar1				;17
	sta Game.Scroll.ScrollXPrecision		;20
	sty Standard.Main.ZTempVar1				;23
	lda Game.Scroll.ScrollXL				;26
	sbc Standard.Main.ZTempVar1				;29
	sta Game.Scroll.ScrollXL				;32
	lda Game.Scroll.ScrollXH				;35
	sbc #0									;37
	and #1									;39
	sta Game.Scroll.ScrollXH 				;42

	pla										;46
	sta Standard.Main.ZTempVar1				;49
	rts

Game.Scroll.ScrollRight:
;Function: Scrolls right <= 255 pixels
;Expected: Scroll amount with whole pixel value in Y, and precision in X

	lda Standard.Main.ZTempVar1				;3
	pha										;6

	stx Standard.Main.ZTempVar1				;9
	clc										;11
	lda Game.Scroll.ScrollXPrecision		;14
	adc Standard.Main.ZTempVar1				;17
	sta Game.Scroll.ScrollXPrecision		;20
	sty Standard.Main.ZTempVar1				;23
	lda Game.Scroll.ScrollXL				;26
	adc Standard.Main.ZTempVar1				;29
	sta Game.Scroll.ScrollXL				;32
	lda Game.Scroll.ScrollXH				;35
	adc #0									;37
	and #1									;39
	sta Game.Scroll.ScrollXH 				;42

	pla										;46
	sta Standard.Main.ZTempVar1				;49
	rts

Game.Scroll.PPUCalculate:
;Function: Calculates PPU tile and attribute address for scrolling horizontally
;Expected: 16-bit X coordinate, Low in X, High in A
	asl a									;2
	asl a									;4
	ora #$20								;6
	sta Game.PPUUpdates.TilePPUH			;9
	ora #$03								;11
	sta Game.PPUUpdates.AttributePPUH		;14

	txa										;16
	lsr a									;18
	lsr a									;20
	lsr a									;22
	sta Game.PPUUpdates.TilePPUL			;25
	lsr a									;27
	lsr a									;29
	ora #$C0								;31
	sta Game.PPUUpdates.AttributePPUL		;34
	rts
