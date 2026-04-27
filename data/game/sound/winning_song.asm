Sound.Songs.Winning.Square1:
--
	.db Music.SetTempo, $C0				;The tempo must be set here.
	.db Music.SetDutyCycle, $C0
-
	.db Music.DottedWhole.Silence
	.db Music.DottedQuarter.11
	.db Music.Sixteenth.8
	.db Music.Sixteenth.8
	.db Music.Eighth.8
	.db Music.DottedQuarter.Silence
	.db Music.SetDutyCycle, $80
	.db Music.Down1Octave
	.db Music.DottedEighth.8
-
	.db Music.DottedWhole.Silence
	.db Music.SetPC
	.dw -


Sound.Songs.Winning.Square2:
--
-
	.db Music.DottedWhole.Silence
	.db Music.SetDutyCycle, $C0
	.db Music.DottedQuarter.8
	.db Music.Sixteenth.4
	.db Music.Sixteenth.4
	.db Music.SetDutyCycle, $80
	.db Music.Sixteenth.4
	.db Music.Sixteenth.Silence
	.db Music.Down1Octave
	.db Music.Eighth.11
	.db Music.Up1Octave
	.db Music.DottedEighth.6
	.db Music.Down1Octave
	.db Music.Sixteenth.11
	.db Music.Up1Octave
	.db Music.DottedEighth.8
-
	.db Music.DottedWhole.Silence
	.db Music.SetPC
	.dw -

Sound.Songs.Winning.Triangle:
--
	.db Music.SetTriangleTicks
	.db 4
-
	.db Music.DottedWhole.Silence
	.db Music.Eighth.4
	.db Music.Quarter.4
	.db Music.Sixteenth.4
	.db Music.Sixteenth.4
	.db Music.Eighth.4
	.db Music.Eighth.4
	.db Music.DottedEighth.4
	.db Music.Sixteenth.4
	.db Music.Quarter.4
-
	.db Music.DottedWhole.Silence
	.db Music.SetPC
	.dw -
	
	
Sound.Songs.Winning.Noise:
-
	.db Music.DottedWhole.0
	.db Music.SetPC
	.dw -