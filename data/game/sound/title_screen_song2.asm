Sound.Songs.TitleScreen.Square1:
--
	.db Music.SetTempo, $A0				;The tempo must be set here.
-
	.db Music.Quarter.Silence
	.db Music.SetReferenceNote
	.db Music.O2 + Music.G
	
	.db Music.Quarter.7
	.db Music.Quarter.6
	.db Music.Quarter.3
	.db Music.Whole.2
	.db Music.Quarter.Silence
	.db Music.Quarter.7
	.db Music.Quarter.6
	.db Music.Quarter.3
	.db Music.DottedEighth.2
	.db Music.Sixteenth.6
	.db Music.Half.2
	.db Music.Triplet.2
	.db Music.Triplet.1
	.db Music.Triplet.2
	.db Music.DottedHalf.1
	.db Music.Triplet.1
	.db Music.Triplet.0
	.db Music.Triplet.1
	.db Music.Whole.0
	.db Music.Whole.Silence
	.db Music.Whole.Silence
	.db Music.Whole.Silence
	.db Music.Whole.Silence
	.db Music.SetReferenceNote
	.db Music.O3 + Music.Db
	.db Music.SetDutyCycle, $00
	.db Music.SetVolumeEnvelope, $03
-
	.db Music.DottedQuarter.10
	.db Music.Sixteenth.7
	.db Music.Sixteenth.7
	.db Music.Quarter.7
	.db Music.Quarter.10
	.db Music.DottedQuarter.9
	.db Music.Sixteenth.6
	.db Music.Sixteenth.6
	.db Music.Quarter.6
	.db Music.Quarter.9
	.db Music.Loop1
	.dw -
	.db 1
	.db Music.Triplet.8
	.db Music.Triplet.4
	.db Music.Triplet.8
	.db Music.Whole.7
	.db Music.Triplet.8
	.db Music.Triplet.9
	.db Music.Triplet.10
	.db Music.Whole.11
-
	.db Music.Quarter.Silence
	.db Music.SetPC
	.dw -


Sound.Songs.TitleScreen.Square2:
--
-
	.db Music.SetReferenceNote
	.db Music.O1 + Music.E
	.db Music.Whole.Silence
	.db Music.Quarter.Silence
	.db Music.DottedHalf.2
	.db Music.Whole.Silence
	.db Music.Whole.2
	.db Music.Whole.1
	.db Music.Whole.0
	.db Music.Whole.Silence
	.db Music.Whole.Silence
	.db Music.SetReferenceNote
	.db Music.O2 + Music.Db
	.db Music.SetVolumeEnvelope, $02
	.db Music.SetDutyCycle
	.db $80
----
---
	.db Music.32nd.2
	.db Music.32nd.3
	.db Music.32nd.4
	.db Music.32nd.5
	.db Music.Loop1
	.dw ---
	.db 1
---
	.db Music.32nd.3
	.db Music.32nd.4
	.db Music.32nd.5
	.db Music.32nd.6
	.db Music.Loop1
	.dw ---
	.db 1
	.db Music.Loop2
	.dw ----
	.db 1
	.db Music.SetDutyCycle, $00
	.db Music.Loop3
	.dw ----
	.db 1
	
	.db Music.SetVolumeEnvelope, $03
	.db Music.SetReferenceNote
	.db Music.O3 + Music.Db
-
	.db Music.DottedQuarter.4
	.db Music.Sixteenth.1
	.db Music.Sixteenth.1
	.db Music.Quarter.1
	.db Music.Quarter.4
	.db Music.DottedQuarter.3
	.db Music.Sixteenth.0
	.db Music.Sixteenth.0
	.db Music.Quarter.0
	.db Music.Quarter.3
	.db Music.Loop1
	.dw -
	.db 1
	.db Music.SetReferenceNote
	.db Music.O2 + Music.D
	.db Music.Triplet.10
	.db Music.Triplet.6
	.db Music.Triplet.10
	.db Music.Whole.9
	.db Music.Triplet.10
	.db Music.Triplet.11
	.db Music.Triplet.12
	.db Music.Whole.13
-
	.db Music.Quarter.Silence
	.db Music.SetPC
	.dw -

Sound.Songs.TitleScreen.Triangle:
--
	.db Music.SetTriangleTicks
	.db 255
	.db Music.SetReferenceNote
	.db Music.O2 + Music.E
-
	.db Music.Whole.3
	.db Music.Whole.2
	.db Music.Loop1
	.dw -
	.db 1
	
	.db Music.Whole.1
	.db Music.Whole.0
	.db Music.SetReferenceNote
	.db Music.O1 + Music.E
	.db Music.SetTriangleTicks
	.db 4
	
-
	.db Music.Eighth.0
	.db Music.Eighth.12
	.db Music.Eighth.0
	.db Music.Eighth.12
	.db Music.Eighth.0
	.db Music.Eighth.12
	.db Music.Eighth.12
	.db Music.Eighth.12
	
	.db Music.SetPC
	.dw -

Sound.Songs.TitleScreen.Noise:
-
	.db Music.DottedWhole.0
	.db Music.SetPC
	.dw -