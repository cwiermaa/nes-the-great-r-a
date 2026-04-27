.incdir "data/game/background"
.include "level1.asm"
.include "tile_defs.asm"
.incdir "data/game/object_maps"
.include "object_maps.asm"
.incdir "data/game/sprite_maps"
.include "sprite_maps.asm"
.incdir "data/game/levels"
.include "levels.asm"
.incdir "data/game/ai"
.include "ai.asm"
.incdir "data/game/spontaneous_objects"
.include "spontaneous.asm"
.incdir ""

StatusBar.Health:
	.db $15,$12,$0E,$19,$21,$15

StatusBar.Power:
	.db $02,$01,$01

StatusBar.Lives:
	.db $19,$16,$23,$12,$20

StatusBar.LifeCount:
	.db $04

StatusBar.Score:
	.db $20,$10,$1C,$1F,$12

StatusBar.ScoreCount:
	.db $01,$02,$03,$04,$05,$06,$07,$08,$09

StatusBar.Ammo:
	.db $0E,$1A,$1A,$1C
