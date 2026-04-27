Game.AI.Nothing:
	jmp Game.Main.HandleAI.Return

	.include "martian_snapper.asm"
	.include "fire_belcher.asm"
	.include "bouncing_ball.asm"
	.include "fire_tremor.asm"
	.include "fire_bird.asm"
	.include "rock_shooter.asm"
	.include "fire_bott.asm"
	.include "pterodactyl.asm"
	.include "lava_blob.asm"
	.include "platform_3long.asm"
	.include "item.asm"
	
Game.AI.Enemy1:
	jmp Game.Main.HandleAI.Return

Game.AI.Enemy2:
	jmp Game.Main.HandleAI.Return

