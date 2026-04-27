;Defines all data associated with a level at start up.
;Defines background data, object map, object map pointers, event code, player X, player Y, and song data by
;And also defines starting position of screen - $200, and the left/right bounds of the level. Also, the pixel
;from which to decode AI info and how many $10 pixel columns it is from the left side of the screen.
;Now also defines palette data, hello.

;Game.LevelAddressL, Game.LevelAddressH
;Game.ObjectMap.PointerL, Game.ObjectMap.PointerH Game.ObjectMapL, Game.ObjectMapH, ;Game.EventL, Game.EventH
;Game.LevelPalette.PointerL, Game.LevelPalette.PointerH
;Game.ItemMapL, Game.ItemMapH
;Player.XL, Player.XH, Player.Y
;Screen.XL, Screen.XH
;Screen.LeftBoundL, Screen.LeftBoundH
;Screen.RightBoundL, Screen.RightBoundH
;(AI Decode from XL), (AI Decode from XH), (Number of $10 pixel wide columns to decode until $180 pixels beyond starting ;screen position)

;Sound.Song.Square1.MusicAddL, Sound.Song.Square1.MusicAddH
;Sound.Song.Square2.MusicAddL, Sound.Song.Square2.MusicAddH
;Sound.Song.Triangle.MusicAddL, Sound.Song.Triangle.MusicAddH, 
;Sound.Song.Noise.MusicAddL, Sound.Song.Noise.MusicAddH.

;Level ID
;Note: If $FF is written for the new Sound.Song.Square1.MusicAddH, it will be seen by the level initializer as indication to ;continue playing the current song.

;Also note: Starting screen X coord MUST be a multiple of $20 to align attribute data.

;***********************************************************

Game.LevelData.Level1:
	.dw Game.Data.Level1
	.dw Game.Data.Level1.ObjectMap.ScreenPointers
	.dw Game.Data.Level1.ObjectMap
	.dw Game.Main.Level1.Event
	.dw Game.Data.Level1.Palette
	.dw Game.Data.Level1.ItemMap

	.db $50,$00,$50				;Beginning of level
;	.db $80,$04,$50				;Halfway through

	.db $00,$3E					;Beginning of level
;	.db $00,$04					;Halfway through
	.db $00,$00
	.db $40,$0F

	.db $00,$00,$29						;$00,$00,$29
	.dw Sound.Songs.Level1.Square1
	.dw Sound.Songs.Level1.Square2
	.dw Sound.Songs.Level1.Triangle
	.dw Sound.Songs.Level1.Noise
	
	.db 0			;Level ID

Game.LevelData.Level2:
	.dw Game.Data.Level1Part2
	.dw Game.Data.Level2.ObjectMap.ScreenPointers
	.dw Game.Data.Level2.ObjectMap
	.dw Game.Main.Level2.Event
	.dw Game.Data.Level1Part2.Palette
	.dw Game.Data.Level1.ItemMap
	.db $20,$00,$70

	.db $00,$3E
	.db $00,$00
	.db $80,$01

	.db $00,$00,$29
	.db $FF,$FF
	.db 1		;Level ID
Game.LevelData.Level3:
Game.LevelData.Level4:
Game.LevelData.Level5:
Game.LevelData.Level6:
Game.LevelData.Level7:
Game.LevelData.Level8: