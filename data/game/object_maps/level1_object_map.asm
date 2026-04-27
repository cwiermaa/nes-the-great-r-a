.DEFINE Nothing 0
.DEFINE LavaBall 1
.DEFINE FireBelcher 2
.DEFINE BouncingBall 3
.DEFINE FireTremor 4
.DEFINE FireBird 5
.DEFINE Geyser 6
.DEFINE FireBott 7
.DEFINE MarsRexBlue 8
.DEFINE Pterodactyl 9
.DEFINE LavaBlob 10
.DEFINE Platform3Long 12
.DEFINE Item 13

Game.Data.Level1.ObjectMap.ScreenPointers:
	.db 0
	.db 9
	.db 12
	.db 21
	.db 26
	.db 31
	.db 36
	.db 39
	.db 42
	.db 43
	.db 44
	.db 45
	.db 46
	.db 47
	.db 48
	.db 49
	.db 50
	.db 51
	.db 52
	.db 53
	.db 54
	.db 55

Game.Data.Level1.ObjectMap:

;Screen0
	.db 4
	.db $43,Item
	.db $88,FireBelcher
	.db $A8,Geyser
	.db $E8,Geyser

;Screen1
	.db 1
	.db $02,BouncingBall
	
;Screen2
	.db 4
	.db $47,FireBott
	.db $73,Pterodactyl
	.db $C3, FireBird
	.db $D8, Platform3Long
;Screen3
	.db 2
	.db $93,FireBelcher
	.db $A3,Item

;Screen4
	.db 2
	.db $A1,FireTremor
	.db $D7,FireBelcher
;Screen5
	.db 2
	.db $27,FireBott
	.db $E3,FireBott
;Screen6
	.db 1
	.db $44,FireBott

;Screen7
	.db 1
	.db $E3,FireBird
;Screen8
	.db 0
	
;Screen9
	.db 0
;Screen10
	.db 0
;Screen11
	.db 0
;Screen11
	.db 0
;Screen11
	.db 0
;Screen11
	.db 0
;Screen11
	.db 0
;Screen11
	.db 0
;Screen11
	.db 0
;Screen11
	.db 0
;Screen11
	.db 0
;Screen11
	.db 0
	
	
Game.Data.Level2.ObjectMap.ScreenPointers:
	.db 0
	.db 1

Game.Data.Level2.ObjectMap:
;Screen 1
	.db 0
	
;Screen 2
	.db 1
	.db $84,LavaBlob
;	.db $43,$05
;	.db $82,$04
;	.db $95,$03
;	.db $C7,$02
;	.db $DA,$06