TitleScreen.Mode0.TheGreatRA:
	.db $21, $15, $12, $00, $14, $1F, $12, $0E, $21, $00, $1F, $0B, $0E, $0B
	
TitleScreen.Mode0.Palette:
	.db $3F, $03, $13, $33
	.db $3F, $00, $10, $30
	.db $3F, $0B, $29, $30
	.db $3F, $06, $16, $26
	
	.db $3F, $00, $10, $30
	.db $3F, $10, $10, $30
	.db $3F, $30, $10, $30
	.db $3F, $3F, $10, $30
	
TitleScreen.Mode1.PaletteColor1:
	.db $02,$03,$04,$03
TitleScreen.Mode1.PaletteColor2:
	.db $12,$13,$13,$13
TitleScreen.Mode1.PaletteColor3:
	.db $32,$33,$34,$33
	
TitleScreen.Mode2.PaletteLow:
	.db $05,$09,$0D,$01
	.db $05,$09,$0D,$01
	.db $05,$09,$0D,$01
	
TitleScreen.Mode2.PaletteColor1:
	.db $3F,$3F,$3F,$02
	.db $3F,$3F,$3F,$3F
	.db $3F,$3F,$3F,$3F
	
TitleScreen.Mode2.PaletteColor2:
	.db $00,$19,$06,$12
	.db $3F,$09,$3F,$02
	.db $3F,$3F,$3F,$3F
	
TitleScreen.Mode2.PaletteColor3:
	.db $10,$29,$16,$32
	.db $00,$09,$06,$02
	.db $3F,$3F,$3F,$3F
	

TitleScreen.Mode3.PaletteLow:
	.db $15
	.db $05,$05,$05
	.db $09,$09,$09
	.db $01,$01,$01
	
TitleScreen.Mode3.PaletteColor1:
	.db $06
	.db $3F,$3F,$06
	.db $3F,$3F,$07
	.db $3F,$3F,$02
	
TitleScreen.Mode3.PaletteColor2:
	.db $3F
	.db $3F,$06,$36
	.db $3F,$07,$17
	.db $3F,$02,$12
	
TitleScreen.Mode3.PaletteColor3:
	.db $3F
	.db $06,$16,$30
	.db $07,$17,$27
	.db $02,$12,$32
	
TitleScreen.Mode3.PaletteLow2:
	.db $01,$09,$05
	.db $01,$09,$05
	.db $01,$09,$05
	.db $15
	
TitleScreen.Mode3.PaletteColor12:
	.db $02,$07,$06
	.db $3F,$3F,$3F
	.db $3F,$3F,$3F
	.db $3F
	
TitleScreen.Mode3.PaletteColor22:
	.db $12,$17,$36
	.db $02,$07,$06
	.db $3F,$3F,$3F
	.db $3F
	
TitleScreen.Mode3.PaletteColor32:
	.db $12,$17,$16
	.db $02,$07,$06
	.db $3F,$3F,$3F
	.db $3F
	
.DEFINE RABlockNTStart $20EE
.DEFINE SunBlockNTStart $2174
.DEFINE PlanetBlockNTStart $21A6
.DEFINE PlanetBlock2NTStart $21BE

TitleScreen.Mode0.RABlock:
;Format: number of rows, starting tile.
;for each row, .dw Start NT address, number of tile in run

	.db 11,$01
	.dw RABlockNTStart,
	.db 4
	.dw RABlockNTStart + $20
	.db 4
	.dw RABlockNTStart + $40
	.db 4
	.dw RABlockNTStart + $60
	.db 4
	.dw RABlockNTStart + $7F
	.db 6
	.dw RABlockNTStart + $9D
	.db 10
	.dw RABlockNTStart + $BD
	.db 10
	.dw RABlockNTStart + $DD
	.db 10
	.dw RABlockNTStart + $FD
	.db 10
	.dw RABlockNTStart + $11D
	.db 10
	.dw RABlockNTStart + $13D
	.db 10
	
TitleScreen.Mode3.SunBlock:
	.db 4,$A0
	.dw SunBlockNTStart,
	.db 4
	.dw SunBlockNTStart + $20
	.db 4
	.dw SunBlockNTStart + $40
	.db 4
	.dw SunBlockNTStart + $60
	.db 4
	
	
TitleScreen.Mode3.PlanetBlock:
	.db 4,$B0
	.dw PlanetBlockNTStart,
	.db 4
	.dw PlanetBlockNTStart + $20
	.db 4
	.dw PlanetBlockNTStart + $40
	.db 4
	.dw PlanetBlockNTStart + $60
	.db 4
	
TitleScreen.Mode3.PlanetBlock2:
	.db 2,$C0
	.dw PlanetBlock2NTStart
	.db 2
	.dw PlanetBlock2NTStart + $20
	.db 2
	
	
TitleScreen.Mode0.MarsBlock:
	.db 2,$60
	.db $60,$23
	.db 32
	.db $80,$23
	.db 32
	
.DEFINE EyesLocationX $70
.DEFINE EyesLocationY $50

TitleScreen.Mode3.Eyes:
	.db EyesLocationY,$C4,$21,EyesLocationX
	.db EyesLocationY,$C5,$21,EyesLocationX+8
	.db EyesLocationY+8,$C6,$21,EyesLocationX
	.db EyesLocationY+8,$C7,$21,EyesLocationX+8
	
	.db EyesLocationY,$C5,$61,EyesLocationX+32
	.db EyesLocationY,$C4,$61,EyesLocationX+40
	.db EyesLocationY+8,$C7,$61,EyesLocationX+32
	.db EyesLocationY+8,$C6,$61,EyesLocationX+40
	
TitleScreen.Mode0.Attributes:
;Format: Number of writes total
;for each byte, Attribute Low, Value
	.db 34
	.db $CB,$A0
	.db $CC,$A0
	
	.db $D2,$AA
	.db $D3,$AA
	.db $D4,$AA
	.db $D5,$AA
	
	.db $DA,$55
	.db $DB,$55
	.db $DC,$55
	.db $DD,$51
	
	.db $E2,$05
	.db $E3,$05
	.db $E4,$05
	.db $E5,$05
	
	.db $EA,$AA
	.db $EB,$AA
	.db $EC,$AA
	.db $ED,$AA
	
	
	.db $F0,$FF
	.db $F1,$FF
	.db $F2,$FF
	.db $F3,$FF
	
	.db $F4,$FF
	.db $F5,$FF
	.db $F6,$FF
	.db $F7,$FF
	
	.db $F8,$FF
	.db $F9,$FF
	.db $FA,$FF
	.db $FB,$FF
	
	.db $FC,$FF
	.db $FD,$FF
	.db $FE,$FF
	.db $FF,$FF
	
TitleScreen.Mode3.Text:
	.db 28
	.db $23,$28,16
	.db $F1,$E5,$E2,$D0			;THE
	.db $F6,$E2,$DE,$EF,$D0		;YEAR
	.db $E6,$F0,$D0				;IS
	.db $D3,$D3,$D9,$D1			;2280
	.db $23,$40,12
	.db $D0,$D0,$D0,$D0
	.db $D0,$D0,$D0,$D0
	.db $D0,$D0,$D0,$D0
	
TitleScreen.Mode3.Text2:
	.db 80
	.db $23,$24,24
	.db $F1,$E5,$E2,$D0						;THE
	.db $EB,$DE,$F1,$E6,$EC,$EB,$F0,$D0		;NATIONS
	.db $EC,$E3,$D0							;OF
	.db $F1,$E5,$E2,$D0						;THE
	.db $F0,$EC,$E9,$DE,$EF					;SOLAR
	.db $23,$42,28
	.db $F0,$F6,$F0,$F1,$E2,$EA,$D0			;SYSTEM
	.db $E9,$E6,$F3,$E2,$D0					;LIVE
	.db $E6,$EB,$D0							;IN
	.db $F1,$E5,$E2,$D0						;THE
	.db $F0,$E5,$DE,$E1,$EC,$F4,$D0			;SHADOW
	.db $EC,$E3								;OF
	.db $23,$62,28
	.db $E4,$EF,$DE,$EB,$E1,$D0				;GRAND
	.db $EA,$DE,$F0,$F1,$E2,$EF,$D0			;MASTER
	.db $E0,$E5,$E6,$E8,$E6,$EB,$D0			;CHIKIN
	.db $E9,$F6,$EB,$DF,$EC,$F2,$E4,$E5		;LYNBOUGH

TitleScreen.Mode0.Stars:
;Format: Number of writes total
;For each byte: NT Address, value
	.db 13
	.db $22,$25,$53
	.db $21,$3A,$54
	.db $20,$E9,$54
	.db $20,$43,$53
	.db $21,$26,$55
	.db $21,$B7,$55
	.db $21,$5C,$53
	.db $20,$7C,$55
	.db $20,$F5,$53
	.db $22,$39,$53
	.db $20,$51,$55
	.db $21,$C1,$54
	.db $22,$7F,$55
	
TitleScreen.Mode3.Stars:
;Format: Number of writes total
;For each byte: NT Address, value
	.db 13
	.db $26,$25,$53
	.db $25,$3A,$54
	.db $24,$E9,$54
	.db $24,$43,$53
	.db $25,$26,$55
	.db $25,$B7,$55
	.db $25,$5C,$53
	.db $24,$7C,$55
	.db $24,$F5,$53
	.db $26,$39,$53
	.db $24,$51,$55
	.db $25,$C1,$54
	.db $26,$7F,$55

TitleScreen.Mode0.PressStart:
	.db 10
	.db $22,$AA,$56
	.db $22,$AB,$57
	.db $22,$AC,$58
	.db $22,$AD,$59
	.db $22,$AE,$59
	
	.db $22,$B1,$59
	.db $22,$B2,$5A
	.db $22,$B3,$5B
	.db $22,$B4,$57
	.db $22,$B5,$5A