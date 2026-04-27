Sound.Songs.VolumeEnvelopesL:
	.db <Sound.Songs.Level1.VE0
	.db <Sound.Songs.Level1.VE1
	.db <Sound.Songs.Level1.VE2
	.db <Sound.Songs.Level1.VE3


Sound.Songs.VolumeEnvelopesH:
	.db >Sound.Songs.Level1.VE0
	.db >Sound.Songs.Level1.VE1
	.db >Sound.Songs.Level1.VE2
	.db >Sound.Songs.Level1.VE3

Sound.Songs.Level1.VE0:
	.db  9
	.db $0A,$0A,$0A,$0A,$09,$09,$0A,$0A,$0A,$08,$07,$08,$0A,$0C,$10

Sound.Songs.Level1.VE1:
	.incbin "volume_envelopes.sav" SKIP $400 READ $20
	
Sound.Songs.Level1.VE2:
	.db 5
	.db $06,$06,$06,$06,$06,$06,$06,$10
	
Sound.Songs.Level1.VE3:
	.db  9
	.db $08,$08,$08,$08,$07,$07,$08,$08,$08,$06,$06,$07,$08,$09,$10