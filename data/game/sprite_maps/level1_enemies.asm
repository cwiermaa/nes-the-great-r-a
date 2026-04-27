;Sprite format:
;.db NumberOfHardwareSprites, WidthOfMetaSpriteInPixels
;.db RelativeY, RelativeX, Tile, Attribute
;etc.
;8x16 sprites are used

Game.SpriteMaps.GreatRA:
Game.SpriteMaps.GreatRA.0:
	.db 8,8
	.db $01,$00,$A0,$00
	.db $01,$08,$A1,$00
	.db $09,$00,$B0,$00
	.db $09,$08,$B1,$00
	.db $11,$00,$C0,$00
	.db $11,$08,$C1,$00
	.db $19,$00,$D0,$00
	.db $19,$08,$D1,$00

Game.SpriteMaps.GreatRA.1:
	.db 8,8
	.db $01,$00,$A0,$00
	.db $01,$08,$A1,$00
	.db $09,$00,$B0,$00
	.db $09,$08,$B1,$00
	.db $11,$00,$C0,$00
	.db $11,$08,$C1,$00
	.db $19,$00,$D2,$00
	.db $19,$08,$D3,$00

Game.SpriteMaps.GreatRA.2:
	.db 8,8
	.db $01,$00,$A0,$00
	.db $01,$08,$A1,$00
	.db $09,$00,$B0,$00
	.db $09,$08,$B1,$00
	.db $11,$00,$C0,$00
	.db $11,$08,$C1,$00
	.db $19,$00,$D4,$00
	.db $19,$08,$D5,$00

Game.SpriteMaps.GreatRA.3:
	.db 6,8
	.db $09,$00,$A0,$00
	.db $09,$08,$A1,$00
	.db $11,$00,$B0,$00
	.db $11,$08,$B1,$00
	.db $19,$00,$D0,$00
	.db $19,$08,$D1,$00


Game.SpriteMaps.GreatRA.4:
	.db 4,8
	.db $11,$00,$78,$00
	.db $11,$08,$79,$00
	.db $19,$00,$88,$00
	.db $19,$08,$89,$00

Game.SpriteMaps.Item1:
	.db 4,8
	.db $02,$00,$7E,$00
	.db $02,$08,$7F,$00
	.db $0A,$00,$8E,$00
	.db $0A,$08,$8F,$00

Game.SpriteMaps.Literal:
	.db 4
	.db $60,$1D,$00,$60
	.db $60,$1C,$00,$68
	.db $60,$1C,$00,$70
	.db $60,$1D,$00,$78

Game.SpriteMaps.PauseLogo:
	.db 5
	.db $78,$1D,$00,$6C
	.db $78,$0E,$00,$74
	.db $78,$22,$00,$7C
	.db $78,$20,$00,$84
	.db $78,$12,$00,$8C
	
Game.SpriteMaps.LavaBall.1:
	.db 4, 8
	.db $00,$00,$01,$01
	.db $00,$08,$01,$41
	.db $08,$00,$02,$01
	.db $08,$08,$02,$41

Game.SpriteMaps.LavaBall.2:
	.db 4, 8
	.db $00,$00,$02,$81
	.db $00,$08,$02,$C1
	.db $08,$00,$01,$81
	.db $08,$08,$01,$C1
	
Game.SpriteMaps.FireBelcher.1:
	.db 3, 8
	.db $00,$00,$19,$00
	.db $08,$04,$1A,$00
	.db $08,$0C,$1B,$00

Game.SpriteMaps.FireBelcher.2:
	.db 3, 8
	.db $00,$00,$19,$00
	.db $08,$04,$1C,$00
	.db $08,$0C,$1D,$00
	
Game.SpriteMaps.FireBelcher.3:
	.db 3, 8
	.db $00,$00,$18,$00
	.db $08,$04,$1C,$00
	.db $08,$0C,$1D,$00
	
Game.SpriteMaps.BouncingBall.1:
	.db 4, 8
	.db $00,$00,$0B,$01
	.db $00,$08,$0B,$41
	.db $08,$00,$0B,$81
	.db $08,$08,$0B,$C1
	
	
Game.SpriteMaps.BouncingBall.2:
	.db 4, 8
	.db $00,$00,$0A,$01
	.db $00,$08,$0A,$41
	.db $08,$00,$0A,$81
	.db $08,$08,$0A,$C1
	
Game.SpriteMaps.FireTremor.1:
	.db 4, 8
	.db $00,$00,$0F,$21
	.db $08,$00,$10,$21
	.db $00,$08,$0F,$61
	.db $08,$08,$10,$61

Game.SpriteMaps.FireTremor.2:
	.db 4, 8
	.db $00,$02,$0F,$21
	.db $08,$00,$10,$21
	.db $00,$06,$0F,$61
	.db $08,$08,$10,$61
	
Game.SpriteMaps.FireBird.1:
	.db 4, 8
	.db $00,$08,$11,$41
	.db $00,$00,$12,$41
	.db $08,$08,$15,$41
	.db $08,$00,$16,$41
	
Game.SpriteMaps.FireBird.2:	
	.db 4, 8
	.db $00,$08,$13,$41
	.db $00,$00,$14,$41
	.db $08,$08,$15,$41
	.db $08,$00,$16,$41
	
Game.SpriteMaps.Geyser.1:
	.db 2, 8
	.db $08,$00,$0D,$01
	.db $08,$08,$0D,$41

Game.SpriteMaps.Bott.1:
	.db 7, 8
	.db $00,$00,$25,$00
	.db $00,$08,$26,$00
	.db $08,$00,$2D,$00
	.db $08,$08,$27,$00
	.db $10,$04,$28,$00
	.db $10,$0C,$29,$00
	.db $18,$06,$2A,$00
	
Game.SpriteMaps.Bott.2:
	.db 8, 8
	.db $00,$00,$25,$00
	.db $00,$08,$26,$00
	.db $08,$00,$2E,$00
	.db $08,$08,$27,$00
	.db $10,$04,$28,$00
	.db $10,$0C,$29,$00
	.db $18,$03,$2B,$00
	.db $18,$0B,$2C,$00

Game.SpriteMaps.MarsRexBlue.1:
	.db 7, 8
	.db $00,$00,$25,$02
	.db $00,$08,$26,$02
	.db $08,$00,$2D,$02
	.db $08,$08,$27,$02
	.db $10,$04,$28,$02
	.db $10,$0C,$29,$02
	.db $18,$06,$2A,$02
	
Game.SpriteMaps.MarsRexBlue.2:
	.db 8, 8
	.db $00,$00,$25,$02
	.db $00,$08,$26,$02
	.db $08,$00,$2E,$02
	.db $08,$08,$27,$02
	.db $10,$04,$28,$02
	.db $10,$0C,$29,$02
	.db $18,$03,$2B,$02
	.db $18,$0B,$2C,$02

Game.SpriteMaps.Pterodactyl.1:
	.db 2, 8
	.db $00,$00,$03,$00
	.db $00,$08,$04,$00
	
Game.SpriteMaps.Pterodactyl.2:
	.db 2, 8
	.db $00,$00,$03,$00
	.db $01,$08,$04,$80

Game.SpriteMaps.Lavasaur.Egg:
	.db 4, 8
	.db $10,$00,$07,$01
	.db $10,$08,$07,$41
	.db $18,$00,$08,$01
	.db $18,$08,$08,$41

Game.SpriteMaps.Bott.Explosion.1:
	.db 4, 8
	.db $00,$00,$1E,$01
	.db $00,$08,$1E,$41
	.db $08,$00,$1E,$81
	.db $08,$08,$1E,$C1
	
Game.SpriteMaps.Bott.Explosion.2:
	.db 4, 8
	.db $00,$00,$1F,$01
	.db $00,$08,$1F,$41
	.db $08,$00,$1F,$81
	.db $08,$08,$1F,$C1
	
Game.SpriteMaps.Platform.3Long:
	.db 3, 12
	.db $00,$00,$09,$00
	.db $00,$08,$09,$00
	.db $00,$10,$09,$00
	
Game.SpriteMaps.Empty:
	.db 1,8
	.db $00,$00,$00,$00