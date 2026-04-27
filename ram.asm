; Last Updated: 2:18 AM, March 2, 2010

; Currently Used (Specifying first and last byte in use):
; $00 - $FA

; $200 - $219
; $228 - $2EA

; $300 - $3FF

; $400 - $4C0

; $500 - $598

; $600 - $6FF

; $700 - $7FF


; Currently Free (Specifying first and last byte free):
; $FC - $FF
; 4 bytes of zero-page

; $21A - $227
; $2EC - $2FF
; $14 bytes of non-zero-page

; $4C1 - $2FF
; $3F bytes of non-zero-page


; $599 - $5FF
; $67 bytes of non-zero-page


; Comments:

; Well, having gone through and seeing the complete use of RAM, I am not as dissapointed as I thought I would be.
; It's still disorganized, don't get me wrong. I did not, however, notice any RAM conflicts by having variables
; declared to use the same RAM. There are some things I'd like to comment on besides that, though.

; First, I'd just like to mention how terrible it is to have Player.XL and DummyPlayerXL to be the same variables.
; We will definitely have to change this so that the code only refers to Player.XL, and not some random test values.

; Secondly, the PPU buffers used for tile and attribute column updating aren't ever completely filled. We only update
; 26 tiles and 7 attribute chunks when scrolling, so this is wasting about 5 bytes of zero page.

; Also, the gap in zero page is unnecessary. We can easily close this up by redefining everything.

; The same type of crap happens in $21A - $227 where we though we were using it but we're not. The buffer holding the
; column of 2x2 tiles is the same size as the column of 8x2 tiles (13 bytes)

; Aside from that, I was just looking over some code that uses non-zero-page RAM for counters and indexes. This
; includes the sprite drawing code. If there are 63 sprites on screen, that at the very least means we're wasting
; 63 cycles by not having those values in zero page. Now I see some values in zero page that do not need to be there.
; For example, though Game.NMIL and Game.NMIH seem to be super high-priority, they're not. The same goes for VBLCount.

; That also reminds me: System.NMI.VBLCount and Game.VBLCount are seperately declared, the first of which is never used.
; So add $55 to the list of free variables.

; Variable Declarations
; ---------------------------------------

.DEFINE Standard.NMI.ZTempVar0 $00
.DEFINE Standard.NMI.ZTempVar1 $01
.DEFINE Standard.NMI.ZTempVar2 $02
.DEFINE Standard.NMI.ZTempVar3 $03
.DEFINE Standard.NMI.ZTempVar4 $04
.DEFINE Standard.NMI.ZTempVar5 $05
.DEFINE Standard.NMI.ZTempVar6 $06
.DEFINE Standard.NMI.ZTempVar7 $07

.DEFINE Standard.NMI.TempAdd0L $08
.DEFINE Standard.NMI.TempAdd0H $09
.DEFINE Standard.NMI.TempAdd1L $0A
.DEFINE Standard.NMI.TempAdd1H $0B
.DEFINE Standard.NMI.TempAdd2L $0C
.DEFINE Standard.NMI.TempAdd2H $0D
.DEFINE Standard.NMI.TempAdd3L $0E
.DEFINE Standard.NMI.TempAdd3H $0F

.DEFINE Standard.Main.ZTempVar0 $10
.DEFINE Standard.Main.ZTempVar1 $11
.DEFINE Standard.Main.ZTempVar2 $12
.DEFINE Standard.Main.ZTempVar3 $13
.DEFINE Standard.Main.ZTempVar4 $14
.DEFINE Standard.Main.ZTempVar5 $15
.DEFINE Standard.Main.ZTempVar6 $16
.DEFINE Standard.Main.ZTempVar7 $17

.DEFINE Standard.Main.TempAdd0L $18
.DEFINE Standard.Main.TempAdd0H $19
.DEFINE Standard.Main.TempAdd1L $1A
.DEFINE Standard.Main.TempAdd1H $1B
.DEFINE Standard.Main.TempAdd2L $1C
.DEFINE Standard.Main.TempAdd2H $1D
.DEFINE Standard.Main.TempAdd3L $1E
.DEFINE Standard.Main.TempAdd3H $1F

.DEFINE Standard.NMI.AHolder $20
.DEFINE Standard.NMI.XHolder $21
.DEFINE Standard.NMI.YHolder $22

.DEFINE Standard.Main.Math.A0 $23
.DEFINE Standard.Main.Math.A1 $24
.DEFINE Standard.Main.Math.A2 $25
.DEFINE Standard.Main.Math.A3 $26
.DEFINE Standard.Main.Math.B0 $27
.DEFINE Standard.Main.Math.B1 $28
.DEFINE Standard.Main.Math.B2 $29
.DEFINE Standard.Main.Math.B3 $2A
.DEFINE Standard.Main.Math.Answer0 $2B
.DEFINE Standard.Main.Math.Answer1 $2C
.DEFINE Standard.Main.Math.Answer2 $2D

.DEFINE Standard.Main.Math.Answer3 $2E
.DEFINE Standard.Main.Math.Answer4 $2F
.DEFINE Standard.Main.Math.Answer5 $30
.DEFINE Standard.Main.Math.Remainder0 Standard.Main.Math.Answer4
.DEFINE Standard.Main.Math.Remainder1 Standard.Main.Math.Answer5
.DEFINE Standard.Main.Math.Remainder2 $31
.DEFINE Standard.Main.Math.Remainder3 $32
.DEFINE Standard.Main.Random.Index0 $33
.DEFINE Standard.Main.Random.Index1 $34
.DEFINE Standard.Main.Random.Random0 $35
.DEFINE Standard.Main.Random.Random1 $36
.DEFINE Standard.Main.Convert.Hex0 $37
.DEFINE Standard.Main.Convert.Hex1 $38
.DEFINE Standard.Main.Convert.Hex2 $39
.DEFINE Standard.Main.Convert.Hex3 $3A
.DEFINE Standard.Main.Convert.DecOnes $3B
.DEFINE Standard.Main.Convert.DecTens $3C
.DEFINE Standard.Main.Convert.DecHundreds $3D

.DEFINE Standard.Main.Convert.DecThousands $3E
.DEFINE Standard.Main.Convert.DecTenThousands $3F
.DEFINE Standard.Main.Convert.DecHundredThousands $40
.DEFINE Standard.Main.Convert.DecMillions $41
.DEFINE Standard.Main.Convert.DecTenMillions $42

.DEFINE Standard.Hardware.ControlCurrent $43
.DEFINE Standard.Hardware.ControlPrevious $44
.DEFINE Standard.Hardware.ControlTrigger $45

.DEFINE Standard.NMIL $46
.DEFINE Standard.NMIH $47
.DEFINE Standard.MainL $48
.DEFINE Standard.MainH $49
.DEFINE Standard.VBLCount $4A

.DEFINE Game.ScreenXL $4B
.DEFINE Game.ScreenXH $4C
.DEFINE Game.Camera.ScreenXL Game.ScreenXL
.DEFINE Game.Camera.ScreenXH Game.ScreenXH

.DEFINE Game.Scroll.ScrollXPrecision $4D
.DEFINE Game.Scroll.ScrollXL $4E
.DEFINE Game.Scroll.ScrollXH $4F

.DEFINE Standard.$2000 $50
.DEFINE Standard.$2001 $51

.DEFINE Game.PPUUpdates.TilePPUL $52
.DEFINE Game.PPUUpdates.TilePPUH $53
.DEFINE Game.PPUUpdates.AttributePPUL $54
.DEFINE Game.PPUUpdates.AttributePPUH $55

.DEFINE Game.PPUUpdates.UpdateAddL $56
.DEFINE Game.PPUUpdates.UpdateAddH $57

.DEFINE Game.PPUUpdates.TileColumn $58							; - $75

.DEFINE Game.PPUUpdates.AttributeColumn $76 						;- $7D

.DEFINE Game.LevelAddressL $7E
.DEFINE Game.LevelAddressH $7F
.DEFINE Game.Main.LevelDecode.XL $80
.DEFINE Game.Main.LevelDecode.XH $81
.DEFINE Game.Main.LevelDecode.GetTileType.Z1	$82
.DEFINE Game.Main.LevelDecode.GetTileType.Z2	$83
.DEFINE Game.Main.LevelDecode.GetTileType.Z3	$84
.DEFINE Game.Main.LevelDecode.GetTileType.Z4	$85
.DEFINE Game.Main.LevelDecode.GetTileType.Z5	$86
.DEFINE Game.Main.LevelDecode.GetTileType.TL	$87
.DEFINE Game.Main.LevelDecode.GetTileType.TH	$88

.DEFINE Game.ObjectMapL $89
.DEFINE Game.ObjectMapH $8A
.DEFINE Game.ObjectMap.PointerL $8B
.DEFINE Game.ObjectMap.PointerH $8C

.DEFINE Game.AIRAM.Current $8D

.DEFINE Game.AIRAM.PointerL $8D									;Obsolete
.DEFINE Game.AIRAM.PointerH $8E									;Obsolete
.DEFINE Game.AI.VelocityXL $8F									;Obsolete
.DEFINE Game.AI.VelocityXH $90									;Obsolete
.DEFINE Game.AI.VelocityYL $91									;Obsolete
.DEFINE Game.AI.VelocityYH $92									;Obsolete
.DEFINE Game.AI.PrecisionX $93									;Obsolete
.DEFINE Game.AI.PrecisionY $94									;Obsolete
.DEFINE Game.Animation.AnimationStack.CurrentL $95				;Obsolete
.DEFINE Game.Animation.AnimationStack.CurrentH $96				;Obsolete

.DEFINE Game.CollisionBoundLL $97
.DEFINE Game.CollisionBoundLH $98
.DEFINE Game.CollisionBoundRL $99
.DEFINE Game.CollisionBoundRH $9A

.DEFINE Game.Camera.Status $9B
.DEFINE Game.EventL $9C
.DEFINE Game.EventH $9D
.DEFINE Game.Camera.LeftBoundL $9E
.DEFINE Game.Camera.LeftBoundH $9F

.DEFINE Game.Camera.RightBoundL $A0
.DEFINE Game.Camera.RightBoundH $A1

.DEFINE Game.Player.XLL $A2
.DEFINE Game.DummyPlayerXL $A3
.DEFINE Game.DummyPlayerXH $A4
.DEFINE Game.Camera.PlayerXL Game.DummyPlayerXL
.DEFINE Game.Camera.PlayerXH Game.DummyPlayerXH
.DEFINE Game.Player.XL Game.DummyPlayerXL
.DEFINE Game.Player.XH Game.DummyPlayerXH

.DEFINE Game.Player.YL $A5
.DEFINE Game.Player.YH $A6
.DEFINE Game.Player.VelocityYL $A7
.DEFINE Game.Player.VelocityYH $A8
.DEFINE Game.Player.VelocityXL $A9
.DEFINE Game.Player.VelocityXH $AA
.DEFINE Game.Player.ActionStatus $AB
.DEFINE Game.Player.PosVelocityXLCap $AC
.DEFINE Game.Player.PosVelocityXHCap $AD
.DEFINE Game.Player.NegVelocityXLCap $AE
.DEFINE Game.Player.NegVelocityXHCap $AF
.DEFINE Game.AI.CollideWithPlayerL $B0

.DEFINE Game.AI.CollideWithPlayerH $B1
.DEFINE Game.Player.TopBorder $B2
.DEFINE Game.Player.BottomBorder $B3
.DEFINE Game.Player.RightBorderL $B4
.DEFINE Game.Player.RightBorderH $B5

.DEFINE Game.Player.ScoreL $B6
.DEFINE Game.Player.ScoreM $B7
.DEFINE Game.Player.ScoreH $B8
.DEFINE Game.Player.Ammo $B9
.DEFINE Game.Player.Lives $BA
.DEFINE Game.Player.Health $BB
.DEFINE Game.Player.PowerUp $BC
.DEFINE Game.Player.Bullet0 $BD
.DEFINE Game.Player.Bullet0.XL $BD
.DEFINE Game.Player.Bullet0.XM $BE
.DEFINE Game.Player.Bullet0.XH $BF
.DEFINE Game.Player.Bullet0.YH $C0
.DEFINE Game.Player.Bullet0.YL $C1
.DEFINE Game.Player.Bullet0.ID $C2
.DEFINE Game.Player.Bullet0.Status $C3
.DEFINE Game.Player.Bullet1 $C4
.DEFINE Game.Player.Bullet1.XL $C4
.DEFINE Game.Player.Bullet1.XM $C5

.DEFINE Game.Player.Bullet1.XH $C6
.DEFINE Game.Player.Bullet1.YH $C7
.DEFINE Game.Player.Bullet1.YL $C8
.DEFINE Game.Player.Bullet1.ID $C9
.DEFINE Game.Player.Bullet1.Status $CA
.DEFINE Game.Player.Bullet2 $CB
.DEFINE Game.Player.Bullet2.XL $CB
.DEFINE Game.Player.Bullet2.XM $CC
.DEFINE Game.Player.Bullet2.XH $CD
.DEFINE Game.Player.Bullet2.YH $CE
.DEFINE Game.Player.Bullet2.YL $CF
.DEFINE Game.Player.Bullet2.ID $D0
.DEFINE Game.Player.Bullet2.Status $D1
.DEFINE Game.Player.BulletsActive $D2

.DEFINE Standard.Main.ZTempVar8 $D3
.DEFINE Standard.Main.ZTempVar9 $D4
.DEFINE Standard.Main.ZTempVarA $D5
.DEFINE Standard.Main.ZTempVarB $D6
.DEFINE Standard.Main.ZTempVarC $D7
.DEFINE Standard.Main.ZTempVarD $D8
.DEFINE Standard.Main.ZTempVarE $D9
.DEFINE Standard.Main.ZTempVarF $DA
.DEFINE Game.PersonalSettings.Difficulty $DB
.DEFINE Game.InitCounter $DC

.DEFINE Sound.RAMBlockL $DD
.DEFINE Sound.RAMBlockH $DE
.DEFINE Sound.ReturnL $DF
.DEFINE Sound.ReturnH $E0

.DEFINE Game.ValidBorderLL $E1
.DEFINE Game.ValidBorderLH $E2
.DEFINE Game.ValidBorderRL $E3
.DEFINE Game.ValidBorderRH $E4

.DEFINE Game.Player.Bullet0.DisplaceL $E5
.DEFINE Game.Player.Bullet0.DisplaceH $E6
.DEFINE Game.Player.Bullet1.DisplaceL $E7
.DEFINE Game.Player.Bullet1.DisplaceH $E8
.DEFINE Game.Player.Bullet2.DisplaceL $E9
.DEFINE Game.Player.Bullet2.DisplaceH $EA

.DEFINE Game.Player.PowerUpMessage $EF
.DEFINE Game.Player.PowerUpMessage.SpeedUp $01			;For immediate use only
.DEFINE Game.Player.PowerUpMessage.InstantiateNew $80	;For immediate use only
.DEFINE Game.Player.PowerUpMessage.InstantiateNew.Inverted $7F	;For immediate use only
.DEFINE Game.Player.PowerUpMessage.JumpUp $02
.DEFINE Standard.LoopCount $F0

.DEFINE Game.Player.Damage $F1				;Variable indicating total damage to player.
.DEFINE Game.Player.Invulnerable $F2		;Counts frames until player is no longer invulnerable (after damage)
.DEFINE Game.Player.HitOnLeft $F3			;Contains either a positive or negative value indicating what side the
											;Player was hit on.

.DEFINE Game.Player.ArmShooting $F4			;Counter determines whether or not the player's arm is shooting
.DEFINE Game.Player.ArmXL $F5
.DEFINE Game.Player.ArmXH $F6
.DEFINE Game.Player.ArmY $F7

.DEFINE Game.Player.DeathCounter $F8
.DEFINE Game.AI.XL $F9
.DEFINE Game.AI.XH $FA
.DEFINE Game.AI.YH $FB

.DEFINE Game.Player.ExternalVelocityXH $FC
.DEFINE Game.Player.ExternalVelocityYH $FD
.DEFINE Game.Player.Bullets.Directions $FE

;***************************

.DEFINE Game.Main.LevelDecode.8x2Column $200				; - $20C
.DEFINE Game.Main.LevelDecode.2x2Column $20D 				; - $219

.DEFINE Game.ObjectStates.Dead $21A						; - $229
.DEFINE Game.ObjectStates.Active $22A						; - $239
.DEFINE Game.AIRAM	$23A								; - $2EB

;Interleaved AIRAM variables
.DEFINE AIRAM.Slots 8
.DEFINE AIRAM.Variables 21

.DEFINE AIRAM.0 $23A
.DEFINE AIRAM.1 AIRAM.0 + AIRAM.Slots
.DEFINE AIRAM.2 AIRAM.1 + AIRAM.Slots
.DEFINE AIRAM.3 AIRAM.2 + AIRAM.Slots
.DEFINE AIRAM.4 AIRAM.3 + AIRAM.Slots
.DEFINE AIRAM.5 AIRAM.4 + AIRAM.Slots
.DEFINE AIRAM.6 AIRAM.5 + AIRAM.Slots
.DEFINE AIRAM.7 AIRAM.6 + AIRAM.Slots
.DEFINE AIRAM.8 AIRAM.7 + AIRAM.Slots
.DEFINE AIRAM.9 AIRAM.8 + AIRAM.Slots
.DEFINE AIRAM.10 AIRAM.9 + AIRAM.Slots
.DEFINE AIRAM.11 AIRAM.10 + AIRAM.Slots
.DEFINE AIRAM.12 AIRAM.11 + AIRAM.Slots
.DEFINE AIRAM.13 AIRAM.12 + AIRAM.Slots
.DEFINE AIRAM.14 AIRAM.13 + AIRAM.Slots
.DEFINE AIRAM.15 AIRAM.14 + AIRAM.Slots
.DEFINE AIRAM.16 AIRAM.15 + AIRAM.Slots
.DEFINE AIRAM.17 AIRAM.16 + AIRAM.Slots
.DEFINE AIRAM.18 AIRAM.17 + AIRAM.Slots
.DEFINE AIRAM.19 AIRAM.18 + AIRAM.Slots
.DEFINE AIRAM.20 AIRAM.19 + AIRAM.Slots
.DEFINE AIRAM.21 AIRAM.20 + AIRAM.Slots

.DEFINE AIRAM.ObjectID AIRAM.0
.DEFINE AIRAM.ObjectNumber AIRAM.1
.DEFINE AIRAM.YH AIRAM.2
.DEFINE AIRAM.XL AIRAM.3
.DEFINE AIRAM.XH AIRAM.4

.DEFINE Game.ObjectsActive $2EA
.DEFINE Standard.CurrentBank $2EB

;*************************

.DEFINE Game.ObjectDraw.OAMPage $300									; - $3FF
.DEFINE Game.ObjectDraw.OAMPage.Y $300
.DEFINE Game.ObjectDraw.OAMPage.Tile $301
.DEFINE Game.ObjectDraw.OAMPage.Attribute $302
.DEFINE Game.ObjectDraw.OAMPage.X $303


;*******************
.DEFINE Game.ObjectDraw.GraphicsStack $400							; - $47D
.DEFINE Game.ObjectDraw.GraphicsStack.Type $400
.DEFINE Game.ObjectDraw.GraphicsStack.MapL $401
.DEFINE Game.ObjectDraw.GraphicsStack.Tile $401
.DEFINE Game.ObjectDraw.GraphicsStack.MapH $402
.DEFINE Game.ObjectDraw.GraphicsStack.Attribute $402
.DEFINE Game.ObjectDraw.GraphicsStack.XL $403
.DEFINE Game.ObjectDraw.GraphicsStack.XH $404
.DEFINE Game.ObjectDraw.GraphicsStack.Y $405

.DEFINE Game.ObjectDraw.NumOfObjects $47E
.DEFINE Game.ObjectDraw.GraphicsStack.Index $47F
.DEFINE Game.ObjectDraw.OAMPage.Index $480
.DEFINE Game.ObjectDraw.OAMPage.SpritesLeft $481


.DEFINE Game.Animation.AnimationStack $482							; - $4B9
.DEFINE Game.Animation.AnimationStack.Player.Command $4BA
.DEFINE Game.Animation.AnimationStack.Player.FrameCounter $4BB
.DEFINE Game.Animation.AnimationStack.Player.Index $4BC
.DEFINE Game.Animation.AnimationStack.Player.AnimationL $4BD
.DEFINE Game.Animation.AnimationStack.Player.AnimationH $4BE
.DEFINE Game.Animation.AnimationStack.Player.AnimationCurrent $4BF
.DEFINE Game.Animation.AnimationStack.Player.AnimationPrevious $4C0

;*******************
.DEFINE Sound.$4000	$500
.DEFINE Sound.$4001	$501
.DEFINE Sound.$4002	$502
.DEFINE Sound.$4003	$503
.DEFINE Sound.$4004	$504
.DEFINE Sound.$4005	$505
.DEFINE Sound.$4006	$506
.DEFINE Sound.$4007	$507
.DEFINE Sound.$4008	$508
.DEFINE Sound.$4009	$509
.DEFINE Sound.$400A	$50A
.DEFINE Sound.$400B	$50B
.DEFINE Sound.$400C	$50C
.DEFINE Sound.$400D	$50D
.DEFINE Sound.$400E	$50E
.DEFINE	Sound.$400F	$50F

.DEFINE Sound.$4010	$510
.DEFINE Sound.$4011	$511
.DEFINE Sound.$4012	$512
.DEFINE Sound.$4013	$513
.DEFINE Sound.$4014	$514
.DEFINE Sound.$4015	$515
.DEFINE Sound.Song.Tempo $516
.DEFINE Sound.Song.TempoCount $517
.DEFINE Sound.Song.Square1.MusicAddL $518
.DEFINE Sound.Song.Square1.MusicAddH $519
.DEFINE Sound.Song.Square1.InternalLoop1 $51A
.DEFINE Sound.Song.Square1.InternalLoop2 $51B
.DEFINE Sound.Song.Square1.InternalLoop3 $51C
.DEFINE Sound.Song.Square1.CurrentNote $51D
.DEFINE Sound.Song.Square1.TicksRemaining $51E
.DEFINE Sound.Song.Square1.ReferenceNote $51F

.DEFINE Sound.Song.Square1.DutyCycle $520
.DEFINE Sound.Song.Square1.UniqueAddL $521
.DEFINE Sound.Song.Square1.UniqueAddH $522
.DEFINE Sound.Song.Square1.VolumeEnvelopeL $523
.DEFINE Sound.Song.Square1.VolumeEnvelopeH $524
.DEFINE Sound.Song.Square1.VolumeEnvelopeIndex $525
.DEFINE Sound.Song.Square2.MusicAddL $526
.DEFINE Sound.Song.Square2.MusicAddH $527
.DEFINE Sound.Song.Square2.InternalLoop1 $528
.DEFINE Sound.Song.Square2.InternalLoop2 $529
.DEFINE Sound.Song.Square2.InternalLoop3 $52A
.DEFINE Sound.Song.Square2.CurrentNote $52B
.DEFINE Sound.Song.Square2.TicksRemaining $52C
.DEFINE Sound.Song.Square2.ReferenceNote $52D
.DEFINE Sound.Song.Square2.DutyCycle $52E
.DEFINE Sound.Song.Square2.UniqueAddL $52F

.DEFINE Sound.Song.Square2.UniqueAddH $530
.DEFINE Sound.Song.Square2.VolumeEnvelopeL $531
.DEFINE Sound.Song.Square2.VolumeEnvelopeH $532
.DEFINE Sound.Song.Square2.VolumeEnvelopeIndex $533
.DEFINE Sound.Song.Triangle.MusicAddL $534
.DEFINE Sound.Song.Triangle.MusicAddH $535
.DEFINE Sound.Song.Triangle.InternalLoop1 $536
.DEFINE Sound.Song.Triangle.InternalLoop2 $537
.DEFINE Sound.Song.Triangle.InternalLoop3 $538
.DEFINE Sound.Song.Triangle.CurrentNote $539
.DEFINE Sound.Song.Triangle.TicksRemaining $53A
.DEFINE Sound.Song.Triangle.ReferenceNote $53B
.DEFINE Sound.Song.Triangle.Octave $53C
.DEFINE Sound.Song.Triangle.UniqueAddL $53D
.DEFINE Sound.Song.Triangle.UniqueAddH $53E
.DEFINE Sound.Song.Triangle.TicksLengthDifference $53F

.DEFINE Sound.Song.Triangle.Length $540
.DEFINE Sound.Song.Noise.MusicAddL $541
.DEFINE Sound.Song.Noise.MusicAddH $542
.DEFINE Sound.Song.Noise.InternalLoop1 $543
.DEFINE Sound.Song.Noise.InternalLoop2 $544
.DEFINE Sound.Song.Noise.InternalLoop3 $545
.DEFINE Sound.Song.Noise.CurrentNote $546
.DEFINE Sound.Song.Noise.TicksRemaining $547
.DEFINE Sound.Song.Noise.ReferenceNote $548
.DEFINE Sound.Song.Noise.12BeatSet $549
.DEFINE Sound.Song.Noise.UniqueAddL $54A
.DEFINE Sound.Song.Noise.UniqueAddH $54B
.DEFINE Sound.Song.Noise.SampleAddressL $54C
.DEFINE Sound.Song.Noise.SampleAddressH $54D
.DEFINE Sound.Song.Noise.Sample.Var1 $54E
.DEFINE Sound.Song.Noise.Sample.Var2 $54F

.DEFINE Sound.Song.Noise.Sample.Var3 $550
.DEFINE Sound.Song.Noise.Sample.Var4 $551
.DEFINE Sound.Song.Noise.Sample.Var5 $552
.DEFINE Sound.Song.Noise.Sample.Var6 $553
.DEFINE Sound.Song.Noise.Sample.Var7 $554
.DEFINE Sound.Song.Noise.Sample.Var8 $555
.DEFINE Sound.Song.Noise.Sample.Var9 $556
.DEFINE Sound.Song.Noise.Sample.VarA $557
.DEFINE Sound.Song.Noise.Sample.VarB $558
.DEFINE Sound.Song.Noise.Sample.VarC $559
.DEFINE Sound.Song.Noise.Sample.VarD $55A
.DEFINE Sound.Song.Noise.Sample.VarE $55B
.DEFINE Sound.Song.Status $55C
.DEFINE Sound.SFX.SoundEffect $55D
.DEFINE Sound.SFX.Var1	$55E
.DEFINE Sound.SFX.Var2	$55F

.DEFINE Sound.SFX.Var3	$560
.DEFINE Sound.SFX.Var4	$561
.DEFINE Sound.SFX.Var5	$562
.DEFINE Sound.SFX.Var6	$563
.DEFINE Sound.SFX.Var7	$564
.DEFINE Sound.SFX.Var8	$565
.DEFINE Sound.SFX.Var9	$566
.DEFINE Sound.SFX.VarA	$567
.DEFINE Sound.SFX.VarB	$568
.DEFINE Sound.SFX.VarC	$569

.DEFINE Sound.Song.Square1.TicksLess $56A
.DEFINE Sound.Song.Square2.TicksLess $56B
.DEFINE Sound.SFX.PreviousSoundEffect	$56C
.DEFINE Sound.$4003Old $56D
.DEFINE Sound.$4007Old $56E
.DEFINE Sound.Song.Triangle.ConstantLength $56F

.DEFINE Game.NMI.BG.Health0 $570
.DEFINE Game.NMI.BG.Health1 $571
.DEFINE Game.NMI.BG.Health2 $572
.DEFINE Game.NMI.BG.Lives0 $573
.DEFINE Game.NMI.BG.Lives1 $574
.DEFINE Game.NMI.BG.Ammo0 $575
.DEFINE Game.NMI.BG.Ammo1 $576
.DEFINE Game.Items.Slots $577
.DEFINE Game.Items.Slots.Available $578
.DEFINE Game.Items	$579


.DEFINE Spontaneous.Slots 8

.DEFINE Spontaneous.0 $579
.DEFINE Spontaneous.1 Spontaneous.0 + Spontaneous.Slots
.DEFINE Spontaneous.2 Spontaneous.1 + Spontaneous.Slots
.DEFINE Spontaneous.3 Spontaneous.2 + Spontaneous.Slots
.DEFINE Spontaneous.4 Spontaneous.3 + Spontaneous.Slots
.DEFINE Spontaneous.5 Spontaneous.4 + Spontaneous.Slots
.DEFINE Spontaneous.6 Spontaneous.5 + Spontaneous.Slots

.DEFINE Game.Items.ItemID	Spontaneous.0
.DEFINE Game.Items.ItemY	Spontaneous.1
.DEFINE Game.Items.ItemXL	Spontaneous.2
.DEFINE Game.Items.ItemXH	Spontaneous.3
.DEFINE Game.Spontaneous.ObjectYP	Spontaneous.4
.DEFINE Game.Spontaneous.ObjectXP	Spontaneous.5
.DEFINE Game.Spontaneous.ObjectVar0	Spontaneous.6

.DEFINE Game.Weapons.Active $5B1

.DEFINE Game.NMI.Palette.1 $5B2
.DEFINE Game.NMI.Palette.2 $5B3
.DEFINE Game.NMI.Palette.3 $5B4

.DEFINE Game.NMI.Palette.Low $5B5

.DEFINE Sound.SFX.$4000	$5B6
.DEFINE Sound.SFX.$4001	$5B7
.DEFINE Sound.SFX.$4002	$5B8
.DEFINE Sound.SFX.$4003	$5B9
.DEFINE Sound.SFX.$4004	$5BA
.DEFINE Sound.SFX.$4005	$5BB
.DEFINE Sound.SFX.$4006	$5BC
.DEFINE Sound.SFX.$4007	$5BD
.DEFINE Sound.SFX.$4008	$5BE
.DEFINE Sound.SFX.$4009	$5BF
.DEFINE Sound.SFX.$400A	$5C0
.DEFINE Sound.SFX.$400B	$5C1
.DEFINE Sound.SFX.$400C	$5C2
.DEFINE Sound.SFX.$400D	$5C3
.DEFINE Sound.SFX.$400E	$5C4
.DEFINE	Sound.SFX.$400F	$5C5

.DEFINE Sound.SFX.$4010	$5C6
.DEFINE Sound.SFX.$4011	$5C7
.DEFINE Sound.SFX.$4012	$5C8
.DEFINE Sound.SFX.$4013	$5C9
.DEFINE Sound.SFX.$4014	$5CA
.DEFINE Sound.SFX.$4015	$5CB

.DEFINE Sound.SFX.$4003Old $5CC
.DEFINE Sound.SFX.$4007Old $5CD

.DEFINE Sound.SFX.SoundEffectOld $5CE
.DEFINE Game.Event.Flags $5CF
.DEFINE Game.Level.ID $5D0
.DEFINE Game.Player.MaxHealth $5D1
.DEFINE Game.ItemAddL $5D2
.DEFINE Game.ItemAddH $5D3

.DEFINE Game.EventCounter $5D4

.DEFINE Sound.Song.Noise.Sample.$4000	$5D5
.DEFINE Sound.Song.Noise.Sample.$4001	$5D6
.DEFINE Sound.Song.Noise.Sample.$4002	$5D7
.DEFINE Sound.Song.Noise.Sample.$4003	$5D8
.DEFINE Sound.Song.Noise.Sample.$4004	$5D9
.DEFINE Sound.Song.Noise.Sample.$4005	$5DA
.DEFINE Sound.Song.Noise.Sample.$4006	$5DB
.DEFINE Sound.Song.Noise.Sample.$4007	$5DC
.DEFINE Sound.Song.Noise.Sample.$4008	$5DD
.DEFINE Sound.Song.Noise.Sample.$4009	$5DE
.DEFINE Sound.Song.Noise.Sample.$400A	$5DF
.DEFINE Sound.Song.Noise.Sample.$400B	$5E0
.DEFINE Sound.Song.Noise.Sample.$400C	$5E1
.DEFINE Sound.Song.Noise.Sample.$400D	$5E2
.DEFINE Sound.Song.Noise.Sample.$400E	$5E3
.DEFINE	Sound.Song.Noise.Sample.$400F	$5E4

.DEFINE Sound.Song.Noise.Sample.$4010	$5E5
.DEFINE Sound.Song.Noise.Sample.$4011	$5E6
.DEFINE Sound.Song.Noise.Sample.$4012	$5E7
.DEFINE Sound.Song.Noise.Sample.$4013	$5E8
.DEFINE Sound.Song.Noise.Sample.$4014	$5E9
.DEFINE Sound.Song.Noise.Sample.$4015	$5EA

.DEFINE Sound.Song.Noise.Sample.$4003Old $5EB
.DEFINE Sound.Song.Noise.Sample.$4007Old $5EC

.DEFINE TitleScreen.Main.Counter0 $5EF
.DEFINE TitleScreen.Main.Counter1 $5F0
.DEFINE TitleScreen.Main.Counter2 $5F1
.DEFINE TitleScreen.Main.Counter3 $5F2

.DEFINE Cutscene.Main.TextCounter $5F3
.DEFINE Cutscene.Main.TextIndex $5F4
.DEFINE Cutscene.Main.CharactersLeft $5F5
.DEFINE Cutscene.Main.LineIndex $5F6
.DEFINE Cutscene.Main.PPUL $5F7
.DEFINE Cutscene.Main.PPUH $5F8
.DEFINE Cutscene.Main.TextL $5F9
.DEFINE Cutscene.Main.TextH $5FA

;Constants
;-----------------
.DEFINE Game.Camera.Status.Centered $10
.DEFINE Game.Camera.Status.Locked	$08
.DEFINE Game.Camera.Status.CenterRequest $04
.DEFINE Game.Camera.Status.LeftLock $02
.DEFINE Game.Camera.Status.RightLock $01


.DEFINE Game.Player.PowerUp.Mode $80
.DEFINE Game.Player.PowerUp.ID $7F

.DEFINE Game.Player.ActionStatus.OnGround $01
.DEFINE Game.Player.ActionStatus.Jumping $02
.DEFINE Game.Player.ActionStatus.UnderWater $04
.DEFINE Game.Player.ActionStatus.FacingLeft $08
.DEFINE Game.Player.ActionStatus.Ducking $10
.DEFINE Game.Player.ActionStatus.UnderPoison $20
.DEFINE Game.Player.ActionStatus.Invincible $40

.DEFINE Game.Player.ActionStatus.OnGround.Inverted $FE
.DEFINE Game.Player.ActionStatus.Jumping.Inverted $FD
.DEFINE Game.Player.ActionStatus.UnderWater.Inverted $FB
.DEFINE Game.Player.ActionStatus.OnGround.UnderWater.Inverted $F9
.DEFINE Game.Player.ActionStatus.FacingLeft.Inverted $F7
.DEFINE Game.Player.ActionStatus.Ducking.Inverted $EF
.DEFINE Game.Player.ActionStatus.UnderPoison.Inverted $DF
.DEFINE Game.Player.ActionStatus.Invincible.Inverted $BF

.DEFINE Game.Player.ArmShooting.InitialValue 20
.DEFINE Game.Player.DeathCounter.InitialValue 120

.DEFINE Game.Player.Bullet.Active $01
.DEFINE Game.Player.Bullet.HitEnemy $02
.DEFINE Game.Player.Bullet.Direction $04
.DEFINE Game.Player.Bullet.Firing $08

.DEFINE Game.PersonalSettings.Difficulty.Easy $00
.DEFINE Game.PersonalSettings.Difficulty.Medium $01
.DEFINE Game.PersonalSettings.Difficulty.Hard $02
.DEFINE Game.PersonalSettings.Difficulty.Master $03

.DEFINE Standard.OAMPage $03

.DEFINE Sound.Song.Status.StopPlaying $01
.DEFINE Sound.Song.Status.StopPlaying.Inverted $FE

; NOTE: Music constants not included. Too long, and not used in code.