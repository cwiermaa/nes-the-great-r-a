Sound.Songs.TitleScreen.Square1:
--
	.db Music.SetTempo, $C0				;The tempo must be set here.
-
	.db Music.DottedQuarter.11
	.db Music.Sixteenth.8
	.db Music.Sixteenth.8
	.db Music.Quarter.8
	.db Music.Quarter.11
	.db Music.DottedQuarter.10
	.db Music.Sixteenth.7
	.db Music.Sixteenth.7
	.db Music.Quarter.7
	.db Music.Quarter.10
	.db Music.Loop1
	.dw -
	.db 1

-	
	.db Music.DottedQuarter.9
	.db Music.Sixteenth.6
	.db Music.Sixteenth.6
	.db Music.Quarter.6
	.db Music.Quarter.9
	.db Music.DottedQuarter.8
	.db Music.Sixteenth.5
	.db Music.Sixteenth.5
	.db Music.Quarter.5
	.db Music.Quarter.8
	.db Music.Loop1
	.dw -
	.db 1
-
	.db Music.DottedQuarter.9
	.db Music.Sixteenth.6
	.db Music.Sixteenth.6
	.db Music.Quarter.6
	.db Music.Quarter.9
	
	.db Music.DottedQuarter.10
	.db Music.Sixteenth.7
	.db Music.Sixteenth.7
	.db Music.Quarter.7
	.db Music.Quarter.10

	.db Music.DottedQuarter.11
	.db Music.Sixteenth.8
	.db Music.Sixteenth.8
	.db Music.Quarter.8
	.db Music.Quarter.11


	.db Music.SetTempo, $A0				;The tempo must be set here.

	.db Music.Quarter.12
	.db Music.Triplet.9
	.db Music.Triplet.9
	.db Music.Triplet.9
	.db Music.Quarter.9
	.db Music.Quarter.12

	.db Music.SetPC
	.dw --


Sound.Songs.TitleScreen.Square2:
--
-
	.db Music.DottedQuarter.8
	.db Music.Sixteenth.4
	.db Music.Sixteenth.4
	.db Music.Quarter.4
	.db Music.Quarter.8
	.db Music.DottedQuarter.7
	.db Music.Sixteenth.4
	.db Music.Sixteenth.4
	.db Music.Quarter.4
	.db Music.Quarter.7
	.db Music.Loop1
	.dw -
	.db 1
-
	.db Music.DottedQuarter.6
	.db Music.Sixteenth.2
	.db Music.Sixteenth.2
	.db Music.Quarter.2
	.db Music.Quarter.6
	.db Music.DottedQuarter.5
	.db Music.Sixteenth.2
	.db Music.Sixteenth.2
	.db Music.Quarter.2
	.db Music.Quarter.5
	.db Music.Loop1
	.dw -
	.db 1

	.db Music.DottedQuarter.2
	.db Music.Sixteenth.2
	.db Music.Sixteenth.2
	.db Music.Quarter.2
	.db Music.Quarter.2
	
	.db Music.DottedQuarter.3
	.db Music.Sixteenth.3
	.db Music.Sixteenth.3
	.db Music.Quarter.3
	.db Music.Quarter.3

	.db Music.DottedQuarter.4
	.db Music.Sixteenth.4
	.db Music.Sixteenth.4
	.db Music.Quarter.4
	.db Music.Quarter.4

	.db Music.Quarter.5
	.db Music.Triplet.5
	.db Music.Triplet.5
	.db Music.Triplet.5
	.db Music.Quarter.5
	.db Music.Quarter.5

	.db Music.SetPC
	.dw --

Sound.Songs.TitleScreen.Triangle:
--
	.db Music.SetTriangleTicks
	.db 4
-
	.db Music.Eighth.4
	.db Music.Quarter.4
	.db Music.Sixteenth.4
	.db Music.Sixteenth.4
	.db Music.Eighth.4
	.db Music.Eighth.4
	.db Music.Eighth.4
	.db Music.Eighth.4
	.db Music.Loop1
	.dw -
	.db 3
-
	.db Music.Eighth.2
	.db Music.Quarter.2
	.db Music.Sixteenth.2
	.db Music.Sixteenth.2
	.db Music.Eighth.2
	.db Music.Eighth.2
	.db Music.Eighth.2
	.db Music.Eighth.2
	.db Music.Loop1
	.dw -
	.db 6

	.db Music.SetTriangleTicks
	.db 6

	.db Music.Quarter.2
	.db Music.Triplet.2
	.db Music.Triplet.2
	.db Music.Triplet.2
	.db Music.Quarter.2
	.db Music.Quarter.2

	.db Music.SetPC
	.dw --

Sound.Songs.TitleScreen.Noise:
-
	.db Music.DottedWhole.0
	.db Music.SetPC
	.dw -