

.MACRO Game.PPUUpdates.Updates.Lock()
	lda #<Game.NMI.SkipUpdate
	sta Game.PPUUpdates.UpdateAddL

.ENDM

.MACRO Game.PPUUpdates.Updates.Unlock()
	lda #<Game.NMI.PPUUpdates
	sta Game.PPUUpdates.UpdateAddL
.ENDM