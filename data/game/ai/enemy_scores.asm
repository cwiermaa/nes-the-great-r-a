Game.AI.EnemyScores:
;Given an object ID * 2 as an index, one can find the low/high
;values for a score to give the player when said object is killed.
;Stored as high, low

	.db $00,$00		;Nothing
	.db $00,$00		;Lava Ball
	.db $00,$64		;Fire Belcher
	.db $00,$64		;Bouncing Ball
	.db $00,$64		;Fire Tremor
	.db $00,$64		;Fire Bird
	.db $00,$64		;Rock Shooter
	.db $00,$64		;Fire Bott
	.db $00,$C8		;Mars Rex Blue
	.db $00,$32		;Pterodactyl
	.db $01,$F4		;Lavasaur
	.db $00,$00		;Exploding
	.db $00,$00		;Platform 3 Long
	
Game.AI.DamageTable:
;Given an object ID as an index, one can find the amount of damage
;The player should receive if the enemy is touched.
	.db 0		;Nothing
	.db 10		;Lava Ball
	.db 5		;Fire Belcher
	.db 0		;Bouncing Ball
	.db 5		;Fire Tremor
	.db 5		;Fire Bird
	.db 5		;Rock Shooter
	.db 5		;Fire Bott
	.db 8		;Mars Rex Blue
	.db 3		;Pterodactyl
	.db 5		;Lavasaur
	.db 0		;Exploding
	.db 0		;Platform 3 Long

Game.AI.EnemyHealth:
	.db 0				;Nothing
	.db 5				;Martian Snapper
	.db 5				;Fire Belcher
	.db 1				;Bouncing Ball 
	.db 5				;Fire Tremor
	.db 5				;Fire Bird
	.db 5				;Rock Shooter
	.db 5				;Fire Bott
	.db 8				;Mars Rex Blue
	.db 2				;Pterodactyl
	.db 20				;Lavasaur
	.db 0				;Exploding
	.db 1				;Platform 3 Long