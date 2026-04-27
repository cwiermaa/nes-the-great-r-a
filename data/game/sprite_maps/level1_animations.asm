;Format: Frame Wait, Sprite Map Low, Sprite Map H, Frame Wait, etc...., $FF, Loop Offset

Game.Animations.Player.Standing:
	.db 254, <Game.SpriteMaps.GreatRA.1, >Game.SpriteMaps.GreatRA.1
	.db $FF, 0

Game.Animations.Player.Walking:
	.db 11, <Game.SpriteMaps.GreatRA.0, >Game.SpriteMaps.GreatRA.0
	.db 11, <Game.SpriteMaps.GreatRA.1, >Game.SpriteMaps.GreatRA.1
	.db 11, <Game.SpriteMaps.GreatRA.2, >Game.SpriteMaps.GreatRA.2
	.db 11, <Game.SpriteMaps.GreatRA.1, >Game.SpriteMaps.GreatRA.1
	.db $FF, 0
	
Game.Animations.Player.Running:
	.db 11, <Game.SpriteMaps.GreatRA.0, >Game.SpriteMaps.GreatRA.0
	.db 8, <Game.SpriteMaps.GreatRA.1, >Game.SpriteMaps.GreatRA.1
	.db 8, <Game.SpriteMaps.GreatRA.2, >Game.SpriteMaps.GreatRA.2
	.db 8, <Game.SpriteMaps.GreatRA.1, >Game.SpriteMaps.GreatRA.1
	.db $FF, 0

Game.Animations.Player.Swimming:
	.db 13, <Game.SpriteMaps.GreatRA.1, >Game.SpriteMaps.GreatRA.1
	.db 13, <Game.SpriteMaps.GreatRA.2, >Game.SpriteMaps.GreatRA.2
	.db $FF, 0

Game.Animations.Player.Crouching:
	.db 3, <Game.SpriteMaps.GreatRA.3, >Game.SpriteMaps.GreatRA.3
	.db 254, <Game.SpriteMaps.GreatRA.4, >Game.SpriteMaps.GreatRA.4
	.db $FF, 3
	
Game.Animations.Player.Jumping:
	.db 3, <Game.SpriteMaps.GreatRA.0, >Game.SpriteMaps.GreatRA.0
	.db 254, <Game.SpriteMaps.GreatRA.2, >Game.SpriteMaps.GreatRA.2
	.db $FF, 3
	
Game.Animations.Enemies.LavaBall.Biting:
	.db 254, <Game.SpriteMaps.LavaBall.1, >Game.SpriteMaps.LavaBall.1
	.db $FF, 0
	
Game.Animations.Enemies.LavaBall.Waiting:
	.db 254, <Game.SpriteMaps.LavaBall.2, >Game.SpriteMaps.LavaBall.2
	.db $FF, 0
	
Game.Animations.Enemies.FireBelcher.Walking:
	.db 15, <Game.SpriteMaps.FireBelcher.1, >Game.SpriteMaps.FireBelcher.1
	.db 15, <Game.SpriteMaps.FireBelcher.2, >Game.SpriteMaps.FireBelcher.2
	.db $FF, 0

Game.Animations.Enemies.FireBelcher.Belching:
	.db 15, <Game.SpriteMaps.FireBelcher.3, >Game.SpriteMaps.FireBelcher.3
	.db $FF, 0
	
Game.Animations.Enemies.BouncingBall.Bouncing:
	.db 10, <Game.SpriteMaps.BouncingBall.1, >Game.SpriteMaps.BouncingBall.1
	.db 10, <Game.SpriteMaps.BouncingBall.2, >Game.SpriteMaps.BouncingBall.2
	.db $FF, 0
	
Game.Animations.Enemies.BouncingBall.Still:
	.db 254, <Game.SpriteMaps.BouncingBall.1, >Game.SpriteMaps.BouncingBall.1
	.db $FF, 0
	
Game.Animations.Enemies.FireTremor.Biting:
	.db 10, <Game.SpriteMaps.FireTremor.1, >Game.SpriteMaps.FireTremor.1
	.db 10, <Game.SpriteMaps.FireTremor.2, >Game.SpriteMaps.FireTremor.2
	.db $FF, 0

Game.Animations.Enemies.FireTremor.Clamped:
	.db 254, <Game.SpriteMaps.FireTremor.2, >Game.SpriteMaps.FireTremor.2
	.db $FF, 0
	
Game.Animations.Enemies.FireBird.Flapping:
	.db 10, <Game.SpriteMaps.FireBird.1, >Game.SpriteMaps.FireBird.1
	.db 10, <Game.SpriteMaps.FireBird.2, >Game.SpriteMaps.FireBird.2
	.db $FF, 0
	
Game.Animations.Enemies.Geyser.Standing:
	.db 254, <Game.SpriteMaps.Geyser.1, >Game.SpriteMaps.Geyser.1
	.db $FF, 0
	
Game.Animations.Enemies.Bott.Walking:
	.db 10, <Game.SpriteMaps.Bott.1, >Game.SpriteMaps.Bott.1
	.db 10, <Game.SpriteMaps.Bott.2, >Game.SpriteMaps.Bott.2
	.db $FF, 0

Game.Animations.Enemies.MarsRexBlue.Walking:
	.db 10, <Game.SpriteMaps.MarsRexBlue.1, >Game.SpriteMaps.MarsRexBlue.1
	.db 10, <Game.SpriteMaps.MarsRexBlue.2, >Game.SpriteMaps.MarsRexBlue.2
	.db $FF, 0
	
Game.Animations.Enemies.Bott.Exploding:
	.db 2, <Game.SpriteMaps.Bott.Explosion.2, >Game.SpriteMaps.Bott.Explosion.2
	.db 10, <Game.SpriteMaps.Bott.Explosion.1, >Game.SpriteMaps.Bott.Explosion.1
	.db $FF, 0
	
Game.Animations.Enemies.Pterodactyl.Flying:
	.db 10, <Game.SpriteMaps.Pterodactyl.1, >Game.SpriteMaps.Pterodactyl.1
	.db 10, <Game.SpriteMaps.Pterodactyl.2, >Game.SpriteMaps.Pterodactyl.2
	.db $FF, 0
	
Game.Animations.Enemies.Lavasaur.Egg:
	.db 254, 
	.dw Game.SpriteMaps.Lavasaur.Egg
	.db $FF, 0
	
Game.Animations.Platforms.3Long:
	.db 254
	.dw Game.SpriteMaps.Platform.3Long
	.db $FF, 0

Game.Animations.Nothing:
	.db 254
	.dw Game.SpriteMaps.Empty
	.db $FF, 0