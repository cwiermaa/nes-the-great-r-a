;For each enemy, each is allowed up to 8 animations.
;The standard animation coordinator is given an animation ID,
;And in each enemy's RAM is their object ID. Using the animation ID
;for the given enemy, the correct table is located (1, 2, 3, 4, etc.)
;Then the object ID is used as an index for that table to get the address
;of the specified animation.

Game.Animations.1L:
	.db $00, <Game.Animations.Enemies.LavaBall.Biting
	.db <Game.Animations.Enemies.FireBelcher.Walking
	.db <Game.Animations.Enemies.BouncingBall.Still
	.db <Game.Animations.Enemies.FireTremor.Clamped
	.db <Game.Animations.Enemies.FireBird.Flapping
	.db <Game.Animations.Enemies.Geyser.Standing
	.db <Game.Animations.Enemies.Bott.Walking
	.db <Game.Animations.Enemies.MarsRexBlue.Walking
	.db <Game.Animations.Enemies.Pterodactyl.Flying
	.db <Game.Animations.Enemies.MarsRexBlue.Walking
	.db <Game.Animations.Enemies.Bott.Exploding
	.db <Game.Animations.Platforms.3Long
	.db <Game.Animations.Nothing	;Item
	.db <Game.Animations.Enemies.Bott.Exploding
	
Game.Animations.1H:
	.db $00, >Game.Animations.Enemies.LavaBall.Biting
	.db >Game.Animations.Enemies.FireBelcher.Walking
	.db >Game.Animations.Enemies.BouncingBall.Still
	.db >Game.Animations.Enemies.FireTremor.Clamped
	.db >Game.Animations.Enemies.FireBird.Flapping
	.db >Game.Animations.Enemies.Geyser.Standing
	.db >Game.Animations.Enemies.Bott.Walking
	.db >Game.Animations.Enemies.MarsRexBlue.Walking
	.db >Game.Animations.Enemies.Pterodactyl.Flying
	.db >Game.Animations.Enemies.MarsRexBlue.Walking
	.db >Game.Animations.Enemies.Bott.Exploding
	.db >Game.Animations.Platforms.3Long
	.db >Game.Animations.Nothing		;Item
	.db >Game.Animations.Enemies.Bott.Exploding
	
Game.Animations.2L:
	.db $00, <Game.Animations.Enemies.LavaBall.Waiting
	.db <Game.Animations.Enemies.FireBelcher.Belching
	.db <Game.Animations.Enemies.BouncingBall.Bouncing
	.db <Game.Animations.Enemies.FireTremor.Biting
	.db $00
	.db $00
	.db <Game.Animations.Enemies.Bott.Exploding
	.db $00,$00
	.db <Game.Animations.Enemies.Lavasaur.Egg
	
Game.Animations.2H:
	.db $00, >Game.Animations.Enemies.LavaBall.Waiting
	.db >Game.Animations.Enemies.FireBelcher.Belching
	.db >Game.Animations.Enemies.BouncingBall.Bouncing
	.db >Game.Animations.Enemies.FireTremor.Biting
	.db $00
	.db $00
	.db >Game.Animations.Enemies.Bott.Exploding
	.db $00,$00
	.db >Game.Animations.Enemies.Lavasaur.Egg

Game.Animations.3L:
Game.Animations.3H:

Game.Animations.4L:
Game.Animations.4H:

Game.Animations.5L:
Game.Animations.5H:

Game.Animations.6L:
Game.Animations.6H:

Game.Animations.7L:
Game.Animations.7H:

Game.Animations.8L:
Game.Animations.8H: