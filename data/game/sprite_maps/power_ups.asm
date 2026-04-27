;Power-Ups sprite maps and BG maps

Game.SpriteMaps.PowerUps.BG.0:
	.db $38,$36,$78
Game.SpriteMaps.PowerUps.BG.1:
	.db $39,$37,$79
Game.SpriteMaps.PowerUps.BG.2:
	.db $48,$46,$88
Game.SpriteMaps.PowerUps.BG.3:
	.db $49,$47,$89
	
Game.SpriteMaps.PowerUpsL:
	.db <Game.SpriteMaps.PowerUps.Running
	.db <Game.SpriteMaps.PowerUps.ShotGun
	.db <Game.SpriteMaps.PowerUps.Running
	.db <Game.SpriteMaps.PowerUps.Running
	
Game.SpriteMaps.PowerUpsH:
	.db >Game.SpriteMaps.PowerUps.Running
	.db >Game.SpriteMaps.PowerUps.ShotGun
	.db >Game.SpriteMaps.PowerUps.Running
	.db >Game.SpriteMaps.PowerUps.Running
	
Game.SpriteMaps.PowerUps.Running:
	.db 1
	.db $13,$FA,$00,$7C
	
Game.SpriteMaps.PowerUps.ShotGun:
	.db 1
	.db $13,$EF,$01,$7C