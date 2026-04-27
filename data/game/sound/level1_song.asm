Sound.Songs.Level1.Square1:

	.db Music.SetTempo, $E8				;The tempo must be set here.
--
-
	.db Music.SetReferenceNote, Music.G + Music.O2		;Reference note = C, Octave 3
	.db Music.Whole.Silence
	.db Music.Whole.Silence
	.db Music.Eighth.Silence
	.db Music.Sixteenth.9	;E
	.db Music.Sixteenth.9	;E
	.db Music.Eighth.9	;E
	.db Music.Eighth.8	;Eb
	.db Music.Eighth.7  ;D
	.db Music.Half.6	;Db

	.db Music.DottedHalf.Silence
	.db Music.Eighth.Silence

	.db Music.Up1Octave		;Reference note = C, Octave 3
	.db Music.Sixteenth.7	;D
	.db Music.Sixteenth.8	;Eb
	.db Music.Eighth.9	;E
	.db Music.Eighth.4	;B
	.db Music.Eighth.0	;G
-
	.db Music.32nd.6
	.db Music.32nd.Silence
	.db Music.Loop1
	.dw -
	.db 7

	.db Music.Down1Octave
	.db Music.Whole.Silence

-
	.db Music.Eighth.Silence
	.db Music.Sixteenth.9	;E
	.db Music.Sixteenth.9	;E
	.db Music.Eighth.9	;E
	.db Music.Eighth.8	;Eb
	.db Music.Eighth.7  ;D
	.db Music.Eighth.6	;Db
	.db Music.Eighth.7
	.db Music.Eighth.8
	.db Music.Quarter.9
	.db Music.Quarter.8
	.db Music.Quarter.7
	.db Music.Quarter.6
	.db Music.Loop1
	.dw -
	.db 1

	.db Music.Eighth.6
-
	.db Music.32nd.5
	.db Music.32nd.6
	.db Music.Loop1
	.dw -
	.db 7

	.db Music.DottedWhole.Silence

	.db Music.Sixteenth.6
	.db Music.Sixteenth.6
	.db Music.Eighth.6
	.db Music.Eighth.5
	.db Music.Eighth.4
	.db Music.Quarter.3
	.db Music.Sixteenth.3
	.db Music.Sixteenth.2
	.db Music.Half.3

	.db Music.Half.Silence

	.db Music.SetReferenceNote, Music.F + Music.O3
-
	.db Music.Sixteenth.5
	.db Music.Sixteenth.1
	.db Music.Sixteenth.2
	.db Music.Sixteenth.1
	.db Music.Sixteenth.0
	.db Music.Sixteenth.1
	.db Music.Sixteenth.6
	.db Music.Sixteenth.1
	.db Music.Sixteenth.5
	.db Music.Sixteenth.1
	.db Music.Sixteenth.2
	.db Music.Sixteenth.1
	.db Music.Sixteenth.0
	.db Music.Sixteenth.1
	.db Music.Sixteenth.2
	.db Music.Sixteenth.1
	.db Music.Loop1
	.dw -
	.db 1
	

	.db Music.SetReferenceNote, Music.G + Music.O2

	.db Music.Eighth.Silence
	.db Music.Sixteenth.6
	.db Music.Sixteenth.6
	.db Music.Eighth.6
	.db Music.Eighth.1
	.db Music.Eighth.0
	.db Music.Half.3

	.db Music.Eighth.Silence
	.db Music.Triplet.6
	.db Music.Triplet.7
	.db Music.Triplet.8
	.db Music.Quarter.9

	.db Music.SetReferenceNote, Music.E + Music.O4
	.db Music.Sixteenth.7
	.db Music.Sixteenth.8
	.db Music.Eighth.9
	.db Music.Eighth.6
	.db Music.Eighth.3
	.db Music.Eighth.0
	.db Music.Down1Octave

-
	.db Music.32nd.9
	.db Music.32nd.Silence
	.db Music.Loop1
	.dw -
	.db 13

	.db Music.SetPC
	.dw --

Sound.Songs.Level1.Square2:

	.db Music.SetDutyCycle, $80				;Duty Cycle = 1
--
-
	.db Music.SetReferenceNote, Music.G + Music.O2
	.db Music.Whole.Silence
	.db Music.Whole.Silence
	.db Music.Eighth.Silence
	.db Music.Sixteenth.12	;G
	.db Music.Sixteenth.12	;G
	.db Music.Eighth.12	;G
	.db Music.Eighth.11	;Gb
	.db Music.Eighth.10  ;F
	.db Music.Half.9	;E
	.db Music.Whole.Silence
	.db Music.DottedQuarter.Silence
-
	.db Music.32nd.Silence
	.db Music.32nd.10
	.db Music.Loop1
	.dw -
	.db 7

	.db Music.Whole.Silence

-
	.db Music.Eighth.Silence
	.db Music.Sixteenth.12	;G
	.db Music.Sixteenth.12	;G
	.db Music.Eighth.12	;G
	.db Music.Eighth.11	;Gb
	.db Music.Eighth.10  ;F
	.db Music.Eighth.9	;E
	.db Music.Eighth.10
	.db Music.Eighth.11
	.db Music.Quarter.12
	.db Music.Quarter.11
	.db Music.Quarter.10
	.db Music.Quarter.9
	.db Music.Loop1
	.dw -
	.db 1

	.db Music.DottedHalf.9

	.db Music.Whole.Silence
	.db Music.DottedQuarter.Silence

	.db Music.Sixteenth.9
	.db Music.Sixteenth.9
	.db Music.Eighth.9
	.db Music.Eighth.8
	.db Music.Eighth.7
	.db Music.DottedHalf.6

	.db Music.Half.Silence
	.db Music.Eighth.Silence
-
	.db Music.Sixteenth.4
	.db Music.Sixteenth.3
	.db Music.Sixteenth.4
	.db Music.Sixteenth.5
	.db Music.Loop1
	.dw -
	.db 7

	.db Music.Eighth.Silence
	.db Music.Sixteenth.9
	.db Music.Sixteenth.9
	.db Music.Eighth.9
	.db Music.Eighth.3
	.db Music.Eighth.4
	.db Music.Half.12
	.db Music.Eighth.Silence
	.db Music.Up1Octave
	.db Music.Triplet.0
	.db Music.Triplet.1
	.db Music.Triplet.2
	.db Music.Quarter.3

	.db Music.SetReferenceNote, Music.Bb + Music.O4
	.db Music.Sixteenth.9
	.db Music.Sixteenth.10
	.db Music.Eighth.11
	.db Music.Eighth.7
	.db Music.Eighth.3
	.db Music.Eighth.0
	.db Music.Down1Octave

-
	.db Music.32nd.Silence
	.db Music.32nd.9
	.db Music.Loop1
	.dw -
	.db 13

	.db Music.SetPC
	.dw --

Sound.Songs.Level1.Triangle:
	.db Music.SetReferenceNote, Music.Ab + Music.O1		;Reference note = C, Octave 3
	.db Music.SetTriangleRelativeTicks, 5

--
-
	.db Music.Eighth.11	;G
	.db Music.Eighth.12	;Ab
	.db Music.Eighth.11	;G
	.db Music.Eighth.13	;A
	.db Music.Loop1
	.dw -
	.db 11

-
	.db Music.Eighth.11	;G
	.db Music.Eighth.12	;Ab
	.db Music.Eighth.11	;G
	.db Music.Eighth.13	;A
	.db Music.Loop1
	.dw -
	.db 1

	.db Music.Quarter.11
	.db Music.Quarter.10
	.db Music.Quarter.9
	.db Music.Quarter.8
	.db Music.Loop2
	.dw -
	.db 1

-
	.db Music.Eighth.8
	.db Music.Eighth.3
	.db Music.Loop1
	.dw -
	.db 28

	.db Music.Up1Octave
	.db Music.Triplet.3
	.db Music.Triplet.2
	.db Music.Triplet.1
	.db Music.Quarter.0
	.db Music.Down1Octave

-
	.db Music.Eighth.11	;G
	.db Music.Eighth.12	;Ab
	.db Music.Eighth.11	;G
	.db Music.Eighth.13	;A
	.db Music.Loop1
	.dw -
	.db 2
	.db Music.SetPC
	.dw --

Sound.Songs.Level1.Noise:

-
	.db Music.DottedWhole.0
	.db Music.SetPC
	.dw -
