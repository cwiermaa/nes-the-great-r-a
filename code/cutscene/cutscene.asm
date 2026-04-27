.DEFINE Cutscene.DrawBlock.Width Standard.Main.ZTempVar1
.DEFINE Cutscene.DrawBlock.Height Standard.Main.ZTempVar2
.DEFINE Cutscene.DrawBlock.PPUL Standard.Main.ZTempVar3
.DEFINE Cutscene.DrawBlock.PPUH Standard.Main.ZTempVar4
.DEFINE Cutscene.DrawBlock.Tile Standard.Main.ZTempVar5
.DEFINE Cutscene.DrawBlock.CurrentChunk Standard.Main.ZTempVar6

.DEFINE Cutscene.LoadAttributeData.ValueCounter Standard.Main.ZTempVar1

Cutscene.DrawBlock:
;Expected: Address of compressed BG block in TempAdd0
	ldy #0
	lda (Standard.Main.TempAdd0L),y
	sta Cutscene.DrawBlock.Height
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Cutscene.DrawBlock.Tile
	iny
--
	iny
	lda (Standard.Main.TempAdd0L),y
	sta $2006
	dey
	lda (Standard.Main.TempAdd0L),y
	sta $2006
	iny
	iny
	lda (Standard.Main.TempAdd0L),y
	sta Cutscene.DrawBlock.Width
	iny
-
	lda Cutscene.DrawBlock.Tile
	sta $2007
	inc Cutscene.DrawBlock.Tile
	dec Cutscene.DrawBlock.Width
	bne -
	dec Cutscene.DrawBlock.Height
	bne --
	rts
	
Cutscene.LoadAttributeData:
;Expected: Address of compressed BG block in TempAdd0
	ldy #0
	lda (Standard.Main.TempAdd0L),y
	sta Cutscene.LoadAttributeData.ValueCounter
	iny
-
	lda #$23
	sta $2006
	lda (Standard.Main.TempAdd0L),y
	sta $2006
	iny
	lda (Standard.Main.TempAdd0L),y
	sta $2007
	iny
	dec Cutscene.LoadAttributeData.ValueCounter
	bne -
	rts
	
Cutscene.DrawBG.Literal:
;Expected: Address of literal BG writes in TempAdd0
	ldy #0
	lda (Standard.Main.TempAdd0L),y
	sta Cutscene.LoadAttributeData.ValueCounter
	iny
-
	lda (Standard.Main.TempAdd0L),y
	sta $2006
	iny
	lda (Standard.Main.TempAdd0L),y
	sta $2006
	iny
	lda (Standard.Main.TempAdd0L),y
	sta $2007
	iny
	dec Cutscene.LoadAttributeData.ValueCounter
	bne -
	rts

Cutscene.DrawSprite.LiteralBlock:
;Expected: Address of literal sprite block in TempAdd0
	ldy #0
	ldx #0
	lda (Standard.Main.TempAdd0L),y
	sta Standard.Main.ZTempVar1
	iny
-
	lda (Standard.Main.TempAdd0L),y
	sta $300,x
	inx
	iny
	dec Standard.Main.ZTempVar1
	bne -
	rts
Cutscene.DrawBlock.Solids:
	.db $00, $4D, $3D, $4E
	
Cutscene.WriteText.Init:
;X - Low address of text data
;Y - High address of text data
	sty Standard.NMI.TempAdd3H
	stx Standard.NMI.TempAdd3L
	lda #$10
	sta Cutscene.Main.TextCounter
	ldy #0
	lda (Standard.NMI.TempAdd3L),y
	sta Cutscene.Main.CharactersLeft
	iny
	lda (Standard.NMI.TempAdd3L),y
	sta Cutscene.Main.PPUH
	iny
	lda (Standard.NMI.TempAdd3L),y
	sta Cutscene.Main.PPUL
	iny
	lda (Standard.NMI.TempAdd3L),y
	sta Cutscene.Main.LineIndex
	iny
	sty Cutscene.Main.TextIndex.w
	rts
	
Cutscene.WriteText:
	dec Cutscene.Main.TextCounter
	lda Cutscene.Main.TextCounter
	bne +++
	
	lda #8
	sta Cutscene.Main.TextCounter
	
	ldy Cutscene.Main.TextIndex
	cpy #4
	bne +
	lda #$23
	sta $2006
	lda #$20
	sta $2006
	lda #$D0
	ldx #$60
-
	sta $2007
	dex
	bne -
	
+

	lda Cutscene.Main.PPUH
	sta $2006
	lda Cutscene.Main.PPUL
	sta $2006
	lda (Standard.NMI.TempAdd3L),y
	sta $2007
	iny
	sty Cutscene.Main.TextIndex.w
	inc Cutscene.Main.PPUL
	
	dec Cutscene.Main.CharactersLeft
	lda Cutscene.Main.CharactersLeft
	bne ++
	lda #1
	rts
++
	dec Cutscene.Main.LineIndex
	lda Cutscene.Main.LineIndex
	bne +++
	lda (Standard.NMI.TempAdd3L),y
	sta Cutscene.Main.PPUH
	iny
	lda (Standard.NMI.TempAdd3L),y
	sta Cutscene.Main.PPUL
	iny
	lda (Standard.NMI.TempAdd3L),y
	sta Cutscene.Main.LineIndex
	iny
	sty Cutscene.Main.TextIndex.w
+++
	lda #0
	rts