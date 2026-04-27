.include "memory.asm"
.include "ram.asm"
.include "modules.asm"

.bank 0 SLOT 0
.orga $8000
.section "Data" FORCE
.include "data.asm"
.ends

.bank 6 SLOT 0
.orga $8000
.section "Cutscenes" FORCE
.incdir "code/title_screen"
.include "title_screen.asm"
.incdir "code/cutscene"
.include "cutscene.asm"
.incdir "code/ending"
.include "ending.asm"

.incdir "data/title_screen"
.include "title_screen_data.asm"

.incdir "data/game/sound"
.include "sound_data.asm"
.ends

.bank 7 SLOT 1
.orga $C000
.section "Fixed" FORCE	

	.incdir "code/game"
	.include "game.asm"
	.incdir ""
	
RESET:
	Standard.Initialize()
	Standard.SetMain() TitleScreen.Mode0

;***************************************
Standard.Main:
	jmp (Standard.MainL)

Standard.MainReturn:
	lda Standard.VBLCount
-
	cmp Standard.VBLCount
	beq -
	jmp Standard.Main

IRQ:
	rti
	
NMI:
	jmp (Standard.NMIL)
;**************************************

	.incdir "code/standard"
	.include "standard.asm"
	.incdir ""
.ends

.bank 1 SLOT 0
.section "CHR" FREE
.incdir "data/standard/graphics"
.include "graphics.asm"
.incdir ""
.ends

.bank 7 SLOT 1
.orga $FFFA
.section "vectors" FORCE
.dw NMI
.dw RESET
.dw IRQ
.ends