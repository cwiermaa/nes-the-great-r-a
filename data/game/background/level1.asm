Game.Data.Level1.Palette:
	.db $05,$08,$27,$30
	.db $05,$3F,$18,$28
	.db $05,$18,$17,$27
	.db $05,$03,$13,$33
	.db $05,$3F,$29,$30
	.db $05,$08,$17,$38
	.db $05,$3F,$12,$32
	.db $05,$3F,$18,$28

Game.Data.Level1Part2.Palette:
	.db $04,$08,$27,$30
	.db $04,$3F,$18,$28
	.db $04,$02,$12,$32
	.db $04,$03,$13,$33
	.db $04,$3F,$29,$30
	.db $04,$08,$17,$38
	.db $04,$3F,$16,$38
	.db $04,$04,$14,$34
	
Game.Data.Level1Part2.GlowPalette:
	.db $17,$27,$28,$28,$28,$28,$27,$17
	
Game.Data.Level1.ItemMap:
	.db 0,21
	.db 10,14
	
Game.LevelData.Level1.GlowPalette:
	.db $18,$17,$27 ; 0
	.db $17,$27,$27 ; 1
	.db $27,$28,$26 ; 2
	.db $27,$28,$26 ; 2
	.db $27,$28,$26 ; 2
	.db $27,$28,$26 ; 2
	.db $17,$27,$27 ; 1
	.db $18,$17,$27 ; 0

Game.Data.Level1Part2:
	.dw Game.Data.Level1Part2.C0
	.dw Game.Data.Level1Part2.C1
	.dw Game.Data.Level1Part2.C2
	.dw Game.Data.Level1Part2.C3
	.dw Game.Data.Level1Part2.C4
	.dw Game.Data.Level1Part2.C5
	.dw Game.Data.Level1Part2.C6
	.dw Game.Data.Level1Part2.C7
	.dw Game.Data.Level1Part2.C8
	.dw Game.Data.Level1Part2.C9
	.dw Game.Data.Level1Part2.CA
	.dw Game.Data.Level1Part2.CB
	.dw Game.Data.Level1Part2.CC

Game.Data.Level1:
	.dw Game.Data.Level1.C0
	.dw Game.Data.Level1.C1
	.dw Game.Data.Level1.C2
	.dw Game.Data.Level1.C3
	.dw Game.Data.Level1.C4
	.dw Game.Data.Level1.C5
	.dw Game.Data.Level1.C6
	.dw Game.Data.Level1.C7
	.dw Game.Data.Level1.C8
	.dw Game.Data.Level1.C9
	.dw Game.Data.Level1.CA
	.dw Game.Data.Level1.CB
	.dw Game.Data.Level1.CC


.DEFINE Game.Data.Level1.Width $41
.DEFINE Game.Data.Level1Part2.Width 15

Game.Data.Level1.C0:
	.incbin "level1.SAV" READ Game.Data.Level1.Width
Game.Data.Level1.C1:
	.incbin "level1.SAV" SKIP $100 READ Game.Data.Level1.Width
Game.Data.Level1.C2:
	.incbin "level1.SAV" SKIP $200 READ Game.Data.Level1.Width
Game.Data.Level1.C3:
	.incbin "level1.SAV" SKIP $300 READ Game.Data.Level1.Width
Game.Data.Level1.C4:
	.incbin "level1.SAV" SKIP $400 READ Game.Data.Level1.Width
Game.Data.Level1.C5:
	.incbin "level1.SAV" SKIP $500 READ Game.Data.Level1.Width
Game.Data.Level1.C6:
	.incbin "level1.SAV" SKIP $600 READ Game.Data.Level1.Width
Game.Data.Level1.C7:
	.incbin "level1.SAV" SKIP $700 READ Game.Data.Level1.Width
Game.Data.Level1.C8:
	.incbin "level1.SAV" SKIP $800 READ Game.Data.Level1.Width
Game.Data.Level1.C9:
	.incbin "level1.SAV" SKIP $900 READ Game.Data.Level1.Width
Game.Data.Level1.CA:
	.incbin "level1.SAV" SKIP $A00 READ Game.Data.Level1.Width
Game.Data.Level1.CB:
	.incbin "level1.SAV" SKIP $B00 READ Game.Data.Level1.Width
Game.Data.Level1.CC:
	.incbin "level1.SAV" SKIP $C00 READ Game.Data.Level1.Width
	
Game.Data.Level1Part2.C0:
	.incbin "level1_part2.SAV" READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.C1:
	.incbin "level1_part2.SAV" SKIP $100 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.C2:
	.incbin "level1_part2.SAV" SKIP $200 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.C3:
	.incbin "level1_part2.SAV" SKIP $300 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.C4:
	.incbin "level1_part2.SAV" SKIP $400 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.C5:
	.incbin "level1_part2.SAV" SKIP $500 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.C6:
	.incbin "level1_part2.SAV" SKIP $600 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.C7:
	.incbin "level1_part2.SAV" SKIP $700 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.C8:
	.incbin "level1_part2.SAV" SKIP $800 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.C9:
	.incbin "level1_part2.SAV" SKIP $900 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.CA:
	.incbin "level1_part2.SAV" SKIP $A00 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.CB:
	.incbin "level1_part2.SAV" SKIP $B00 READ Game.Data.Level1Part2.Width
Game.Data.Level1Part2.CC:
	.incbin "level1_part2.SAV" SKIP $C00 READ Game.Data.Level1Part2.Width